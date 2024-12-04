// 定义互递归函数
// atomic = "(" expression ")" | Value
// 使用组合子构建的解析器atomic：从左到右解析表达式或数值tokens
fn atomic(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  lparen
  .and(
    // statements, // 引用函数,statements函数自动类型转换为Parser
    expression, // 暂时仅支持
  )
  .and(rparen)
  .map(fn { ((_, expr), _) => expr }) // 忽略括号
  .or(string)
  .or(number)
  .or(add_sub_number)
  .or(boolean)
  .or(var)
  .or(add_sub_var)
  .or(call_fn_stmt)
  .parse(tokens)
}

fn compare(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  Parser(atomic)
  .and(compares.map(map_op).and(atomic).many())
  .map(
    fn {
      (e, list) =>
        // println("combine fold: \{e} \{list}")
        list.fold(
          init=e,
          fn {
            e, (Some(op), expr) =>
              match op {
                EqEq => Prim(e, expr, EqEq)
                NotEqual => Prim(e, expr, NotEqual)
                GreaterThan => Prim(e, expr, GreaterThan)
                LessThan => Prim(e, expr, LessThan)
                GreaterEqual => Prim(e, expr, GreaterEqual)
                LessEqual => Prim(e, expr, LessEqual)
                _ => @util.die("不应该出现在这里")
              }
            _, _ => @util.die("不应该出现在这里")
          },
        )
    },
  )
  .parse(tokens)
}

// 使用组合子构建的解析器combine：从左到右解析atomic和乘或除运算符（递归）
fn combine(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  Parser(compare)
  .and(mul_div.map(map_op).and(compare).many())
  .map(
    fn {
      (e, list) =>
        // println("combine fold: \{e} \{list}")
        list.fold(
          init=e,
          fn {
            e, (Some(op), expr) =>
              match op {
                Mul => Prim(e, expr, Mul)
                Div => Prim(e, expr, Div)
                _ => @util.die("不应该出现在这里")
              }
            _, _ => @util.die("不应该出现在这里")
          },
        )
    },
  )
  .parse(tokens)
}

// 使用组合子构建的解析器expression：从左到右解析combine和加或减运算符（递归）
fn expression(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  Parser(combine)
  .and(add_sub.map(map_op).and(combine).many())
  // .and(separator)
  .map(
    fn {
      (e, list) => {
        let result = list.fold(
          init=e,
          fn {
            e, (Some(op), expr) =>
              match op {
                Add => Prim(e, expr, Add)
                Sub => Prim(e, expr, Sub)
                _ => @util.die("不应该出现在这里")
              }
            _, _ => @util.die("不应该出现在这里")
          },
        )
        // println("开始解析表达式 \{tokens}")
        // println("expression fold: \{e} \{list} -> \{result}")
        result
      }
    },
  )
  .parse(tokens)
}
