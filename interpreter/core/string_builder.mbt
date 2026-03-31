///|
let stringbuilder_methods : Map[String, RuntimeFunction] = {
  "new": stringbuilder_new_fn,
  "is_empty": stringbuilder_is_empty_fn,
  "output": stringbuilder_output_fn,
  "reset": stringbuilder_reset_fn,
  "to_string": stringbuilder_to_string_fn,
  "write_char": stringbuilder_write_char_fn,
  "write_iter": stringbuilder_write_iter_fn,
  "write_string": stringbuilder_write_string_fn,
  "write_stringview": stringbuilder_write_stringview_fn,
  "write_view": stringbuilder_write_view_fn,
}

///|
let stringbuilder_new_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(size_hint, ..), .. }] =>
      StringBuilder(StringBuilder::new(size_hint~))
    _ => StringBuilder(StringBuilder::new())
  }
}

///|
let stringbuilder_is_empty_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }] => Bool(self.is_empty())
    _ => Bool(false)
  }
}

///|
let stringbuilder_output_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }, { val: StringBuilder(logger), .. }] => {
      logger.write_string(self.to_string())
      Unit
    }
    _ => Unit
  }
}

///|
let stringbuilder_reset_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }] => {
      self.reset()
      Unit
    }
    _ => Unit
  }
}

///|
let stringbuilder_to_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }] => String(self.to_string())
    _ => String("")
  }
}

///|
let stringbuilder_write_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }, { val: Char(ch), .. }] => {
      self.write_char(ch)
      Unit
    }
    _ => Unit
  }
}

///|
let stringbuilder_write_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }, { val: Iter(iter), .. }] => {
      self.write_iter(iter.map(x => if x is Char(c) { c } else { panic() }))
      Unit
    }
    _ => Unit
  }
}

///|
let stringbuilder_write_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }, { val: String(str), .. }] => {
      self.write_string(str)
      Unit
    }
    _ => Unit
  }
}

///|
let stringbuilder_write_stringview_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }, { val: StringView(view), .. }] => {
      self.write_stringview(view)
      Unit
    }
    _ => Unit
  }
}

///|
let stringbuilder_write_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringBuilder(self), .. }, { val: StringView(view), .. }] => {
      self.write_view(view)
      Unit
    }
    _ => Unit
  }
}
