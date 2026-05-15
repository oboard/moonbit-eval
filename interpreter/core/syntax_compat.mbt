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
