// String embedded code and methods

///|
let string_view_methods : Map[String, RuntimeFunction] = {
  "length": string_view_length,
  "add": string_view_add,
  "code_unit_at": string_view_code_unit_at,
  "char_length": string_view_char_length,
  "char_length_eq": string_view_char_length_eq,
  "char_length_ge": string_view_char_length_ge,
  "compare": string_view_compare,
  "contains": string_view_contains,
  "data": string_view_data,
  "default": string_view_default,
  "equal": string_view_equal,
  "find": string_view_find,
  "fold": string_view_fold,
  "get_char": string_view_get_char,
  "has_prefix": string_view_has_prefix,
  "has_suffix": string_view_has_suffix,
  "is_blank": string_view_is_blank,
  "is_empty": string_view_is_empty,
  "iter": string_view_iter,
  "offset_of_nth_char": string_view_offset_of_nth_char,
  "op_add": string_view_op_add,
  "op_equal": string_view_op_equal,
  "pad_end": string_view_pad_end,
  "pad_start": string_view_pad_start,
  "repeat": string_view_repeat,
  "replace": string_view_replace,
  "replace_all": string_view_replace_all,
  "rev": string_view_rev,
  "rev_find": string_view_rev_find,
  "rev_fold": string_view_rev_fold,
  "rev_iter": string_view_rev_iter,
  "split": string_view_split,
  "start_offset": string_view_start_offset,
  "strip_prefix": string_view_strip_prefix,
  "strip_suffix": string_view_strip_suffix,
  "to_array": string_view_to_array,
  "to_bytes": string_view_to_bytes,
  "to_json": string_view_to_json,
  "to_lower": string_view_to_lower,
  "to_string": string_view_to_string,
  "to_string_view": string_view_to_string_view_view,
  "to_upper": string_view_to_upper,
  "trim": string_view_trim,
  "trim_end": string_view_trim_end,
  "trim_space": string_view_trim_space,
  "trim_start": string_view_trim_start,
  "unsafe_charcode_at": string_view_unsafe_charcode_at,
}

///|
let string_view_length : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Int(s.length(), raw=None)
  _ => Int(0, raw=None)
}

///|
let string_view_add : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] =>
    StringView(s1 + s2)
  _ => StringView("")
}

///|
let string_view_code_unit_at : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
    UInt16(s.code_unit_at(i))
  _ => StringView("")
}

///|
let string_view_char_length : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Int(s.char_length(), raw=None)
  _ => Int(0, raw=None)
}

///|
let string_view_char_length_eq : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
    Bool(s.char_length() == n)
  _ => Bool(false)
}

///|
let string_view_char_length_ge : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
    Bool(s.char_length() >= n)
  _ => Bool(false)
}

///|
let string_view_compare : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] =>
    Int(s1.compare(s2), raw=None)
  _ => Int(0, raw=None)
}

///|
let string_view_contains : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(sub), .. }] =>
    Bool(s.contains(sub))
  _ => Bool(false)
}

///|
let string_view_data : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => String(s.data())
  _ => String("")
}

///|
let string_view_default : RuntimeFunction = ctx => match ctx.args {
  _ => StringView("")
}

///|
let string_view_equal : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] => Bool(s1 == s2)
  _ => Bool(false)
}

///|
let string_view_find : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(sub), .. }] =>
    match s.find(sub) {
      Some(i) => Int(i, raw=None)
      None => Int(-1, raw=None)
    }
  _ => Int(-1, raw=None)
}

///|
let string_view_fold : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: init, .. }, { val: Fn(func), .. }, ..] =>
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

///|
let string_view_get_char : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
    s.get_char(i).map(Char(_)) |> RuntimeValue::from_option
  _ => StringView("")
}

///|
let string_view_has_prefix : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(prefix), .. }] =>
    Bool(s.has_prefix(prefix))
  _ => Bool(false)
}

///|
let string_view_has_suffix : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(suffix), .. }] =>
    Bool(s.has_suffix(suffix))
  _ => Bool(false)
}

///|
let string_view_is_blank : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Bool(s.is_blank())
  _ => Bool(false)
}

///|
let string_view_is_empty : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Bool(s.is_empty())
  _ => Bool(false)
}

///|
let string_view_iter : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Iter(s.iter().map(Char(_)))
  _ => Iter(Iter::empty())
}

///|
let string_view_offset_of_nth_char : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
    RuntimeValue::from_option(s.offset_of_nth_char(n).map(Int(_, raw=None)))
  _ => Int(-1, raw=None)
}

