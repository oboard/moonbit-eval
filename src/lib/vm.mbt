///|
struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
}

///|
pub fn MoonBitVM::new(log~ : Bool = false) -> MoonBitVM {
  let interpreter = ClosureInterpreter::new()
  interpreter.add_extern_fn("println", fn(arr) {
    match arr[0] {
      Int(i) => println(i)
      Double(i) => println(i)
      Bool(i) => println(i)
      String(i) => println(i)
      _ => println("Unknown type")
    }
    Unit
  })
  { interpreter, log }
}

///|
pub fn MoonBitVM::eval(self : MoonBitVM, code : String, log? : Bool) -> Value {
  // let tokens = []
  // @lex.lex({ str: code, offset: 0, array: tokens })
  // if log.unwrap_or(self.log) {
  //   println(tokens)
  // }
  let buf = @buffer.new()
  @encoding.encode_to("fn init {\n\{code}\n}", buf, encoding=UTF8)
  let (impls, diagnostics) = @moonbitlang/parser.parse_bytes(
    buf.to_bytes(),
    parser=Handrolled,
  )
  if @moonbitlang/parser/syntax.impls_to_json(impls)
    is {
      "type": "Program",
      "body": [{ "type": "Impl::TopFuncDef", "decl_body": body, .. }],
      ..
    } {
    println(body.stringify())
  }
  Unit
  // match @parser.parse_syntax(tokens) {
  //   Some((expr, _)) => {
  //     if log.unwrap_or(self.log) {
  //       println(expr)
  //     }
  //     self.interpreter.visit(expr)
  //   }
  //   None => Unit
  // }
}
