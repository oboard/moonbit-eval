// String embedded code and methods

///|
pub let string_embedded_code : Map[String, RuntimeFunction] = {
  "%string_length": string_length,
  "%string_add": string_add_fn,
  "%string_eq": string_eq_fn,
  "%string_to_string": string_to_string_fn,
}

///|
let string_methods : Map[String, RuntimeFunction] = {
  "length": string_length,
  "char_length": string_char_length_fn,
  "char_length_eq": string_char_length_eq_fn,
  "char_length_ge": string_char_length_ge_fn,
  "add": string_add_fn,
  "equal": string_eq_fn,
  "to_string": string_to_string_fn,
  "lexical_compare": string_lexical_compare_fn,
  "make": string_make_fn,
  "from_array": string_from_array_fn,
  "from_iter": string_from_iter_fn,
  "iter": string_iter_fn,
  "iter2": string_iter2_fn,
  "offset_of_nth_char": string_offset_of_nth_char_fn,
  "to_array": string_to_array_fn,
  "contains": string_contains_fn,
  "contains_any": string_contains_any_fn,
  "contains_char": string_contains_char_fn,
  "find": string_find_fn,
  "find_by": string_find_by_fn,
  "fold": string_fold_fn,
  "has_prefix": string_has_prefix_fn,
  "has_suffix": string_has_suffix_fn,
  "is_blank": string_is_blank_fn,
  "is_empty": string_is_empty_fn,
  "pad_end": string_pad_end_fn,
  "pad_start": string_pad_start_fn,
  "repeat": string_repeat_fn,
  "replace": string_replace_fn,
  "replace_all": string_replace_all_fn,
  "rev": string_rev_fn,
  "rev_find": string_rev_find_fn,
  "rev_fold": string_rev_fold_fn,
  "rev_iter": string_rev_iter_fn,
  "split": string_split_fn,
  "split_once": string_split_once_fn,
  "before": string_before_fn,
  "after": string_after_fn,
  "rev_split_once": string_rev_split_once_fn,
  "rev_before": string_rev_before_fn,
  "rev_after": string_rev_after_fn,
  "strip_prefix": string_strip_prefix_fn,
  "strip_suffix": string_strip_suffix_fn,
  "to_bytes": string_to_bytes_fn,
  "to_lower": string_to_lower_fn,
  "to_upper": string_to_upper_fn,
  "trim": string_trim_fn,
  "trim_end": string_trim_end_fn,
  "trim_space": string_trim_space_fn,
  "trim_start": string_trim_start_fn,
  "escape": string_escape_fn,
  "get": string_get_fn,
  "get_char": string_get_char_fn,
  "at": string_at_fn,
  "unsafe_get": string_unsafe_get_fn,
  "unsafe_charcode_at": string_unsafe_charcode_at_fn,
  "sub": string_sub_fn,
  "substring": string_substring_fn,
  "unsafe_substring": string_unsafe_substring_fn,
  "suffixes": string_suffixes_fn,
  "view": string_view_fn,
  "code_unit_at": string_code_unit_at_fn,
}

// Core string functions

///|
let string_length : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Int(s.length(), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_code_unit_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(i, ..), .. }] =>
      UInt16(s.code_unit_at(i))
    _ => UInt16(0)
  }
}

///|
let string_add_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(a), .. }, { val: String(b), .. }] => String(a + b)
    _ => String("")
  }
}

///|
let string_eq_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(a), .. }, { val: String(b), .. }] => Bool(a == b)
    _ => Bool(false)
  }
}

///|
let string_to_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s)
    _ => String("")
  }
}

// Simple implementations for other methods

///|
let string_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val: Char(value), .. }] =>
      String(String::make(len, value))
    _ => String("")
  }
}

///|
let string_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Iter(s.iter().map(x => Char(x)))
    _ => panic()
  }
}

///|
let string_to_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Array(s.to_array().map(x => Char(x)))
    _ => Array([])
  }
}

///|
let string_contains_fn : RuntimeFunction = ctx => {
  Bool(
    match ctx.args {
      [{ val: String(str), .. }, { val: String(str2), .. }] =>
        str.contains(str2)
      _ => false
    },
  )
}

///|
let string_contains_char_fn : RuntimeFunction = ctx => {
  Bool(
    match ctx.args {
      [{ val: String(str), .. }, { val: Char(c), .. }] => str.contains_char(c)
      _ => false
    },
  )
}

