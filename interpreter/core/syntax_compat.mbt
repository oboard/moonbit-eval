///|
fn string_starts_with_at(
  source : String,
  index : Int,
  pattern : String,
) -> Bool {
  if index + pattern.length() > source.length() {
    return false
  }
  for i = 0; i < pattern.length(); i = i + 1 {
    if source.unsafe_get(index + i) != pattern.unsafe_get(i) {
      return false
    }
  }
  true
}

///|
fn is_ascii_space(ch : Char) -> Bool {
  ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t'
}

///|
fn find_list_comprehension_rewrite(source : String, start : Int) -> (Int, Int)? {
  if !string_starts_with_at(source, start, "[for") {
    return None
  }
  let after_for = start + 4
  if after_for < source.length() &&
    !is_ascii_space(source.get_char(after_for).unwrap_or(' ')) {
    return None
  }
  let mut paren_depth = 0
  let mut bracket_depth = 0
  let mut brace_depth = 0
  let mut arrow = -1
  let mut i = start + 1
  while i < source.length() {
    let ch = source.get_char(i).unwrap_or('\u{0}')
    match ch {
      '(' => paren_depth += 1
      ')' if paren_depth > 0 => paren_depth -= 1
      '[' => bracket_depth += 1
      ']' =>
        if bracket_depth == 0 && paren_depth == 0 && brace_depth == 0 {
          if arrow >= 0 {
            return Some((arrow, i))
          }
          return None
        } else if bracket_depth > 0 {
          bracket_depth -= 1
        }
      '{' => brace_depth += 1
      '}' if brace_depth > 0 => brace_depth -= 1
      '=' if paren_depth == 0 && bracket_depth == 0 && brace_depth == 0 =>
        if i + 1 < source.length() &&
          source.get_char(i + 1).unwrap_or('\u{0}') == '>' {
          arrow = i
          i += 1
        }
      _ => ()
    }
    i += 1
  }
  None
}

///|
fn find_list_comprehension_filter(
  source : String,
  start : Int,
  arrow : Int,
) -> Int {
  let mut paren_depth = 0
  let mut bracket_depth = 0
  let mut brace_depth = 0
  let mut i = start + 1
  while i + 2 < arrow {
    let ch = source.get_char(i).unwrap_or('\u{0}')
    match ch {
      '(' => paren_depth += 1
      ')' if paren_depth > 0 => paren_depth -= 1
      '[' => bracket_depth += 1
      ']' if bracket_depth > 0 => bracket_depth -= 1
      '{' => brace_depth += 1
      '}' if brace_depth > 0 => brace_depth -= 1
      'i' if paren_depth == 0 && bracket_depth == 0 && brace_depth == 0 =>
        if source.get_char(i + 1).unwrap_or('\u{0}') == 'f' &&
          is_ascii_space(source.get_char(i - 1).unwrap_or('\u{0}')) &&
          is_ascii_space(source.get_char(i + 2).unwrap_or('\u{0}')) {
          return i
        }
      _ => ()
    }
    i += 1
  }
  -1
}

///|
pub fn normalize_v092_syntax(source : String) -> String {
  let buf = StringBuilder::new()
  let mut i = 0
  while i < source.length() {
    match find_list_comprehension_rewrite(source, i) {
      Some((arrow, end)) => {
        let filter_start = find_list_comprehension_filter(source, i, arrow)
        if filter_start >= 0 {
          buf.write_view(source[i:filter_start])
          buf.write_string("{ guard ")
          buf.write_view(source[filter_start + 2:arrow])
          buf.write_string(" else { continue }; ")
        } else {
          buf.write_view(source[i:arrow])
          buf.write_string("{ ")
        }
        buf.write_view(source[arrow + 2:end])
        buf.write_string(" }")
        buf.write_char(']')
        i = end + 1
      }
      None => {
        buf.write_char(source.get_char(i).unwrap_or('\u{0}'))
        i += 1
      }
    }
  }
  buf.to_string()
}
