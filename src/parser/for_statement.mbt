// For(Syntax, Syntax, Syntax, Syntax) // for _; _; _ { _ }
fn for_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(
    fn {
      @lex.Token::For => {
        println("for_statement")
        println(tokens)
        true
      }
      _ => false
    },
  )
  .and(assign_statement)
  .and(semicolon_skip)
  .and(expression)
  .and(semicolon_skip)
  .and(assign_statement)
  .and(block)
  .map(
    fn {
      ((((((_, initialization), _), condition), _), iteration), statements) =>
        @types.Syntax::For(initialization, condition, iteration, statements)
    },
  )
  .parse(tokens)
}
