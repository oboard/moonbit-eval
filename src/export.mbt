///|
pub fn value_to_json(value : RuntimeValue) -> String {
  value.to_json().stringify()
}

///|
pub fn MoonBitVM::create(log~ : Bool = false, core~ : Bool = true) -> MoonBitVM {
  MoonBitVM::new(log~, core~)
}

///|
pub fn eval_result_to_string(result : EvalResult) -> String {
  result.to_string()
}
