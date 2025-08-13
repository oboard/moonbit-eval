///|
struct ClosureInterpreter {
  extern_fns : Map[String, (Array[Value]) -> Value]
  values : Array[Map[String, Variable]]
}

///|
priv enum Variable {
  Immutable(Value)
  Mutable(Value)
}

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
  FunctionType(String)
}

///|
pub impl Show for Value with output(self : Value, logger : &Logger) -> Unit {
  match self {
    Unit => logger.write_string("Unit")
    Int(i) => {
      logger.write_string("Int(")
      logger.write_string(i.to_string())
      logger.write_string(")")
    }
    Bool(b) => {
      logger.write_string("Bool(")
      logger.write_string(b.to_string())
      logger.write_string(")")
    }
    Double(d) => {
      logger.write_string("Double(")
      logger.write_string(d.to_string())
      logger.write_string(")")
    }
    String(s) => {
      logger.write_string("String(")
      logger.write_string("\"")
      logger.write_string(s)
      logger.write_string("\"")
      logger.write_string(")")
    }
    Tuple(arr) => {
      logger.write_string("Tuple(")
      arr.output(logger)
      logger.write_string(")")
    }
    Array(arr) => {
      logger.write_string("Array(")
      arr.output(logger)
      logger.write_string(")")
    }
    ExternFn(name) => {
      logger.write_string("ExternFn(")
      logger.write_string("\"")
      logger.write_string(name)
      logger.write_string("\"")
      logger.write_string(")")
    }
    Closure(_, _) => logger.write_string("Closure(...)")
    FunctionType(type_str) => logger.write_string(type_str)
  }
}

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
    (FunctionType(x), FunctionType(y)) => x == y
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
  f : (Array[Value]) -> Value,
) -> Unit {
  self.extern_fns.set(name, f)
}

///|
fn type_to_string(t : @types.Type) -> String {
  match t {
    @types.Type::Unit => "Unit"
    @types.Type::Bool => "Bool"
    @types.Type::Int => "Int"
    @types.Type::Double => "Double"
    @types.Type::String => "String"
    @types.Type::Fun(args, ret) => {
      let arg_strs = args.map(type_to_string)
      let arg_str = if arg_strs.length() == 0 {
        ""
      } else {
        arg_strs.join(", ")
      }
      "(" + arg_str + ") -> " + type_to_string(ret)
    }
    @types.Type::Tuple(types) => {
      let type_strs = types.map(type_to_string)
      "(" + type_strs.join(", ") + ")"
    }
    @types.Type::Array(t) => "Array[" + type_to_string(t) + "]"
    @types.Type::Var(_) => "_"
    @types.Type::Ptr => "Ptr"
  }
}

///|
fn ClosureInterpreter::find(self : ClosureInterpreter, name : String) -> Value {
  for value in self.extern_fns.keys() {
    if value == name {
      return ExternFn(name)
    }
  }
  for value in self.values.rev() {
    match value.get(name) {
      Some(variable) =>
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
  node : @types.Syntax,
) -> Value {
  match node {
    Int(i) => Int(i)
    Double(d) => Double(d)
    String(s) => String(s)
    TemplateString(parts) => {
      let mut result = ""
      for part in parts {
        match part {
          (text, None) => result += text
          (text, Some(expr)) => {
            let value = self.visit(expr)
            let expr_str = match value {
              String(s) => s
              Int(i) => i.to_string()
              Bool(b) => b.to_string()
              Double(d) => d.to_string()
              Unit => "()"
              _ => "[object]"
            }
            result += text + expr_str
          }
        }
      }
      String(result)
    }
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
    LetRec({ name, args, body }, _next) => {
      let (funcName, return_type) = name
      self.values
      .last()
      .unwrap()
      .set(funcName, Immutable(Closure({ name, args, body }, [])))
      // Create function type representation
      let arg_types = args.map(fn(arg) {
        let (_, t) = arg
        t
      })
      // If return_type is a type variable, try to infer it from the function body
      let inferred_return_type = match return_type {
        @types.Type::Var(_) => {
          // Try to infer the return type by evaluating the body
          let body_result = self.visit(body)
          match body_result {
            Int(_) => @types.Type::Int
            Bool(_) => @types.Type::Bool
            Double(_) => @types.Type::Double
            String(_) => @types.Type::String
            Unit => @types.Type::Unit
            _ => return_type // fallback to original type
          }
        }
        _ => return_type
      }
      let func_type = @types.Type::Fun(arg_types, inferred_return_type)
      FunctionType(type_to_string(func_type))
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
      }
      Unit
    }
    While(condition, statements) => {
      while self.visit(condition) is Bool(true) {
        self.visit(statements) |> ignore
      }
      Unit
    }
    Lambda(param_name, body) => {
      // 创建一个匿名函数定义
      let fundef : @types.Fundef = {
        name: ("", @types.Type::Var({ val: None })), // 匿名函数，类型待推导
        args: [(param_name, @types.Type::Var({ val: None }))], // 参数类型待推导
        body,
      }
      Closure(fundef, [])
    }
    Assign(name, value) => {
      let value_val = self.visit(value)
      for value in self.values.rev() {
        match value.get(name) {
          Some(variable) =>
            match variable {
              Mutable(_) => {
                value[name] = Mutable(value_val)
                return Unit
              }
              _ => continue
            }
          None => {
            value[name] = Mutable(value_val)
            return Unit
          }
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
