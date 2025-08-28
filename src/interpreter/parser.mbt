///|
pub fn parse_code_to_expr(code : String) -> Result[@syntax.Expr, String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    code,
    parser=Handrolled,
  )
  match impls {
    @list.List::More(
      @syntax.Impl::TopFuncDef(fun_decl=_, decl_body~, loc=_),
      tail=@list.List::Empty
    ) =>
      match decl_body {
        @syntax.DeclBody::DeclBody(local_types=_, expr~) => Ok(expr)
        _ => Err("Invalid function declaration body")
      }
    _ => Err(diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}"))
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