///|
let string_find_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(str), .. }, { val: StringView(view), .. }] =>
      RuntimeValue::from_option(str.find(view).map(x => Int(x, raw=None)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_find_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Fn(func), .. }] =>
      RuntimeValue::from_option(
        s
        .find_by(char => {
          let res = ctx.context.call(func.val, ctx.pkg, [
            { val: Char(char), kind: Positional },
          ]) catch {
            _ => Unit
          }
          match res {
            Bool(bool) => bool
            _ => false
          }
        })
        .map(x => Int(x, raw=None)),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: init, .. }, { val: Fn(func), .. }, ..] =>
      s.fold(init~, fn(acc, char) {
        ctx.context.call(func.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val: Char(char), kind: Positional },
        ]) catch {
          _ => Unit
        }
      })
    _ => String("")
  }
}

///|
let string_has_prefix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(prefix), .. }] =>
      Bool(s.has_prefix(prefix))
    _ => Bool(false)
  }
}

///|
let string_has_suffix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(suffix), .. }] =>
      Bool(s.has_suffix(suffix))
    _ => Bool(false)
  }
}

///|
let string_is_empty_fn : RuntimeFunction = ctx => {
  if ctx.args.length() > 0 {
    match ctx.args[0].val {
      String(s) => Bool(s.length() == 0)
      _ => Bool(false)
    }
  } else {
    Bool(false)
  }
}

///|
let string_is_blank_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Bool(s.is_blank())
    _ => Bool(false)
  }
}

///|
let string_pad_end_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: String(s), .. },
      { val: Int(total_width, ..), .. },
      { val: Char(padding_char), .. },
    ] => String(s.pad_end(total_width, padding_char))
    _ => String("")
  }
}

///|
let string_pad_start_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: String(s), .. },
      { val: Int(total_width, ..), .. },
      { val: Char(padding_char), .. },
    ] => String(s.pad_start(total_width, padding_char))
    _ => String("")
  }
}

///|
let string_repeat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(count, ..), .. }] =>
      String(s.repeat(count))
    _ => String("")
  }
}

///|
let string_replace_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: String(s), .. },
      { val: String(from), kind: Labelled("old") },
      { val: String(to), kind: Labelled("new") },
    ] => String(s.replace(old=from, new=to))
    _ => String("")
  }
}

///|
let string_replace_all_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(from), .. }, { val: String(to), .. }] =>
      String(s.replace_all(old=from, new=to))
    _ => String("")
  }
}

///|
let string_rev_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s.rev())
    _ => String("")
  }
}

///|
let string_rev_find_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(substr), .. }] =>
      RuntimeValue::from_option(s.rev_find(substr).map(x => Int(x, raw=None)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_rev_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: String(s), .. },
      { val: init, kind: Labelled("init") },
      { val: Fn(func), .. },
      ..,
    ] =>
      s.rev_fold(init~, fn(acc, char) {
        ctx.context.call(func.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val: Char(char), kind: Positional },
        ]) catch {
          _ => Unit
        }
      })
    _ => Unit
  }
}

///|
let string_rev_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Iter(s.rev_iter().map(x => Char(x)))
    _ => Unit
  }
}

///|
let string_split_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(sep), .. }] =>
      Iter(s.split(sep).map(x => StringView(x)))
    _ => Unit
  }
}

///|
let string_strip_prefix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(prefix), .. }] =>
      RuntimeValue::from_option(s.strip_prefix(prefix).map(x => StringView(x)))
    _ => StringView("")
  }
}

///|
let string_strip_suffix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: String(suffix), .. }] =>
      RuntimeValue::from_option(s.strip_suffix(suffix).map(x => StringView(x)))
    _ => StringView("")
  }
}

///|
let string_to_bytes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Bytes(@encoding/utf8.encode(s))
    _ => Bytes(b"")
  }
}

///|
let string_to_lower_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s.to_lower())
    _ => String("")
  }
}

///|
let string_to_upper_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s.to_upper())
    _ => String("")
  }
}

///|
let string_trim_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(char_set), .. }] =>
      StringView(s.trim(char_set~))
    _ => StringView("")
  }
}

///|
let string_trim_start_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(char_set), .. }] =>
      StringView(s.trim_start(char_set~))
    _ => StringView("")
  }
}

///|
let string_trim_end_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(char_set), .. }] =>
      StringView(s.trim_end(char_set~))
    _ => StringView("")
  }
}

///|
let string_trim_space_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => StringView(s.trim())
    _ => StringView("")
  }
}

