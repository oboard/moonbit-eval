///|
/// 构造器字段 - 支持带标签和可变性
pub(all) struct ConstructorField {
  name : String? // 字段名称，None表示位置参数
  mut value : RuntimeValue // 字段值
  mutable : Bool // 是否可变
}

///|
/// 构造器值 - 包含构造器名称和字段
pub(all) struct ConstructorValue {
  name : String // 构造器名称
  fields : Array[ConstructorField] // 字段列表
}

///|
/// 运行时值 - 解释器实际操作的数据类型
pub(all) enum RuntimeValue {
  // 基本值类型
  Unit
  Bool(Bool)
  Int(Int)
  UInt(UInt)
  UInt16(UInt16)
  Int64(Int64)
  UInt64(UInt64)
  Float(Float)
  Double(Double)
  BigInt(BigInt)
  Char(Char)
  Byte(Byte)
  String(String)
  Bytes(Bytes)
  StringView(@string.View)
  StringBuilder(StringBuilder)

  // 复合值类型
  Tuple(Array[RuntimeValue])
  Array(Array[RuntimeValue])
  FixedArray(FixedArray[RuntimeValue])
  ArrayView(@array.View[RuntimeValue])
  UninitializedArray(UninitializedArray[RuntimeValue])
  Map(Map[RuntimeValue, RuntimeValue])

  // 结构类型 - 直接存储字段映射
  Struct(WithType[Map[String, RuntimeValue]])

  // 闭包 - 包含函数定义和捕获的环境（所有函数都是闭包）
  Closure(@syntax.Func, RuntimeEnvironment)

  // 构造函数调用 - 支持带标签参数和可变字段
  Constructor(WithType[ConstructorValue])

  // 异常处理 - 用于实现raise和try语句
  Exception(String) // 异常信息

  // 迭代器类型 - 用于实现内部迭代器
  Iter(Iter[RuntimeValue])

  // 双参数迭代器类型 - 用于实现带索引的迭代器
  Iter2(Iter2[RuntimeValue, RuntimeValue])

  // JSON 类型 - 用于 JSON 数据处理
  Json(Json)
}

///|
pub suberror ControlFlow {
  Raise(RuntimeValue)
  Continue(Array[RuntimeValue])
  Break(RuntimeValue)
  Return(RuntimeValue)
  Error(String)
}

///|
pub impl Compare for RuntimeValue with compare(self, other) {
  match (self, other) {
    (Int(a), Int(b)) => a.compare(b)
    (UInt(a), UInt(b)) => a.compare(b)
    (Int64(a), Int64(b)) => a.compare(b)
    (UInt64(a), UInt64(b)) => a.compare(b)
    (Float(a), Float(b)) => a.compare(b)
    (Double(a), Double(b)) => a.compare(b)
    (BigInt(a), BigInt(b)) => a.compare(b)
    (String(a), String(b)) => a.compare(b)
    (Char(a), Char(b)) => a.compare(b)
    (Byte(a), Byte(b)) => a.compare(b)
    (Bytes(a), Bytes(b)) => a.compare(b)
    (StringView(a), StringView(b)) => a.compare(b)
    (StringBuilder(a), StringBuilder(b)) => a.to_string().compare(b.to_string())
    (Tuple(a), Tuple(b)) => a.compare(b)
    (Array(a), Array(b)) => a.compare(b)
    (Json(a), Json(b)) => a.to_string().compare(b.to_string())
    _ => abort("unable to compare")
  }
}

///|
pub impl Hash for RuntimeValue with hash_combine(
  self : RuntimeValue,
  hasher : Hasher,
) -> Unit {
  hasher.combine(self)
}

