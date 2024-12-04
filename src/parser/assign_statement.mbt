fn assign_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(
    fn {
      Identifier(_) => true
      _ => false
    },
  )
  .map(
    fn {
      @lex.Token::Identifier(name) => name
      _ => @util.die("name 标识符错误")
    },
  )
  .and(colon_skip.and(parse_type_skip)) // todo,skip2
  .and(assign)
  .and(expression) // 暂时仅支持expression
  // .and(statements)
  // .and(separator)
  // .and(statements) // 去掉连续语句
  .map(
    fn {
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
    },
  )
  .parse(tokens)
}
