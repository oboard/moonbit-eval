///| 运行时值系统 - 彻底分离值和引用的概念

///| 这是Linus式的"好品味"重构：消除所有特殊情况

///| 引用ID类型 - 用于标识可变对象
pub struct RefId(Int) derive(Eq, Hash, Show)

///| 运行时值 - 解释器实际操作的数据类型
pub enum RuntimeValue {
  // 基本值类型（不可变）
  Unit
  Bool(Bool)
  Int(String)
  Double(String)
  Char(String)
  String(String)

  // 复合值类型（不可变）
  Tuple(@list.List[RuntimeValue])
  Array(@list.List[RuntimeValue])

  // 引用类型（可变对象的引用）
  RecordRef(RefId)
  ArrayRef(RefId)

  // 函数值
  Function(@syntax.Func)
  Closure(@syntax.Func, Map[String, RuntimeValue])
}

///| 运行时存储 - 统一管理所有可变对象
pub struct RuntimeStore {
  // 记录数据存储
  records : Map[RefId, Map[String, RuntimeValue]]
  // 数组数据存储  
  arrays : Map[RefId, @list.List[RuntimeValue]]
  // 引用计数器
  mut next_id : RefId
}

///|
pub fn RuntimeStore::new() -> RuntimeStore {
  { records: Map::new(), arrays: Map::new(), next_id: RefId(1) }
}

///| 分配新的记录引用
pub fn RuntimeStore::alloc_record(
  self : RuntimeStore,
  fields : Map[String, RuntimeValue],
) -> RefId {
  let id = self.next_id
  let RefId(current_id) = self.next_id
  self.next_id = RefId(current_id + 1)
  self.records.set(id, fields)
  id
}

///| 分配新的数组引用
pub fn RuntimeStore::alloc_array(
  self : RuntimeStore,
  elements : @list.List[RuntimeValue],
) -> RefId {
  let id = self.next_id
  let RefId(current_id) = self.next_id
  self.next_id = RefId(current_id + 1)
  self.arrays.set(id, elements)
  id
}

///| 获取记录数据
pub fn RuntimeStore::get_record(
  self : RuntimeStore,
  id : RefId,
) -> Map[String, RuntimeValue]? {
  self.records.get(id)
}

///| 获取数组数据
pub fn RuntimeStore::get_array(
  self : RuntimeStore,
  id : RefId,
) -> @list.List[RuntimeValue]? {
  self.arrays.get(id)
}

///| 更新记录字段
pub fn RuntimeStore::update_record_field(
  self : RuntimeStore,
  id : RefId,
  field : String,
  value : RuntimeValue,
) -> Bool {
  match self.records.get(id) {
    Some(record) => {
      record.set(field, value)
      true
    }
    None => false
  }
}

///| 更新数组元素
pub fn RuntimeStore::update_array_element(
  self : RuntimeStore,
  id : RefId,
  index : Int,
  value : RuntimeValue,
) -> Bool {
  match self.arrays.get(id) {
    Some(array) => {
      // 将List转换为Array进行索引访问
      let arr = array.to_array()
      if index >= 0 && index < arr.length() {
        arr[index] = value
        // 将修改后的Array转换回List
        self.arrays.set(id, @list.from_array(arr))
        true
      } else {
        false
      }
    }
    None => false
  }
}

///| 检查值是否为引用类型
pub fn RuntimeValue::is_reference(self : RuntimeValue) -> Bool {
  match self {
    RecordRef(_) | ArrayRef(_) => true
    _ => false
  }
}

///| 检查值是否为可变类型
pub fn RuntimeValue::is_mutable(self : RuntimeValue) -> Bool {
  match self {
    RecordRef(_) | ArrayRef(_) => true
    _ => false
  }
}

///| 将RuntimeValue转换为表达式（用于输出）
pub fn RuntimeValue::to_expr(self : RuntimeValue) -> @syntax.Expr {
  let dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    Unit => @syntax.Expr::Unit(loc=dummy_loc, faked=true)
    Bool(b) =>
      @syntax.Expr::Constant(c=@syntax.Constant::Bool(b), loc=dummy_loc)
    Int(i) => @syntax.Expr::Constant(c=@syntax.Constant::Int(i), loc=dummy_loc)
    Double(d) =>
      @syntax.Expr::Constant(c=@syntax.Constant::Double(d), loc=dummy_loc)
    Char(c) =>
      @syntax.Expr::Constant(c=@syntax.Constant::Char(c), loc=dummy_loc)
    String(s) =>
      @syntax.Expr::Constant(c=@syntax.Constant::String(s), loc=dummy_loc)
    Tuple(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Tuple(exprs~, loc=dummy_loc)
    }
    Array(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Array(exprs~, loc=dummy_loc)
    }
    // 引用类型需要通过store解析
    RecordRef(_) | ArrayRef(_) => @syntax.Expr::Unit(loc=dummy_loc, faked=true)
    Function(func) => @syntax.Expr::Function(func~, loc=dummy_loc)
    Closure(_, _) => @syntax.Expr::Unit(loc=dummy_loc, faked=true)
  }
}

