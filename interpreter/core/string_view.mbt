// String embedded code and methods

///|
let string_view_methods : Map[String, RuntimeFunction] = {
  "add": string_view_add,
  "after": string_view_after_fn,
  "at": string_view_code_unit_at,
  "before": string_view_before_fn,
  "char_length": string_view_char_length,
  "char_length_eq": string_view_char_length_eq,
  "char_length_ge": string_view_char_length_ge,
  "compare": string_view_compare,
  "contains": string_view_contains,
  "contains_any": string_view_contains_any_fn,
  "contains_char": string_view_contains_char_fn,
  "data": string_view_data,
  "default": string_view_default,
  "equal": string_view_equal,
  "escape": string_view_escape_fn,
  "find": string_view_find,
  "find_by": string_view_find_by_fn,
  "from_array": string_view_from_array_fn,
  "from_iter": string_view_from_iter_fn,
  "from_json": string_view_from_json_fn,
  "get": string_view_get_fn,
  "get_char": string_view_get_char,
  "has_prefix": string_view_has_prefix,
  "has_suffix": string_view_has_suffix,
  "hash_combine": string_view_hash_combine_fn,
  "is_blank": string_view_is_blank,
  "is_empty": string_view_is_empty,
  "iter": string_view_iter,
  "iter2": string_view_iter2_fn,
  "length": string_view_length,
  "lexical_compare": string_view_lexical_compare_fn,
  "make": string_view_make_fn,
  "offset_of_nth_char": string_view_offset_of_nth_char,
  "output": string_view_output_fn,
  "pad_end": string_view_pad_end,
  "pad_start": string_view_pad_start,
  "repeat": string_view_repeat,
  "replace": string_view_replace,
  "replace_all": string_view_replace_all,
  "rev": string_view_rev,
  "rev_after": string_view_rev_after_fn,
  "rev_before": string_view_rev_before_fn,
  "rev_find": string_view_rev_find,
  "rev_iter": string_view_rev_iter,
  "rev_split_once": string_view_rev_split_once_fn,
  "split": string_view_split,
  "split_once": string_view_split_once_fn,
  "start_offset": string_view_start_offset,
  "strip_prefix": string_view_strip_prefix,
  "strip_suffix": string_view_strip_suffix,
  "sub": string_view_sub_fn,
  "suffixes": string_view_suffixes_fn,
  "to_array": string_view_to_array,
  "to_bytes": string_view_to_bytes,
  "to_json": string_view_to_json,
  "to_lower": string_view_to_lower,
  "to_string": string_view_to_string,
  "to_string_view": string_view_to_string_view_view,
  "to_upper": string_view_to_upper,
  "trim": string_view_trim,
  "trim_end": string_view_trim_end,
  "trim_space": string_view_trim_space_fn,
  "trim_start": string_view_trim_start,
  "unsafe_charcode_at": string_view_unsafe_charcode_at,
  "unsafe_get": string_view_unsafe_charcode_at,
  "view": string_view_view_fn,
}

///|
let string_view_length : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Int(s.length(), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_view_add : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] =>
      StringView(s1 + s2)
    _ => StringView("")
  }
}

///|
let string_view_code_unit_at : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
      UInt16(s.code_unit_at(i))
    _ => StringView("")
  }
}

///|
let string_view_char_length : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Int(s.char_length(), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_view_char_length_eq : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
      Bool(s.char_length() == n)
    _ => Bool(false)
  }
}

///|
let string_view_char_length_ge : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
      Bool(s.char_length() >= n)
    _ => Bool(false)
  }
}

///|
let string_view_compare : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] =>
      Int(s1.compare(s2), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_view_contains : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(sub), .. }] =>
      Bool(s.contains(sub))
    _ => Bool(false)
  }
}

///|
let string_view_data : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => String(s.data())
    _ => String("")
  }
}

///|
let string_view_default : RuntimeFunction = ctx => {
  match ctx.args {
    _ => StringView("")
  }
}

///|
let string_view_equal : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] => Bool(s1 == s2)
    _ => Bool(false)
  }
}

///|
let string_view_find : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(sub), .. }] =>
      match s.find(sub) {
        Some(i) => Int(i, raw=None)
        None => Int(-1, raw=None)
      }
    _ => Int(-1, raw=None)
  }
}

///|
let string_view_get_char : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
      s.get_char(i).map(x => Char(x)) |> RuntimeValue::from_option
    _ => StringView("")
  }
}

///|
let string_view_has_prefix : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(prefix), .. }] =>
      Bool(s.has_prefix(prefix))
    _ => Bool(false)
  }
}

///|
let string_view_has_suffix : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(suffix), .. }] =>
      Bool(s.has_suffix(suffix))
    _ => Bool(false)
  }
}

///|
let string_view_is_blank : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Bool(s.is_blank())
    _ => Bool(false)
  }
}

///|
let string_view_is_empty : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Bool(s.is_empty())
    _ => Bool(false)
  }
}

