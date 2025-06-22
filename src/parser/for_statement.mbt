// For(Syntax, Syntax, Syntax, Syntax) // for _; _; _ { _ }

///|
fn for_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
    @lex.Token::For =>
      // println(tokens)
      true
    _ => false
  })
  .andBind(assign_statement)
  .andBind(semicolon_skip)
  .andBind(expression)
  .andBind(semicolon_skip)
  .andBind(assign_statement)
  .andBind(block)
  .map(x => match x {
    ((((((_, initialization), _), condition), _), iteration), statements) =>
      @types.Syntax::For(initialization, condition, iteration, statements)
  })
  .parse(tokens)
}
