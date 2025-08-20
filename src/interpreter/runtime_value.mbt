///| 运行时值系统 - 简化的语义值表示

///| 运行时值 - 解释器实际操作的数据类型
pub(all) enum RuntimeValue {
  // 基本值类型
  Unit
  Bool(Bool)
  Int(Int)
  UInt(UInt)
  Int64(Int64)
  UInt64(UInt64)
  Float(Float)
  Double(Double)
  Char(Char)
  Byte(Byte)
  String(String)
  Error(Failure)

  // 复合值类型
  Tuple(Array[RuntimeValue])
  Array(Array[RuntimeValue])

  // 结构类型 - 直接存储字段映射
  Struct(Ref[Map[String, RuntimeValue]])

  // 闭包 - 包含函数定义和捕获的环境（所有函数都是闭包）
  Closure(@syntax.Func, RuntimeEnvironment)

  // 构造函数调用
  Constructor(String, Array[RuntimeValue]) // 构造函数名称和参数

  // 控制流异常 - 用于实现break和continue语句
  Break(RuntimeValue?) // break可以带返回值
  Continue(Array[RuntimeValue]) // continue可以带参数列表
}

///|
pub fn build(code : String) -> RuntimeValue {
  let expr = parse_code_to_expr(code)
  match expr {
    Ok(expr) =>
      Closure(
        @syntax.Func::Lambda(
          parameters=@list.of([
            Positional(binder={ name: "self", loc: dummy_loc() }, ty=None),
          ]),
          params_loc=dummy_loc(),
          body=expr,
          return_type=None,
          error_type=NoErrorType,
          kind=Arrow,
          has_error=None,
          is_async=false,
          loc=dummy_loc(),
        ),
        RuntimeEnvironment::new(),
      )
    Err(error) => RuntimeValue::Error(Failure(error))
  }
}

///| 为 RuntimeValue 实现自定义的 ToJson trait
pub impl ToJson for RuntimeValue with to_json(self : RuntimeValue) -> Json {
  match self {
    Unit => Json::null()
    Bool(b) => b.to_json()
    Int(i) => i.to_json()
    UInt(u) => u.to_json()
    Int64(i) => i.to_json()
    UInt64(u) => u.to_json()
    Float(f) => f.to_json()
    Double(d) => d.to_json()
    Char(c) => c.to_json()
    Byte(b) => b.to_json()
    String(s) => s.to_json()
    Tuple(t) => t.to_json()
    Array(a) => a.to_json()
    Struct(s) => s.val.to_json()
    Closure(f, _) => f.to_json()
    Constructor(name, args) => [name, args.to_json()]
    Break(v) => ["break", v.to_json()]
    Continue(v) => ["continue", v.to_json()]
    Error(e) => e.to_json()
  }
}

///| 为 RuntimeValue 实现自定义的 Eq trait

///| 特别处理 Function 类型，通过函数签名比较相等性
pub impl Eq for RuntimeValue with op_equal(
  self : RuntimeValue,
  other : RuntimeValue,
) -> Bool {
  match (self, other) {
    // 基本值类型比较
    (Unit, Unit) => true
    (Bool(a), Bool(b)) => a == b
    (Int(a), Int(b)) => a == b
    (UInt(a), UInt(b)) => a == b
    (Int64(a), Int64(b)) => a == b
    (UInt64(a), UInt64(b)) => a == b
    (Float(a), Float(b)) => a == b
    (Double(a), Double(b)) => a == b
    (Char(a), Char(b)) => a == b
    (Byte(a), Byte(b)) => a == b
    (String(a), String(b)) => a == b

    // 复合值类型比较
    (Tuple(a), Tuple(b)) | (Array(a), Array(b)) | (Continue(a), Continue(b)) =>
      a == b

    // 结构类型比较
    (Struct({ val: a }), Struct({ val: b })) => a == b

    // 闭包类型的比较 - 比较函数签名和环境
    (Closure(func_a, _), Closure(func_b, _)) =>
      compare_function_signatures(func_a, func_b)

    // 构造函数比较
    (Constructor(name_a, args_a), Constructor(name_b, args_b)) =>
      name_a == name_b && args_a == args_b

    // 控制流异常比较
    (Break(a), Break(b)) => a == b

    // 不同类型之间不相等
    _ => false
  }
}

