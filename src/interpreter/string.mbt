// String embedded code and methods

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
let string_methods : Map[String, RuntimeFunction] = {
  "length": string_length,
  "get": string_get_fn,
  "unsafe_get": string_unsafe_get_fn,
  "add": string_add_fn,
  "equal": string_eq_fn,
  "to_string": string_to_string_fn,
  "make": string_make_fn,
  "iter": string_iter_fn,
  "to_array": string_to_array_fn,
  "contains": string_contains_fn,
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
  "strip_prefix": string_strip_prefix_fn,
  "strip_suffix": string_strip_suffix_fn,
  "to_bytes": string_to_bytes_fn,
  "to_lower": string_to_lower_fn,
  "to_upper": string_to_upper_fn,
  "trim": string_trim_fn,
  "trim_end": string_trim_end_fn,
  "trim_space": string_trim_space_fn,
  "trim_start": string_trim_start_fn,
  "view": string_view_fn,
}

// Core string functions

///|
let string_length : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => Int(s.length())
  _ => Int(0)
}

///|
let string_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: Int(i), .. }] =>
    if i >= 0 && i < s.length() {
      Int(s[i])
    } else {
      Int(0)
    }
  _ => Int(0)
}

///|
let string_unsafe_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: Int(i), .. }] => Int(s[i])
  _ => Int(0)
}

///|
let string_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(a), .. }, { val: String(b), .. }] => String(a + b)
  _ => String("")
}

///|
let string_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(a), .. }, { val: String(b), .. }] => Bool(a == b)
  _ => Bool(false)
}

///|
let string_to_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => String(s)
  _ => String("")
}

// Simple implementations for other methods

///|
let string_make_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(len), .. }, { val: Char(value), .. }] =>
    String(String::make(len, value))
  _ => String("")
}

///|
let string_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => Iter(s.iter().map(Char(_)))
  _ => Iter(Iter::new(_ => IterEnd))
}

///|
let string_to_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => Array(s.to_array().map(Char(_)))
  _ => Array([])
}

///|
let string_contains_fn : RuntimeFunction = ctx => Bool(
  match ctx.args {
    [{ val: String(str), .. }, { val: String(str2), .. }] => str.contains(str2)
    _ => false
  },
)

///|
let string_contains_char_fn : RuntimeFunction = ctx => Bool(
  match ctx.args {
    [{ val: String(str), .. }, { val: Char(c), .. }] => str.contains_char(c)
    _ => false
  },
)

///|
let string_find_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(str), .. }, { val: StringView(view), .. }] =>
    RuntimeValue::from_option(str.find(view).map(Int(_)))
  _ => RuntimeValue::from_option(None)
}

///|
let string_find_by_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: Fn(func, env), .. }] =>
    RuntimeValue::from_option(
      s
      .find_by(char => {
        let res = ctx.context.call(
          func,
          ctx.pkg,
          env,
          @list.singleton({ val: Char(char), kind: Positional }),
        ) catch {
          _ => Unit
        }
        match res {
          Bool(bool) => bool
          _ => false
        }
      })
      .map(Int(_)),
    )
  _ => RuntimeValue::from_option(None)
}

///|
let string_fold_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: init, .. }, { val: Fn(func, env), .. }, ..] =>
    s.fold(init~, fn(acc, char) {
      ctx.context.call(
        func,
        ctx.pkg,
        env,
        @list.of([
          { val: acc, kind: Positional },
          { val: Char(char), kind: Positional },
        ]),
      ) catch {
        _ => Unit
      }
    })
  _ => String("")
}

///|
let string_has_prefix_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(prefix), .. }] =>
    Bool(s.has_prefix(prefix))
  _ => Bool(false)
}

///|
let string_has_suffix_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(suffix), .. }] =>
    Bool(s.has_suffix(suffix))
  _ => Bool(false)
}

///|
let string_is_empty_fn : RuntimeFunction = ctx => if ctx.args.length() > 0 {
  match ctx.args[0].val {
    String(s) => Bool(s.length() == 0)
    _ => Bool(false)
  }
} else {
  Bool(false)
}

