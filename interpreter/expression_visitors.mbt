// Expression visitor methods for ClosureInterpreter
// This file contains all the specialized visit methods for different expression types

///|
/// 处理中缀表达式
fn ClosureInterpreter::visit_infix_expression(
  self : ClosureInterpreter,
  op : @syntax.LongIdent,
  lhs : @syntax.Expr,
  rhs : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  match op {
    Ident(name~) =>
      // 检查是否为增强赋值操作符
      match name {
        "+=" | "-=" | "*=" | "/=" | "%=" =>
          self.visit_augmented_assignment(name, lhs, rhs)
        "||" => self.visit_logical_or(lhs, rhs)
        "&&" => self.visit_logical_and(lhs, rhs)
        _ => {
          // 普通中缀表达式
          let left_val = self.visit(lhs)
          let right_val = self.visit(rhs)
          runtime_value_infix(name, left_val, right_val)
        }
      }
    _ => Unit
  }
}

///|
/// 处理一元表达式
fn ClosureInterpreter::visit_unary_expression(
  self : ClosureInterpreter,
  op : @syntax.LongIdent,
  expr : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  match op {
    Ident(name~) => {
      let val = self.visit(expr)
      match (name, val) {
        ("!", Bool(value)) => Bool(!value)
        ("-", Int(value, ..)) => Int(-value, raw=None)
        ("-", Double(value)) => Double(-value)
        _ => Unit
      }
    }
    _ => Unit
  }
}

///|
/// 处理记录创建
fn ClosureInterpreter::visit_record_creation(
  self : ClosureInterpreter,
  type_name : @syntax.TypeName?,
  fields : @list.List[@syntax.FieldDef],
) -> RuntimeValue raise ControlFlow {
  let evaluated_fields = Map::new()
  for field in fields {
    let field_value = self.visit(field.expr)
    evaluated_fields.set(field.label.name, field_value)
  }
  fn alloc(pkg : RuntimePackage, name : String) -> RuntimeValue {
    Object({ val: evaluated_fields, ty: Object(pkg~, name~) })
  }

  if type_name is Some(type_name) {
    self.with_ident(type_name.name, (pkg, name) => alloc(pkg, name))
  } else {
    let field_names = []
    for field in fields {
      field_names.push(field.label.name)
    }
    let type_name = self.current_pkg.infer_struct_type_from_fields(field_names)
    alloc(self.current_pkg, type_name)
  }
}

///|
/// 处理数组展开表达式
fn ClosureInterpreter::visit_array_spread(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.SpreadableElem],
) -> RuntimeValue raise ControlFlow {
  let result_values = []
  for elem in elems {
    match elem {
      Regular(expr) => result_values.push(self.visit(expr))
      Spread(expr~, ..) => {
        let spread_value = self.visit(expr)
        match spread_value {
          Array(arr) =>
            for val in arr {
              result_values.push(val)
            }
          _ => result_values.push(spread_value)
        }
      }
    }
  }
  Array(result_values)
}

///|
/// 处理元组表达式
fn ClosureInterpreter::visit_tuple(
  self : ClosureInterpreter,
  exprs : @list.List[@syntax.Expr],
) -> RuntimeValue raise ControlFlow {
  let evaluated_values = exprs.map(expr => self.visit(expr)).to_array()
  Tuple(evaluated_values)
}

///|
/// 处理数组表达式
fn ClosureInterpreter::visit_array(
  self : ClosureInterpreter,
  exprs : @list.List[@syntax.Expr],
) -> RuntimeValue raise ControlFlow {
  let result_values = []
  for expr in exprs {
    match expr {
      // 处理数组展开语法 ..arr
      Unary(op~, expr~, ..) =>
        match op.name {
          Ident(name~) =>
            if name == ".." {
              let inner_value = self.visit(expr)
              match inner_value {
                Array(arr) =>
                  for val in arr {
                    result_values.push(val)
                  }
                _ => result_values.push(inner_value)
              }
            } else {
              result_values.push(self.visit(expr))
            }
          _ => result_values.push(self.visit(expr))
        }
      _ => result_values.push(self.visit(expr))
    }
  }
  let final_array = Array::new()
  for val in result_values {
    final_array.push(val)
  }
  Array(final_array)
}

