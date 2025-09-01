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
pub fn[T] ClosureInterpreter::with_ident(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
  func : (RuntimeModule, String, String) -> T raise?,
) -> T raise? {
  let currrent_module = self.current_module
  fn check_init(mod : RuntimeModule) -> Unit {
    if !mod.code.is_empty() {
      let code = mod.code
      mod.code = ""
      let old_module = self.current_module
      self.current_module = mod
      defer {
        self.current_module = old_module
      }
      let (impls, _diagnostics) = @moonbitlang/parser.parse_string(code)
      impls.each(node => self.top_visit(node) |> ignore)
    }
  }

  match long_ident {
    Ident(name~) => func(currrent_module, currrent_module.meta.name, name)
    Dot(pkg~, id~) =>
      if currrent_module.deps.get(pkg) is Some(mod) {
        check_init(mod)
        func(mod, pkg, id)
        // 检查 main 模块的 deps (core_modules) 中是否有这个包
      } else if self.main.deps.get(pkg) is Some(mod) {
        check_init(mod)
        func(mod, pkg, id)
      } else {
        func(currrent_module, pkg, id)
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
  self.current_module.env = RuntimeEnvironment::new(
    parent=self.current_module.env,
  )
}

///|
/// 销毁当前作用域
pub fn ClosureInterpreter::pop_scope(self : ClosureInterpreter) -> Unit {
  // println(String::make(self.call_stack.length(), ' ') + self.call_stack.pop().to_string() + "}")
  self.call_stack.pop() |> ignore
  if self.current_module.env.parent is Some(parent) {
    self.current_module.env = parent
  }
}
