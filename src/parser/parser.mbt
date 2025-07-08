// 语法解析

// 解析操作符并映射到 Op 枚举

///|
fn map_op(token : @lex.Token) -> @types.Op? {
  match token {
    Add => Some(Add)
    Sub => Some(Sub)
    Mul => Some(Mul)
    Div => Some(Div)
    EqEq => Some(EqEq)
    LessThan => Some(LessThan)
    GreaterThan => Some(GreaterThan)
    LessEqual => Some(LessEqual)
    GreaterEqual => Some(GreaterEqual)
    NotEqual => Some(NotEqual)
    _ => None
  }
}

///|
pub fn[V] parse(
  self : Parser[V],
  tokens : ArrayView[@lex.Token]
) -> (V, ArrayView[@lex.Token])? {
  // match tokens{
  //   []=> None
  // }
  self.inner()(tokens) //  self._: self.0
}

// 对解析结果进行变换

///|
fn[I, O] map(self : Parser[I], f : (I) -> O) -> Parser[O] {
  x => match x {
    input =>
      match self.parse(input) {
        Some((token, rest)) => Some((f(token), rest))
        None => None
      }
  }
}

// 顺序解析：顺序解析，若遇到失败则返回None，提前退出解析。

///|
fn[V1, V2] andBind(self : Parser[V1], parser2 : Parser[V2]) -> Parser[(V1, V2)] {
  // and返回值为一个函数（输入input，成功则输出为((value1, value2), rest2)）
  // 调用bind者，本身为None时，直接返回None；否则则表示parser1解析成功,解析结果为value1和rest1,继续使用parser2解析rest1,解析结果为value2,rest2
  // 最后解析结果为((value1, value2), rest2)
  x => match x {
    input =>
      self
      .parse(input)
      .bind(x => match x {
        (value1, rest1) =>
          parser2
          .parse(rest1)
          .map(x => match x {
            (value2, rest2) => ((value1, value2), rest2)
          })
      })
  }
}

// 尝试解析：尝试解析每一个部分，若都失败才返回None。

///|
fn[Value] or(self : Parser[Value], parser2 : Parser[Value]) -> Parser[Value] {
  x => match x {
    input =>
      match self.parse(input) {
        None => parser2.parse(input)
        Some(_) as result => result
      }
  }
}

// 重复解析：0次或多次，直到失败为止。

///|
fn[Value : Show] many(self : Parser[Value]) -> Parser[Array[Value]] {
  fn(input) {
    // println("Many 1")
    // println("input: \{input}")
    // println("self.parse(input): \{self.parse(input)}")
    let cumul = []
    let mut rest = input

    // 方法1
    while true {
      match self.parse(rest) {
        None => break
        Some((v, rest_)) => {
          cumul.push(v)
          rest = rest_
        }
      }
    }
    // println("many()成功解析: \{cumul}")
    // println("many()尚未解析: \{rest}")
    Some((cumul, rest))

    // 方法2
    // loop self.parse(rest) {
    //   None => break Some((cumul, rest))
    //   Some((v, rest_)) => {
    //     println("Many 2")
    //     println("value: \{v}")
    //     println("rest_: \{rest_}")
    //     println("self.parse(rest_): \{self.parse(rest_)}")
    //     cumul.push(v)
    //     rest = rest_
    //     continue self.parse(rest) // to drop
    //   }
    // }

  }
}

///|
// fn[Value : Show] zero_one(self : Parser[Value]) -> Parser[Array[Value]] {
//   fn(input) {
//     // println("Many 1")
//     // println("input: \{input}")
//     // println("self.parse(input): \{self.parse(input)}")
//     let cumul = []
//     let mut rest = input

//     // 方法1
//     while true {
//       match self.parse(rest) {
//         None => break
//         Some((v, rest_)) => {
//           cumul.push(v)
//           rest = rest_
//         }
//       }
//     }
//     // println("many()成功解析: \{cumul}")
//     // println("many()尚未解析: \{rest}")
//     Some((cumul, rest))

//     // 方法2
//     // loop self.parse(rest) {
//     //   None => break Some((cumul, rest))
//     //   Some((v, rest_)) => {
//     //     println("Many 2")
//     //     println("value: \{v}")
//     //     println("rest_: \{rest_}")
//     //     println("self.parse(rest_): \{self.parse(rest_)}")
//     //     cumul.push(v)
//     //     rest = rest_
//     //     continue self.parse(rest) // to drop
//     //   }
//     // }

//   }
// }

// 递归定义：延迟定义并未使用

///|
// fn[Value] Parser::reference(reference : Ref[Parser[Value]]) -> Parser[Value] {
//   fn(input) { reference.val.parse(input) }
// }

// if语句解析器

///|
fn if_statement(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  ptoken(x => match x {
    @lex.Token::If => true
    _ => false
  })
  .andBind(expression) // 解析条件表达式
  // .andBind(statements) // 解析多语句
  .andBind(block) // 解析 then 分支
  .andBind(
    ptoken(x => match x {
      @lex.Token::Else => true
      _ => false
    }),
  )
  .andBind(block) // 解析 else 分支
  .map(x => match x {
    ((((_, condition), then_branch), _), else_branch) =>
      @types.Syntax::If(condition, then_branch, else_branch)
  })
  .parse(tokens)
}

// ()

