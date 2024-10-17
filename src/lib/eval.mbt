fn eval_code(code : String) -> Unit {
  let tokens = []
  @lex.lex({ str: code, offset: 0, array: tokens })
  // println(tokens)
  match @parser.parse_syntax(tokens[:]) {
    Some((expr, _)) => {
      // println(expr)
      let interpreter = ClosureInterpreter::new()
      interpreter.add_extern_fn(
        "println",
        fn(arr) {
          match arr[0] {
            Int(i) => println(i)
            Double(i) => println(i)
            Bool(i) => println(i)
            String(i) => println(i)
            _ => println("Unknown type")
          }
          Unit
        },
      )
      interpreter.visit(expr) |> ignore
    }
    None => println("Syntax error")
  }
}

test "println" {
  // eval_code("let x: Int = 2\nlet b: Int = 3\nprintln(x+b)")
  eval_code("println(\"hello哈哈world\")")
  // eval_code("println(1)")
}
