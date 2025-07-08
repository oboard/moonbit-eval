// 添加 let 语句的解析器

///|
fn let_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
    Let => true
    _ => false
  })
  .andBind(
    ptoken(x => match x {
      Mut => true
      _ => false
    })
    .map(_ => true)
    .or(Parser(fn(tokens) { Some((false, tokens)) })),
  )
  .andBind(
    ptoken(x => match x {
      Identifier(_) => true
      _ => false
    }).map(x => match x {
      @lex.Token::Identifier(name) => name
      _ => @util.identifier_error("let name")
    }),
  )
  .andBind(colon_skip.andBind(parse_type_skip))
  .andBind(assign)
  .andBind(let_right)
  .map(x => match x {
    (((((_, is_mutable), name), (_, ty)), _), expr1) =>
      @types.Syntax::Let(
        (name, ty),
        expr1,
        @types.Syntax::Unit,
        mutable=is_mutable,
      )
  })
  .parse(tokens)
}

///|
fn let_right(
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
