// 添加 let 语句的解析器
fn let_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  let mut mutable = false
  ptoken(
    fn {
      @lex.Token::Let => true
      _ => false
    },
  )
  .and(
    ptoken_skip(
      fn {
        Mut => {
          mutable = true
          true
        }
        _ => false
      },
    ),
  )
  .and(
    ptoken(
      fn {
        Identifier(_) => true
        _ => @util.die("let identifier 标识符错误")
      },
    ).map(
      fn {
        @lex.Token::Identifier(name) => name
        _ => @util.die("let identifier 标识符错误")
      },
    ),
  )
  .and(colon_skip.and(parse_type_skip)) // todo,skip2
  .and(assign)
  .and(expression) // 暂时仅支持expression
  // .and(statements)
  // .and(separator)
  // .and(statements) // 去掉连续语句
  .map(
    fn {
      // ((((_, name), (_, ty)), _), expr1) =>
      // ((((((@lex.Token, @lex.Token), String), (@lex.Token, @types.Type)), @lex.Token), @types.Syntax))
      ((((_, name), (_, ty)), _), expr1) =>
        @types.Syntax::Let((name, ty), expr1, @types.Syntax::Unit, ~mutable)
    },
  )
  .parse(tokens)
}
