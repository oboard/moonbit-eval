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
  let tokens = []
  @lex.lex({ str: code, offset: 0, array: tokens })
  if log.or(self.log) {
    println(tokens)
  }
  match @parser.parse_syntax(tokens[:]) {
    Some((expr, _)) => {
      if log.or(self.log) {
        println(expr)
      }
      self.interpreter.visit(expr)
    }
    None => Unit
  }
}
