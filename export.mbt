///|
pub fn value_to_json(value : RuntimeValue) -> String {
  value.to_json().stringify()
}

///|
pub fn value_to_string(value : RuntimeValue) -> String {
  value.to_string()
}

///|
pub(open) trait ToRuntime {
  fn to_runtime(Self) -> RuntimeValue
}

///|
pub impl ToRuntime for RuntimeValue with fn to_runtime(self) {
  self
}

///|
pub impl ToRuntime for Int with fn to_runtime(value) {
  Int(value, raw=None)
}

///|
pub impl ToRuntime for Bool with fn to_runtime(value) {
  Bool(value)
}

///|
pub impl ToRuntime for String with fn to_runtime(value) {
  String(value)
}

///|
pub impl ToRuntime for Double with fn to_runtime(value) {
  Double(value)
}

///|
pub fn MoonBitVM::create(
  log? : Bool = false,
  modules? : Array[RuntimeModule] = [],
) -> MoonBitVM {
  MoonBitVM(log~, modules~)
}

///|
pub fn eval_result_to_string(result : EvalResult) -> String {
  match result {
    Success(value, _) => value.to_string()
    Error(msg, _) => "Error: " + msg
  }
}

///|
pub fn test_result_to_string(result : TestResult) -> String {
  result.to_string()
}

///|
pub fn code_to_ast(code : String) -> String {
  match @core.parse_eval_code(code) {
    Ok(EvalExpr(expr)) => expr.to_json().stringify()
    Ok(EvalTop(impls, ..)) => impls.to_json().stringify()
    Err(msg) => msg
  }
}

///|
pub fn add_extern_fn(
  vm : MoonBitVM,
  name : String,
  func : @core.RuntimeFunction,
) -> Unit {
  vm.interpreter.add_extern_fn(name, func)
}

///|
pub fn add_embedded_fn(
  vm : MoonBitVM,
  name : String,
  func : @core.RuntimeFunction,
) -> Unit {
  vm.interpreter.add_embedded_fn(name, func)
}

///|
pub fn add_embedded_method(
  vm : MoonBitVM,
  name : String,
  method_name : String,
  func : @core.RuntimeFunction,
) -> Unit {
  vm.interpreter.add_embedded_method(name, method_name, func)
}