///|
let string_view_iter : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Iter(s.iter().map(x => Char(x)))
    _ => Iter(Iter::empty())
  }
}

///|
let string_view_offset_of_nth_char : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
      RuntimeValue::from_option(
        s.offset_of_nth_char(n).map(x => Int(x, raw=None)),
      )
    _ => Int(-1, raw=None)
  }
}

///|
let string_view_pad_end : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: StringView(s), .. },
      { val: Int(total_width, ..), .. },
      { val: Char(padding_char), .. },
    ] => StringView(s.pad_end(total_width, padding_char))
    _ => StringView("")
  }
}

///|
let string_view_pad_start : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: StringView(s), .. },
      { val: Int(total_width, ..), .. },
      { val: Char(padding_char), .. },
    ] => StringView(s.pad_start(total_width, padding_char))
    _ => StringView("")
  }
}

///|
let string_view_repeat : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
      StringView(s.repeat(n))
    _ => StringView("")
  }
}

///|
let string_view_replace : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: StringView(s), .. },
      { val: StringView(old), .. },
      { val: StringView(new), .. },
    ] => StringView(s.replace(old~, new~))
    _ => StringView("")
  }
}

///|
let string_view_replace_all : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: StringView(s), .. },
      { val: String(from), .. },
      { val: String(to), .. },
    ] => StringView(s.replace_all(old=from, new=to))
    _ => StringView("")
  }
}

///|
let string_view_rev : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => String(s.rev())
    _ => String("")
  }
}

///|
let string_view_rev_find : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(sub), .. }] =>
      match s.rev_find(sub) {
        Some(i) => Int(i, raw=None)
        None => Int(-1, raw=None)
      }
    _ => Int(-1, raw=None)
  }
}

///|
let string_view_rev_iter : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Iter(s.rev_iter().map(x => Char(x)))
    _ => Iter(Iter::empty())
  }
}

///|
let string_view_split : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: String(sep), .. }] =>
      Iter(s.split(sep).map(x => StringView(x)))
    [{ val: StringView(s), .. }, { val: StringView(sep), .. }] =>
      Iter(s.split(sep).map(x => StringView(x)))
    _ => Iter(Iter::empty())
  }
}

///|
let string_view_start_offset : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Int(s.start_offset(), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_view_strip_prefix : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(prefix), .. }] =>
      match s.strip_prefix(prefix) {
        Some(rest) => StringView(rest)
        None => StringView(s)
      }
    _ => StringView("")
  }
}

///|
let string_view_strip_suffix : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(suffix), .. }] =>
      match s.strip_suffix(suffix) {
        Some(rest) => StringView(rest)
        None => StringView(s)
      }
    _ => StringView("")
  }
}

///|
let string_view_to_array : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Array(s.to_array().map(x => Char(x)))
    _ => Array([])
  }
}

///|
let string_view_to_bytes : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Bytes(@encoding/utf8.encode(s))
    _ => Bytes(b"")
  }
}

///|
let string_view_to_json : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => Json(s.to_json())
    _ => String("\"\"")
  }
}

///|
let string_view_to_lower : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => StringView(s.to_lower())
    _ => StringView("")
  }
}

///|
let string_view_to_string : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => String(s.to_string())
    _ => String("")
  }
}

///|
let string_view_to_string_view_view : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => StringView(s)
    _ => StringView("")
  }
}

///|
let string_view_to_upper : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => StringView(s.to_upper())
    _ => StringView("")
  }
}

///|
let string_view_trim : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(char_set), .. }] =>
      StringView(s.trim(char_set~))
    _ => StringView("")
  }
}

///|
let string_view_trim_end : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(char_set), .. }] =>
      StringView(s.trim_end(char_set~))
    _ => StringView("")
  }
}

///|
let string_view_trim_start : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(char_set), .. }] =>
      StringView(s.trim_start(char_set~))
    _ => StringView("")
  }
}

///|
let string_view_unsafe_charcode_at : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
      if i >= 0 && i < s.length() {
        UInt16(s.unsafe_get(i))
      } else {
        UInt16(0)
      }
    _ => UInt16(0)
  }
}

///|
let string_view_after_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.after(needle).map(x => StringView(x)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_before_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.before(needle).map(x => StringView(x)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_contains_any_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(chars), .. }] =>
      Bool(s.contains_any(chars~))
    _ => Bool(false)
  }
}

///|
let string_view_contains_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Char(c), .. }] =>
      Bool(s.contains_char(c))
    _ => Bool(false)
  }
}

///|
let string_view_escape_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Bool(quote), .. }] =>
      StringView(s.escape(quote~))
    [{ val: StringView(s), .. }] => StringView(s.escape())
    _ => StringView("")
  }
}

