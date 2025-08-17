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

  // 统一的结构引用类型（可变对象的引用）
  StructRef(RefId)

  // 函数值
  Function(@syntax.Func)
}

///| 运行时存储 - 统一管理所有可变对象
pub struct RuntimeStore {
  // 统一的结构化数据存储 - 可以是Record或Array
  structs : Map[RefId, Map[String, RuntimeValue]]
  // 引用计数器
  mut next_id : RefId
}

///|
pub fn RuntimeStore::new() -> RuntimeStore {
  { structs: Map::new(), next_id: RefId(1) }
}

///| 分配新的结构引用
pub fn RuntimeStore::alloc_struct(
  self : RuntimeStore,
  fields : Map[String, RuntimeValue],
) -> RefId {
  let id = self.next_id
  let RefId(current_id) = self.next_id
  self.next_id = RefId(current_id + 1)
  self.structs.set(id, fields)
  id
}

///| 获取结构数据
pub fn RuntimeStore::get_struct(
  self : RuntimeStore,
  id : RefId,
) -> Map[String, RuntimeValue]? {
  self.structs.get(id)
}

///| 更新结构字段
pub fn RuntimeStore::update_struct_field(
  self : RuntimeStore,
  id : RefId,
  field : String,
  value : RuntimeValue,
) -> Bool {
  match self.structs.get(id) {
    Some(struct_data) => {
      struct_data.set(field, value)
      true
    }
    None => false
  }
}

///| 检查值是否为引用类型
pub fn RuntimeValue::is_reference(self : RuntimeValue) -> Bool {
  match self {
    StructRef(_) => true
    _ => false
  }
}

///| 检查值是否为可变类型
pub fn RuntimeValue::is_mutable(self : RuntimeValue) -> Bool {
  match self {
    StructRef(_) => true
    _ => false
  }
}

///| 将RuntimeValue转换为表达式（用于输出）
pub fn RuntimeValue::to_expr(self : RuntimeValue) -> @syntax.Expr {
  let _dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    Unit => @syntax.Expr::Unit(loc=_dummy_loc, faked=true)
    Bool(b) =>
      @syntax.Expr::Constant(c=@syntax.Constant::Bool(b), loc=_dummy_loc)
    Int(i) => @syntax.Expr::Constant(c=@syntax.Constant::Int(i), loc=_dummy_loc)
    Double(d) =>
      @syntax.Expr::Constant(c=@syntax.Constant::Double(d), loc=_dummy_loc)
    Char(c) =>
      @syntax.Expr::Constant(c=@syntax.Constant::Char(c), loc=_dummy_loc)
    String(s) =>
      @syntax.Expr::Constant(c=@syntax.Constant::String(s), loc=_dummy_loc)
    Tuple(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Tuple(exprs~, loc=_dummy_loc)
    }
    Array(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Array(exprs~, loc=_dummy_loc)
    }
    // 引用类型需要通过store解析
    StructRef(_) => @syntax.Expr::Unit(loc=_dummy_loc, faked=true)
    Function(func) => @syntax.Expr::Function(func~, loc=_dummy_loc)
  }
}

///| 将RuntimeValue转换为引用表达式（保持引用语义）
pub fn RuntimeValue::to_reference_expr(
  self : RuntimeValue,
  _store : RuntimeStore,
) -> @syntax.Expr {
  let _dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    StructRef(id) => {
      // 返回特殊的Unit表达式来保持引用信息
      let RefId(ref_num) = id
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
  let _dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    StructRef(id) =>
      match store.get_struct(id) {
        Some(struct_data) => {
          let field_defs = []
          struct_data.each(fn(field_name, field_value) {
            field_defs.push(@syntax.FieldDef::{
              label: @syntax.Label::{ name: field_name, loc: _dummy_loc },
              expr: field_value.to_expr_with_store(store),
              is_pun: false,
              loc: _dummy_loc,
            })
          })
          @syntax.Expr::Record(
            type_name=None,
            fields=@list.from_array(field_defs),
            trailing=None,
            loc=_dummy_loc,
          )
        }
        None => @syntax.Expr::Unit(loc=_dummy_loc, faked=true)
      }
    _ => self.to_expr()
  }
}

///| 将@syntax.Expr转换为RuntimeValue
pub fn RuntimeValue::from_expr(expr : @syntax.Expr) -> RuntimeValue {
  // 调试：查看所有Unit表达式的详细信息
  match expr {
    @syntax.Expr::Unit(loc~, faked~) =>
      // 检查是否是记录引用Unit表达式
      if not(faked) {
        // 这是一个特殊的结构引用Unit表达式
        // 从loc中提取RefId
        if loc.start.fname == "record" {
          StructRef(RefId(loc.start.lnum))
        } else {
          Unit
        }
      } else {
        Unit
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
      // 数组应该是引用类型，但这里无法访问store，暂时返回Array
      // 实际使用时需要通过带store的方法来处理
      Array(values)
    }
    @syntax.Expr::Function(func~, ..) => Function(func)
    @syntax.Expr::Ident(..) => Unit // Ident表达式需要通过环境查找，这里返回Unit作为占位符
    _ => Unit
  }
}