///|
/// 处理函数调用
fn ClosureInterpreter::visit_apply(
  self : ClosureInterpreter,
  func : @syntax.Expr,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  try {
    match func {
      Ident(id={ name, .. }, ..) => self.call_by_name(name, args)
      // 处理构造函数调用，如 Some(5)
      Constr(constr~, ..) => {
        let fields = args
          .map(arg => {
            match arg.kind {
              Positional =>
                ConstructorField::{
                  name: None,
                  value: self.visit(arg.value),
                  mutable: false,
                }
              Labelled(label)
              | LabelledPun(label)
              | LabelledOption(label~, ..)
              | LabelledOptionPun(label~, ..) =>
                ConstructorField::{
                  name: Some(label.name),
                  value: self.visit(arg.value),
                  mutable: false,
                }
            }
          })
          .to_array()
        let constr_name = constr.name.name
        Constructor({
          val: { name: constr_name, fields },
          ty: self.current_pkg.find_static_type(constr_name),
        })
      }
      // 处理静态方法调用，如 Bool::default()
      Method(type_name~, method_name~, ..) =>
        self.with_ident(type_name.name, (pkg, name) => {
          self.execute_static_method_call(
            pkg.find_static_type(name),
            method_name.name,
            args,
          )
        })
      // 处理其他表达式作为函数的情况，如 a[1](10)
      _ => {
        let func_value = self.visit(func)
        match func_value {
          Fn(function) =>
            self.call(
              function.val,
              self.current_pkg,
              self.convert_to_runtime_arguments(args),
            )
          _ => Unit
        }
      }
    }
  } catch {
    Return(v) => v
    e => raise e
  }
}

///|
/// 处理 if 表达式
fn ClosureInterpreter::visit_if(
  self : ClosureInterpreter,
  cond : @syntax.Expr,
  ifso : @syntax.Expr,
  ifnot : @syntax.Expr?,
) -> RuntimeValue raise ControlFlow {
  let cond_val = self.visit(cond)
  match (cond_val, ifnot) {
    (Bool(true), _) =>
      self.visit_scoped(ifso, RuntimeLocation::ControlFlow("if"))
    (Bool(false), Some(else_expr)) =>
      self.visit_scoped(else_expr, RuntimeLocation::ControlFlow("else"))
    _ => Unit
  }
}

///|
/// 处理字段访问
fn ClosureInterpreter::visit_field(
  self : ClosureInterpreter,
  record : @syntax.Expr,
  accessor : @syntax.Accessor,
) -> RuntimeValue raise ControlFlow {
  let record_val = self.visit(record)
  match (record_val, accessor) {
    (Object({ val: fields, .. }), Label(label)) =>
      match fields.get(label.name) {
        Some(field_value) => field_value
        None => self.error("Field: not found")
      }
    (Tuple(values), Index(tuple_index~, ..)) => values[tuple_index]
    (Array(values), Index(tuple_index~, ..)) => values[tuple_index]
    (Constructor(refer), Label(label)) => {
      // 构造函数字段访问处理
      let field_name = label.name

      // 按名称查找字段
      for i = 0; i < refer.val.fields.length(); i = i + 1 {
        let field = refer.val.fields[i]
        if field.name == Some(field_name) {
          break field.value
        }
      } nobreak {
        self.error(
          "Field: " + field_name + " not found in constructor " + refer.val.name,
        )
      }
    }
    (Map(fields), Label(label)) =>
      match fields.get(String(label.name)) {
        Some(field_value) => field_value
        None => self.error("Field: not found")
      }
    // (Object({ty,..}),_)=>{
    //   if ty.find_method("_[_]") is Some((pkg, func)) {
    //     if func is Fn({ val: func, .. }) {
    //       func({
    //         context: self,
    //         pkg,
    //         args: [
    //           RuntimeArgument::{ val: record_val, kind: Positional },
    //           RuntimeArgument::{ val: accessor, kind: Positional },
    //         ],
    //       })
    //     } else {
    //       self.error("Field accessor: not implemented")
    //     }
    //   } else {
    //     self.error("Field accessor: not implemented")
    //   }
    // }
    _ => self.error("Field accessor: not implemented")
  }
}

///|
/// 处理逻辑或操作
fn ClosureInterpreter::visit_logical_or(
  self : ClosureInterpreter,
  lhs : @syntax.Expr,
  rhs : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let left_val = self.visit(lhs)
  if left_val is Bool(true) {
    left_val
  } else {
    self.visit(rhs)
  }
}

///|
/// 处理逻辑与操作
fn ClosureInterpreter::visit_logical_and(
  self : ClosureInterpreter,
  lhs : @syntax.Expr,
  rhs : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let left_val = self.visit(lhs)
  if left_val is Bool(false) {
    left_val
  } else {
    self.visit(rhs)
  }
}
