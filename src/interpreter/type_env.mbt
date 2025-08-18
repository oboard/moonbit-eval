///| 泛型类型环境 - 跟踪类型变量绑定
pub struct TypeEnvironment {
  // 类型变量到具体类型的映射
  type_bindings : Map[String, String]
  // 嵌套作用域支持
  parent : TypeEnvironment?
}

///| TypeEnvironment 方法
fn TypeEnvironment::new() -> TypeEnvironment {
  { type_bindings: Map::new(), parent: None }
}

///|
fn TypeEnvironment::with_parent(parent : TypeEnvironment) -> TypeEnvironment {
  { type_bindings: Map::new(), parent: Some(parent) }
}

///|
fn TypeEnvironment::bind_type(
  self : TypeEnvironment,
  type_var : String,
  concrete_type : String,
) -> Unit {
  self.type_bindings.set(type_var, concrete_type)
}

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

///|
fn TypeEnvironment::resolve_type(
  self : TypeEnvironment,
  type_name : String,
) -> String {
  match self.lookup_type(type_name) {
    Some(concrete_type) => concrete_type
    None => type_name // 如果不是类型变量，返回原始类型名
  }
}

///| ClosureInterpreter 泛型类型环境管理方法
fn ClosureInterpreter::push_type_environment(self : ClosureInterpreter) -> Unit {
  let current = self.type_environments[self.type_environments.length() - 1]
  self.type_environments.push(TypeEnvironment::with_parent(current))
}

///|
fn ClosureInterpreter::pop_type_environment(self : ClosureInterpreter) -> Unit {
  if self.type_environments.length() > 1 {
    self.type_environments.pop() |> ignore
  }
}

///|
fn ClosureInterpreter::current_type_environment(
  self : ClosureInterpreter,
) -> TypeEnvironment {
  self.type_environments[self.type_environments.length() - 1]
}

///|
fn ClosureInterpreter::bind_type_variable(
  self : ClosureInterpreter,
  type_var : String,
  concrete_type : String,
) -> Unit {
  self.current_type_environment().bind_type(type_var, concrete_type)
}

///|
fn ClosureInterpreter::resolve_type_name(
  self : ClosureInterpreter,
  type_name : String,
) -> String {
  self.current_type_environment().resolve_type(type_name)
}

///| 泛型类型实例化 - 根据类型参数创建具体类型实例
fn ClosureInterpreter::instantiate_generic_type(
  self : ClosureInterpreter,
  base_type : String,
  type_args : Array[String],
) -> String {
  if type_args.length() == 0 {
    base_type
  } else {
    let args_str = type_args.join(", ")
    "\{base_type}[\{args_str}]"
  }
}

///| 检查类型是否为泛型类型
fn ClosureInterpreter::is_generic_type(
  self : ClosureInterpreter,
  type_name : String,
) -> Bool {
  match self.type_definitions.get(type_name) {
    Some(type_def) => {
      let param_count = type_def.params.length()
      param_count > 0
    }
    None => false
  }
}