///|
let string_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: String(s), .. },
      { val: Int(start_offset, ..), kind: Labelled("start_offset") },
      { val: Int(end_offset, ..), kind: Labelled("end_offset") },
      ..,
    ] => StringView(s.view(start_offset~, end_offset~))
    [
      { val: String(s), .. },
      { val: Int(start_offset, ..), kind: Labelled("start_offset") },
      ..,
    ] => StringView(s.view(start_offset~))
    [
      { val: String(s), .. },
      { val: Int(end_offset, ..), kind: Labelled("end_offset") },
      ..,
    ] => StringView(s.view(end_offset~))
    [{ val: String(s), .. }] => StringView(s.view())
    _ => StringView("")
  }
}

///|
let string_char_length_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => Int(s.char_length(), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_char_length_eq_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(n, ..), .. }] =>
      Bool(s.char_length_eq(n))
    _ => Bool(false)
  }
}

///|
let string_char_length_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(n, ..), .. }] =>
      Bool(s.char_length_ge(n))
    _ => Bool(false)
  }
}

///|
let string_lexical_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(a), .. }, { val: String(b), .. }] =>
      Int(a.lexical_compare(b), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_from_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(chars), .. }] => {
      let result = String::from_array(
        chars.map(ch => {
          match ch {
            Char(c) => c
            _ => '\u{0000}'
          }
        }),
      )
      String(result)
    }
    _ => String("")
  }
}

///|
let string_from_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(it), .. }] => {
      let result = String::from_iter(
        it.map(ch => {
          match ch {
            Char(c) => c
            _ => '\u{0000}'
          }
        }),
      )
      String(result)
    }
    _ => String("")
  }
}

///|
let string_contains_any_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(chars), .. }] =>
      Bool(s.contains_any(chars~))
    _ => Bool(false)
  }
}

///|
let string_get_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(s.get_char(i).map(c => Char(c)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => {
      let it = s.iter2()
      let iterator = Iter2::new(fn() {
        match it.next() {
          Some((i, ch)) => Some((Int(i, raw=None), Char(ch)))
          None => None
        }
      })
      Iter2(iterator.iter2())
    }
    _ => Unit
  }
}

///|
let string_offset_of_nth_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(n, ..), .. }] =>
      RuntimeValue::from_option(
        s.offset_of_nth_char(n).map(i => Int(i, raw=None)),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_split_once_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(sep), .. }] =>
      RuntimeValue::from_option(
        s
        .split_once(sep)
        .map(pair => {
          match pair {
            (a, b) => Tuple([StringView(a), StringView(b)])
          }
        }),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_before_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.before(needle).map(v => StringView(v)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_after_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.after(needle).map(v => StringView(v)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_rev_split_once_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(sep), .. }] =>
      RuntimeValue::from_option(
        s
        .rev_split_once(sep)
        .map(pair => {
          match pair {
            (a, b) => Tuple([StringView(a), StringView(b)])
          }
        }),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_rev_before_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.rev_before(needle).map(v => StringView(v)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_rev_after_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: StringView(needle), .. }] =>
      RuntimeValue::from_option(s.rev_after(needle).map(v => StringView(v)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_escape_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s.escape())
    [{ val: String(s), .. }, { val: Bool(quote), .. }] =>
      String(s.escape(quote~))
    _ => String("")
  }
}

///|
let string_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(i, ..), .. }] =>
      if i < 0 || i >= s.length() {
        RuntimeValue::from_option(None)
      } else {
        RuntimeValue::from_option(
          Some(Int(s.code_unit_at(i).to_int(), raw=None)),
        )
      }
    _ => RuntimeValue::from_option(None)
  }
}

///|
let string_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(i, ..), .. }] => UInt16(s.at(i))
    _ => UInt16(0)
  }
}

///|
let string_unsafe_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(i, ..), .. }] => UInt16(s.unsafe_get(i))
    _ => UInt16(0)
  }
}

///|
let string_unsafe_charcode_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }, { val: Int(i, ..), .. }] =>
      Int(s.unsafe_get(i).to_int(), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let string_sub_fn : RuntimeFunction = ctx => string_substring_fn(ctx)

///|
let string_substring_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s.view().to_string())
    [{ val: String(s), .. }, { val: Int(start, ..), .. }] =>
      String(s.view(start_offset=start).to_string())
    [
      { val: String(s), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] => String(s.view(start_offset=start, end_offset=end_).to_string())
    _ => String("")
  }
}

///|
let string_unsafe_substring_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => String(s.view().to_string())
    [{ val: String(s), .. }, { val: Int(start, ..), .. }] =>
      String(s.view(start_offset=start).to_string())
    [
      { val: String(s), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] => String(s.view(start_offset=start, end_offset=end_).to_string())
    _ => String("")
  }
}

///|
let string_suffixes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => {
      let out = []
      for v in s.suffixes() {
        out.push(StringView(v))
      }
      Array(out)
    }
    _ => Array([])
  }
}
