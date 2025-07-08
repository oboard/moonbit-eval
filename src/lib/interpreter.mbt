///|
struct ClosureInterpreter {
  extern_fns : Map[String, (Array[Value]) -> Value]
  values : Array[Map[String, Variable]]
}

///|
priv enum Variable {
  Immutable(Value)
  Mutable(Value)
} derive(Show)

///|
enum Value {
  Unit
  Int(Int)
  Bool(Bool)
  Double(Double)
  String(String)
  Tuple(Array[Value])
  Array(Array[Value])
  ExternFn(String)
  Closure(@types.Fundef, Array[Value])
} derive(Show)

///|
pub impl Eq for Value with op_equal(self : Value, other : Value) -> Bool {
  match (self, other) {
    (Unit, Unit) => true
    (Int(x), Int(y)) => x == y
    (Bool(x), Bool(y)) => x == y
    (String(x), String(y)) => x == y
    (Double(x), Double(y)) => x == y
    (Tuple(xs), Tuple(ys)) => xs == ys
    (Array(xs), Array(ys)) => xs == ys
    (ExternFn(x), ExternFn(y)) => x == y
    (Closure(_, _), Closure(_, _)) => false
    _ => false
  }
}

///|
pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  { extern_fns: Map::new(), values: [{}] }
}

///|
pub fn ClosureInterpreter::add_extern_fn(
  self : ClosureInterpreter,
  name : String,
  f : (Array[Value]) -> Value
) -> Unit {
  self.extern_fns.set(name, f)
}

///|
fn ClosureInterpreter::find(self : ClosureInterpreter, name : String) -> Value {
  // println("find: \{name}")
  for value in self.extern_fns.keys() {
    if value == name {
      // println("found extern fn: \{name}")
      return ExternFn(name)
    }
  }
  for value in self.values.rev() {
    match value.get(name) {
      Some(variable) =>
        // println("found value: \{name}")
        return match variable {
          Immutable(value) => value
          Mutable(value) => value
        }
      None => continue
    }
  }
  Unit
}

///|
fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @types.Syntax
) -> Value {
  match node {
    Int(i) => Int(i)
    Double(d) => Double(d)
    String(s) => String(s)
    Bool(b) => Bool(b)
    Unit => Unit
    Tuple(xs) => Tuple(xs.map(fn(x) { self.visit(x) }))
    Seq(xs) => xs.map(fn(x) { self.visit(x) }).last().unwrap()
    Let((name, _types), value, _return_type, mutable~) => {
      let value_val = self.visit(value)
      self.values[0][name] = if mutable {
        Mutable(value_val)
      } else {
        Immutable(value_val)
      }
      Unit
    }
    Neg(x) => {
      let x_val = self.visit(x)
      match x_val {
        Int(x) => Int(-x)
        Double(x) => Double(-x)
        _ => Unit
      }
    }
    Prim(lhs, rhs, op) => {
      let result = self.visit(lhs)
      let y = self.visit(rhs)
      // println("result: \{result}")
      // println("y: \{y}")
      // println("op: \{op}")
      match result {
        String(x) =>
          match y {
            String(y) =>
              match op {
                Add => String(x + y)
                EqEq => Bool(x == y)
                NotEqual => Bool(x != y)
                LessThan => Bool(x < y)
                GreaterThan => Bool(x > y)
                LessEqual => Bool(x <= y)
                GreaterEqual => Bool(x >= y)
                _ => Unit
              }
            _ => Unit
          }
        Int(x) =>
          match y {
            Int(y) =>
              match op {
                Add => Int(x + y)
                Sub => Int(x - y)
                Mul => Int(x * y)
                Div => Int(x / y)
                EqEq => Bool(x == y)
                NotEqual => Bool(x != y)
                LessThan => Bool(x < y)
                GreaterThan => Bool(x > y)
                LessEqual => Bool(x <= y)
                GreaterEqual => Bool(x >= y)
                _ => Unit
              }
            _ => Unit
          }
        Double(x) =>
          match y {
            Double(y) =>
              match op {
                Add => Double(x + y)
                Sub => Double(x - y)
                Mul => Double(x * y)
                Div => Double(x / y)
                EqEq => Bool(x == y)
                NotEqual => Bool(x != y)
                LessThan => Bool(x < y)
                GreaterThan => Bool(x > y)
                LessEqual => Bool(x <= y)
                GreaterEqual => Bool(x >= y)
                _ => Unit
              }
            _ => Unit
          }
        _ => Unit
      }
    }
    LetRec({ name, args, body }, _return_type) => {
      let (funcName, _) = name
      self.values
      .last()
      .unwrap()
      .set(funcName, Immutable(Closure({ name, args, body }, [])))
      Unit
    }
    Array(xs) => Array(xs.map(fn(x) { self.visit(x) }))
    If(cond, then, else_) => {
      let cond_val = self.visit(cond)
      if cond_val is Bool(true) {
        self.visit(then)
      } else {
        self.visit(else_)
      }
    }
    For(initialization, condition, iteration, statements) => {
      self.visit(initialization) |> ignore
      while self.visit(condition) is Bool(true) {
        self.visit(statements) |> ignore
        self.visit(iteration) |> ignore
      } else {
        Unit
      }
    }
    While(condition, statements) =>
      while self.visit(condition) is Bool(true) {
        self.visit(statements) |> ignore
      } else {
        Unit
      }
    Assign(name, value) => {
      let value_val = self.visit(value)
      for value in self.values.rev() {
        match value.get(name) {
          Some(variable) =>
            match variable {
              Mutable(_) => value[name] = Mutable(value_val)
              _ => continue
            }
          None => value[name] = Mutable(value_val)
        }
      }
      Unit
    }
    App(f, xs) => {
      let f_val = self.visit(f)
      let xs_val = xs.map(fn(x) { self.visit(x) })
      match f_val {
        ExternFn(name) => {
          let f = self.extern_fns.get(name).unwrap()
          f(xs_val)
        }
        Closure(func, _env) => {
          let closure = Map::new()
          for i = 0; i < xs_val.length(); i = i + 1 {
            let (name, _types) = func.args[i]
            let val = xs_val[i]
            closure.set(name, Immutable(val))
          }
          self.values.push(closure)
          let result = self.visit(func.body)
          self.values.pop() |> ignore
          result
        }
        _ => Unit
      }
    }
    Var(name) => self.find(name)
    _ => Unit
  }
}
