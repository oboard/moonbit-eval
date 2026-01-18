///|
let stringbuilder_methods : Map[String, RuntimeFunction] = {
  "new": stringbuilder_new_fn,
  "is_empty": stringbuilder_is_empty_fn,
  "reset": stringbuilder_reset_fn,
  "to_string": stringbuilder_to_string_fn,
  "write_iter": stringbuilder_write_iter_fn,
  "write_object": stringbuilder_write_object_fn,
  "write_string": stringbuilder_write_string_fn,
  "write_char": stringbuilder_write_char_fn,
  "write_view": stringbuilder_write_view_fn,
}

///|
let stringbuilder_new_fn : RuntimeFunction = _ => StringBuilder(
  StringBuilder::new(),
)

///|
let stringbuilder_is_empty_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }] => Bool(self.is_empty())
  _ => Bool(false)
}

///|
let stringbuilder_reset_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }] => {
    self.reset()
    Unit
  }
  _ => Unit
}

///|
let stringbuilder_to_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }] => String(self.to_string())
  _ => String("")
}

///|
let stringbuilder_write_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }, { val: Iter(iter), .. }] => {
    self.write_iter(iter.map(x => if x is Char(c) { c } else { panic() }))
    Unit
  }
  _ => Unit
}

///|
let stringbuilder_write_object_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }, { val: str, .. }] => {
    self.write_object(str)
    Unit
  }
  _ => Unit
}

///|
let stringbuilder_write_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }, { val: String(str), .. }] => {
    self.write_string(str)
    Unit
  }
  _ => Unit
}

///|
let stringbuilder_write_char_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }, { val: Char(ch), .. }] => {
    self.write_char(ch)
    Unit
  }
  _ => Unit
}

///|
let stringbuilder_write_view_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringBuilder(self), .. }, { val: StringView(view), .. }] => {
    self.write_view(view)
    Unit
  }
  _ => Unit
}
