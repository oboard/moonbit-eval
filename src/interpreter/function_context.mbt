///| Runtime函数执行上下文 - 统一所有函数的执行环境
pub(all) struct RuntimeFunctionContext {
  context : ClosureInterpreter
  mod : RuntimeModule
  arguments : Array[RuntimeArgument]
}

///| 新的函数类型定义 - 统一的上下文访问
pub typealias (RuntimeFunctionContext) -> RuntimeValue raise ControlFlow as RuntimeFunction
