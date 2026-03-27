///|
pub fn parse_code_to_expr(code : String) -> Result[@syntax.Expr, String] {
  let tokens = @moonbitlang/parser/lexer.tokens_from_string(
    code,
    comment=true,
  )
  .tokens
  let (expr, diagnostics) = @moonbitlang/parser/handrolled_parser.parse_expr(
    tokens,
  )
  if diagnostics.is_empty() {
    Ok(expr)
  } else {
    Err(diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}"))
  }
}

///|
pub fn parse_code_to_impl(code : String) -> Result[@syntax.Impl, String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    code,
    parser=Handrolled,
  )
  match impls {
    @list.List::More(top, tail=@list.List::Empty) => Ok(top)
    _ => Err(diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}"))
  }
}
