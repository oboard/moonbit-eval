///|
pub let bytes_methods : Map[String, RuntimeFunction] = {
  "length": bytes_length_fn,
  "at": bytes_at_fn,
  "get": bytes_get_fn,
  "is_empty": bytes_is_empty_fn,
  "compare": bytes_compare_fn,
  "lexical_compare": bytes_lexical_compare_fn,
  "equal": bytes_equal_fn,
  "make": bytes_make_fn,
  "makei": bytes_makei_fn,
  "new": bytes_new_fn,
  "repeat": bytes_repeat_fn,
  "from_array": bytes_from_array_fn,
  "from_fixedarray": bytes_from_fixedarray_fn,
  "from_iter": bytes_from_iter_fn,
  "op_equal": bytes_op_equal_fn,
  "to_array": bytes_to_array_fn,
  "to_fixedarray": bytes_to_fixedarray_fn,
  "iter": bytes_iter_fn,
  "iter2": bytes_iter2_fn,
  "find": bytes_find_fn,
  "rev_find": bytes_rev_find_fn,
  "has_prefix": bytes_has_prefix_fn,
  "has_suffix": bytes_has_suffix_fn,
  "chop_prefix": bytes_chop_prefix_fn,
  "chop_suffix": bytes_chop_suffix_fn,
  "view": bytes_view_fn,
  "unsafe_read_uint16_le": bytes_unsafe_read_uint16_le_fn,
  "unsafe_read_uint16_be": bytes_unsafe_read_uint16_be_fn,
  "unsafe_read_uint32_le": bytes_unsafe_read_uint32_le_fn,
  "unsafe_read_uint32_be": bytes_unsafe_read_uint32_be_fn,
  "unsafe_read_uint64_le": bytes_unsafe_read_uint64_le_fn,
  "unsafe_read_uint64_be": bytes_unsafe_read_uint64_be_fn,
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

///|
let bytes_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(b.get(i).map(x => Byte(x)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let bytes_is_empty_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Bool(b.is_empty())
    _ => Bool(false)
  }
}

///|
let bytes_lexical_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(a), .. }, { val: Bytes(b), .. }] =>
      Int(a.lexical_compare(b), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let bytes_repeat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(count, ..), .. }] =>
      Bytes(b.repeat(count))
    _ => Unit
  }
}

///|
let bytes_to_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Array(b.to_array().map(x => Byte(x)))
    _ => Array([])
  }
}

///|
let bytes_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Iter(b.iter().map(x => Byte(x)))
    _ => Unit
  }
}

///|
let bytes_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => {
      let it = b.iter2()
      let iterator = Iter2::new(fn() {
        match it.next() {
          Some((i, v)) => Some((Int(i, raw=None), Byte(v)))
          None => None
        }
      })
      Iter2(iterator.iter2())
    }
    _ => Unit
  }
}

///|
let bytes_from_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] =>
      Bytes(
        Bytes::from_array(
          arr.map(v => {
            match v {
              Byte(b) => b
              _ => Byte::default()
            }
          }),
        ),
      )
    _ => Unit
  }
}

///|
let bytes_from_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(it), .. }] =>
      Bytes(
        Bytes::from_iter(
          it.map(v => {
            match v {
              Byte(b) => b
              _ => Byte::default()
            }
          }),
        ),
      )
    _ => Unit
  }
}

///|
let bytes_from_fixedarray_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => {
      let limit = if ctx.named("len") is Some(Int(i, ..)) { Some(i) } else { None }
      let out = []
      for i in 0..<arr.length() {
        if limit is Some(max) && i >= max {
          break
        }
        out.push(
          match arr[i] {
            Byte(b) => b
            _ => Byte::default()
          },
        )
      }
      Bytes(Bytes::from_array(out))
    }
    _ => Unit
  }
}

///|
let bytes_to_fixedarray_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => {
      let limit = if ctx.named("len") is Some(Int(i, ..)) { Some(i) } else { None }
      let src = b.to_array()
      let out = []
      for i in 0..<src.length() {
        if limit is Some(max) && i >= max {
          break
        }
        out.push(Byte(src[i]))
      }
      FixedArray(FixedArray::from_array(out))
    }
    _ => Unit
  }
}

///|
let bytes_find_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Bytes(p), .. }] =>
      RuntimeValue::from_option(b.find(p[:]).map(i => Int(i, raw=None)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let bytes_rev_find_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Bytes(p), .. }] =>
      RuntimeValue::from_option(b.rev_find(p[:]).map(i => Int(i, raw=None)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let bytes_has_prefix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Bytes(p), .. }] => Bool(b.has_prefix(p[:]))
    _ => Bool(false)
  }
}

///|
let bytes_has_suffix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Bytes(p), .. }] => Bool(b.has_suffix(p[:]))
    _ => Bool(false)
  }
}

///|
let bytes_chop_prefix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Bytes(p), .. }] =>
      RuntimeValue::from_option(
        b.chop_prefix(p[:]).map(v => Bytes(v.to_bytes())),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let bytes_chop_suffix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Bytes(p), .. }] =>
      RuntimeValue::from_option(
        b.chop_suffix(p[:]).map(v => Bytes(v.to_bytes())),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let bytes_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Bytes(b.view().to_bytes())
    [{ val: Bytes(b), .. }, { val: Int(start, ..), .. }] =>
      Bytes(b.view(start~).to_bytes())
    [
      { val: Bytes(b), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] => Bytes(b.view(start~, end=end_).to_bytes())
    _ => Unit
  }
}

///|
let bytes_unsafe_read_uint16_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      UInt16(b.unsafe_read_uint16_le(i))
    _ => UInt16(0)
  }
}

///|
let bytes_unsafe_read_uint16_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      UInt16(b.unsafe_read_uint16_be(i))
    _ => UInt16(0)
  }
}

///|
let bytes_unsafe_read_uint32_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      UInt(b.unsafe_read_uint32_le(i))
    _ => UInt(0)
  }
}

///|
let bytes_unsafe_read_uint32_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      UInt(b.unsafe_read_uint32_be(i))
    _ => UInt(0)
  }
}

///|
let bytes_unsafe_read_uint64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      UInt64(b.unsafe_read_uint64_le(i))
    _ => UInt64(0UL)
  }
}

///|
let bytes_unsafe_read_uint64_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, { val: Int(i, ..), .. }] =>
      UInt64(b.unsafe_read_uint64_be(i))
    _ => UInt64(0UL)
  }
}
