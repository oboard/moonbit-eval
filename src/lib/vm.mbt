pub struct MoonBitVM {
  interpreter : ClosureInterpreter
}

pub fn MoonBitVM::new() -> MoonBitVM {
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
  { interpreter, }
}

pub fn MoonBitVM::eval(
  self : MoonBitVM,
  code : String,
  ~log : Bool = false
) -> Value {
  let tokens = []
  @lex.lex({ str: code, offset: 0, array: tokens })
  if log {
    println(tokens)
  }
  match @parser.parse_syntax(tokens[:]) {
    Some((expr, _)) => {
      if log {
        println(expr)
      }
      self.interpreter.visit(expr)
    }
    None => Unit
  }
}