///|
pub impl Add for RuntimeValue with op_add(
  self : RuntimeValue,
  other : RuntimeValue,
) -> RuntimeValue {
  match (self, other) {
    (Int(a), Int(b)) => Int(a + b)
    (UInt(a), UInt(b)) => UInt(a + b)
    (Int64(a), Int64(b)) => Int64(a + b)
    (UInt64(a), UInt64(b)) => UInt64(a + b)
    (Float(a), Float(b)) => Float(a + b)
    (Double(a), Double(b)) => Double(a + b)
    (BigInt(a), BigInt(b)) => BigInt(a + b)
    (String(a), String(b)) => String(a + b)
    (Char(a), Char(b)) => String(a.to_string() + b.to_string())
    (Byte(a), Byte(b)) => Byte(a + b)
    (Bytes(a), Bytes(b)) => Bytes(a + b)
    (StringView(a), StringView(b)) => StringView(a + b)
    (StringBuilder(a), StringBuilder(b)) => {
      let result = StringBuilder::new()
      result.write_string(a.to_string())
      result.write_string(b.to_string())
      StringBuilder(result)
    }
    (StringBuilder(sb), String(s)) => {
      let result = StringBuilder::new()
      result.write_string(sb.to_string())
      result.write_string(s)
      StringBuilder(result)
    }
    (String(s), StringBuilder(sb)) => {
      let result = StringBuilder::new()
      result.write_string(s)
      result.write_string(sb.to_string())
      StringBuilder(result)
    }
    (Tuple(a), Tuple(b)) => Tuple(a + b)
    (Array(a), Array(b)) => Array(a + b)
    _ => abort("unable to add")
  }
}

///|
pub impl Hash for RuntimeValue with hash(self : RuntimeValue) -> Int {
  match self {
    Unit => 0
    Bool(b) => b.hash()
    Int(i) => i.hash()
    UInt(u) => u.hash()
    Int64(i) => i.hash()
    UInt64(u) => u.hash()
    Float(f) => f.hash()
    Double(d) => d.hash()
    BigInt(b) => b.hash()
    Char(c) => c.hash()
    Byte(b) => b.hash()
    String(s) => s.hash()
    Bytes(b) => b.hash()
    StringView(sv) => sv.hash()
    Tuple(t) => t.hash()
    Array(a) => a.hash()
    Json(j) => j.to_string().hash()
    _ => abort("unable to hash")
  }
}

///|
/// 为 RuntimeValue 实现自定义的 ToJson trait
pub impl ToJson for RuntimeValue with to_json(self : RuntimeValue) -> Json {
  match self {
    Map(m) => m.to_json()
    Unit => Json::null()
    Bool(b) => b.to_json()
    Int(i) => i.to_json()
    UInt(u) => u.to_json()
    Int64(i) => i.to_json()
    UInt16(u) => u.to_json()
    UInt64(u) => u.to_json()
    Float(f) => f.to_json()
    Double(d) => d.to_json()
    BigInt(b) => b.to_json()
    Char(c) => c.to_json()
    Byte(b) => b.to_json()
    String(s) => s.to_json()
    Bytes(b) => b.to_string().to_json()
    StringView(sv) => sv.to_string().to_json()
    StringBuilder(sb) => sb.to_string().to_json()
    Tuple(t) => t.to_json()
    Array(a) => a.to_json()
    FixedArray(a) => a.to_json()
    ArrayView(a) => a.to_json()
    Struct(s) => s.val.to_json()
    Closure(f, _) => f.to_json()
    Constructor({ val: { name, fields }, .. }) => {
      let args = fields.map(fn(field) { field.value })
      [name, args.to_json()]
    }
    Exception(msg) => ["exception", msg.to_json()]
    Iter(_) => ["iterator", Json::null()]
    Iter2(_) => ["iter2", Json::null()]
    UninitializedArray(_) => ["uninitialized_array", Json::null()]
    Json(j) => j
  }
}

///| 为 RuntimeValue 实现自定义的 Eq trait

///|
/// 特别处理 Function 类型，通过函数签名比较相等性
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
    (Bytes(a), Bytes(b)) => a == b
    (StringView(a), StringView(b)) => a == b
    (StringBuilder(a), StringBuilder(b)) => a.to_string() == b.to_string()

    // 复合值类型比较
    (Tuple(a), Tuple(b)) | (Array(a), Array(b)) => a == b

    // 结构类型比较
    (Struct({ val: a, .. }), Struct({ val: b, .. })) => a == b

    // 闭包类型的比较 - 比较函数签名和环境
    (Closure(func_a, _), Closure(func_b, _)) =>
      compare_function_signatures(func_a, func_b)

    // 构造函数比较
    (
      Constructor({ val: { name: name_a, fields: fields_a }, .. }),
      Constructor({ val: { name: name_b, fields: fields_b }, .. }),
    ) =>
      if name_a != name_b || fields_a.length() != fields_b.length() {
        false
      } else {
        let mut all_equal = true
        for i = 0; i < fields_a.length(); i = i + 1 {
          if fields_a[i].value != fields_b[i].value {
            all_equal = false
            break
          }
        }
        all_equal
      }

    // 不同类型之间不相等
    _ => false
  }
}

