///| 运行时类型信息 - 包含包名、类型名和环境
pub struct RuntimeType {
  pkg : String
  name : String
  env : RuntimeEnvironment
}

///|
pub fn RuntimeType::to_string(self : RuntimeType) -> String {
  (if self.pkg == "main" { "" } else { "@" + self.pkg + "." }) + self.name
}

///|
pub fn RuntimeType::bool() -> RuntimeType {
  {
    pkg: moonbitlang_core_bool_module.meta.name,
    name: "Bool",
    env: moonbitlang_core_bool_module.env,
  }
}

///|
pub fn RuntimeType::int() -> RuntimeType {
  {
    pkg: moonbitlang_core_int_module.meta.name,
    name: "Int",
    env: moonbitlang_core_int_module.env,
  }
}

///|
pub fn RuntimeType::uint() -> RuntimeType {
  {
    pkg: moonbitlang_core_uint_module.meta.name,
    name: "UInt",
    env: moonbitlang_core_uint_module.env,
  }
}

///|
pub fn RuntimeType::int64() -> RuntimeType {
  {
    pkg: moonbitlang_core_int64_module.meta.name,
    name: "Int64",
    env: moonbitlang_core_int64_module.env,
  }
}

///|
pub fn RuntimeType::uint64() -> RuntimeType {
  {
    pkg: moonbitlang_core_uint64_module.meta.name,
    name: "UInt64",
    env: moonbitlang_core_uint64_module.env,
  }
}

///|
pub fn RuntimeType::float() -> RuntimeType {
  {
    pkg: moonbitlang_core_float_module.meta.name,
    name: "Float",
    env: moonbitlang_core_float_module.env,
  }
}

///|
pub fn RuntimeType::double() -> RuntimeType {
  {
    pkg: moonbitlang_core_double_module.meta.name,
    name: "Double",
    env: moonbitlang_core_double_module.env,
  }
}

///|
pub fn RuntimeType::bigint() -> RuntimeType {
  {
    pkg: moonbitlang_core_bigint_module.meta.name,
    name: "BigInt",
    env: moonbitlang_core_bigint_module.env,
  }
}

///|
pub fn RuntimeType::char() -> RuntimeType {
  {
    pkg: moonbitlang_core_char_module.meta.name,
    name: "Char",
    env: moonbitlang_core_char_module.env,
  }
}

///|
pub fn RuntimeType::byte() -> RuntimeType {
  {
    pkg: moonbitlang_core_byte_module.meta.name,
    name: "Byte",
    env: moonbitlang_core_byte_module.env,
  }
}

///|
pub fn RuntimeType::string() -> RuntimeType {
  {
    pkg: moonbitlang_core_string_module.meta.name,
    name: "String",
    env: moonbitlang_core_string_module.env,
  }
}

///|
pub fn RuntimeType::tuple() -> RuntimeType {
  {
    pkg: moonbitlang_core_tuple_module.meta.name,
    name: "Tuple",
    env: moonbitlang_core_tuple_module.env,
  }
}

///|
pub fn RuntimeType::array() -> RuntimeType {
  {
    pkg: moonbitlang_core_array_module.meta.name,
    name: "Array",
    env: moonbitlang_core_array_module.env,
  }
}

///|
pub fn RuntimeType::array_view() -> RuntimeType {
  {
    pkg: moonbitlang_core_array_module.meta.name,
    name: "ArrayView",
    env: moonbitlang_core_array_module.env,
  }
}

