// While(Syntax, Syntax) // while _ { _ }

///|
fn while_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
    @lex.Token::While => true
    _ => false
  })
  .andBind(expression) // 解析条件表达式
  .andBind(block) // 解析循环体
  .map(x => match x {
    ((_, condition), statements) => @types.Syntax::While(condition, statements)
  })
  .parse(tokens)
}
