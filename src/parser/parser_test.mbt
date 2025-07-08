///|
test {
  let input = "1 + 2 * 3 - 6;"
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  inspect(
    tokens,
    content="[Number(1), Add, Number(2), Mul, Number(3), Sub, Number(6), Semicolon]",
  )
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  // inspect(expr,content="Prim(Prim(Int(1), Prim(Int(2), Int(3), Mul, kind=None), Add, kind=None), Int(6), Sub, kind=None)",)
  inspect(
    expr,
    content="Seq([Prim(Prim(Int(1), Prim(Int(2), Int(3), Mul, kind=None), Add, kind=None), Int(6), Sub, kind=None)])",
  )
  let input = "1/2-(3)"
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  inspect(
    tokens,
    content="[Number(1), Div, Number(2), Sub, LParen, Number(3), RParen]",
  )
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  inspect(
    expr,
    content="Seq([Prim(Prim(Int(1), Int(2), Div, kind=None), Int(3), Sub, kind=None)])",
  )

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
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  println(expr)
  // inspect(expr, content="Prim(Prim(Int(1), Int(2), Add, kind=None), Int(3), Sub, kind=None)")
  inspect(
    expr,
    content="Seq([Prim(Prim(Int(1), Int(2), Add, kind=None), Int(3), Sub, kind=None), Int(2)])",
  )
  let input = "1/2-3 \n4*5+6"
  let tokens = []
  @lex.lex({ str: input, offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Number(1), Div, Number(2), Sub, Number(3), Newline, Number(4), Mul, Number(5), Add, Number(6)]",
  )
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content="Seq([Prim(Prim(Int(1), Int(2), Div, kind=None), Int(3), Sub, kind=None), Prim(Prim(Int(4), Int(5), Mul, kind=None), Int(6), Add, kind=None)])",
  )

  // let input = "+ + 2 * 3 - 6"  // 暂时报错, moonbit支持不报错
  // let tokens = []
  // @lex.lex({ str: input, offset: 0, array: tokens })
  // inspect(
  //   tokens,
  //   content="[Add, Add, Number(2), Mul, Number(3), Sub, Number(6)]",
  // )
  // let (expr, _) = parser.parse(tokens[:]).unwrap()
  // inspect(
  //   expr,
  //   content="Minus(Plus(Add, Multiply(Number(2), Number(3))), Number(6))",
  // )

  // let语句
  let tokens = []
  @lex.lex({ str: "let a:Int=1;2", offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Let, Identifier(\"a\"), Colon, Int, Assign, Number(1), Semicolon, Number(2)]",
  )
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(expr, content="Seq([Let((\"a\", Int), Int(1), Unit), Int(2)])")

  // 多行let
  let tokens = []
  @lex.lex({ str: "let a:Int=1;let b:Int=1", offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Let, Identifier(\"a\"), Colon, Int, Assign, Number(1), Semicolon, Let, Identifier(\"b\"), Colon, Int, Assign, Number(1)]",
  )
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content="Seq([Let((\"a\", Int), Int(1), Unit), Let((\"b\", Int), Int(1), Unit)])",
  )
  let tokens = []
  @lex.lex({ str: "let a:Int=1\nlet b:Int=1", offset: 0, array: tokens })
  println(tokens)
  inspect(
    tokens,
    content="[Let, Identifier(\"a\"), Colon, Int, Assign, Number(1), Newline, Let, Identifier(\"b\"), Colon, Int, Assign, Number(1)]",
  )
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  println(expr)
  inspect(
    expr,
    content="Seq([Let((\"a\", Int), Int(1), Unit), Let((\"b\", Int), Int(1), Unit)])",
  )

  // if in file
  // moon run src/bin/main.mbt -- --end-stage parse test/test_simple_src/if_else.mbt  // success
  // moon run src/bin/main.mbt -- --end-stage parse test/test_simple_src/if_else2.mbt // failure  换行
  // moon run src/bin/main.mbt -- --end-stage parse test/test_simple_src/if.mbt // failure  缺少else
  // moon run src/bin/main.mbt -- --end-stage parse test/test_simple_src/if2.mbt  // failure  缺少else

  // fn in file
}
