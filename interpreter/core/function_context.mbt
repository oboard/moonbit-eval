///|
/// Runtime函数执行上下文 - 统一所有函数的执行环境
pub(all) struct RuntimeFunctionContext {
  context : ClosureInterpreter
  pkg : RuntimePackage
  args : FixedArray[RuntimeArgument]
}

///|
/// 新的函数类型定义 - 统一的上下文访问
pub type RuntimeFunction = (RuntimeFunctionContext) -> RuntimeValue raise ControlFlow

///|
pub fn ClosureInterpreter::create_function(
  self : ClosureInterpreter,
  func : @syntax.Func,
  pkg : RuntimePackage,
  name? : String,
) -> WithType[RuntimeFunction] {
  let closure_env = pkg.env.create_closure_env()
  {
    val: ctx => {
      match func {
        { parameters, body, return_type, .. } => {
          // 切换到闭包捕获的环境
          let old_mod = self.current_pkg
          let old_env = pkg.env
          self.current_pkg = pkg
          self.current_pkg.env = closure_env
          self.push_scope(
            RuntimeLocation::FunctionCall(
              "@" +
              pkg.name +
              "." +
              name.unwrap_or("<function>") +
              self.get_function_type_string(func),
            ),
          )
          // 在新环境中绑定已解释的参数值
          self.bind_runtime_parameters(parameters, @list.from_array(ctx.args))
          defer {
            self.pop_scope()
            self.current_pkg.env = old_env
            self.current_pkg = old_mod
          }
          // 执行函数体
          let result = self.visit(body)
          match (result.get_type(), result, return_type) {
            (Any, Object({ val, .. }), Some(Arrow(res~, ..))) =>
              Object({ val, ty: self.parse_type(res) })
            _ => result
          }
        }
      }
    },
    ty: self.parse_function_type(func),
  }
}

///|
pub fn RuntimeFunctionContext::named(
  ctx : RuntimeFunctionContext,
  name : String,
) -> RuntimeValue? {
  for arg in ctx.args {
    match arg.kind {
      Labelled(arg_name) | LabelledOption(arg_name) =>
        if arg_name == name {
          return Some(arg.val)
        }
      _ => continue
    }
  }
  None
}