///| 比较两个函数的签名是否相等

///|
/// 通过参数类型、返回类型等信息判断函数是否相同
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

///|
/// 比较两个参数的签名是否相等
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

///|
fn RuntimeValue::from_constant(c : @syntax.Constant) -> RuntimeValue {
  match c {
    Bool(b) => Bool(b)
    Int(s) => Int(@strconv.parse_int(s) catch { _ => 0 })
    UInt(s) => UInt(@strconv.parse_uint(s) catch { _ => 0U })
    Int64(s) => Int64(@strconv.parse_int64(s) catch { _ => 0L })
    UInt64(s) => UInt64(@strconv.parse_uint64(s) catch { _ => 0UL })
    Float(s) => Float((@strconv.parse_double(s) catch { _ => 0.0 }).to_float())
    Double(s) => Double(@strconv.parse_double(s) catch { _ => 0.0 })
    Byte(s) => {
      let int_val = @strconv.parse_int(s) catch { _ => 0 }
      Byte(int_val.to_byte())
    }
    Char(s) => Char(s.get_char(0).unwrap_or(' '))
    String(s) => String(s)
    BigInt(bigint) => BigInt(@bigint.BigInt::from_string(bigint))
    _ => abort("Constant: not implemented")
  }
}

///|
/// 从@syntax.Type中提取简单的类型名
pub fn extract_type_name(ty : @syntax.Type) -> String {
  match ty {
    Name(constr_id={ id: Ident(name~), .. }, ..) => name
    Name(constr_id={ id: Dot(id~, ..), .. }, ..) => id
    _ => "Any"
  }
}

///|
/// 重载字面量转换 - 将默认类型的RuntimeValue转换为期望的类型
/// 遵循MoonBit重载字面量规则，同时支持模式匹配中的隐式转换
pub fn RuntimeValue::overload_literal(
  self : RuntimeValue,
  expected_type : String,
) -> RuntimeValue {
  match (self, expected_type) {
    // 数字字面量重载 (默认Int -> 其他数字类型)
    (Int(i), "UInt") => UInt(i.reinterpret_as_uint())
    (Int(i), "Int64") => Int64(i.to_int64())
    (Int(i), "UInt64") => UInt64(i.to_uint64())
    (Int(i), "UInt16") => UInt16(i.to_uint16())
    (Int(i), "Byte") => Byte(i.to_byte())
    (Int(i), "Double") => Double(i.to_double())
    (Int(i), "Float") => Float(i.to_float())
    (Int(i), "BigInt") => BigInt(BigInt::from_int(i))

    // 字符串字面量重载 (默认String -> Bytes)
    (String(s), "Bytes") => Bytes(@encoding.encode(UTF8, s))

    // 字符字面量重载 (默认Char -> Int/Byte)
    (Char(c), "Int") => Int(c.to_int())
    (Char(c), "Byte") => Byte(c.to_int().to_byte())

    // 浮点数字面量重载 (默认Double -> Float)
    (Double(d), "Float") => Float(d.to_float())

    // JSON 类型重载 - 支持基本类型到 JSON 的转换
    (Int(i), "Json") => Json(i.to_json())
    (Double(d), "Json") => Json(d.to_json())
    (String(s), "Json") => Json(s.to_json())
    (Bool(b), "Json") => Json(b.to_json())

    // Map 到 Json 的转换 - 处理对象字面量
    (Map(m), "Json") =>
      // 和其他基本类型一样的方法：使用 to_json() 转换
      Json(m.to_json())

    // Array 到 Json 的转换 - 处理数组字面量  
    (Array(arr), "Json") => {
      // 简单的转换：将 Array 转换为 Json 字符串表示
      let json_str = arr.to_string() // 这会生成类似 ["item1", "item2"] 的格式
      Json(@json.parse(json_str) catch { _ => return self })
    }

    // 模式匹配中的隐式转换
    (Array(arr), "ArrayView") => ArrayView(arr)

    // Array[Char] -> String 转换
    (Array(arr), "String") => {
      let chars = []
      for i = 0; i < arr.length(); i = i + 1 {
        match arr[i] {
          Char(c) => chars.push(c)
          _ => return self // 如果不是Char数组，返回原值
        }
      }
      String(String::from_array(chars))
    }

    // Array[Int] -> Bytes 转换
    (Array(arr), "Bytes") => {
      let bytes = []
      for i = 0; i < arr.length(); i = i + 1 {
        match arr[i] {
          Int(n) => bytes.push(n.to_byte())
          Byte(b) => bytes.push(b)
          _ => return self // 如果不是Int数组，返回原值
        }
      }
      Bytes(Bytes::from_array(bytes))
    }

    // 如果类型匹配或无法转换，返回原值
    _ => self
  }
}

