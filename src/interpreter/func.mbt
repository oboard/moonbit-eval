///| Runtime函数执行上下文 - 统一所有函数的执行环境
pub(all) struct RuntimeFunctionContext {
  context : ClosureInterpreter
  mod : RuntimeModule
  arguments : Array[RuntimeArgument]
}

///| 构造 Constructor
pub fn RuntimeModule::cons(
  self : RuntimeModule,
  name : String,
  args : Array[RuntimeValue],
) -> RuntimeValue {
  Constructor({ val: (name, args), type_info: self.find_static_type(name) })
}

///| 新的函数类型定义 - 统一的上下文访问
pub typealias (RuntimeFunctionContext) -> RuntimeValue raise ControlFlow as RuntimeFunction
