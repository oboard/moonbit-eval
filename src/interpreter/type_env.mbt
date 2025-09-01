///|
/// 运行时类型信息 - 包含包名、类型名和环境
pub struct RuntimeType {
  name : String
  mod : RuntimePackage
} derive(ToJson)

///|
pub fn RuntimeType::to_string(self : RuntimeType) -> String {
  (if self.mod.meta.name == "main" {
    ""
  } else {
    "@" + self.mod.meta.name + "."
  }) +
  self.name
}

///|
pub fn RuntimeType::bool() -> RuntimeType {
  { name: "Bool", mod: moonbitlang_core_bool_module }
}

///|
pub fn RuntimeType::int() -> RuntimeType {
  { name: "Int", mod: moonbitlang_core_int_module }
}

///|
pub fn RuntimeType::uint() -> RuntimeType {
  { name: "UInt", mod: moonbitlang_core_uint_module }
}

///|
pub fn RuntimeType::int64() -> RuntimeType {
  { name: "Int64", mod: moonbitlang_core_int64_module }
}

///|
pub fn RuntimeType::uint16() -> RuntimeType {
  { name: "UInt16", mod: moonbitlang_core_uint16_module }
}

///|
pub fn RuntimeType::uint64() -> RuntimeType {
  { name: "UInt64", mod: moonbitlang_core_uint64_module }
}

///|
pub fn RuntimeType::float() -> RuntimeType {
  { name: "Float", mod: moonbitlang_core_float_module }
}

///|
pub fn RuntimeType::double() -> RuntimeType {
  { name: "Double", mod: moonbitlang_core_double_module }
}

///|
pub fn RuntimeType::bigint() -> RuntimeType {
  { name: "BigInt", mod: moonbitlang_core_bigint_module }
}

///|
pub fn RuntimeType::char() -> RuntimeType {
  { name: "Char", mod: moonbitlang_core_char_module }
}

///|
pub fn RuntimeType::byte() -> RuntimeType {
  { name: "Byte", mod: moonbitlang_core_byte_module }
}

///|
pub fn RuntimeType::string() -> RuntimeType {
  { name: "String", mod: moonbitlang_core_string_module }
}

///|
pub fn RuntimeType::bytes() -> RuntimeType {
  { name: "Bytes", mod: moonbitlang_core_bytes_module }
}

///|
pub fn RuntimeType::tuple() -> RuntimeType {
  { name: "Tuple", mod: moonbitlang_core_tuple_module }
}

///|
pub fn RuntimeType::array() -> RuntimeType {
  { name: "Array", mod: moonbitlang_core_array_module }
}

///|
pub fn RuntimeType::array_view() -> RuntimeType {
  { name: "ArrayView", mod: moonbitlang_core_array_module }
}

///|
pub fn RuntimeType::uninitialized_array() -> RuntimeType {
  { name: "UninitializedArray", mod: moonbitlang_core_builtin_module }
}

///|
pub fn RuntimeType::map() -> RuntimeType {
  { name: "Map", mod: moonbitlang_core_builtin_module }
}

///|
pub fn RuntimeType::json() -> RuntimeType {
  { name: "Json", mod: moonbitlang_core_builtin_module }
}

///|
pub fn RuntimeType::option() -> RuntimeType {
  { name: "Option", mod: moonbitlang_core_option_module }
}

///|
pub fn RuntimeType::result() -> RuntimeType {
  { name: "Result", mod: moonbitlang_core_result_module }
}

///|
pub fn RuntimeType::iter() -> RuntimeType {
  { name: "Iter", mod: moonbitlang_core_builtin_module }
}

///|
pub fn RuntimeType::list() -> RuntimeType {
  { name: "List", mod: moonbitlang_core_list_module }
}

///|
pub fn RuntimeType::any() -> RuntimeType {
  { name: "Any", mod: RuntimePackage::new("main") }
}

///|
/// 带类型信息的值包装器
pub struct WithType[T] {
  val : T
  ty : RuntimeType
} derive(ToJson)