///|
pub fn RuntimeType::uninitialized_array() -> RuntimeType {
  {
    pkg: moonbitlang_core_builtin_module.meta.name,
    name: "UninitializedArray",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::map() -> RuntimeType {
  {
    pkg: moonbitlang_core_builtin_module.meta.name,
    name: "Map",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::option() -> RuntimeType {
  {
    pkg: moonbitlang_core_option_module.meta.name,
    name: "Option",
    env: moonbitlang_core_option_module.env,
  }
}

///|
pub fn RuntimeType::iter() -> RuntimeType {
  {
    pkg: moonbitlang_core_builtin_module.meta.name,
    name: "Iter",
    env: moonbitlang_core_builtin_module.env,
  }
}

///|
pub fn RuntimeType::any() -> RuntimeType {
  { pkg: "main", name: "Any", env: RuntimeEnvironment::new() }
}

///| 带类型信息的值包装器
pub struct WithType[T] {
  val : T
  type_info : RuntimeType
}

///| 泛型类型环境 - 跟踪类型变量绑定
pub struct TypeEnvironment {
  // 类型变量到具体类型的映射
  type_bindings : Map[String, String]
  // 嵌套作用域支持
  parent : TypeEnvironment?
} derive(ToJson)

///| TypeEnvironment 方法
fn TypeEnvironment::new() -> TypeEnvironment {
  { type_bindings: Map::new(), parent: None }
}

// ///|
// fn TypeEnvironment::with_parent(parent : TypeEnvironment) -> TypeEnvironment {
//   { type_bindings: Map::new(), parent: Some(parent) }
// }

// ///|
// fn TypeEnvironment::bind_type(
//   self : TypeEnvironment,
//   type_var : String,
//   concrete_type : String,
// ) -> Unit {
//   self.type_bindings.set(type_var, concrete_type)
// }

///|
fn TypeEnvironment::lookup_type(
  self : TypeEnvironment,
  type_var : String,
) -> String? {
  match self.type_bindings.get(type_var) {
    Some(t) => Some(t)
    None =>
      match self.parent {
        Some(parent) => parent.lookup_type(type_var)
        None => None
      }
  }
}

// ///|
// fn TypeEnvironment::resolve_type(
//   self : TypeEnvironment,
//   type_name : String,
// ) -> String {
//   match self.lookup_type(type_name) {
//     Some(concrete_type) => concrete_type
//     None => type_name // 如果不是类型变量，返回原始类型名
//   }
// }

// ///| ClosureInterpreter 泛型类型环境管理方法
// fn ClosureInterpreter::push_type_environment(self : ClosureInterpreter) -> Unit {
//   let current = self.type_environments[self.type_environments.length() - 1]
//   self.type_environments.push(TypeEnvironment::with_parent(current))
// }

// ///|
// fn ClosureInterpreter::pop_type_environment(self : ClosureInterpreter) -> Unit {
//   if self.type_environments.length() > 1 {
//     self.type_environments.pop() |> ignore
//   }
// }

// ///|
// fn ClosureInterpreter::current_type_environment(
//   self : ClosureInterpreter,
// ) -> TypeEnvironment {
//   self.type_environments[self.type_environments.length() - 1]
// }

// ///|
// fn ClosureInterpreter::bind_type_variable(
//   self : ClosureInterpreter,
//   type_var : String,
//   concrete_type : String,
// ) -> Unit {
//   self.current_type_environment().bind_type(type_var, concrete_type)
// }

// ///|
// fn ClosureInterpreter::resolve_type_name(
//   self : ClosureInterpreter,
//   type_name : String,
// ) -> String {
//   self.current_type_environment().resolve_type(type_name)
// }

// ///| 泛型类型实例化 - 根据类型参数创建具体类型实例
// fn ClosureInterpreter::instantiate_generic_type(
//   self : ClosureInterpreter,
//   base_type : String,
//   type_args : Array[String],
// ) -> String {
//   if type_args.length() == 0 {
//     base_type
//   } else {
//     let args_str = type_args.join(", ")
//     "\{base_type}[\{args_str}]"
//   }
// }

// ///| 检查类型是否为泛型类型
// fn ClosureInterpreter::is_generic_type(
//   self : ClosureInterpreter,
//   type_name : String,
// ) -> Bool {
//   match self.main.env.type_definitions.get(type_name) {
//     Some(type_def) => {
//       let param_count = type_def.params.length()
//       param_count > 0
//     }
//     None => false
//   }
// }