///|
let string_view_find_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Fn(func), .. }] =>
      RuntimeValue::from_option(
        s
        .find_by(char => {
          let result = ctx.context.call(func.val, ctx.pkg, [
            { val: Char(char), kind: Positional },
          ]) catch {
            _ => Unit
          }
          match result {
            Bool(value) => value
            _ => false
          }
        })
        .map(index => Int(index, raw=None)),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_from_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(values), .. }] => {
      let chars = values
        .to_array()
        .map(v => if v is Char(c) { c } else { panic() })
      StringView(String::from_array(chars[:]).view())
    }
    [{ val: Array(values), .. }] => {
      let chars = values.map(v => if v is Char(c) { c } else { panic() })
      StringView(String::from_array(chars[:]).view())
    }
    _ => StringView("")
  }
}

///|
let string_view_from_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] =>
      StringView(
        String::from_iter(iter.map(v => if v is Char(c) { c } else { panic() })).view(),
      )
    _ => StringView("")
  }
}

///|
let string_view_from_json_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Json(value), .. }, ..] =>
      match value {
        String(str) => StringView(str[:])
        _ => StringView("")
      }
    _ => StringView("")
  }
}

///|
let string_view_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(
        if i >= 0 && i < s.length() {
          Some(Int(s.unsafe_get(i).to_int(), raw=None))
        } else {
          None
        },
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_hash_combine_fn : RuntimeFunction = _ctx => Unit

///|
let string_view_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => {
      let iter2 = s.iter2()
      let converted = Iter2::new(fn() {
        match iter2.next() {
          Some((index, ch)) => Some((Int(index, raw=None), Char(ch)))
          None => None
        }
      })
      Iter2(converted)
    }
    _ => Iter2(Iter2::new(fn() { None }))
  }
}

///|
let string_view_lexical_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(lhs), .. }, { val: StringView(rhs), .. }] =>
      Int(lhs.lexical_compare(rhs), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_view_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(length, ..), .. }, { val: Char(value), .. }] =>
      StringView(String::make(length, value).view())
    _ => StringView("")
  }
}

///|
let string_view_output_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringBuilder(logger), .. }] => {
      logger.write_stringview(s.escape())
      Unit
    }
    _ => Unit
  }
}

///|
let string_view_rev_after_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.rev_after(needle).map(x => StringView(x)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_rev_before_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.rev_before(needle).map(x => StringView(x)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_rev_split_once_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(
        s
        .rev_split_once(needle)
        .map(pair => Tuple([StringView(pair.0), StringView(pair.1)])),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_split_once_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(
        s
        .split_once(needle)
        .map(pair => Tuple([StringView(pair.0), StringView(pair.1)])),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_view_sub_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: StringView(s), .. },
      { val: Int(start, ..), kind: Labelled("start") },
      { val: Int(end_, ..), kind: Labelled("end") },
      ..,
    ] => StringView(s.sub(start~, end=end_))
    [
      { val: StringView(s), .. },
      { val: Int(start, ..), kind: Labelled("start") },
      ..,
    ] => StringView(s.sub(start~))
    [
      { val: StringView(s), .. },
      { val: Int(end_, ..), kind: Labelled("end") },
      ..,
    ] => StringView(s.sub(end=end_))
    [{ val: StringView(s), .. }] => StringView(s.sub())
    [
      { val: StringView(s), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] => StringView(s.sub(start~, end=end_))
    [{ val: StringView(s), .. }, { val: Int(start, ..), .. }] =>
      StringView(s.sub(start~))
    _ => StringView("")
  }
}

///|
let string_view_suffixes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }, { val: Bool(include_empty), .. }] =>
      Iter(s.suffixes(include_empty~).map(x => StringView(x)))
    [{ val: StringView(s), .. }] => Iter(s.suffixes().map(x => StringView(x)))
    _ => Iter(Iter::empty())
  }
}

///|
let string_view_trim_space_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(s), .. }] => StringView(s.trim())
    _ => StringView("")
  }
}

///|
let string_view_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: StringView(s), .. },
      { val: Int(start_offset, ..), kind: Labelled("start_offset") },
      { val: Int(end_offset, ..), kind: Labelled("end_offset") },
      ..,
    ] => StringView(s.view(start_offset~, end_offset~))
    [
      { val: StringView(s), .. },
      { val: Int(start_offset, ..), kind: Labelled("start_offset") },
      ..,
    ] => StringView(s.view(start_offset~))
    [
      { val: StringView(s), .. },
      { val: Int(end_offset, ..), kind: Labelled("end_offset") },
      ..,
    ] => StringView(s.view(end_offset~))
    [{ val: StringView(s), .. }] => StringView(s.view())
    [
      { val: StringView(s), .. },
      { val: Int(start_offset, ..), .. },
      { val: Int(end_offset, ..), .. },
    ] => StringView(s.view(start_offset~, end_offset~))
    [{ val: StringView(s), .. }, { val: Int(start_offset, ..), .. }] =>
      StringView(s.view(start_offset~))
    _ => StringView("")
  }
}