///|
/// 带期望类型的常量创建函数
pub fn RuntimeValue::from_constant_with_type(
  c : @syntax.Constant,
  expected_type : String?,
) -> RuntimeValue {
  let default_value = RuntimeValue::from_constant(c)
  match expected_type {
    Some(ty) => default_value.overload_literal(ty)
    None => default_value
  }
}

///|
/// 比较两个可选类型是否相等
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

///|
/// 比较两个类型签名是否相等
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
  val : RuntimeValue
  kind : RuntimeArgumentKind
}

///|
pub(all) enum RuntimeArgumentKind {
  Positional
  Labelled(String)
  LabelledOption(String)
}

///|
pub fn RuntimeArgumentKind::from_syntax(
  arg : @syntax.ArgumentKind,
) -> RuntimeArgumentKind {
  match arg {
    Positional => Positional
    Labelled({ name, .. }) | LabelledPun({ name, .. }) => Labelled(name)
    LabelledOption(label={ name, .. }, ..)
    | LabelledOptionPun(label={ name, .. }, ..) => LabelledOption(name)
  }
}

///|
/// 检查值是否为引用类型
pub fn RuntimeValue::is_reference(self : RuntimeValue) -> Bool {
  match self {
    Struct(_) => true
    Constructor(_) => true
    _ => false
  }
}

///|
/// 检查数组元素是否可以重载为指定类型
fn can_overload_array_elements(
  elements : Array[RuntimeValue],
  element_type : String,
) -> Bool {
  let mut all_match = true
  for elem in elements {
    match (elem, element_type) {
      (Int(_), "Byte") => continue
      (Char(_), "Char") => continue
      (Int(_), "Int") => continue
      (Double(_), "Double") => continue
      (String(_), "String") => continue
      _ => {
        all_match = false
        break
      }
    }
  }
  all_match
}

///|
/// 重载数组字面量 - 支持组合重载如[1,2,3] -> Bytes
pub fn RuntimeValue::overload_array_literal(
  self : RuntimeValue,
  expected_type : String,
) -> RuntimeValue {
  match (self, expected_type) {
    (Array(elements), "Bytes") =>
      if can_overload_array_elements(elements, "Byte") {
        let bytes = elements.map(fn(elem) {
          match elem.overload_literal("Byte") {
            Byte(b) => b
            _ => 0
          }
        })
        Bytes(Bytes::from_array(bytes))
      } else {
        self
      }
    (Array(elements), "String") =>
      if can_overload_array_elements(elements, "Char") {
        let chars = elements.map(fn(elem) {
          match elem {
            Char(c) => c
            _ => ' '
          }
        })
        String(String::from_array(chars))
      } else {
        self
      }
    (Array(elements), "ArrayView") => ArrayView(elements[:])
    _ => self
  }
}

///|
/// 检查值是否为可变类型
pub fn RuntimeValue::is_mutable(self : RuntimeValue) -> Bool {
  match self {
    Struct(_) => true
    _ => false
  }
}

///|
/// 从类型名称推断期望的RuntimeValue类型
pub fn get_expected_runtime_type(type_name : String) -> String? {
  match type_name {
    "Int" => Some("Int")
    "UInt" => Some("UInt")
    "Int64" => Some("Int64")
    "UInt64" => Some("UInt64")
    "UInt16" => Some("UInt16")
    "Byte" => Some("Byte")
    "Double" => Some("Double")
    "Float" => Some("Float")
    "BigInt" => Some("BigInt")
    "String" => Some("String")
    "Bytes" => Some("Bytes")
    "Char" => Some("Char")
    "Bool" => Some("Bool")
    "Json" => Some("Json")
    _ => None
  }
}

