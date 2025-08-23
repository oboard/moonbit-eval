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
pub fn[A] error(msg : String, loc~ : SourceLoc) -> A raise ControlFlow {
  raise ControlFlow::Error(msg + " " + loc.to_string())
}
