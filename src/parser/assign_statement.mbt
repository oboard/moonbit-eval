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
    _ => @util.identifier_error("name")
  })
  .andBind(colon_skip.andBind(parse_type_skip)) // todo,skip2
  .andBind(assign)
  .andBind(assign_right)
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
        _ => @util.assign_error()
      }
      match sign {
        Assign => @types.Syntax::Assign(name, expr)
        AddEqual | SubEqual | MulEqual | DivEqual => Assign(name, expr)
        _ => @util.assign_error()
      }
    }
  })
  .parse(tokens)
}

///|
fn assign_right(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  let parser = fn(tokens) {
    match lambda_expression(tokens) {
      Some(res) => Some(res)
      None => expression(tokens)
    }
  }
  parser(tokens)
}
