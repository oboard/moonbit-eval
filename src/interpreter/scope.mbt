///| 变量管理模块

///| 处理变量查找、设置和作用域管理

///| 在解释器中查找变量
pub fn RuntimeEnvironment::find(
  self : RuntimeEnvironment,
  name : String,
) -> RuntimeValue? {
  let mut cur = Some(self)
  // traverse parent environments
  while cur is Some(env) {
    if env.values.get(name) is Some(v) {
      return Some(v)
    }
    cur = env.parent
  }
  None
}

///|
pub fn[T] RuntimeModule::with_ident(
  self : RuntimeModule,
  long_ident : @syntax.LongIdent,
  func : (RuntimeModule, String, String) -> T raise?,
) -> T raise? {
  match long_ident {
    Ident(name~) => func(self, self.meta.name, name)
    Dot(pkg~, id~) =>
      if self.deps.get(pkg) is Some(mod) {
        func(mod, pkg, id)
      } else {
        func(self, pkg, id)
      }
  }
}

///| 设置不可变变量
pub fn RuntimeEnvironment::set(
  self : RuntimeEnvironment,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.values.set(name, value)
  self.mutable_vars.set(name, false)
}

///| 设置可变变量
pub fn RuntimeEnvironment::set_mutable_variable(
  self : RuntimeEnvironment,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.values.set(name, value)
  self.mutable_vars.set(name, true)
}

///| 更新可变变量的值

///| 在可变变量数组中查找并更新指定变量
pub fn RuntimeEnvironment::update(
  self : RuntimeEnvironment,
  name : String,
  new_value : RuntimeValue,
) -> Unit {
  let mut current_env = self
  // First check current environment
  if current_env.values.contains(name) {
    current_env.values.set(name, new_value)
    return
  }
  // Then traverse parent environments
  while current_env.parent is Some(parent) {
    current_env = parent
    if current_env.values.contains(name) {
      current_env.values.set(name, new_value)
      return
    }
  }
}

///| 创建新的作用域
pub fn ClosureInterpreter::push_scope(self : ClosureInterpreter) -> Unit {
  self.current_module.env = RuntimeEnvironment::new(
    parent=self.current_module.env,
  )
}

///| 销毁当前作用域
pub fn ClosureInterpreter::pop_scope(self : ClosureInterpreter) -> Unit {
  if self.current_module.env.parent is Some(parent) {
    self.current_module.env = parent
  }
}
