// Assignment operations for ClosureInterpreter
// This file contains all assignment and augmented assignment operations

///|
/// 处理增强赋值操作
fn ClosureInterpreter::visit_augmented_assignment(
  self : ClosureInterpreter,
  op : String,
  lhs : @syntax.Expr,
  rhs : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let base_op = match op {
    "+=" => "+"
    "-=" => "-"
    "*=" => "*"
    "/=" => "/"
    "%=" => "%"
    _ => "+"
  }
  match lhs {
    Field(record~, accessor~, ..) =>
      self.visit_field_augmented_assignment(record, accessor, base_op, rhs)
    Ident(id={ name: var_name, .. }, ..) =>
      self.visit_variable_augmented_assignment(var_name, base_op, rhs)
    _ => Unit
  }
}

///|
/// 处理字段增强赋值
fn ClosureInterpreter::visit_field_augmented_assignment(
  self : ClosureInterpreter,
  record : @syntax.Expr,
  accessor : @syntax.Accessor,
  base_op : String,
  rhs : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let right_val = self.visit(rhs)
  match self.visit(record) {
    Object(refer) =>
      match accessor {
        Label(label) => {
          let current_val = refer.val
            .get(label.name)
            .unwrap_or(Int(0, raw=None))
          let new_val = runtime_value_infix(base_op, current_val, right_val)
          refer.val.set(label.name, new_val)
        }
        Index(tuple_index~, ..) => {
          let current_val = refer.val
            .get(tuple_index.to_string())
            .unwrap_or(Int(0, raw=None))
          let new_val = runtime_value_infix(base_op, current_val, right_val)
          refer.val.set(tuple_index.to_string(), new_val)
        }
        Newtype(_) => ()
      }
    _ => ()
  }
  Unit
}

///|
/// 处理变量增强赋值
fn ClosureInterpreter::visit_variable_augmented_assignment(
  self : ClosureInterpreter,
  var_name : @syntax.LongIdent,
  base_op : String,
  rhs : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let var_name_str = match var_name {
    Ident(name~) => name
    _ => "Any"
  }
  let current_val = self.with_ident(var_name, fn(pkg, name) {
    pkg.find(name).unwrap_or(Unit)
  })
  let right_val = self.visit(rhs)
  let new_val = runtime_value_infix(base_op, current_val, right_val)
  self.current_pkg.env.update(var_name_str, new_val)
  Unit
}

///|
/// 处理数组元素赋值
fn ClosureInterpreter::visit_array_set(
  self : ClosureInterpreter,
  array : @syntax.Expr,
  index : @syntax.Expr,
  value : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let array_value = self.visit(array)
  match array_value {
    Array(arr) => {
      let index = self.visit(index)
      match index {
        Int(index, ..) => {
          let value = self.visit(value)
          arr[index] = value
        }
        _ => ()
      }
    }
    Map(map) => {
      let index = self.visit(index)
      let value = self.visit(value)
      map.set(index, value)
    }
    Object({ ty, .. }) => {
      let index = self.visit(index)
      let value = self.visit(value)
      if ty.find_method("_[_]=_") is Some((pkg, func)) {
        if func is Fn({ val: func, .. }) {
          func({
            context: self,
            pkg,
            args: [
              RuntimeArgument::{ val: array_value, kind: Positional },
              RuntimeArgument::{ val: index, kind: Positional },
              RuntimeArgument::{ val: value, kind: Positional },
            ],
          })
          |> ignore
        }
      }
    }
    _ => raise Error("Unsupported array set operation")
  }
  Unit
}
