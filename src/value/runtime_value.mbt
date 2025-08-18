///| 运行时值系统 - 彻底分离值和引用的概念

///| 引用ID类型 - 用于标识可变对象
pub(all) struct RefId(Int) derive(Eq, Hash, Show)

///| 运行时值 - 解释器实际操作的数据类型
pub(all) enum RuntimeValue {
  // 基本值类型（不可变）
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

  // 复合值类型（不可变）
  Tuple(Array[RuntimeValue])
  Array(Array[RuntimeValue])

  // 统一的结构引用类型（可变对象的引用）
  StructRef(RefId)

  // 函数值
  Function(@syntax.Func)

  // 构造函数调用
  Constructor(String, Array[RuntimeValue]) // 构造函数名称和参数

  // 控制流异常 - 用于实现break和continue语句
  Break(RuntimeValue?) // break可以带返回值
  Continue(Array[RuntimeValue]) // continue可以带参数列表
}

///| 为 RuntimeValue 实现自定义的 Eq trait

///| 特别处理 Function 类型，通过函数签名比较相等性
pub impl Eq for RuntimeValue with op_equal(
  self : RuntimeValue,
  other : RuntimeValue,
) -> Bool {
  match (self, other) {
    // 基本类型的比较
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

    // 复合类型的比较
    (Tuple(a), Tuple(b)) => {
      if a.length() != b.length() {
        return false
      }
      for i = 0; i < a.length(); i = i + 1 {
        if a[i] != b[i] {
          return false
        }
      }
      true
    }
    (Array(a), Array(b)) => {
      if a.length() != b.length() {
        return false
      }
      for i = 0; i < a.length(); i = i + 1 {
        if a[i] != b[i] {
          return false
        }
      }
      true
    }

    // 引用类型的比较
    (StructRef(a), StructRef(b)) => a == b

    // 函数类型的比较 - 通过函数签名比较
    (Function(func_a), Function(func_b)) =>
      compare_function_signatures(func_a, func_b)

    // 构造函数的比较
    (Constructor(name_a, args_a), Constructor(name_b, args_b)) => {
      if name_a != name_b || args_a.length() != args_b.length() {
        return false
      }
      for i = 0; i < args_a.length(); i = i + 1 {
        if args_a[i] != args_b[i] {
          return false
        }
      }
      true
    }

    // 控制流异常的比较
    (Break(a), Break(b)) =>
      match (a, b) {
        (Some(val_a), Some(val_b)) => val_a == val_b
        (None, None) => true
        _ => false
      }
    (Continue(a), Continue(b)) => {
      if a.length() != b.length() {
        return false
      }
      for i = 0; i < a.length(); i = i + 1 {
        if a[i] != b[i] {
          return false
        }
      }
      true
    }

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
      @syntax.Func::Lambda(parameters=params_a, return_type=ret_type_a, ..),
      @syntax.Func::Lambda(parameters=params_b, return_type=ret_type_b, ..),
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
    ) => binder_a.name == binder_b.name && compare_optional_types(ty_a, ty_b)
    (
      @syntax.Parameter::Labelled(binder=binder_a, ty=ty_a),
      @syntax.Parameter::Labelled(binder=binder_b, ty=ty_b),
    ) => binder_a.name == binder_b.name && compare_optional_types(ty_a, ty_b)
    (
      @syntax.Parameter::Optional(binder=binder_a, ty=ty_a, ..),
      @syntax.Parameter::Optional(binder=binder_b, ty=ty_b, ..),
    ) => binder_a.name == binder_b.name && compare_optional_types(ty_a, ty_b)
    (
      @syntax.Parameter::QuestionOptional(binder=binder_a, ty=ty_a),
      @syntax.Parameter::QuestionOptional(binder=binder_b, ty=ty_b),
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

///| 比较两个类型签名是否相等
fn compare_type_signatures(ty_a : @syntax.Type, ty_b : @syntax.Type) -> Bool {
  // 简化实现：对于函数签名比较，我们只做基本的类型匹配
  match (ty_a, ty_b) {
    (@syntax.Type::Name(..), @syntax.Type::Name(..)) => true
    (@syntax.Type::Arrow(..), @syntax.Type::Arrow(..)) => true
    (@syntax.Type::Tuple(..), @syntax.Type::Tuple(..)) => true
    (@syntax.Type::Option(..), @syntax.Type::Option(..)) => true
    (@syntax.Type::Any(..), @syntax.Type::Any(..)) => true
    (@syntax.Type::Object(_), @syntax.Type::Object(_)) => true
    _ => false
  }
}

///|
pub(all) struct RuntimeArgument {
  value : RuntimeValue
  kind : @syntax.ArgumentKind
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
  ignore(self.structs.set(id, fields))
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
      ignore(struct_data.set(field, value))
      true
    }
    None => false
  }
}