///|
pub impl Show for RuntimeValue with output(self, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
/// 将RuntimeValue转换为字符串表示
pub impl Show for RuntimeValue with to_string(self) -> String {
  match self {
    Unit => "()"
    Bool(b) => b.to_string()
    Int(i) => i.to_string()
    UInt(u) => u.to_string()
    UInt16(u) => u.to_string()
    Int64(i64) => i64.to_string()
    UInt64(u64) => u64.to_string()
    Float(f) => f.to_string()
    Double(d) => d.to_string()
    BigInt(b) => b.to_string()
    Char(c) => c.to_string()
    Byte(b) => b.to_int().to_string()
    String(s) => s
    Bytes(b) => b.to_string()
    StringView(sv) => sv.to_string()
    StringBuilder(sb) => sb.to_string()
    Tuple(values) => {
      let parts = values.map(fn(v) { v.to_string() })
      "(" + parts.join(", ") + ")"
    }
    Array(values) => {
      let parts = values
        .map(val => match val {
          String(s) => "\"\{s}\""
          _ => val.to_string()
        })
        .join(", ")
      "[\{parts}]"
    }
    FixedArray(values) => {
      let parts = values
        .map(val => match val {
          String(s) => "\"\{s}\""
          _ => val.to_string()
        })
        .join(", ")
      "[\{parts}]"
    }
    ArrayView(values) => {
      let parts = values
        .map(val => match val {
          String(s) => "\"\{s}\""
          _ => val.to_string()
        })
        .join(", ")
      "[\{parts}]"
    }
    UninitializedArray(_) => "<uninitialized_array>"
    Map(entities) => {
      let parts = entities
        .map(fn(key, val) {
          let key_str = match key {
            String(s) => "\"\{s}\""
            _ => key.to_string()
          }
          let val_str = match val {
            String(s) => "\"\{s}\""
            _ => val.to_string()
          }
          "\{key_str}: \{val_str}"
        })
        .values()
        .join(", ")
      "{\{parts}}"
    }
    Struct(fields) => {
      let parts = []
      fields.val.each(fn(field_name, field_value) {
        parts.push(field_name + ": " + field_value.to_string())
      })
      "\{self.get_type()}::{" + parts.join(", ") + "}"
    }
    Constructor({ val: { name, fields }, .. }) =>
      // Format constructor call with field names if present
      if fields.length() == 0 {
        "\{name}"
      } else {
        let arg_strs = fields.map(fn(field) {
          match field.name {
            Some(field_name) => field_name + "=" + field.value.to_string()
            None => field.value.to_string()
          }
        })
        name + "(" + arg_strs.join(", ") + ")"
      }
    Iter(_) => "<iterator>"
    Iter2(_) => "<iter2>"
    // 从函数中提取参数和返回类型信息
    Closure(func, _env) => {
      fn infer_func_type(func : @syntax.Func) -> String {
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
              Some(t) =>
                "(" + param_strs.join(", ") + ") -> " + type_to_string(t)
              None => {
                // 对于没有显式返回类型的函数，无法在这里进行复杂的类型推导
                // 因为这里没有解释器上下文，所以只能进行简单的推导
                let inferred_type = match body {
                  Constant(c~, ..) =>
                    match c {
                      Int(_) => "Int"
                      UInt(_) => "UInt"
                      Int64(_) => "Int64"
                      // UInt16(_) => "UInt16"
                      UInt64(_) => "UInt64"
                      Float(_) => "Float"
                      Double(_) => "Double"
                      BigInt(_) => "BigInt"
                      Char(_) => "Char"
                      Byte(_) => "Byte"
                      String(_) => "String"
                      Bool(_) => "Bool"
                      Bytes(_) => "Bytes"
                    }
                  Unit(..) => "Unit"
                  Array(..) => "Array"
                  Tuple(..) => "Tuple"
                  Record(..) => "Record"
                  Apply(
                    func=Function(func=Lambda(return_type=Some(ty), ..), ..),
                    ..
                  ) => type_to_string(ty)
                  _ => "Any"
                }
                "(" + param_strs.join(", ") + ") -> " + inferred_type
              }
            }
          }
          _ => "<function>"
        }
      }

      infer_func_type(func)
    }
    Exception(msg) => "exception: " + msg
    Json(j) => j.to_string()
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
        // 泛型
        let type_strs = tys.map(fn(t) { type_to_string(t) })
        name + "[" + type_strs.to_array().join(", ") + "]"
      }
    Name(constr_id={ id: Dot(pkg~, id~), .. }, tys~, ..) =>
      if tys.is_empty() {
        if pkg == "" {
          id // 对于空包名，直接返回类型名
        } else {
          "@" + pkg + "." + id
        }
      } else {
        // 泛型
        let type_strs = tys.map(fn(t) { type_to_string(t) })
        let prefix = if pkg == "" { id } else { "@" + pkg + "." + id }
        prefix + "[" + type_strs.to_array().join(", ") + "]"
      }
    Option(ty~, ..) => type_to_string(ty) + "?"
    Object(_) => "Object"
  }
}

