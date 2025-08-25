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
  let fields = args.mapi(fn(i, value) {
    // 对于List的More构造函数，tail字段（索引1）应该是可变的
    let mutable = if name == "More" && i == 1 { true } else { false }
    { name: None, value, mutable }
  })
  Constructor({ val: { name, fields }, type_info: self.find_static_type(name) })
}

///| 构造带标签参数的 Constructor
pub fn RuntimeModule::cons_with_labels(
  self : RuntimeModule,
  name : String,
  labeled_args : Array[(String?, RuntimeValue, Bool)], // (label, value, mutable)
) -> RuntimeValue {
  let fields = labeled_args.map(fn(arg) {
    let (label, value, mutable) = arg
    { name: label, value, mutable }
  })
  Constructor({ val: { name, fields }, type_info: self.find_static_type(name) })
}

///| 新的函数类型定义 - 统一的上下文访问
pub typealias (RuntimeFunctionContext) -> RuntimeValue raise ControlFlow as RuntimeFunction