///| 比较两个函数的签名是否相等

///| 通过参数类型、返回类型等信息判断函数是否相同
fn compare_function_signatures(
  func_a : @syntax.Func,
  func_b : @syntax.Func,
) -> Bool {
  match (func_a, func_b) {
    (
      Lambda(parameters=params_a, return_type=ret_type_a, ..),
      Lambda(parameters=params_b, return_type=ret_type_b, ..),
    ) => {
      // 比较参数列表长度
      if params_a.length() != params_b.length() {
        return false
      }

      // 比较每个参数的类型
      let mut parameters_a = params_a
      let mut parameters_b = params_b
      while true {
        match (parameters_a, parameters_b) {
          (@list.More(param_a, tail=tail_a), @list.More(param_b, tail=tail_b)) => {
            if not(compare_parameter_signatures(param_a, param_b)) {
              return false
            }
            parameters_a = tail_a
            parameters_b = tail_b
          }
          (@list.Empty, @list.Empty) => break
          _ => return false
        }
      }

      // 比较返回类型
      match (ret_type_a, ret_type_b) {
        (Some(ret_a), Some(ret_b)) => compare_type_signatures(ret_a, ret_b)
        (None, None) => true
        _ => false
      }
    }
    _ => false // 其他函数类型暂不支持
  }
}

///| 比较两个参数的签名是否相等
fn compare_parameter_signatures(
  param_a : @syntax.Parameter,
  param_b : @syntax.Parameter,
) -> Bool {
  match (param_a, param_b) {
    (
      @syntax.Parameter::Positional(binder=binder_a, ty=ty_a),
      @syntax.Parameter::Positional(binder=binder_b, ty=ty_b),
    )
    | (
      @syntax.Parameter::Labelled(binder=binder_a, ty=ty_a),
      @syntax.Parameter::Labelled(binder=binder_b, ty=ty_b),
    )
    | (
      @syntax.Parameter::QuestionOptional(binder=binder_a, ty=ty_a),
      @syntax.Parameter::QuestionOptional(binder=binder_b, ty=ty_b),
    ) => binder_a.name == binder_b.name && compare_optional_types(ty_a, ty_b)
    (
      @syntax.Parameter::Optional(binder=binder_a, ty=ty_a, ..),
      @syntax.Parameter::Optional(binder=binder_b, ty=ty_b, ..),
    ) => binder_a.name == binder_b.name && compare_optional_types(ty_a, ty_b)
    (
      @syntax.Parameter::DiscardPositional(ty=ty_a, ..),
      @syntax.Parameter::DiscardPositional(ty=ty_b, ..),
    ) => compare_optional_types(ty_a, ty_b)
    _ => false
  }
}

///| 比较两个可选类型是否相等
fn compare_optional_types(ty_a : @syntax.Type?, ty_b : @syntax.Type?) -> Bool {
  match (ty_a, ty_b) {
    (Some(t_a), Some(t_b)) => compare_type_signatures(t_a, t_b)
    (None, None) => true
    _ => false
  }
}

///|
fn compare_identifiers(a : @syntax.LongIdent, b : @syntax.LongIdent) -> Bool {
  match (a, b) {
    (
      @syntax.LongIdent::Dot(pkg=pkg_a, id=id_a),
      @syntax.LongIdent::Dot(pkg=pkg_b, id=id_b),
    ) => pkg_a == pkg_b && id_a == id_b
    (@syntax.LongIdent::Ident(name=a), @syntax.LongIdent::Ident(name=b)) =>
      a == b
    _ => false
  }
}

