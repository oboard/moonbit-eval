///|
/// 运行时类型信息 - 包含包名、类型名和环境
pub struct RuntimeType {
  name : String
  path : String
  env : RuntimeEnvironment
}

///|
pub fn RuntimeType::to_string(self : RuntimeType) -> String {
  (if self.path == "main" { "" } else { "@" + self.path + "." }) + self.name
}

///|
pub fn RuntimeType::bool() -> RuntimeType {
  {
    path: moonbitlang_core_bool_module.meta.name,
    name: "Bool",
    env: moonbitlang_core_bool_module.env,
  }
}

///|
pub fn RuntimeType::int() -> RuntimeType {
  {
    path: moonbitlang_core_int_module.meta.name,
    name: "Int",
    env: moonbitlang_core_int_module.env,
  }
}

///|
pub fn RuntimeType::uint() -> RuntimeType {
  {
    path: moonbitlang_core_uint_module.meta.name,
    name: "UInt",
    env: moonbitlang_core_uint_module.env,
  }
}

///|
pub fn RuntimeType::int64() -> RuntimeType {
  {
    path: moonbitlang_core_int64_module.meta.name,
    name: "Int64",
    env: moonbitlang_core_int64_module.env,
  }
}

///|
pub fn RuntimeType::uint16() -> RuntimeType {
  {
    path: moonbitlang_core_uint16_module.meta.name,
    name: "UInt16",
    env: moonbitlang_core_uint16_module.env,
  }
}

///|
pub fn RuntimeType::uint64() -> RuntimeType {
  {
    path: moonbitlang_core_uint64_module.meta.name,
    name: "UInt64",
    env: moonbitlang_core_uint64_module.env,
  }
}

///|
pub fn RuntimeType::float() -> RuntimeType {
  {
    path: moonbitlang_core_float_module.meta.name,
    name: "Float",
    env: moonbitlang_core_float_module.env,
  }
}

///|
pub fn RuntimeType::double() -> RuntimeType {
  {
    path: moonbitlang_core_double_module.meta.name,
    name: "Double",
    env: moonbitlang_core_double_module.env,
  }
}

///|
pub fn RuntimeType::bigint() -> RuntimeType {
  {
    path: moonbitlang_core_bigint_module.meta.name,
    name: "BigInt",
    env: moonbitlang_core_bigint_module.env,
  }
}

///|
pub fn RuntimeType::char() -> RuntimeType {
  {
    path: moonbitlang_core_char_module.meta.name,
    name: "Char",
    env: moonbitlang_core_char_module.env,
  }
}

///|
pub fn RuntimeType::byte() -> RuntimeType {
  {
    path: moonbitlang_core_byte_module.meta.name,
    name: "Byte",
    env: moonbitlang_core_byte_module.env,
  }
}

///|
pub fn RuntimeType::string() -> RuntimeType {
  {
    path: moonbitlang_core_string_module.meta.name,
    name: "String",
    env: moonbitlang_core_string_module.env,
  }
}

///|
pub fn RuntimeType::bytes() -> RuntimeType {
  {
    path: moonbitlang_core_bytes_module.meta.name,
    name: "Bytes",
    env: moonbitlang_core_bytes_module.env,
  }
}

///|
pub fn RuntimeType::tuple() -> RuntimeType {
  {
    path: moonbitlang_core_tuple_module.meta.name,
    name: "Tuple",
    env: moonbitlang_core_tuple_module.env,
  }
}

///|
pub fn RuntimeType::array() -> RuntimeType {
  {
    path: moonbitlang_core_array_module.meta.name,
    name: "Array",
    env: moonbitlang_core_array_module.env,
  }
}

///|
pub fn RuntimeType::array_view() -> RuntimeType {
  {
    path: moonbitlang_core_array_module.meta.name,
    name: "ArrayView",
    env: moonbitlang_core_array_module.env,
  }
}

///|
pub fn RuntimeType::uninitialized_array() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "UninitializedArray",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::map() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "Map",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::json() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "Json",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::option() -> RuntimeType {
  {
    path: moonbitlang_core_option_module.meta.name,
    name: "Option",
    env: moonbitlang_core_option_module.env,
  }
}

///|
pub fn RuntimeType::result() -> RuntimeType {
  {
    path: moonbitlang_core_result_module.meta.name,
    name: "Result",
    env: moonbitlang_core_result_module.env,
  }
}

///|
pub fn RuntimeType::iter() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "Iter",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::any() -> RuntimeType {
  { path: "main", name: "Any", env: RuntimeEnvironment::new() }
}

///|
/// 带类型信息的值包装器
pub struct WithType[T] {
  val : T
  type_info : RuntimeType
}
