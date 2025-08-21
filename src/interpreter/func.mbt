///| Runtime函数执行上下文 - 统一所有函数的执行环境
pub(all) struct RuntimeFunctionContext {
  context : ClosureInterpreter
  env : RuntimeEnvironment
  arguments : Array[RuntimeArgument]
}

///| 构造 Constructor
pub fn RuntimeFunctionContext::cons(
  self : RuntimeFunctionContext,
  name : String,
  args : Array[RuntimeValue],
) -> RuntimeValue {
  Constructor({ val: (name, args), env: self.env })
}

///| 新的函数类型定义 - 统一的上下文访问
pub typealias (RuntimeFunctionContext) -> RuntimeValue as RuntimeFunction
