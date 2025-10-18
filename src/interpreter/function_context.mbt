///|
/// Runtime函数执行上下文 - 统一所有函数的执行环境
pub(all) struct RuntimeFunctionContext {
  context : ClosureInterpreter
  pkg : RuntimePackage
  args : Array[RuntimeArgument]
}

///|
/// 新的函数类型定义 - 统一的上下文访问
pub typealias (RuntimeFunctionContext) -> RuntimeValue raise ControlFlow as RuntimeFunction

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
