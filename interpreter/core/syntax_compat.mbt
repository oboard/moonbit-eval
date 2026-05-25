///|
fn is_ascii_space(ch : Char) -> Bool {
  ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t'
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
fn parse_moon_config_import_item(ast : @moon_config.Ast) -> PackageImport? {
  match ast {
    Str(path, ..) => Some({ path, alias_: Some(default_import_alias(path)) })
    Obj(fields, ..) => {
      let mut path = None
      let mut alias_ = None
      for field in fields {
        match field {
          ("path", Str(value, ..)) => path = Some(value)
          ("alias", Str(value, ..)) => alias_ = Some(value)
          _ => ()
        }
      }
      match path {
        Some(path) =>
          Some({
            path,
            alias_: Some(alias_.unwrap_or(default_import_alias(path))),
          })
        None => None
      }
    }
    _ => None
  }
}

///|
priv struct ImportSpan {
  start : Int
  end : Int
}

///|
fn collect_imports_from_moon_config(
  ast : @moon_config.Ast,
) -> (Array[PackageImport], Array[ImportSpan]) {
  let imports = []
  let spans = []
  match ast {
    Obj(fields, ..) =>
      for field in fields {
        match field {
          ("import", Arr(content, loc~)) => {
            for item in content {
              if parse_moon_config_import_item(item) is Some(import_) {
                imports.push(import_)
              }
            }
            spans.push({ start: loc.start.cnum, end: loc.end.cnum })
          }
          _ => ()
        }
      }
    _ => ()
  }
  (imports, spans)
}

///|
fn remove_import_spans(source : String, spans : Array[ImportSpan]) -> String {
  let buf = StringBuilder::new()
  let mut cursor = 0
  for span in spans {
    let start = span.start.clamp(min=0, max=source.length())
    let end = span.end.clamp(min=start, max=source.length())
    if cursor < start {
      buf.write_view(source[cursor:start])
    }
    cursor = end
    while cursor < source.length() &&
          is_ascii_space(source.get_char(cursor).unwrap_or('\u{0}')) {
      cursor += 1
    }
  }
  if cursor < source.length() {
    buf.write_view(source[cursor:])
  }
  buf.to_string()
}

///|
pub fn parse_package_imports(source : String) -> ImportParseResult {
  let (ast, _diagnostics) = @moon_config.parse_moon_pkg(source)
  let (imports, spans) = collect_imports_from_moon_config(ast)
  { code: remove_import_spans(source, spans), imports }
}

///|
fn source_char(source : String, index : Int) -> Char {
  source.get_char(index).unwrap_or('\u{0}')
}

///|
fn is_ascii_ident_char(ch : Char) -> Bool {
  (ch >= 'a' && ch <= 'z') ||
  (ch >= 'A' && ch <= 'Z') ||
  (ch >= '0' && ch <= '9') ||
  ch == '_'
}

///|
fn starts_with_at(source : String, index : Int, needle : String) -> Bool {
  if index < 0 {
    return false
  }
  let end = index + needle.length()
  if end > source.length() {
    return false
  }
  for offset = 0; offset < needle.length(); offset = offset + 1 {
    if source.get_char(index + offset) != needle.get_char(offset) {
      return false
    }
  }
  true
}

///|
fn word_at(source : String, index : Int, word : String) -> Bool {
  if !starts_with_at(source, index, word) {
    return false
  }
  let before_ok = if index == 0 {
    true
  } else {
    !is_ascii_ident_char(source_char(source, index - 1))
  }
  let after = index + word.length()
  let after_ok = if after >= source.length() {
    true
  } else {
    !is_ascii_ident_char(source_char(source, after))
  }
  before_ok && after_ok
}

///|
fn skip_ascii_space_at(source : String, index : Int) -> Int {
  let mut i = index
  while i < source.length() && is_ascii_space(source_char(source, i)) {
    i += 1
  }
  i
}

///|
fn skip_quoted_source(source : String, index : Int) -> Int {
  let quote = source_char(source, index)
  let mut i = index + 1
  let mut escaped = false
  while i < source.length() {
    let ch = source_char(source, i)
    if escaped {
      escaped = false
    } else if ch == '\\' {
      escaped = true
    } else if ch == quote {
      return i + 1
    }
    i += 1
  }
  source.length()
}

///|
fn skip_non_code_source(source : String, index : Int) -> Int {
  if index >= source.length() {
    return index
  }
  let ch = source_char(source, index)
  if ch == '"' || ch == '\'' {
    return skip_quoted_source(source, index)
  }
  if starts_with_at(source, index, "//") {
    let mut i = index + 2
    while i < source.length() && source_char(source, i) != '\n' {
      i += 1
    }
    return i
  }
  if starts_with_at(source, index, "/*") {
    let mut i = index + 2
    while i + 1 < source.length() && !starts_with_at(source, i, "*/") {
      i += 1
    }
    return (i + 2).clamp(min=0, max=source.length())
  }
  index
}

///|
fn find_list_comprehension_body_brace(source : String, start : Int) -> Int {
  let mut i = start
  let mut paren_depth = 0
  let mut square_depth = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if paren_depth == 0 && square_depth == 0 {
      if starts_with_at(source, i, "=>") {
        return -1
      }
      match source_char(source, i) {
        '{' => return i
        ']' => return -1
        _ => ()
      }
    }
    match source_char(source, i) {
      '(' => paren_depth += 1
      ')' => paren_depth -= 1
      '[' => square_depth += 1
      ']' => square_depth -= 1
      _ => ()
    }
    i += 1
  }
  -1
}

