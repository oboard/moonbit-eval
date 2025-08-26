///|
pub let string_embedded_code : Map[String, RuntimeFunction] = {
  "%string_length": string_length,
  "%string_get": string_get_fn,
  "%string.unsafe_get": string_unsafe_get_fn,
  "%string_add": string_add_fn,
  "%string_eq": string_eq_fn,
  "%string_to_string": string_to_string_fn,
}

///|
pub let string_methods : Map[String, RuntimeFunction] = {
  "length": string_length,
  "get": string_get_fn,
  "unsafe_get": string_unsafe_get_fn,
  "to_string": string_to_string_fn,
  "make": string_make_fn,
  "iter": string_iter_fn,
}

// ===== 字符串操作 =====

///| 字符串make操作
let string_make_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(len), .. }, { val: Char(ch), .. }, ..] =>
    String(String::make(len, ch))
  _ => Unit
}

///|
let string_length : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(s), .. }, ..] {
  Int(s.length())
} else {
  Unit
}

///| 字符串索引访问
let string_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: Int(idx), .. }, ..] =>
    if idx >= 0 && idx < s.length() {
      Int(s[idx])
    } else {
      abort("string index out of bounds")
      Unit
    }
  _ => Unit
}

///| 字符串不安全索引访问
let string_unsafe_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: Int(idx), .. }, ..] =>
    Int(s.unsafe_charcode_at(idx))
  _ => Unit
}

///| 字符串迭代器
let string_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(str), .. }, ..] => Iter(str.iter().map(c => Char(c)))
  _ => Unit
}

///| 字符串连接
let string_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(a), .. }, { val: String(b), .. }, ..] => String(a + b)
  _ => Unit
}

///| 字符串相等比较
let string_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(a), .. }, { val: String(b), .. }, ..] => Bool(a == b)
  _ => Bool(false)
}

///| 字符串 to_string
let string_to_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, ..] => String(s)
  _ => Unit
}
