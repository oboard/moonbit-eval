///|
struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
}

///|
pub fn MoonBitVM::new(log~ : Bool = false) -> MoonBitVM {
  let interpreter = ClosureInterpreter::new()
  // interpreter.add_extern_fn("println", fn(arr) {
  //   match arr[0] {
  //     Int(i) => println(i)
  //     Double(i) => println(i)
  //     Bool(i) => println(i)
  //     String(i) => println(i)
  //     _ => println("Unknown type")
  //   }
  //   @syntax.Constant::Int("0")
  // })
  { interpreter, log }
}

///|
pub fn MoonBitVM::eval_to_str(
  self : MoonBitVM,
  code : String,
  log? : Bool,
) -> String {
  let expr = self.eval(code, log?)
  match expr {
    Constant(c~, ..) =>
      match c {
        Bool(b) => b.to_string()
        Byte(b) => b
        Bytes(b) => b
        Char(c) => c
        Int(str) => str
        Int64(str) => str
        UInt(str) => str
        UInt64(str) => str
        Float(str) => str
        Double(str) => str
        String(str) => str
        BigInt(str) => str
      }
    Unit(..) => "Unit"
    _ => ""
  }
}

///|
pub fn MoonBitVM::eval(
  self : MoonBitVM,
  code : String,
  log? : Bool,
) -> @syntax.Expr {
  // let tokens = []
  // @lex.lex({ str: code, offset: 0, array: tokens })
  // if log.unwrap_or(self.log) {
  //   println(tokens)
  // }
  let buf = @buffer.new()
  @encoding.encode_to("fn init {\n\{code}\n}", buf, encoding=UTF8)
  let (impls, _diagnostics) = @moonbitlang/parser.parse_bytes(
    buf.to_bytes(),
    parser=Handrolled,
  )
  match impls {
    @list.List::More(
      @syntax.Impl::TopFuncDef(fun_decl=_, decl_body~, loc=_),
      tail=@list.List::Empty
    ) =>
      match decl_body {
        @syntax.DeclBody::DeclBody(local_types=_, expr~) => {
          if log.unwrap_or(self.log) {
            println(expr.to_json().stringify())
          }
          return self.interpreter.visit(expr)
        }
        _ => ()
      }
    _ => ()
  }
  @syntax.Expr::Unit(
    loc={
      start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
      end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
    },
    faked=true,
  )
  // match @parser.parse_syntax(tokens) {
  //   Some((expr, _)) => {
  //     if log.unwrap_or(self.log) {
  //       println(expr)
  //     }
  //     self.interpreter.visit(expr)
  //   }
  //   None => @syntax.Constant::Int("0")
  // }
}
