///|
fn diagnostics_to_string(
  diagnostics : Array[@moonbitlang/parser/basic.Report],
) -> String {
  diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}")
}

///|
pub fn parse_code_to_expr(code : String) -> Result[@syntax.Expr, String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    "fn init{\n  \{code}\n}",
    parser=Handrolled,
  )
  match impls {
    More(TopFuncDef(fun_decl=_, decl_body~, where_clause=_, loc=_), tail=Empty) =>
      match decl_body {
        DeclBody(expr~) => Ok(expr)
        _ => Err("Invalid function declaration body")
      }
    _ => Err(diagnostics_to_string(diagnostics))
  }
}

///|
pub fn parse_code_to_impl(code : String) -> Result[@syntax.Impl, String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    code,
    parser=Handrolled,
  )
  match impls {
    More(top, tail=Empty) => Ok(top)
    _ => Err(diagnostics_to_string(diagnostics))
  }
}