///|
fn lparen_rparen_stmt(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  lparen
  .andBind(rparen)
  .map(x => match x {
    _ => @types.Syntax::Unit
  })
  .parse(tokens)
}

// fn newline_stmt(tokens: ArrayView[@lex.Token]) -> Option[(@types.Syntax, ArrayView[@lex.Token])] {
//     newline_skip
//     // .many()
//     .map(fn {  _ => {
//       @types.Syntax::Unit
//     }})
//     .parse(tokens)
// }

///|
fn block(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  parser_context.is_top_level = false
  // println("block: \{parser_context}")
  lbrace
  // lbrace.many().map(fn {_ => None})
  // .andBind(expression)
  // .andBind(statement()) // 解析单个语句
  .andBind(statements) // 解析多个语句
  .andBind(separator.many())
  .andBind(rbrace)
  .map(x => match x {
    (((_, stmts), _), _rbrace) => {
      // println("消耗了： \{rbrace}")
      // println("block内语法是 \{stmts}")
      parser_context.is_top_level = true
      // println(parser_context)
      stmts
    }
  })
  .parse(tokens)
}

// 优化语句解析

///|
fn statement() -> Parser[@types.Syntax] {
  fn(
    tokens : ArrayView[@lex.Token]
  ) -> (@types.Syntax, ArrayView[@lex.Token])? {
    if tokens.length() == 0 {
      return None
    }

    // 按优先级排序的解析器
    let parsers = [
      fn_main_statement, fn_statement, let_statement, for_statement, while_statement,
      if_statement, assign_statement, expression, // 使用expression_statement.mbt中定义的expression
       lparen_rparen_stmt, call_fn_stmt,
    ]

    // 优化遍历
    let mut i = 0
    let len = parsers.length()
    while i < len {
      let result = parsers[i](tokens)
      if not(result.is_empty()) {
        return result
      }
      i += 1
    }
    None
  }
}

// 优化语句序列解析

///|
fn statements(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  statement()
  .andBind(separator_skip.andBind(statement()).many())
  .map(x => match x {
    (first_stmt, list) => {
      let stmts = [first_stmt]
      list.each(x => match x {
        (_, stmt) => stmts.push(stmt)
      })
      if stmts.length() == 1 {
        stmts[0]
      } else {
        @types.Syntax::Seq(stmts)
      }
    }
  })
  .parse(tokens)
}

///|
pub fn parse_syntax(
  tokens : ArrayView[@lex.Token]
) -> (@types.Syntax, ArrayView[@lex.Token])? {
  parser_context.token_length = tokens.length()
  statements(tokens)
}

///|
test {
  let input = "1 + 2 * 3 - 6;"
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  inspect(
    tokens,
    content="[Number(1), Add, Number(2), Mul, Number(3), Sub, Number(6), Semicolon]",
  )
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  inspect(
    expr,
    content="Prim(Prim(Int(1), Prim(Int(2), Int(3), Mul), Add), Int(6), Sub)",
  )
  let input = "1/2-(3)"
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  inspect(
    tokens,
    content="[Number(1), Div, Number(2), Sub, LParen, Number(3), RParen]",
  )
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  inspect(expr, content="Prim(Prim(Int(1), Int(2), Div), Int(3), Sub)")

  // 多行表达式
  // 字符串输入
  let input = "1 + 2 - 3;2;"
  // 词法解析
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  inspect(
    tokens,
    content="[Number(1), Add, Number(2), Sub, Number(3), Semicolon, Number(2), Semicolon]",
  )
  // 语法解析（自顶向下的解释器组合子）
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content="Seq([Prim(Prim(Int(1), Int(2), Add), Int(3), Sub), Int(2)])",
  )
  let input = "1/2-3 \n4*5+6"
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Number(1), Div, Number(2), Sub, Number(3), Newline, Number(4), Mul, Number(5), Add, Number(6)]",
  )
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content="Seq([Prim(Prim(Int(1), Int(2), Div), Int(3), Sub), Prim(Prim(Int(4), Int(5), Mul), Int(6), Add)])",
  )

  // let 语句
  let tokens = []
  @lex.lex({ str: "let a:Int=1;2", offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Let, Identifier(\"a\"), Colon, Int, Assign, Number(1), Semicolon, Number(2)]",
  )
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content=
      #|Seq([Let(("a", Int), Int(1), Unit, mutable=false), Int(2)])
    ,
  )

  // 多行let
  let tokens = []
  @lex.lex({ str: "let a:Int=1;let b:Int=1", offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Let, Identifier(\"a\"), Colon, Int, Assign, Number(1), Semicolon, Let, Identifier(\"b\"), Colon, Int, Assign, Number(1)]",
  )
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content=
      #|Seq([Let(("a", Int), Int(1), Unit, mutable=false), Let(("b", Int), Int(1), Unit, mutable=false)])
    ,
  )
  let tokens = []
  @lex.lex({ str: "let a:Int=1\nlet b:Int=1", offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Let, Identifier(\"a\"), Colon, Int, Assign, Number(1), Newline, Let, Identifier(\"b\"), Colon, Int, Assign, Number(1)]",
  )
  let (expr, _) = parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content=
      #|Seq([Let(("a", Int), Int(1), Unit, mutable=false), Let(("b", Int), Int(1), Unit, mutable=false)])
    ,
  )
}
