// 定义互递归函数
// atomic = "(" expression ")" | Value
// 使用组合子构建的解析器atomic：从左到右解析表达式或数值tokens

// Lambda(String, Syntax) // x => x * 2

///|
fn lambda_expression(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
    Identifier(_) => true
    _ => false
  })
  .andBind(
    ptoken(x => match x {
      Arrow => true
      _ => false
    }),
  )
  .andBind(lambda_body)
  .map(x => match x {
    ((@lex.Token::Identifier(param_name), _), body) =>
      @types.Syntax::Lambda(param_name, body)
    _ => @util.lambda_pattern_error()
  })
  .parse(tokens)
}

///|
fn lambda_body(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  expression(tokens)
}

///|
fn atomicExpression(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  // 优先尝试 lambda
  match lambda_expression(tokens) {
    Some(res) => Some(res)
    None =>
      lparen
      .andBind(expression)
      .andBind(rparen)
      .map(x => match x {
        ((_, expr), _) => expr
      })
      .or(string)
      .or(number)
      .or(add_sub_number)
      .or(boolean)
      .or(variable)
      .or(add_sub_var)
      .or(call_fn_stmt)
      .parse(tokens)
  }
}

///|
fn compare(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  Parser(atomicExpression)
  .andBind(compares.map(map_op).andBind(atomicExpression).many())
  .map(x => match x {
    (e, list) =>
      // println("combine fold: \{e} \{list}")
      list.fold(init=e, (sum, elem) => match (sum, elem) {
        (e, (Some(op), expr)) =>
          match op {
            EqEq => Prim(e, expr, EqEq)
            NotEqual => Prim(e, expr, NotEqual)
            GreaterThan => Prim(e, expr, GreaterThan)
            LessThan => Prim(e, expr, LessThan)
            GreaterEqual => Prim(e, expr, GreaterEqual)
            LessEqual => Prim(e, expr, LessEqual)
            _ => @util.unreachable()
          }
        (_, _) => @util.unreachable()
      })
  })
  .parse(tokens)
}

// 使用组合子构建的解析器combine：从左到右解析atomic和乘或除运算符（递归）

///|
fn combine(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  Parser(compare)
  .andBind(mul_div.map(map_op).andBind(compare).many())
  .map(x => match x {
    (e, list) =>
      // println("combine fold: \{e} \{list}")
      list.fold(init=e, (sum, elem) => match (sum, elem) {
        (e, (Some(op), expr)) =>
          match op {
            Mul => Prim(e, expr, Mul)
            Div => Prim(e, expr, Div)
            _ => @util.unreachable()
          }
        (_, _) => @util.unreachable()
      })
  })
  .parse(tokens)
}

// 使用组合子构建的解析器expression：从左到右解析combine和加或减运算符（递归）

///|
fn expression(
  tokens : ArrayView[@lex.Token],
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  Parser(combine)
  .andBind(add_sub.map(map_op).andBind(combine).many())
  // .and(separator)
  .map(x => match x {
    (e, list) => {
      let result = list.fold(init=e, (sum, elem) => match (sum, elem) {
        (e, (Some(op), expr)) =>
          match op {
            Add => Prim(e, expr, Add)
            Sub => Prim(e, expr, Sub)
            _ => @util.unreachable()
          }
        (_, _) => @util.unreachable()
      })
      // println("开始解析表达式 \{tokens}")
      // println("expression fold: \{e} \{list} -> \{result}")
      result
    }
  })
  .parse(tokens)
}
