fn eval_code(code : String) -> Unit {
  let tokens = []
  @lex.lex({ str: code, offset: 0, array: tokens })
  let (expr, _) = @parser.parse_syntax(tokens[:]).unwrap()
  println(expr)
  let interpreter = ClosureInterpreter::new()
  interpreter.add_extern_fn(
    "println",
    fn(arr) {
      match arr[0] {
        Int(n) => println(n)
        Double(d) => println(d)
        Bool(b) => println(b)
        String(s) => println(s)
        _ => println("Unknown type")
      }
      Unit
    },
  )
  interpreter.visit(expr) |> ignore
}

test "println" {
  eval_code("let x: Int = 2\nlet b: Int = 3\nprintln(x+b)")
}
