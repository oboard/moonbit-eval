///|
pub let string_embedded_code : Map[
  String,
  (Array[RuntimeArgument]) -> RuntimeValue,
] = {
  "%string_length": string_length,
  "%string_get": string_get_fn,
  "%string.unsafe_get": string_unsafe_get_fn,
  "%string_add": string_add_fn,
  "%string_eq": string_eq_fn,
  "%string_to_string": string_to_string_fn,
}

///|
pub let string_methods : Map[String, (Array[RuntimeArgument]) -> RuntimeValue] = {
  "length": string_length,
  "get": string_get_fn,
  "unsafe_get": string_unsafe_get_fn,
  "to_string": string_to_string_fn,
}

// ===== 字符串操作 =====

///|
let string_length : (Array[RuntimeArgument]) -> RuntimeValue = params => if params
  is [{ value: String(s), .. }, ..] {
  Int(s.length())
} else {
  Unit
}

///| 字符串索引访问
let string_get_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(s), .. }, { value: Int(idx), .. }, ..] =>
    if idx >= 0 && idx < s.length() {
      Int(s[idx])
    } else {
      abort("string index out of bounds")
      Unit
    }
  _ => Unit
}

///| 字符串不安全索引访问
let string_unsafe_get_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(s), .. }, { value: Int(idx), .. }, ..] =>
    Int(s.unsafe_charcode_at(idx))
  _ => Unit
}

///| 字符串连接
let string_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(a), .. }, { value: String(b), .. }, ..] => String(a + b)
  _ => Unit
}

///| 字符串相等比较
let string_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(a), .. }, { value: String(b), .. }, ..] => Bool(a == b)
  _ => Bool(false)
}

///| 字符串 to_string
let string_to_string_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(s), .. }, ..] => String(s)
  _ => Unit
}
