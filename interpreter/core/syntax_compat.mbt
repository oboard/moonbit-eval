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

///|
pub(all) struct PackageImport {
  path : String
  alias_ : String?
}

///|
pub(all) struct ImportParseResult {
  code : String
  imports : Array[PackageImport]
}

///|
fn skip_ascii_space(source : String, start : Int) -> Int {
  let mut i = start
  while i < source.length() {
    if is_ascii_space(source.get_char(i).unwrap_or('\u{0}')) {
      i += 1
    } else {
      break
    }
  }
  i
}

///|
fn parse_import_block_end(source : String, open_brace : Int) -> Int? {
  let mut i = open_brace + 1
  let mut in_string = false
  let mut escaped = false
  while i < source.length() {
    let ch = source.get_char(i).unwrap_or('\u{0}')
    if in_string {
      if escaped {
        escaped = false
      } else if ch == '\\' {
        escaped = true
      } else if ch == '"' {
        in_string = false
      }
    } else {
      match ch {
        '"' => in_string = true
        '}' => return Some(i)
        _ => ()
      }
    }
    i += 1
  }
  None
}

///|
fn default_import_alias(path : String) -> String {
  let mut slash = -1
  for i = 0; i < path.length(); i = i + 1 {
    if path.get_char(i).unwrap_or('\u{0}') == '/' {
      slash = i
    }
  }
  if slash >= 0 {
    path[slash + 1:].to_owned()
  } else {
    path
  }
}

///|
fn parse_pkg_import_item(ast : @pkg_parser.Ast) -> PackageImport? {
  match ast {
    Str(str=path, ..) =>
      Some({ path, alias_: Some(default_import_alias(path)) })
    Obj(map~, ..) =>
      match (map.get("path"), map.get("alias")) {
        (Some(Str(str=path, ..)), Some(Str(str=alias_, ..))) =>
          Some({ path, alias_: Some(alias_) })
        (Some(Str(str=path, ..)), _) =>
          Some({ path, alias_: Some(default_import_alias(path)) })
        _ => None
      }
    _ => None
  }
}

///|
fn parse_import_entries(source : String) -> Array[PackageImport] {
  let imports = []
  let (ast, _diagnostics) = @pkg_parser.parse_string(source, name="moon.pkg")
  match ast {
    Obj(map~, ..) =>
      match map.get("import") {
        Some(Arr(content~, ..)) =>
          for item in content {
            if parse_pkg_import_item(item) is Some(import_) {
              imports.push(import_)
            }
          }
        _ => ()
      }
    _ => ()
  }
  imports
}

///|
pub fn parse_package_imports(source : String) -> ImportParseResult {
  let imports = []
  let buf = StringBuilder::new()
  let mut cursor = 0
  let mut i = skip_ascii_space(source, 0)
  while string_starts_with_at(source, i, "import") {
    let after_import = skip_ascii_space(source, i + "import".length())
    if after_import >= source.length() ||
      source.get_char(after_import).unwrap_or('\u{0}') != '{' {
      break
    }
    match parse_import_block_end(source, after_import) {
      Some(close_brace) => {
        imports.append(
          parse_import_entries(source[i:close_brace + 1].to_owned()),
        )
        buf.write_view(source[cursor:i])
        cursor = close_brace + 1
        i = skip_ascii_space(source, cursor)
      }
      None => break
    }
  }
  buf.write_view(source[cursor:])
  { code: buf.to_string(), imports }
}