///|
let string_view_op_add : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] =>
    StringView(s1 + s2)
  _ => StringView("")
}

///|
let string_view_op_equal : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s1), .. }, { val: StringView(s2), .. }] => Bool(s1 == s2)
  _ => Bool(false)
}

///|
let string_view_pad_end : RuntimeFunction = ctx => match ctx.args {
  [
    { val: StringView(s), .. },
    { val: Int(total_width, ..), .. },
    { val: Char(padding_char), .. },
  ] => StringView(s.pad_end(total_width, padding_char))
  _ => StringView("")
}

///|
let string_view_pad_start : RuntimeFunction = ctx => match ctx.args {
  [
    { val: StringView(s), .. },
    { val: Int(total_width, ..), .. },
    { val: Char(padding_char), .. },
  ] => StringView(s.pad_start(total_width, padding_char))
  _ => StringView("")
}

///|
let string_view_repeat : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(n, ..), .. }] =>
    StringView(s.repeat(n))
  _ => StringView("")
}

///|
let string_view_replace : RuntimeFunction = ctx => match ctx.args {
  [
    { val: StringView(s), .. },
    { val: StringView(old), .. },
    { val: StringView(new), .. },
  ] => StringView(s.replace(old~, new~))
  _ => StringView("")
}

///|
let string_view_replace_all : RuntimeFunction = ctx => match ctx.args {
  [
    { val: StringView(s), .. },
    { val: String(from), .. },
    { val: String(to), .. },
  ] => StringView(s.replace_all(old=from, new=to))
  _ => StringView("")
}

///|
let string_view_rev : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => StringView(s.rev())
  _ => StringView("")
}

///|
let string_view_rev_find : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(sub), .. }] =>
    match s.rev_find(sub) {
      Some(i) => Int(i, raw=None)
      None => Int(-1, raw=None)
    }
  _ => Int(-1, raw=None)
}

///|
let string_view_rev_fold : RuntimeFunction = ctx => match ctx.args {
  [
    { val: StringView(s), .. },
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

///|
let string_view_rev_iter : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Iter(s.rev_iter().map(Char(_)))
  _ => Iter(Iter::empty())
}

///|
let string_view_split : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: String(sep), .. }] =>
    Iter(s.split(sep).map(StringView(_)))
  [{ val: StringView(s), .. }, { val: StringView(sep), .. }] =>
    Iter(s.split(sep).map(StringView(_)))
  _ => Iter(Iter::empty())
}

///|
let string_view_start_offset : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Int(s.start_offset(), raw=None)
  _ => Int(0, raw=None)
}

///|
let string_view_strip_prefix : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(prefix), .. }] =>
    match s.strip_prefix(prefix) {
      Some(rest) => StringView(rest)
      None => StringView(s)
    }
  _ => StringView("")
}

///|
let string_view_strip_suffix : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(suffix), .. }] =>
    match s.strip_suffix(suffix) {
      Some(rest) => StringView(rest)
      None => StringView(s)
    }
  _ => StringView("")
}

///|
let string_view_to_array : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Array(s.to_array().map(Char(_)))
  _ => Array([])
}

///|
let string_view_to_bytes : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Bytes(@encoding/utf8.encode(s))
  _ => Bytes(b"")
}

///|
let string_view_to_json : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => Json(s.to_json())
  _ => String("\"\"")
}

///|
let string_view_to_lower : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => StringView(s.to_lower())
  _ => StringView("")
}

///|
let string_view_to_string : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => String(s.to_string())
  _ => String("")
}

///|
let string_view_to_string_view_view : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => StringView(s)
  _ => StringView("")
}

///|
let string_view_to_upper : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => StringView(s.to_upper())
  _ => StringView("")
}

///|
let string_view_trim : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(char_set), .. }] =>
    StringView(s.trim(char_set~))
  _ => StringView("")
}

///|
let string_view_trim_end : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(char_set), .. }] =>
    StringView(s.trim_end(char_set~))
  _ => StringView("")
}

///|
let string_view_trim_space : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }] => StringView(s.trim_space())
  _ => StringView("")
}

///|
let string_view_trim_start : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: StringView(char_set), .. }] =>
    StringView(s.trim_start(char_set~))
  _ => StringView("")
}

///|
let string_view_unsafe_charcode_at : RuntimeFunction = ctx => match ctx.args {
  [{ val: StringView(s), .. }, { val: Int(i, ..), .. }] =>
    if i >= 0 && i < s.length() {
      Int(s.unsafe_charcode_at(i), raw=None)
    } else {
      Int(0, raw=None)
    }
  _ => Int(0, raw=None)
}
