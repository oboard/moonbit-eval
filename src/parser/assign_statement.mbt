///|
fn assign_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
    Identifier(_) => true
    _ => false
  })
  .map(x => match x {
    @lex.Token::Identifier(name) => name
    _ => @util.die("name 标识符错误")
  })
  .andBind(colon_skip.andBind(parse_type_skip)) // todo,skip2
  .andBind(assign)
  .andBind(expression) // 暂时仅支持expression
  // .andBind(statements)
  // .andBind(separator)
  // .andBind(statements) // 去掉连续语句
  .map(x => match x {
    (((name, _), sign), expr1) => {
      let expr = match sign {
        Assign => expr1
        AddEqual => Prim(Var(name), expr1, Add)
        SubEqual => Prim(Var(name), expr1, Sub)
        MulEqual => Prim(Var(name), expr1, Mul)
        DivEqual => Prim(Var(name), expr1, Div)
        _ => @util.die("assign 错误")
      }
      @types.Syntax::Assign(name, expr)
    }
  })
  .parse(tokens)
}
