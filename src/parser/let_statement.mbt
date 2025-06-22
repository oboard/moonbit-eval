// 添加 let 语句的解析器

///|
fn let_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  let mut mutable = false
  ptoken(x => match x {
    @lex.Token::Let => true
    _ => false
  })
  .andBind(
    ptoken_skip(x => match x {
      Mut => {
        mutable = true
        true
      }
      _ => false
    }),
  )
  .andBind(
    ptoken(x => match x {
      Identifier(_) => true
      _ => @util.die("let identifier 标识符错误")
    }).map(x => match x {
      @lex.Token::Identifier(name) => name
      _ => @util.die("let identifier 标识符错误")
    }),
  )
  .andBind(colon_skip.andBind(parse_type_skip)) // todo,skip2
  .andBind(assign)
  .andBind(expression) // 暂时仅支持expression
  // .andBind(statements)
  // .andBind(separator)
  // .andBind(statements) // 去掉连续语句
  .map(x => match x {
    // ((((_, name), (_, ty)), _), expr1) =>
    // ((((((@lex.Token, @lex.Token), String), (@lex.Token, @types.Type)), @lex.Token), @types.Syntax))
    ((((_, name), (_, ty)), _), expr1) =>
      @types.Syntax::Let((name, ty), expr1, @types.Syntax::Unit, mutable~)
  })
  .parse(tokens)
}
