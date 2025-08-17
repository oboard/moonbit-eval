///| 运行时值系统 - 彻底分离值和引用的概念

///| 这是Linus式的"好品味"重构：消除所有特殊情况

///| 引用ID类型 - 用于标识可变对象
pub struct RefId(Int) derive(Eq, Hash, Show)

///| 运行时值 - 解释器实际操作的数据类型
pub enum RuntimeValue {
  // 基本值类型（不可变）
  Unit
  Bool(Bool)
  Int(Int)
  Double(Double)
  Char(Char)
  String(String)

  // 复合值类型（不可变）
  Tuple(Array[RuntimeValue])
  Array(Array[RuntimeValue])

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

///| 从函数体推导返回类型
fn infer_return_type_from_body(body : @syntax.Expr) -> String {
  match body {
    @syntax.Expr::Constant(c~, ..) =>
      match c {
        @syntax.Constant::Int(_) => "Int"
        @syntax.Constant::Double(_) => "Double"
        @syntax.Constant::String(_) => "String"
        @syntax.Constant::Bool(_) => "Bool"
        @syntax.Constant::Char(_) => "Char"
        @syntax.Constant::Bytes(_) => "Bytes"
        _ => "Unit"
      }
    @syntax.Expr::Unit(..) => "Unit"
    @syntax.Expr::Array(..) => "Array"
    @syntax.Expr::Tuple(..) => "Tuple"
    @syntax.Expr::Record(..) => "Record"
    // 对于复杂表达式，默认返回Unit
    _ => "Unit"
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

///| 将RuntimeValue转换为字符串表示
pub fn RuntimeValue::to_string(self : RuntimeValue) -> String {
  match self {
    Unit => "()"
    Bool(b) => b.to_string()
    Int(i) => i.to_string()
    Double(d) => d.to_string()
    Char(c) => c.to_string()
    String(s) => s
    Tuple(values) => {
      let parts = values.map(fn(v) { v.to_string() })
      "(" + parts.join(", ") + ")"
    }
    Array(values) => {
      let parts = values.map(fn(v) { v.to_string() })
      "[" + parts.join(", ") + "]"
    }
    StructRef(RefId(id)) => "<ref:" + id.to_string() + ">"
    Function(func) =>
      // 从函数中提取参数和返回类型信息
      match func {
        @syntax.Func::Lambda(parameters~, return_type~, ..) => {
          let param_strs = []
          for param in parameters {
            let param_str = match param {
              @syntax.Parameter::Positional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + ": " + type_to_string(t) // 简化类型显示
                  None => binder.name
                }
              @syntax.Parameter::Labelled(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + "~: " + type_to_string(t)
                  None => binder.name + "~"
                }
              @syntax.Parameter::Optional(binder~, ty~, default~) => {
                let type_str = match ty {
                  Some(t) => binder.name + "~: " + type_to_string(t)
                  None => binder.name + "~"
                }
                // 添加默认值显示
                match default {
                  @syntax.Expr::Constant(c=@syntax.Constant::Int(val), ..) =>
                    type_str + " = " + val
                  _ => type_str
                }
              }
              @syntax.Parameter::QuestionOptional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + "?: " + type_to_string(t)
                  None => binder.name + "?"
                }
              @syntax.Parameter::DiscardPositional(..) => "_"
            }
            param_strs.push(param_str)
          }
          match return_type {
            Some(t) => "(" + param_strs.join(", ") + ") -> " + type_to_string(t)
            None => {
              // 从函数体推导返回类型
              let inferred_type = match func {
                @syntax.Func::Lambda(body~, ..) =>
                  infer_return_type_from_body(body)
                _ => "Unit"
              }
              "(" + param_strs.join(", ") + ") -> " + inferred_type
            }
          }
        }
        _ => "<function>"
      }
  }
}

///|
pub fn type_to_string(ty : @syntax.Type) -> String {
  match ty {
    @syntax.Type::Any(..) => "Any"
    @syntax.Type::Arrow(args~, res~, ..) => {
      let arg_strs = args.map(fn(arg) { type_to_string(arg) })
      "(" + arg_strs.to_array().join(", ") + ") -> " + type_to_string(res)
    }
    @syntax.Type::Tuple(tys~, ..) => {
      let type_strs = tys.map(fn(t) { type_to_string(t) })
      "(" + type_strs.to_array().join(", ") + ")"
    }
    @syntax.Type::Name(constr_id={ id: Ident(name~), .. }, tys~, ..) =>
      if tys.is_empty() {
        name
      } else {
        let type_strs = tys.map(fn(t) { type_to_string(t) })
        name + "<" + type_strs.to_array().join(", ") + ">"
      }
    @syntax.Type::Name(constr_id={ id: Dot(pkg~, id~), .. }, tys~, ..) =>
      if tys.is_empty() {
        pkg + "." + id
      } else {
        let type_strs = tys.map(fn(t) { type_to_string(t) })
        pkg + "." + id + "<" + type_strs.to_array().join(", ") + ">"
      }
    @syntax.Type::Option(ty~, ..) => type_to_string(ty) + "?"
    @syntax.Type::Object(_) => "Object"
  }
}

///| 将RuntimeValue转换为字符串表示（通过store解析引用）
pub fn RuntimeValue::to_string_with_store(
  self : RuntimeValue,
  store : RuntimeStore,
) -> String {
  match self {
    StructRef(id) =>
      match store.get_struct(id) {
        Some(struct_data) => {
          // 这是一个记录
          let parts = []
          struct_data.each(fn(field_name, field_value) {
            parts.push(
              field_name + ": " + field_value.to_string_with_store(store),
            )
          })
          "{ " + parts.join(", ") + " }"
        }
        None => "<invalid_ref>"
      }
    _ => self.to_string()
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
    Int(i) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Int(i.to_string()),
        loc=_dummy_loc,
      )
    Double(d) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Double(d.to_string()),
        loc=_dummy_loc,
      )
    Char(c) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Char(c.to_string()),
        loc=_dummy_loc,
      )
    String(s) =>
      @syntax.Expr::Constant(c=@syntax.Constant::String(s), loc=_dummy_loc)
    Tuple(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Tuple(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    Array(_) =>
      // let exprs = values.map(fn(v) { v.to_expr() })
      // @syntax.Expr::Array(exprs=@list.from_array(exprs), loc=_dummy_loc)
      @syntax.Expr::Unit(loc=_dummy_loc, faked=true)
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
        @syntax.Constant::Int(i) => Int((try? @strconv.parse_int(i)).unwrap())
        @syntax.Constant::Double(d) =>
          Double((try? @strconv.parse_double(d)).unwrap())
        @syntax.Constant::Char(c) => Char(c.get_char(0).unwrap())
        @syntax.Constant::String(s) => String(s)
        _ => Unit
      }
    @syntax.Expr::Tuple(exprs~, ..) => {
      let values = exprs.map(fn(e) { RuntimeValue::from_expr(e) })
      Tuple(values.to_array())
    }
    @syntax.Expr::Array(exprs~, ..) => {
      let values = exprs.map(fn(e) { RuntimeValue::from_expr(e) })
      // 数组应该是引用类型，但这里无法访问store，暂时返回Array
      // 实际使用时需要通过带store的方法来处理
      Array(values.to_array())
    }
    @syntax.Expr::Function(func~, ..) => Function(func)
    @syntax.Expr::Record(..) => Unit // Record表达式应该通过store处理，这里返回Unit作为占位符
    @syntax.Expr::Ident(..) => Unit // Ident表达式需要通过环境查找，这里返回Unit作为占位符
    @syntax.Expr::Sequence(last_expr~, ..) =>
      // 对于Sequence表达式，只关心最后一个表达式的值
      RuntimeValue::from_expr(last_expr)
    _ => Unit
  }
}

///| 将@syntax.Expr转换为RuntimeValue（通过store处理记录）
pub fn RuntimeValue::from_expr_with_store(
  expr : @syntax.Expr,
  store : RuntimeStore,
) -> RuntimeValue {
  match expr {
    @syntax.Expr::Record(fields~, ..) => {
      // 处理记录表达式，将其转换为StructRef
      let field_map = Map::new()
      for field in fields {
        let field_value = RuntimeValue::from_expr_with_store(field.expr, store)
        field_map.set(field.label.name, field_value)
      }
      let ref_id = store.alloc_struct(field_map)
      StructRef(ref_id)
    }
    _ => RuntimeValue::from_expr(expr)
  }
}