///| 从常量推导类型
pub fn infer_type_from_constant(c : @syntax.Constant) -> String {
  match c {
    @syntax.Constant::Int(_) => "Int"
    @syntax.Constant::UInt(_) => "UInt"
    @syntax.Constant::Int64(_) => "Int64"
    @syntax.Constant::UInt64(_) => "UInt64"
    @syntax.Constant::Float(_) => "Float"
    @syntax.Constant::Double(_) => "Double"
    @syntax.Constant::Byte(_) => "Byte"
    @syntax.Constant::Char(_) => "Char"
    @syntax.Constant::String(_) => "String"
    @syntax.Constant::Bool(_) => "Bool"
    @syntax.Constant::Bytes(_) => "Bytes"
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
    StructRef(RefId(id)) => "<ref:" + id.to_string() + ">"
    Constructor(name, args) =>
      // 格式化构造函数调用
      if args.length() == 0 {
        name
      } else {
        let arg_strs = args.map(fn(v) { v.to_string() })
        name + "(" + arg_strs.join(", ") + ")"
      }
    Function(func) =>
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
              // 对于没有显式返回类型的函数，无法在这里进行复杂的类型推导
              // 因为这里没有解释器上下文，所以只能进行简单的推导
              let inferred_type = match body {
                @syntax.Expr::Constant(c~, ..) => infer_type_from_constant(c)
                @syntax.Expr::Unit(..) => "Unit"
                @syntax.Expr::Array(..) => "Array"
                @syntax.Expr::Tuple(..) => "Tuple"
                @syntax.Expr::Record(..) => "Record"
                @syntax.Expr::Apply(..) => "Unknown" // 无法在没有解释器上下文的情况下推导
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
    Constructor(name, args) =>
      // 处理构造函数调用
      if args.length() == 0 {
        name
      } else {
        let arg_strs = args.map(fn(v) { v.to_string_with_store(store) })
        name + "(" + arg_strs.join(", ") + ")"
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
    UInt(u) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Int(u.to_string()),
        loc=_dummy_loc,
      )
    Int64(i64) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Int64(i64.to_string()),
        loc=_dummy_loc,
      )
    UInt64(u64) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::UInt64(u64.to_string()),
        loc=_dummy_loc,
      )
    Float(f) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Float(f.to_string()),
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
    Byte(b) =>
      @syntax.Expr::Constant(
        c=@syntax.Constant::Int(b.to_int().to_string()),
        loc=_dummy_loc,
      )
    String(s) =>
      @syntax.Expr::Constant(c=@syntax.Constant::String(s), loc=_dummy_loc)
    Tuple(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Tuple(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    Array(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      @syntax.Expr::Array(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    // 引用类型需要通过store解析
    StructRef(_) => @syntax.Expr::Unit(loc=_dummy_loc, faked=true)
    Function(func) => @syntax.Expr::Function(func~, loc=_dummy_loc)
    Constructor(_) =>
      // 暂时返回Unit，避免复杂的语法构造
      @syntax.Expr::Unit(loc=_dummy_loc, faked=true)
    Break(value) =>
      @syntax.Expr::Break(
        arg=value.map(fn(v) { v.to_expr() }),
        label=None,
        loc=_dummy_loc,
      )
    Continue(args) => {
      let expr_args = args.map(fn(v) { v.to_expr() })
      @syntax.Expr::Continue(
        args=@list.from_array(expr_args),
        label=None,
        loc=_dummy_loc,
      )
    }
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
        ignore(field_map.set(field.label.name, field_value))
      }
      let ref_id = store.alloc_struct(field_map)
      StructRef(ref_id)
    }
    _ => RuntimeValue::from_expr(expr)
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