///|
fn find_matching_curly(source : String, open_index : Int) -> Int {
  let mut i = open_index
  let mut depth = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    match source_char(source, i) {
      '{' => depth += 1
      '}' => {
        depth -= 1
        if depth == 0 {
          return i
        }
      }
      _ => ()
    }
    i += 1
  }
  -1
}

///|
fn normalize_list_comprehension_blocks(source : String) -> String {
  let buf = StringBuilder::new()
  let mut cursor = 0
  let mut i = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if source_char(source, i) == '[' {
      let content_start = skip_ascii_space_at(source, i + 1)
      if word_at(source, content_start, "for") {
        let body_brace = find_list_comprehension_body_brace(
          source,
          content_start + 3,
        )
        if body_brace >= 0 {
          let body_end = find_matching_curly(source, body_brace)
          let after_body = skip_ascii_space_at(source, body_end + 1)
          if body_end > body_brace &&
            after_body < source.length() &&
            source_char(source, after_body) == ']' {
            buf.write_view(source[cursor:body_brace])
            buf.write_string("=> ")
            buf.write_view(source[body_brace + 1:body_end])
            cursor = body_end + 1
            i = body_end + 1
            continue
          }
        }
      }
    }
    i += 1
  }
  if cursor < source.length() {
    buf.write_view(source[cursor:])
  }
  buf.to_string()
}

///|
fn find_loop_body_brace(source : String, start : Int) -> Int {
  let mut i = start
  let mut paren_depth = 0
  let mut square_depth = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if paren_depth == 0 && square_depth == 0 {
      if source_char(source, i) == '{' {
        return i
      }
      if source_char(source, i) == ';' {
        return -1
      }
    }
    match source_char(source, i) {
      '(' => paren_depth += 1
      ')' => paren_depth -= 1
      '[' => square_depth += 1
      ']' => square_depth -= 1
      _ => ()
    }
    i += 1
  }
  -1
}

///|
fn normalize_loop_expressions(source : String) -> String {
  let loop_arg = "__moonbit_eval_loop_arg"
  let buf = StringBuilder::new()
  let mut cursor = 0
  let mut i = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if word_at(source, i, "loop") {
      let arg_start = skip_ascii_space_at(source, i + 4)
      let body_brace = find_loop_body_brace(source, arg_start)
      if body_brace >= 0 {
        let body_end = find_matching_curly(source, body_brace)
        if body_end > body_brace {
          buf.write_view(source[cursor:i])
          buf.write_string("for ")
          buf.write_string(loop_arg)
          buf.write_string(" = ")
          buf.write_view(source[arg_start:body_brace])
          buf.write_string(" { match ")
          buf.write_string(loop_arg)
          buf.write_string(" {")
          buf.write_view(source[body_brace + 1:body_end])
          buf.write_string("} }")
          cursor = body_end + 1
          i = body_end + 1
          continue
        }
      }
    }
    i += 1
  }
  if cursor < source.length() {
    buf.write_view(source[cursor:])
  }
  buf.to_string()
}

///|
fn find_header_brace(source : String, start : Int) -> Int {
  let mut i = start
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if source_char(source, i) == '{' {
      return i
    }
    if source_char(source, i) == '\n' {
      return -1
    }
    i += 1
  }
  -1
}

///|
fn normalize_enum_header(header : String) -> String {
  let buf = StringBuilder::new()
  let mut i = 0
  while i < header.length() {
    if source_char(header, i) == '@' {
      i += 1
      while i < header.length() && source_char(header, i) != '.' {
        i += 1
      }
      if i < header.length() && source_char(header, i) == '.' {
        i += 1
      }
      continue
    }
    if starts_with_at(header, i, "+=") {
      i += 2
      continue
    }
    buf.write_char(source_char(header, i))
    i += 1
  }
  buf.to_string()
}

