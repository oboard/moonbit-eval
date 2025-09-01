///|
/// 类型操作模块
/// 包含类型推断、类型检查和类型转换相关的方法

///|
/// 根据字段名推导结构体类型
fn RuntimeModule::infer_struct_type_from_fields(
  self : RuntimeModule,
  current_fields : Array[String],
) -> String {
  self.type_definitions
  .iter()
  .fold(init="Any", fn(result, entry) {
    let (type_name, type_def) = entry
    match type_def.components {
      Record(struct_fields) => {
        let all_matched = struct_fields.all(sf => current_fields
          .iter()
          .any(cf => sf.name.label == cf))
        if struct_fields.length() == current_fields.length() && all_matched {
          type_name
        } else {
          result
        }
      }
      _ => result
    }
  })
}

///|
/// 查找静态类型定义
fn RuntimeModule::find_static_type(
  self : RuntimeModule,
  name : String,
) -> RuntimeType {
  match name {
    "Bool" => RuntimeType::bool()
    "Int" => RuntimeType::int()
    "UInt" => RuntimeType::uint()
    "Int64" => RuntimeType::int64()
    "UInt16" => RuntimeType::uint16()
    "UInt64" => RuntimeType::uint64()
    "Float" => RuntimeType::float()
    "Double" => RuntimeType::double()
    "BigInt" => RuntimeType::bigint()
    "Char" => RuntimeType::char()
    "Byte" => RuntimeType::byte()
    "String" => RuntimeType::string()
    "Tuple" => RuntimeType::tuple()
    "Array" => RuntimeType::array()
    "ArrayView" | "View" => RuntimeType::array_view()
    "UninitializedArray" => RuntimeType::uninitialized_array()
    "Map" => RuntimeType::map()
    "Iter" => RuntimeType::iter()
    "Option" => RuntimeType::option()
    _ =>
      {
        path: self.meta.name,
        name: if self.type_definitions.get(name) is Some(decl) {
          decl.tycon
        } else {
          name
        },
        mod: self,
      }
  }
}

///|
/// 根据运行时值推断类型
fn RuntimeValue::get_type(self : RuntimeValue) -> RuntimeType {
  match self {
    Unit => { path: "main", name: "Unit", mod: RuntimeModule::new("main") }
    Bool(_) => RuntimeType::bool()
    Int(_) => RuntimeType::int()
    UInt(_) => RuntimeType::uint()
    Int64(_) => RuntimeType::int64()
    UInt16(_) => RuntimeType::uint16()
    UInt64(_) => RuntimeType::uint64()
    Float(_) => RuntimeType::float()
    Double(_) => RuntimeType::double()
    BigInt(_) => RuntimeType::bigint()
    Char(_) => RuntimeType::char()
    Byte(_) => RuntimeType::byte()
    String(_) => RuntimeType::string()
    Bytes(_) => RuntimeType::bytes()
    StringView(_) => RuntimeType::string()
    Tuple(_) => RuntimeType::tuple()
    Array(_) => RuntimeType::array()
    FixedArray(_) => RuntimeType::array()
    ArrayView(_) => RuntimeType::array_view()
    UninitializedArray(_) => RuntimeType::uninitialized_array()
    Map(_) => RuntimeType::map()
    Struct(data) => data.type_info
    Closure(_) =>
      { path: "main", name: self.to_string(), mod: RuntimeModule::new("main") }
    Exception(_) =>
      { path: "main", name: "Exception", mod: RuntimeModule::new("main") }
    Constructor({ val: { name, .. }, type_info }) =>
      match name {
        "Some" | "None" => RuntimeType::option()
        "More" | "Empty" => RuntimeType::list()
        _ => type_info
      }
    Iter(_) => RuntimeType::iter()
    Iter2(_) => RuntimeType::iter()
    Json(_) => RuntimeType::json()
  }
}

///|
/// 从函数体推导返回类型
fn ClosureInterpreter::infer_return_type_from_expr(
  self : ClosureInterpreter,
  body : @syntax.Expr,
) -> RuntimeType {
  match body {
    // 处理函数调用表达式
    Apply(func~, ..) =>
      match func {
        @syntax.Expr::Ident(id={ name: ident, .. }, ..) =>
          self.with_ident(ident, (mod, _pkg, name) => mod.env
            .find(name)
            .unwrap_or(Unit)
            .get_type())
        _ => RuntimeType::any()
      }
    // 处理 match 表达式
    Match(..) => RuntimeType::any()
    Sequence(last_expr~, ..) => self.infer_return_type_from_expr(last_expr)
    Infix(op={ name: Ident(name=op_name), .. }, lhs~, ..) =>
      match op_name {
        "==" | "!=" | "<" | ">" | "<=" | ">=" | "&&" | "||" =>
          RuntimeType::bool()
        _ => self.infer_return_type_from_expr(lhs)
      }
    _ => RuntimeType::any()
  }
}

///|
/// 将RuntimeValue转换为字符串表示（带解释器支持，用于正确的类型推导）
pub fn ClosureInterpreter::get_function_type_string(
  self : ClosureInterpreter,
  value : RuntimeValue,
) -> String {
  match value {
    Closure(func, _env) =>
      // 从函数中提取参数和返回类型信息
      match func {
        Lambda(parameters~, return_type~, body~, ..) => {
          let param_strs = []
          for param in parameters {
            let param_str = match param {
              @syntax.Parameter::Positional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + ": " + type_to_string(t)
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
                match default {
                  @syntax.Expr::Constant(c=Int(val), ..) =>
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
              // 推断返回类型，对于柯里化函数需要特殊处理
              let inferred_type = self
                .infer_return_type_from_expr(body)
                .to_string()
              "(" + param_strs.join(", ") + ") -> " + inferred_type
            }
          }
        }
        _ => "<function>"
      }
    _ => value.to_string()
  }
}