///|
let string_is_blank_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => Bool(s.is_blank())
  _ => Bool(false)
}

///|
let string_pad_end_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: String(s), .. },
    { val: Int(total_width), .. },
    { val: Char(padding_char), .. },
  ] => String(s.pad_end(total_width, padding_char))
  _ => String("")
}

///|
let string_pad_start_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: String(s), .. },
    { val: Int(total_width), .. },
    { val: Char(padding_char), .. },
  ] => String(s.pad_start(total_width, padding_char))
  _ => String("")
}

///|
let string_repeat_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: Int(count), .. }] => String(s.repeat(count))
  _ => String("")
}

///|
let string_replace_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: String(s), .. },
    { val: String(from), kind: Labelled("old") },
    { val: String(to), kind: Labelled("new") },
  ] => String(s.replace(old=from, new=to))
  _ => String("")
}

///|
let string_replace_all_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(from), .. }, { val: String(to), .. }] =>
    String(s.replace_all(old=from, new=to))
  _ => String("")
}

///|
let string_rev_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => String(s.rev())
  _ => String("")
}

///|
let string_rev_find_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(substr), .. }] =>
    RuntimeValue::from_option(s.rev_find(substr).map(Int(_)))
  _ => RuntimeValue::from_option(None)
}

///|
let string_rev_fold_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: String(s), .. },
    { val: init, kind: Labelled("init") },
    { val: Fn(func, env), .. },
    ..,
  ] =>
    s.rev_fold(init~, fn(acc, char) {
      ctx.context.call(
        func,
        ctx.pkg,
        env,
        @list.of([
          { val: acc, kind: Positional },
          { val: Char(char), kind: Positional },
        ]),
      ) catch {
        _ => Unit
      }
    })
  _ => Unit
}

///|
let string_rev_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => Iter(s.rev_iter().map(Char(_)))
  _ => Unit
}

///|
let string_split_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(sep), .. }] =>
    Iter(s.split(sep).map(StringView(_)))
  _ => Unit
}

///|
let string_strip_prefix_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(prefix), .. }] =>
    RuntimeValue::from_option(s.strip_prefix(prefix).map(StringView(_)))
  _ => StringView("")
}

///|
let string_strip_suffix_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: String(suffix), .. }] =>
    RuntimeValue::from_option(s.strip_prefix(suffix).map(StringView(_)))
  _ => StringView("")
}

///|
let string_to_bytes_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => Bytes(@encoding/utf8.encode(s))
  _ => Bytes(b"")
}

///|
let string_to_lower_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => String(s.to_lower())
  _ => String("")
}

///|
let string_to_upper_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => String(s.to_upper())
  _ => String("")
}

///|
let string_trim_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: StringView(char_set), .. }] =>
    StringView(s.trim(char_set~))
  _ => StringView("")
}

///|
let string_trim_start_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: StringView(char_set), .. }] =>
    StringView(s.trim_start(char_set~))
  _ => StringView("")
}

///|
let string_trim_end_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }, { val: StringView(char_set), .. }] =>
    StringView(s.trim_end(char_set~))
  _ => StringView("")
}

///|
let string_trim_space_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: String(s), .. }] => StringView(s.trim_space())
  _ => StringView("")
}

///|
let string_view_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: String(s), .. },
    { val: Int(start_offset), kind: Labelled("start_offset") },
    { val: Int(end_offset), kind: Labelled("end_offset") },
    ..,
  ] => StringView(s.view(start_offset~, end_offset~))
  [
    { val: String(s), .. },
    { val: Int(start_offset), kind: Labelled("start_offset") },
    ..,
  ] => StringView(s.view(start_offset~))
  [
    { val: String(s), .. },
    { val: Int(end_offset), kind: Labelled("end_offset") },
    ..,
  ] => StringView(s.view(end_offset~))
  [{ val: String(s), .. }] => StringView(s.view())
  _ => StringView("")
}
