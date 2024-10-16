struct ClosureInterpreter {
  extern_fns : Map[String, (Array[Value]) -> Value]
  values : Array[Map[String, Value]]
}

pub typealias InterpreterLocalVars = @immut/hashmap.T[@types.Name, Value]

// struct Func {
//   name : String
//   args : Array[String]
//   body : @types.Syntax
// } derive(Show, ToJson)

pub enum Value {
  Unit
  Int(Int)
  Bool(Bool)
  Double(Double)
  String(String)
  Tuple(Array[Value])
  Array(Array[Value])
  ExternFn(String)
  Closure(@types.Fundef, Array[Value])
} derive(Show, ToJson)

pub fn Value::op_equal(self : Value, other : Value) -> Bool {
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

pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  { extern_fns: Map::new(), values: [{}] }
}

pub fn ClosureInterpreter::add_extern_fn(
  self : ClosureInterpreter,
  name : String,
  f : (Array[Value]) -> Value
) -> Unit {
  self.extern_fns.set(name, f)
}

fn ClosureInterpreter::find(self : ClosureInterpreter, name : String) -> Value {
  // println("find: \{name}")
  for value in self.extern_fns.keys() {
    if value == name {
      // println("found extern fn: \{name}")
      return ExternFn(name)
    }
  }
  for value in self.values.rev() {
    match value[name] {
      Some(value) =>
        // println("found value: \{name}")
        return value
      None => continue
    }
  }
  Unit
}

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
    Let((name, _types), value, _return_type) => {
      let value_val = self.visit(value)
      self.values[0][name] = value_val
      Unit
    }
    Prim(lhs, rhs, op, ..) => {
      let result = self.visit(lhs)
      let y = self.visit(rhs)
      // println("result: \{result}")
      // println("y: \{y}")
      // println("op: \{op}")
      match result {
        Int(x) =>
          match y {
            Int(y) =>
              match op {
                Add => Int(x + y)
                Sub => Int(x - y)
                Mul => Int(x * y)
                Div => Int(x / y)
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
              }
            _ => Unit
          }
        _ => Unit
      }
    }
    App(f, xs) => {
      let f_val = self.visit(f)
      let xs_val = xs.map(fn(x) { self.visit(x) })
      match f_val {
        ExternFn(name) => {
          let f = self.extern_fns.get(name).unwrap()
          f(xs_val)
        }
        // Closure(func, env) => {
        //   let new_env = [env, xs_val]
        //   let new_interpreter =  {
        //     extern_fns: self.extern_fns,
        //     values: [{}]
        //   }
        //   new_interpreter.visit(func)
        // }
        _ => Unit
      }
    }
    Var(name) => self.find(name)
    _ => Unit
  }
}
