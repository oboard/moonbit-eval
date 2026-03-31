///|
pub let bytes_methods : Map[String, RuntimeFunction] = {
  "length": bytes_length_fn,
  "at": bytes_at_fn,
  "compare": bytes_compare_fn,
  "equal": bytes_equal_fn,
  "make": bytes_make_fn,
  "makei": bytes_makei_fn,
  "new": bytes_new_fn,
  "op_equal": bytes_op_equal_fn,
  "to_unchecked_string": bytes_to_unchecked_string_fn,
  "unsafe_get": bytes_unsafe_get_fn,
}

///|
let bytes_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] => Byte(b[i])
    _ => Unit
  }
}

///|
let bytes_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(a), .. }, { val: Bytes(b), .. }] =>
      Int(a.compare(b), raw=None)
    _ => Unit
  }
}

///|
let bytes_equal_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(a), .. }, { val: Bytes(b), .. }] => Bool(a == b)
    _ => Unit
  }
}

///|
let bytes_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val: Byte(byte), .. }] =>
      Bytes(Bytes::make(len, byte))
    _ => Unit
  }
}

///|
let bytes_makei_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val: Fn(f), .. }] => {
      let result = Bytes::makei(len, i => {
        let arg = Int(i, raw=None)
        let ret = ctx.context.call(f.val, ctx.pkg, [
          { val: arg, kind: Positional },
        ])
        match ret {
          Byte(b) => b
          _ => 0
        }
      })
      Bytes(result)
    }
    _ => Unit
  }
}

///|
let bytes_new_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }] => Bytes(Bytes::new(len))
    _ => Unit
  }
}

///|
let bytes_op_equal_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(a), .. }, { val: Bytes(b), .. }] => Bool(a == b)
    _ => Unit
  }
}

///|
let bytes_to_unchecked_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => {
      let offset = if ctx.named("offset") is Some(Int(i, ..)) {
        Some(i)
      } else {
        None
      }
      let length = if ctx.named("length") is Some(Int(i, ..)) {
        Some(i)
      } else {
        None
      }
      String(b.to_unchecked_string(offset?, length?))
    }
    _ => Unit
  }
}

///|
let bytes_unsafe_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] => Byte(b.unsafe_get(i))
    _ => Unit
  }
}

///|
let bytes_length_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Int(b.length(), raw=None)
    _ => Unit
  }
}
