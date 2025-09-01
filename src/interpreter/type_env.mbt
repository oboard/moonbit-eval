///|
/// 运行时类型信息 - 包含包名、类型名和环境
pub struct RuntimeType {
  name : String
  path : String
  mod : RuntimeModule
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
    mod: moonbitlang_core_bool_module,
  }
}

///|
pub fn RuntimeType::int() -> RuntimeType {
  {
    path: moonbitlang_core_int_module.meta.name,
    name: "Int",
    mod: moonbitlang_core_int_module,
  }
}

///|
pub fn RuntimeType::uint() -> RuntimeType {
  {
    path: moonbitlang_core_uint_module.meta.name,
    name: "UInt",
    mod: moonbitlang_core_uint_module,
  }
}

///|
pub fn RuntimeType::int64() -> RuntimeType {
  {
    path: moonbitlang_core_int64_module.meta.name,
    name: "Int64",
    mod: moonbitlang_core_int64_module,
  }
}

///|
pub fn RuntimeType::uint16() -> RuntimeType {
  {
    path: moonbitlang_core_uint16_module.meta.name,
    name: "UInt16",
    mod: moonbitlang_core_uint16_module,
  }
}

///|
pub fn RuntimeType::uint64() -> RuntimeType {
  {
    path: moonbitlang_core_uint64_module.meta.name,
    name: "UInt64",
    mod: moonbitlang_core_uint64_module,
  }
}

///|
pub fn RuntimeType::float() -> RuntimeType {
  {
    path: moonbitlang_core_float_module.meta.name,
    name: "Float",
    mod: moonbitlang_core_float_module,
  }
}

///|
pub fn RuntimeType::double() -> RuntimeType {
  {
    path: moonbitlang_core_double_module.meta.name,
    name: "Double",
    mod: moonbitlang_core_double_module,
  }
}

///|
pub fn RuntimeType::bigint() -> RuntimeType {
  {
    path: moonbitlang_core_bigint_module.meta.name,
    name: "BigInt",
    mod: moonbitlang_core_bigint_module,
  }
}

///|
pub fn RuntimeType::char() -> RuntimeType {
  {
    path: moonbitlang_core_char_module.meta.name,
    name: "Char",
    mod: moonbitlang_core_char_module,
  }
}

///|
pub fn RuntimeType::byte() -> RuntimeType {
  {
    path: moonbitlang_core_byte_module.meta.name,
    name: "Byte",
    mod: moonbitlang_core_byte_module,
  }
}

///|
pub fn RuntimeType::string() -> RuntimeType {
  {
    path: moonbitlang_core_string_module.meta.name,
    name: "String",
    mod: moonbitlang_core_string_module,
  }
}

///|
pub fn RuntimeType::bytes() -> RuntimeType {
  {
    path: moonbitlang_core_bytes_module.meta.name,
    name: "Bytes",
    mod: moonbitlang_core_bytes_module,
  }
}

///|
pub fn RuntimeType::tuple() -> RuntimeType {
  {
    path: moonbitlang_core_tuple_module.meta.name,
    name: "Tuple",
    mod: moonbitlang_core_tuple_module,
  }
}

///|
pub fn RuntimeType::array() -> RuntimeType {
  {
    path: moonbitlang_core_array_module.meta.name,
    name: "Array",
    mod: moonbitlang_core_array_module,
  }
}

///|
pub fn RuntimeType::array_view() -> RuntimeType {
  {
    path: moonbitlang_core_array_module.meta.name,
    name: "ArrayView",
    mod: moonbitlang_core_array_module,
  }
}

///|
pub fn RuntimeType::uninitialized_array() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "UninitializedArray",
    mod: moonbitlang_core_builtin_module,
  }
}

///|
pub fn RuntimeType::map() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "Map",
    mod: moonbitlang_core_builtin_module,
  }
}

///|
pub fn RuntimeType::json() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "Json",
    mod: moonbitlang_core_builtin_module,
  }
}

///|
pub fn RuntimeType::option() -> RuntimeType {
  {
    path: moonbitlang_core_option_module.meta.name,
    name: "Option",
    mod: moonbitlang_core_option_module,
  }
}

///|
pub fn RuntimeType::result() -> RuntimeType {
  {
    path: moonbitlang_core_result_module.meta.name,
    name: "Result",
    mod: moonbitlang_core_result_module,
  }
}

///|
pub fn RuntimeType::iter() -> RuntimeType {
  {
    path: moonbitlang_core_builtin_module.meta.name,
    name: "Iter",
    mod: moonbitlang_core_builtin_module,
  }
}

///|
pub fn RuntimeType::list() -> RuntimeType {
  {
    path: moonbitlang_core_list_module.meta.name,
    name: "List",
    mod: moonbitlang_core_list_module,
  }
}

///|
pub fn RuntimeType::any() -> RuntimeType {
  { path: "main", name: "Any", mod: RuntimeModule::new("main") }
}

///|
/// 带类型信息的值包装器
pub struct WithType[T] {
  val : T
  type_info : RuntimeType
}