///|
fn normalize_extenum_decls(source : String) -> String {
  let buf = StringBuilder::new()
  let mut i = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      buf.write_view(source[i:skipped])
      i = skipped
      continue
    }
    let mut keyword_len = 0
    if word_at(source, i, "extenum") {
      keyword_len = 7
    } else if word_at(source, i, "enum") {
      keyword_len = 4
    }
    if keyword_len > 0 {
      buf.write_string("enum")
      i += keyword_len
      let brace = find_header_brace(source, i)
      if brace >= 0 {
        buf.write_string(normalize_enum_header(source[i:brace].to_owned()))
        i = brace
      }
      continue
    }
    buf.write_char(source_char(source, i))
    i += 1
  }
  buf.to_string()
}

///|
fn scan_left_type_ref(source : String, index : Int) -> Int {
  let mut i = index
  while i >= 0 && is_ascii_space(source_char(source, i)) {
    i -= 1
  }
  while i >= 0 {
    let ch = source_char(source, i)
    if is_ascii_ident_char(ch) || ch == '.' || ch == '@' {
      i -= 1
    } else {
      break
    }
  }
  i + 1
}

///|
fn normalize_extensible_constructor_refs(source : String) -> String {
  let buf = StringBuilder::new()
  let mut cursor = 0
  let mut i = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if starts_with_at(source, i, "::@") {
      let left_start = scan_left_type_ref(source, i - 1)
      if left_start >= cursor {
        buf.write_view(source[cursor:left_start])
        cursor = i + 2
      }
      i += 2
      continue
    }
    i += 1
  }
  if cursor < source.length() {
    buf.write_view(source[cursor:])
  }
  buf.to_string()
}

///|
fn previous_non_space(source : String, index : Int) -> Int {
  let mut i = index
  while i >= 0 && is_ascii_space(source_char(source, i)) {
    i -= 1
  }
  i
}

///|
fn find_matching_open_paren(source : String, close_index : Int) -> Int {
  let mut i = close_index
  let mut depth = 0
  while i >= 0 {
    let ch = source_char(source, i)
    if ch == ')' {
      depth += 1
    } else if ch == '(' {
      depth -= 1
      if depth == 0 {
        return i
      }
    }
    i -= 1
  }
  -1
}

///|
fn has_call_args(source : String, open_index : Int, close_index : Int) -> Bool {
  let mut i = open_index + 1
  while i < close_index {
    if !is_ascii_space(source_char(source, i)) {
      return true
    }
    i += 1
  }
  false
}

///|
fn find_reverse_pipe_rhs_end(source : String, start : Int) -> Int {
  let mut i = start
  let mut paren_depth = 0
  let mut brace_depth = 0
  let mut square_depth = 0
  while i < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    let ch = source_char(source, i)
    if paren_depth == 0 && brace_depth == 0 && square_depth == 0 {
      match ch {
        ';' | ',' | ')' | ']' | '}' => return i
        _ => ()
      }
    }
    match ch {
      '(' => paren_depth += 1
      ')' => paren_depth -= 1
      '{' => brace_depth += 1
      '}' => brace_depth -= 1
      '[' => square_depth += 1
      ']' => square_depth -= 1
      _ => ()
    }
    i += 1
  }
  i
}

///|
fn normalize_reverse_pipe_methods(source : String) -> String {
  let buf = StringBuilder::new()
  let mut cursor = 0
  let mut i = 0
  while i + 1 < source.length() {
    let skipped = skip_non_code_source(source, i)
    if skipped != i {
      i = skipped
      continue
    }
    if starts_with_at(source, i, "<|") {
      let lhs_close = previous_non_space(source, i - 1)
      if lhs_close >= cursor && source_char(source, lhs_close) == ')' {
        let lhs_open = find_matching_open_paren(source, lhs_close)
        let rhs_start = skip_ascii_space_at(source, i + 2)
        let rhs_end = find_reverse_pipe_rhs_end(source, rhs_start)
        if lhs_open >= cursor && rhs_start < rhs_end {
          buf.write_view(source[cursor:lhs_close])
          if has_call_args(source, lhs_open, lhs_close) {
            buf.write_string(", ")
          }
          buf.write_view(source[rhs_start:rhs_end])
          buf.write_char(')')
          cursor = rhs_end
          i = rhs_end
          continue
        }
      }
    }
    i += 1
  }
  if cursor < source.length() {
    buf.write_view(source[cursor:])
  }
  buf.to_string()
}

///|
fn normalize_v092_syntax(source : String) -> String {
  source
  |> normalize_list_comprehension_blocks
  |> normalize_loop_expressions
  |> normalize_extenum_decls
  |> normalize_extensible_constructor_refs
  |> normalize_reverse_pipe_methods
}