///| 将RuntimeValue转换为引用表达式（保持引用语义）
pub fn RuntimeValue::to_reference_expr(
  self : RuntimeValue,
  store : RuntimeStore,
) -> @syntax.Expr {
  let dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    RecordRef(id) => {
      // 返回特殊的Unit表达式来保持引用信息
      let RefId(ref_num) = id
      println(
        "to_reference_expr: Creating Unit with fname=record, lnum=" +
        ref_num.to_string(),
      )
      @syntax.Expr::Unit(
        loc=@basic.Location::{
          start: { fname: "record", lnum: ref_num, bol: 0, cnum: 0 },
          end: { fname: "record", lnum: ref_num, bol: 0, cnum: 0 },
        },
        faked=false,
      )
    }
    _ => self.to_expr()
  }
}

///| 将RuntimeValue转换为表达式（通过store解析引用）
pub fn RuntimeValue::to_expr_with_store(
  self : RuntimeValue,
  store : RuntimeStore,
) -> @syntax.Expr {
  let dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    RecordRef(id) =>
      match store.get_record(id) {
        Some(record) => {
          let field_defs = []
          record.each(fn(field_name, field_value) {
            field_defs.push(@syntax.FieldDef::{
              label: @syntax.Label::{ name: field_name, loc: dummy_loc },
              expr: field_value.to_expr_with_store(store),
              is_pun: false,
              loc: dummy_loc,
            })
          })
          @syntax.Expr::Record(
            type_name=None,
            fields=@list.from_array(field_defs),
            trailing=None,
            loc=dummy_loc,
          )
        }
        None => @syntax.Expr::Unit(loc=dummy_loc, faked=true)
      }
    ArrayRef(id) =>
      match store.get_array(id) {
        Some(array) => {
          let exprs = array.map(fn(v) { v.to_expr_with_store(store) })
          @syntax.Expr::Array(exprs~, loc=dummy_loc)
        }
        None => @syntax.Expr::Unit(loc=dummy_loc, faked=true)
      }
    _ => self.to_expr()
  }
}

///| 将@syntax.Expr转换为RuntimeValue
pub fn RuntimeValue::from_expr(expr : @syntax.Expr) -> RuntimeValue {
  // 调试：查看所有Unit表达式的详细信息
  match expr {
    @syntax.Expr::Unit(loc~, faked~) => {
      println("from_expr: Unit with faked=" + faked.to_string())
      // 检查是否是记录引用Unit表达式
      if not(faked) {
        // 这是一个特殊的记录引用Unit表达式
        // 从loc中提取RefId
        if loc.start.fname == "record" {
          println("from_expr: Found record reference Unit with id=" + loc.start.lnum.to_string())
          RecordRef(RefId(loc.start.lnum))
        } else {
          println("from_expr: Found non-faked Unit but not record reference")
          Unit
        }
      } else {
        println("from_expr: Found regular/faked Unit expression")
        Unit
      }
    }
    @syntax.Expr::Constant(c~, ..) =>
      match c {
        @syntax.Constant::Bool(b) => Bool(b)
        @syntax.Constant::Int(i) => Int(i)
        @syntax.Constant::Double(d) => Double(d)
        @syntax.Constant::Char(c) => Char(c)
        @syntax.Constant::String(s) => String(s)
        _ => Unit
      }
    @syntax.Expr::Tuple(exprs~, ..) => {
      let values = exprs.map(fn(e) { RuntimeValue::from_expr(e) })
      Tuple(values)
    }
    @syntax.Expr::Array(exprs~, ..) => {
      let values = exprs.map(fn(e) { RuntimeValue::from_expr(e) })
      Array(values)
    }
    @syntax.Expr::Function(func~, ..) => Function(func)
    @syntax.Expr::Ident(..) => Unit // Ident表达式需要通过环境查找，这里返回Unit作为占位符
    _ => Unit
  }
}