///|
fn compare_types(
  a : @list.List[@syntax.Type],
  b : @list.List[@syntax.Type],
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  let mut tys_a = a
  let mut tys_b = b
  while true {
    match (tys_a, tys_b) {
      (@list.More(ty_a, tail=tail_a), @list.More(ty_b, tail=tail_b)) => {
        if not(compare_type_signatures(ty_a, ty_b)) {
          return false
        }
        tys_a = tail_a
        tys_b = tail_b
      }
      (@list.Empty, @list.Empty) => break
      _ => return false
    }
  }
  true
}

///| 比较两个类型签名是否相等
fn compare_type_signatures(ty_a : @syntax.Type, ty_b : @syntax.Type) -> Bool {
  // 简化实现：对于函数签名比较，我们只做基本的类型匹配
  match (ty_a, ty_b) {
    (
      Name(constr_id={ id: id_a, .. }, tys=tys_a, ..),
      Name(constr_id={ id: id_b, .. }, tys=tys_b, ..),
    ) => compare_identifiers(id_a, id_b) && compare_types(tys_a, tys_b)
    (Arrow(..), Arrow(..)) => true
    (Tuple(tys=a, ..), Tuple(tys=b, ..)) => compare_types(a, b)
    (Option(ty=a, ..), Option(ty=b, ..)) => compare_type_signatures(a, b)
    (Any(..), Any(..)) => true
    (Object({ id: a, .. }), Object({ id: b, .. })) => compare_identifiers(a, b)
    _ => false
  }
}

///|
pub(all) struct RuntimeArgument {
  value : RuntimeValue
  kind : @syntax.ArgumentKind
}

///| 从常量推导类型
pub fn infer_type_from_constant(c : @syntax.Constant) -> String {
  match c {
    Int(_) => "Int"
    UInt(_) => "UInt"
    Int64(_) => "Int64"
    UInt64(_) => "UInt64"
    Float(_) => "Float"
    Double(_) => "Double"
    Byte(_) => "Byte"
    Char(_) => "Char"
    String(_) => "String"
    Bool(_) => "Bool"
    Bytes(_) => "Bytes"
    _ => "Unit"
  }
}

///| 检查值是否为引用类型
pub fn RuntimeValue::is_reference(self : RuntimeValue) -> Bool {
  match self {
    Struct(_) => true
    _ => false
  }
}

///| 检查值是否为可变类型
pub fn RuntimeValue::is_mutable(self : RuntimeValue) -> Bool {
  match self {
    Struct(_) => true
    _ => false
  }
}

///|
pub impl Show for RuntimeValue with output(self, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///| 将RuntimeValue转换为字符串表示
pub impl Show for RuntimeValue with to_string(self) -> String {
  match self {
    Unit => "()"
    Bool(b) => b.to_string()
    Int(i) => i.to_string()
    UInt(u) => u.to_string()
    Int64(i64) => i64.to_string()
    UInt64(u64) => u64.to_string()
    Float(f) => f.to_string()
    Double(d) => d.to_string()
    Char(c) => c.to_string()
    Byte(b) => b.to_int().to_string()
    String(s) => s
    Tuple(values) => {
      let parts = values.map(fn(v) { v.to_string() })
      "(" + parts.join(", ") + ")"
    }
    Array(values) => {
      let parts = values.map(fn(v) { v.to_string() })
      "[" + parts.join(", ") + "]"
    }
    Struct(fields) => {
      let parts = []
      fields.val.each(fn(field_name, field_value) {
        parts.push(field_name + ": " + field_value.to_string())
      })
      "{ " + parts.join(", ") + " }"
    }
    Constructor(name, args) =>
      // 格式化构造函数调用
      if args.length() == 0 {
        name
      } else {
        let arg_strs = args.map(fn(v) { v.to_string() })
        name + "(" + arg_strs.join(", ") + ")"
      }
    Closure(func, _env) =>
      // 从函数中提取参数和返回类型信息
      match func {
        @syntax.Func::Lambda(parameters~, return_type~, body~, ..) => {
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
                  Constant(c=Int(val), ..) => type_str + " = " + val
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
              // 对于没有显式返回类型的函数，无法在这里进行复杂的类型推导
              // 因为这里没有解释器上下文，所以只能进行简单的推导
              let inferred_type = match body {
                Constant(c~, ..) => infer_type_from_constant(c)
                Unit(..) => "Unit"
                Array(..) => "Array"
                Tuple(..) => "Tuple"
                Record(..) => "Record"
                Apply(..) => "Unknown" // 无法在没有解释器上下文的情况下推导
                _ => "Unit"
              }
              "(" + param_strs.join(", ") + ") -> " + inferred_type
            }
          }
        }
        _ => "<function>"
      }
    Break(value) =>
      match value {
        Some(v) => "break " + v.to_string()
        None => "break"
      }
    Continue(args) => {
      let arg_strs = args.map(fn(v) { v.to_string() })
      "continue " + arg_strs.join(", ")
    }
    Error(e) => e.to_string()
  }
}

