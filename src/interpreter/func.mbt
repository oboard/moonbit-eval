///| Runtime函数执行上下文 - 统一所有函数的执行环境
pub(all) struct RuntimeFunctionContext {
  context : ClosureInterpreter
  env : RuntimeEnvironment
  arguments : Array[RuntimeArgument]
}

///| 构造 Constructor
pub fn RuntimeEnvironment::cons(
  self : RuntimeEnvironment,
  name : String,
  args : Array[RuntimeValue],
) -> RuntimeValue {
  Constructor({ val: (name, args), env: self })
}

///| 新的函数类型定义 - 统一的上下文访问
pub typealias (RuntimeFunctionContext) -> RuntimeValue as RuntimeFunction