///|
/// 将RuntimeValue转换为表达式（用于输出）
pub fn RuntimeValue::to_expr(self : RuntimeValue) -> @syntax.Expr {
  let _dummy_loc = @basic.Location::{
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
  match self {
    Map(_) => Unit(loc=_dummy_loc, faked=true)
    Unit => Unit(loc=_dummy_loc, faked=true)
    Bool(b) => Constant(c=Bool(b), loc=_dummy_loc)
    Int(i) => Constant(c=Int(i.to_string()), loc=_dummy_loc)
    UInt(u) => Constant(c=Int(u.to_string()), loc=_dummy_loc)
    UInt16(u) => Constant(c=Int(u.to_string()), loc=_dummy_loc)
    Int64(i64) => Constant(c=Int64(i64.to_string()), loc=_dummy_loc)
    UInt64(u64) => Constant(c=UInt64(u64.to_string()), loc=_dummy_loc)
    Float(f) => Constant(c=Float(f.to_string()), loc=_dummy_loc)
    Double(d) => Constant(c=Double(d.to_string()), loc=_dummy_loc)
    BigInt(b) => Constant(c=BigInt(b.to_string()), loc=_dummy_loc)
    Char(c) => Constant(c=Char(c.to_string()), loc=_dummy_loc)
    Byte(b) => Constant(c=Int(b.to_int().to_string()), loc=_dummy_loc)
    String(s) => Constant(c=String(s), loc=_dummy_loc)
    Bytes(b) => Constant(c=Bytes(b.to_string()), loc=_dummy_loc)
    StringView(sv) => Constant(c=String(sv.to_string()), loc=_dummy_loc)
    Tuple(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      Tuple(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    Array(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      Array(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    FixedArray(values) => {
      let exprs = Array::from_fixed_array(values.map(fn(v) { v.to_expr() }))
      Array(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    ArrayView(values) => {
      let exprs = values.map(fn(v) { v.to_expr() })
      Array(exprs=@list.from_array(exprs), loc=_dummy_loc)
    }
    UninitializedArray(_) => Unit(loc=_dummy_loc, faked=true)
    // 结构类型转换为Record表达式
    Struct(_) => Unit(loc=_dummy_loc, faked=true)
    Closure(func, _env) => Function(func~, loc=_dummy_loc)
    Constructor(_) => Unit(loc=_dummy_loc, faked=true)
    Exception(_) => Unit(loc=_dummy_loc, faked=true)
    Iter(_) => Unit(loc=_dummy_loc, faked=true)
    Iter2(_) => Unit(loc=_dummy_loc, faked=true)
    Json(_) => Unit(loc=_dummy_loc, faked=true)
    StringBuilder(sb) => Constant(c=String(sb.to_string()), loc=_dummy_loc)
  }
}

///|
/// 将@syntax.Expr转换为RuntimeValue
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
        Bytes(b) => Bytes(b.to_bytes())
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
      Struct({ val: struct_data, ty: Any })
    }
    Ident(..) => Unit // Ident表达式需要通过环境查找，这里返回Unit作为占位符
    Sequence(last_expr~, ..) =>
      // 对于Sequence表达式，只关心最后一个表达式的值
      RuntimeValue::from_expr(last_expr)
    _ => Unit
  }
}

///|
/// 为 RuntimeValue 实现 iter2() 方法，返回双值迭代器
/// 根据 iter2.mbt 中的 iter2_iter_fn，应该返回 Iter，其中每个元素是元组
pub fn RuntimeValue::iter2(self : RuntimeValue) -> RuntimeValue {
  match self {
    Array(arr) => {
      // 将数组转换为 Iter2，每个元素是 (index, value) 元组
      let iter_impl = Iter2::new(fn(f) {
        for i = 0; i < arr.length(); i = i + 1 {
          match f(Int(i), arr[i]) {
            IterEnd => return IterEnd
            IterContinue => ()
          }
        }
        IterEnd
      })
      Iter2(iter_impl)
    }
    String(str) => {
      // 将字符串转换为 Iter2，每个元素是 (index, char) 元组
      let chars = str.to_array()
      let iter_impl = Iter2::new(fn(f) {
        for i = 0; i < chars.length(); i = i + 1 {
          match f(Int(i), Char(chars[i])) {
            IterEnd => return IterEnd
            IterContinue => ()
          }
        }
        IterEnd
      })
      Iter2(iter_impl)
    }
    StringBuilder(sb) => {
      // 将 StringBuilder 转换为 Iter2，每个元素是 (index, char) 元组
      let str = sb.to_string()
      let chars = str.to_array()
      let iter_impl = Iter2::new(fn(f) {
        for i = 0; i < chars.length(); i = i + 1 {
          match f(Int(i), Char(chars[i])) {
            IterEnd => return IterEnd
            IterContinue => ()
          }
        }
        IterEnd
      })
      Iter2(iter_impl)
    }
    _ => Iter2(Iter2::new(fn(_) { IterEnd }))
  }
}

///|
/// RuntimeValue 之间的中缀运算 - 消除对 constant_infix 的依赖
pub fn runtime_value_infix(
  op : String,
  lhs : RuntimeValue,
  rhs : RuntimeValue,
) -> RuntimeValue {
  match (lhs, rhs) {
    // Int 运算
    (Int(left), Char(right)) =>
      runtime_value_infix(op, Int(left), Int(right.to_int()))
    (Char(left), Int(right)) =>
      runtime_value_infix(op, Int(left.to_int()), Int(right))
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
        // 增强赋值操作符 - 注意：这些操作符不应该在这里处理
        // 它们应该在解释器的 Infix 处理中被特殊处理
        "+=" | "-=" | "*=" | "/=" | "%=" => Unit
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
    // String 和 Char 混合运算
    (String(left), Char(right)) =>
      match op {
        "+" => String(left + right.to_string())
        "==" => Bool(false)
        "!=" => Bool(true)
        _ => Unit
      }
    (Char(left), String(right)) =>
      match op {
        "+" => String(left.to_string() + right)
        "==" => Bool(false)
        "!=" => Bool(true)
        _ => Unit
      }
    // Char 运算
    (Char(left), Char(right)) =>
      match op {
        "+" => String(left.to_string() + right.to_string())
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    // Bytes 运算
    (Bytes(left), Bytes(right)) =>
      match op {
        "+" => Bytes(left + right)
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    // StringView 运算
    (StringView(left), StringView(right)) =>
      match op {
        "+" => StringView(left + right)
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    (Array(left), Array(right)) =>
      match op {
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    (Map(left), Map(right)) =>
      match op {
        "==" => Bool(left == right)
        "!=" => Bool(left != right)
        _ => Unit
      }
    _ => Unit
  }
}

///|
pub fn RuntimeValue::from_option(val : RuntimeValue?) -> RuntimeValue {
  match val {
    Some(x) =>
      Constructor({
        val: {
          name: "Some",
          fields: [{ name: None, value: x, mutable: false }],
        },
        ty: RuntimeType::option(),
      })
    None =>
      Constructor({
        val: { name: "None", fields: [] },
        ty: RuntimeType::option(),
      })
  }
}

///|
pub fn RuntimeValue::from_result(
  val : Result[RuntimeValue, RuntimeValue],
) -> RuntimeValue {
  match val {
    Ok(x) =>
      Constructor({
        val: { name: "Ok", fields: [{ name: None, value: x, mutable: false }] },
        ty: RuntimeType::result(),
      })
    Err(x) =>
      Constructor({
        val: { name: "Err", fields: [{ name: None, value: x, mutable: false }] },
        ty: RuntimeType::result(),
      })
  }
}