///|
pub fn type_to_string(ty : @syntax.Type) -> String {
  match ty {
    Any(..) => "Any"
    Arrow(args~, res~, ..) => {
      let arg_strs = args.map(fn(arg) { type_to_string(arg) })
      "(" + arg_strs.to_array().join(", ") + ") -> " + type_to_string(res)
    }
    Tuple(tys~, ..) => {
      let type_strs = tys.map(fn(t) { type_to_string(t) })
      "(" + type_strs.to_array().join(", ") + ")"
    }
    Name(constr_id={ id: Ident(name~), .. }, tys~, ..) =>
      if tys.is_empty() {
        name
      } else {
        let type_strs = tys.map(fn(t) { type_to_string(t) })
        name + "<" + type_strs.to_array().join(", ") + ">"
      }
    Name(constr_id={ id: Dot(pkg~, id~), .. }, tys~, ..) =>
      if tys.is_empty() {
        if pkg == "" {
          id // 对于空包名，直接返回类型名
        } else {
          pkg + "." + id
        }
      } else {
        let type_strs = tys.map(fn(t) { type_to_string(t) })
        let prefix = if pkg == "" { id } else { pkg + "." + id }
        prefix + "<" + type_strs.to_array().join(", ") + ">"
      }
    Option(ty~, ..) => type_to_string(ty) + "?"
    Object(_) => "Object"
  }
}

