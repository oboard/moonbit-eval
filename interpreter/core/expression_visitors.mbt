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
  let evaluated_fields = {}
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
/// 处理重载为 Iter 的数组插值表达式
fn ClosureInterpreter::visit_array_spread_as_iter(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.SpreadableElem],
) -> RuntimeValue raise ControlFlow {
  let iters = []
  for elem in elems {
    match elem {
      Regular(expr) => {
        let value = self.visit(expr)
        iters.push(Iter::singleton(value))
      }
      Spread(expr~, ..) => {
        let spread_value = self.visit(expr)
        iters.push(runtime_value_to_iter(spread_value))
      }
    }
  }
  Iter(iters.iter().flat_map(iter => iter))
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
fn ClosureInterpreter::syntax_iterable_to_iter(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
) -> Iter[RuntimeValue] raise ControlFlow {
  match expr {
    Infix(op~, lhs~, rhs~, ..) =>
      match op.name {
        Ident(name="..<") => {
          let start_val = self.visit(lhs)
          let end_val = self.visit(rhs)
          match (start_val, end_val) {
            (Int(start, ..), Int(end, ..)) =>
              start.until(end).map(fn(i) { Int(i, raw=None) })
            _ => Iter::empty()
          }
        }
        Ident(name="..=") => {
          let start_val = self.visit(lhs)
          let end_val = self.visit(rhs)
          match (start_val, end_val) {
            (Int(start, ..), Int(end, ..)) =>
              start.until(end, inclusive=true).map(fn(i) { Int(i, raw=None) })
            _ => Iter::empty()
          }
        }
        _ => self.visit_iterable_expr(expr)
      }
    _ => self.visit_iterable_expr(expr)
  }
}

///|
fn ClosureInterpreter::visit_iterable_expr(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
) -> Iter[RuntimeValue] raise ControlFlow {
  match self.visit(expr) {
    Iter(iter) => iter
    value =>
      match self.method_call(value, "iter", @list.new()) {
        Iter(iter) => iter
        _ => self.error("iter method not found")
      }
  }
}

///|
fn is_iter_expected_type(expected_type : String?) -> Bool {
  match expected_type {
    Some(ty) => ty == "Iter" || ty.has_prefix("Iter[")
    None => false
  }
}

///|
fn ClosureInterpreter::bind_for_each_value(
  self : ClosureInterpreter,
  binders : @list.List[@syntax.Binder?],
  value : RuntimeValue,
) -> Unit {
  let binder_count = binders.length()
  match binders {
    @list.More(Some(binder), tail=@list.Empty) =>
      self.current_pkg.env.set(binder.name, value)
    @list.More(Some(binder1), tail=@list.More(Some(binder2), tail=@list.Empty)) =>
      match value {
        Tuple([first, second]) => {
          self.current_pkg.env.set(binder1.name, first)
          self.current_pkg.env.set(binder2.name, second)
        }
        _ => ()
      }
    _ => if binder_count == 0 { () }
  }
}

///|
fn ClosureInterpreter::visit_for_each_as_array(
  self : ClosureInterpreter,
  binders : @list.List[@syntax.Binder?],
  expr : @syntax.Expr,
  body : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let result : Array[RuntimeValue] = []
  for value in self.syntax_iterable_to_iter(expr) {
    self.push_scope(RuntimeLocation::ControlFlow("list comprehension"))
    defer self.pop_scope()
    self.bind_for_each_value(binders, value)
    let value = self.visit(body) catch {
      Continue(_) => continue
      e => raise e
    }
    result.push(value)
  }
  Array(result)
}

///|
fn ClosureInterpreter::visit_for_each_as_iter(
  self : ClosureInterpreter,
  binders : @list.List[@syntax.Binder?],
  expr : @syntax.Expr,
  body : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let source_iter = self.syntax_iterable_to_iter(expr)
  Iter(
    Iter::new(fn() -> RuntimeValue? {
      while source_iter.next() is Some(value) {
        self.push_scope(RuntimeLocation::ControlFlow("list comprehension"))
        self.bind_for_each_value(binders, value)
        let result = self.visit(body) catch {
          Continue(_) => {
            self.pop_scope()
            continue
          }
          _ => {
            self.pop_scope()
            return None
          }
        }
        self.pop_scope()
        return Some(result)
      }
      None
    }),
  )
}

///|
fn ClosureInterpreter::init_for_loop_scope(
  self : ClosureInterpreter,
  binders : @list.List[(@syntax.Binder, @syntax.Expr)],
) -> Unit raise ControlFlow {
  for binder_init in binders {
    let (binder, init_expr) = binder_init
    let init_value = self.visit(init_expr)
    self.current_pkg.env.set(binder.name, init_value)
  }
}

///|
fn ClosureInterpreter::for_condition_holds(
  self : ClosureInterpreter,
  condition : @syntax.Expr?,
) -> Bool raise ControlFlow {
  match condition {
    Some(cond) =>
      match self.visit(cond) {
        Bool(value) => value
        _ => false
      }
    None => true
  }
}

///|
fn ClosureInterpreter::visit_for_as_array(
  self : ClosureInterpreter,
  binders : @list.List[(@syntax.Binder, @syntax.Expr)],
  condition : @syntax.Expr?,
  continue_block : @list.List[(@syntax.Binder, @syntax.Expr)],
  body : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let result : Array[RuntimeValue] = []
  self.push_scope(RuntimeLocation::ControlFlow("list comprehension"))
  defer self.pop_scope()
  self.init_for_loop_scope(binders)
  while self.for_condition_holds(condition) {
    let value = self.visit_scoped(
      body,
      RuntimeLocation::ControlFlow("list comprehension"),
    ) catch {
      Continue(_) => {
        self.execute_for_continue_block(continue_block)
        continue
      }
      e => raise e
    }
    result.push(value)
    self.execute_for_continue_block(continue_block)
  }
  Array(result)
}

///|
fn ClosureInterpreter::visit_for_as_iter(
  self : ClosureInterpreter,
  binders : @list.List[(@syntax.Binder, @syntax.Expr)],
  condition : @syntax.Expr?,
  continue_block : @list.List[(@syntax.Binder, @syntax.Expr)],
  body : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let parent_env = self.current_pkg.env
  let loop_env = RuntimeEnvironment::new(parent=parent_env)
  self.current_pkg.env = loop_env
  self.init_for_loop_scope(binders) catch {
    e => {
      self.current_pkg.env = parent_env
      raise e
    }
  }
  self.current_pkg.env = parent_env
  Iter(
    Iter::new(fn() -> RuntimeValue? {
      let previous_env = self.current_pkg.env
      self.current_pkg.env = loop_env
      defer {
        self.current_pkg.env = previous_env
      }
      while true {
        let should_continue = self.for_condition_holds(condition) catch {
          _ => false
        }
        if !should_continue {
          break
        }
        let value = self.visit_scoped(
          body,
          RuntimeLocation::ControlFlow("list comprehension"),
        ) catch {
          Continue(_) => {
            self.execute_for_continue_block(continue_block)
            continue
          }
          _ => return None
        }
        self.execute_for_continue_block(continue_block)
        return Some(value)
      }
      None
    }),
  )
}

///|
/// 处理数组表达式
fn ClosureInterpreter::visit_array(
  self : ClosureInterpreter,
  exprs : @list.List[@syntax.Expr],
  expected_type : String?,
) -> RuntimeValue raise ControlFlow {
  match exprs {
    @list.More(ForEach(binders~, expr~, body~, ..), tail=@list.Empty) =>
      if is_iter_expected_type(expected_type) {
        return self.visit_for_each_as_iter(binders, expr, body)
      } else {
        return self.visit_for_each_as_array(binders, expr, body)
      }
    @list.More(
      For(binders~, condition~, continue_block~, body~, ..),
      tail=@list.Empty
    ) =>
      if is_iter_expected_type(expected_type) {
        return self.visit_for_as_iter(binders, condition, continue_block, body)
      } else {
        return self.visit_for_as_array(binders, condition, continue_block, body)
      }
    _ => ()
  }
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
fn ClosureInterpreter::call_struct_constr(
  self : ClosureInterpreter,
  pkg_name : String?,
  type_name : String,
  field_values : @list.List[@syntax.Argument],
) -> RuntimeValue? raise ControlFlow {
  let pkg = match pkg_name {
    Some(name) => self.find_pkg(name)
    None => self.current_pkg
  }
  let ty = pkg.find_static_type(type_name)
  if pkg.struct_constrs.get(type_name) is Some(constr_name) {
    self.execute_static_method_call(ty, constr_name, field_values) |> Some
  } else {
    None
  }
}

///|
fn ClosureInterpreter::call_struct_constr_with_type_name(
  self : ClosureInterpreter,
  type_name : @syntax.TypeName,
  constr_name : String,
  field_values : @list.List[@syntax.Argument],
) -> RuntimeValue? raise ControlFlow {
  self.with_ident(type_name.name, (pkg, name) => {
    let ty = pkg.find_static_type(name)
    if pkg.struct_constrs.get(name) is Some(method_name) {
      let method_name = if constr_name == "" {
        method_name
      } else {
        constr_name
      }
      Some(self.execute_static_method_call(ty, method_name, field_values))
    } else {
      None
    }
  })
}

///|
fn ClosureInterpreter::constructor_runtime_package(
  self : ClosureInterpreter,
  constr : @syntax.Constructor,
) -> RuntimePackage {
  match constr.extra_info {
    Package(pkg_name) => self.find_pkg(pkg_name)
    TypeName(type_name) => self.with_ident(type_name.name, (pkg, _) => pkg)
    NoExtraInfo => self.current_pkg
  }
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
        match constr.extra_info {
          TypeName(type_name) =>
            if self.call_struct_constr_with_type_name(
                type_name,
                constr.name.name,
                args,
              )
              is Some(result) {
              return result
            }
          Package(pkg_name) if self.call_struct_constr(
              Some(pkg_name),
              constr.name.name,
              args,
            )
            is Some(result) => return result
          NoExtraInfo if self.call_struct_constr(None, constr.name.name, args)
            is Some(result) => return result
          _ => ()
        }
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
        let pkg = self.constructor_runtime_package(constr)
        Constructor({
          val: { name: constr_name, fields },
          ty: pkg.find_static_type(constr_name),
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
