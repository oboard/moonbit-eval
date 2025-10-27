///|
pub fn value_to_json(value : RuntimeValue) -> String {
  value.to_json().stringify()
}

///|
pub fn value_to_string(value : RuntimeValue) -> String {
  value.to_string()
}

///|
pub fn MoonBitVM::create(log? : Bool = false) -> MoonBitVM {
  MoonBitVM::new(log~)
}

///|
pub fn eval_result_to_string(result : EvalResult) -> String {
  match result {
    Success(value, _) => value.to_string()
    Error(msg, _) => "Error: " + msg
  }
}

///|
pub fn add_extern_fn(
  vm : MoonBitVM,
  name : String,
  func : RuntimeFunction,
) -> Unit {
  vm.interpreter.add_extern_fn(name, func)
}

///|
pub fn add_embedded_fn(
  vm : MoonBitVM,
  name : String,
  func : RuntimeFunction,
) -> Unit {
  vm.interpreter.add_embedded_fn(name, func)
}

///|
pub fn add_embedded_method(
  vm : MoonBitVM,
  name : String,
  method_name : String,
  func : RuntimeFunction,
) -> Unit {
  vm.interpreter.add_embedded_method(name, method_name, func)
}
