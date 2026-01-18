///|
pub enum RuntimeLocation {
  FunctionCall(String)
  ControlFlow(String)
  LetMut(String)
} derive(Show)

///| 变量管理模块

///| 处理变量查找、设置和作用域管理

///|
/// 在解释器中查找变量
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
pub fn ClosureInterpreter::find_pkg(
  self : ClosureInterpreter,
  pkg_name : String,
) -> RuntimePackage {
  let current_module = self.current_pkg
  if current_module.deps.get(pkg_name) is Some(pkg) {
    self.load_package(pkg)
    pkg
    // 检查 main 模块的 deps (core_modules) 中是否有这个包
  } else if self.main_pkg.deps.get(pkg_name) is Some(pkg) {
    self.load_package(pkg)
    pkg
  } else {
    current_module
  }
}

///|
pub fn[T] ClosureInterpreter::with_ident(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
  func : (RuntimePackage, String) -> T raise?,
) -> T raise? {
  let current_pkg = self.current_pkg
  match long_ident {
    Ident(name~) => {
      let f = current_pkg.type_aliases.get(name)
      let pkg = match f {
        Some(f) =>
          match f.ty {
            Object(pkg~, ..) => pkg
            Option(_) => moonbitlang_core_option_module
            _ => current_pkg
          }
        None => current_pkg
      }
      func(pkg, name)
    }
    Dot(pkg~, id~) =>
      if current_pkg.deps.get(pkg) is Some(pkg) {
        self.load_package(pkg)
        func(pkg, id)
        // 检查 main 模块的 deps (core_modules) 中是否有这个包
      } else if self.main_pkg.deps.get(pkg) is Some(pkg) {
        self.load_package(pkg)
        func(pkg, id)
      } else {
        func(current_pkg, id)
      }
  }
}

///|
/// 设置不可变变量
pub fn RuntimeEnvironment::set(
  self : RuntimeEnvironment,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.values.set(name, value)
  self.mutable_vars.set(name, false)
}

///|
pub fn RuntimePackage::set(
  self : RuntimePackage,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.values.set(name, value)
}

///|
/// 设置可变变量
pub fn RuntimeEnvironment::set_mutable_variable(
  self : RuntimeEnvironment,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.values.set(name, value)
  self.mutable_vars.set(name, true)
}

///| 更新可变变量的值

///|
/// 在可变变量数组中查找并更新指定变量
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

///|
/// 查找当前调用的函数名
pub fn ClosureInterpreter::lookup_current_function(
  self : ClosureInterpreter,
) -> String {
  let buf = @buffer.new()
  self.call_stack.each(frame => if frame is FunctionCall(name) {
    buf.write_string("\{name} => ")
  })
  buf.to_string()
}

///|
/// 创建新的作用域
pub fn ClosureInterpreter::push_scope(
  self : ClosureInterpreter,
  loc : RuntimeLocation,
) -> Unit {
  self.call_stack.push(loc)
  // println(String::make(self.call_stack.length(), ' ') + loc.to_string() + "{")
  self.current_pkg.env = RuntimeEnvironment::new(parent=self.current_pkg.env)
}

///|
/// 销毁当前作用域
pub fn ClosureInterpreter::pop_scope(self : ClosureInterpreter) -> Unit {
  // println(String::make(self.call_stack.length(), ' ') + self.call_stack.pop().to_string() + "}")
  self.call_stack.pop() |> ignore
  if self.current_pkg.env.parent is Some(parent) {
    self.current_pkg.env = parent
  }
}
