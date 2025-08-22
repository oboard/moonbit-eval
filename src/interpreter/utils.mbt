///|
pub fn unit(loc? : @basic.Location) -> @syntax.Expr {
  @syntax.Expr::Unit(
    loc=loc.unwrap_or({
      start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
      end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    }),
    faked=true,
  )
}

///|
#callsite(autofill(loc))
pub fn[A] ClosureInterpreter::error(
  self : ClosureInterpreter,
  msg : String,
  loc~ : SourceLoc,
) -> A {
  (self.visit(
    Apply(
      func=@syntax.Expr::Ident(
        id={ name: Ident(name="println"), loc: dummy_loc() },
        loc=dummy_loc(),
      ),
      args=@list.of([
        @syntax.Argument::{
          value: @syntax.Expr::Constant(
            c=String(msg + " " + loc.to_string()),
            loc=dummy_loc(),
          ),
          kind: @syntax.ArgumentKind::Positional,
        },
      ]),
      attr=NoAttr,
      loc=dummy_loc(),
    ),
  ) catch {
    _ => Unit
  })
  |> ignore
  abort(msg)
}

///|
#callsite(autofill(loc))
pub fn[A] error(msg : String, loc~ : SourceLoc) -> A {
  println("\{msg} \{loc}")
  abort(msg)
}