///| 将RuntimeValue转换为表达式（用于输出）
pub fn RuntimeValue::to_expr(self : RuntimeValue) -> @syntax.Expr {
  let _dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    Unit => Unit(loc=_dummy_loc, faked=true)
    Bool(b) => Constant(c=Bool(b), loc=_dummy_loc)
    Int(i) => Constant(c=Int(i.to_string()), loc=_dummy_loc)
    UInt(u) => Constant(c=Int(u.to_string()), loc=_dummy_loc)
    Int64(i64) => Constant(c=Int64(i64.to_string()), loc=_dummy_loc)
    UInt64(u64) => Constant(c=UInt64(u64.to_string()), loc=_dummy_loc)
    Float(f) => Constant(c=Float(f.to_string()), loc=_dummy_loc)
    Double(d) => Constant(c=Double(d.to_string()), loc=_dummy_loc)
    Char(c) => Constant(c=Char(c.to_string()), loc=_dummy_loc)
    Byte(b) => Constant(c=Int(b.to_int().to_string()), loc=_dummy_loc)
    String(s) => Constant(c=String(s), loc=_dummy_loc)
    Tuple(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      Tuple(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    Array(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      Array(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    // 结构类型转换为Record表达式
    Struct(_) => Unit(loc=_dummy_loc, faked=true)
    Closure(func, _env) => Function(func~, loc=_dummy_loc)
    Constructor(_) => Unit(loc=_dummy_loc, faked=true)
    Break(value) =>
      Break(arg=value.map(fn(v) { v.to_expr() }), label=None, loc=_dummy_loc)
    Continue(args) => {
      let expr_args = args.map(fn(v) { v.to_expr() })
      Continue(args=@list.from_array(expr_args), label=None, loc=_dummy_loc)
    }
    Error(_) => Unit(loc=_dummy_loc, faked=true)
  }
}

///| 将@syntax.Expr转换为RuntimeValue
pub fn RuntimeValue::from_expr(expr : @syntax.Expr) -> RuntimeValue {
  match expr {
    Unit(..) => Unit
    Constant(c~, ..) =>
      match c {
        Bool(b) => Bool(b)
        Int(i) => Int((try? @strconv.parse_int(i)).unwrap())
        Double(d) => Double((try? @strconv.parse_double(d)).unwrap())
        Char(c) => Char(c.get_char(0).unwrap())
        String(s) => String(s)
        _ => Unit
      }
    Tuple(exprs~, ..) => {
      let values = exprs.map(fn(e) { RuntimeValue::from_expr(e) })
      Tuple(values.to_array())
    }
    Array(exprs~, ..) => {
      let values = exprs.map(fn(e) { RuntimeValue::from_expr(e) })
      // 数组应该是引用类型，但这里无法访问store，暂时返回Array
      // 实际使用时需要通过带store的方法来处理
      Array(values.to_array())
    }
    Function(func~, ..) => Closure(func, RuntimeEnvironment::new())
    Record(fields~, ..) => {
      // 创建一个新的结构
      let struct_data = Map::new()
      for field in fields {
        let field_name = field.label.name
        let field_value = RuntimeValue::from_expr(field.expr)
        struct_data.set(field_name, field_value)
      }
      Struct(@ref.new(struct_data))
    }
    Ident(..) => Unit // Ident表达式需要通过环境查找，这里返回Unit作为占位符
    Sequence(last_expr~, ..) =>
      // 对于Sequence表达式，只关心最后一个表达式的值
      RuntimeValue::from_expr(last_expr)
    _ => Unit
  }
}

///| RuntimeValue 之间的中缀运算 - 消除对 constant_infix 的依赖
pub fn runtime_value_infix(
  op : String,
  lhs : RuntimeValue,
  rhs : RuntimeValue,
) -> RuntimeValue {
  match (lhs, rhs) {
    // Int 运算
    (Int(left), Int(right)) =>
      match op {
        "+" => Int(left + right)
        "-" => Int(left - right)
        "*" => Int(left * right)
        "/" => Int(left / right)
        "%" => Int(left % right)
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        "<" => Bool(left < right)
        ">" => Bool(left > right)
        "<=" => Bool(left <= right)
        ">=" => Bool(left >= right)
        _ => Unit
      }
    // Double 运算
    (Double(left), Double(right)) =>
      match op {
        "+" => Double(left + right)
        "-" => Double(left - right)
        "*" => Double(left * right)
        "/" => Double(left / right)
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        "<" => Bool(left < right)
        ">" => Bool(left > right)
        "<=" => Bool(left <= right)
        ">=" => Bool(left >= right)
        _ => Unit
      }
    // Bool 运算
    (Bool(left), Bool(right)) =>
      match op {
        "&&" => Bool(left && right)
        "||" => Bool(left || right)
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    // String 运算
    (String(left), String(right)) =>
      match op {
        "+" => String(left + right)
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    _ => Unit
  }
}

///|
pub fn RuntimeValue::from_option(self : RuntimeValue?) -> RuntimeValue {
  match self {
    Some(x) => RuntimeValue::Constructor("Some", [x])
    None => RuntimeValue::Constructor("None", [])
  }
}
