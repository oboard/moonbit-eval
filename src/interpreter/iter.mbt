///|
pub let iter_methods : Map[String, RuntimeFunction] = { "new": iter_new_fn }

///|
let iter_new_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val, .. }, ..] => Iter(Iter::new(f => f(val)))
  _ => Unit
}
