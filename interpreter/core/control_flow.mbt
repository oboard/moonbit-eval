///|
/// 控制流处理 - For、While、Try、Guard、Defer等

///|
fn ClosureInterpreter::execute_for_continue_block(
  self : ClosureInterpreter,
  continue_block : @list.List[(@syntax.Binder, @syntax.Expr)],
) -> Unit {
  let updates : Array[(String, RuntimeValue)] = []
  for update_tuple in continue_block {
    let (binder, update_expr) = update_tuple
    let new_value = self.visit(update_expr) catch { _ => Unit }
    updates.push((binder.name, new_value))
  }
  for update in updates {
    self.current_pkg.env.update(update.0, update.1)
  }
}

///|
/// 处理 For 循环
fn ClosureInterpreter::visit_for(
  self : ClosureInterpreter,
  binders : @list.List[(@syntax.Binder, @syntax.Expr)],
  condition : @syntax.Expr?,
  continue_block : @list.List[(@syntax.Binder, @syntax.Expr)],
  body : @syntax.Expr,
  for_else : @syntax.Expr?,
) -> RuntimeValue raise ControlFlow {
  // 初始化循环变量
  for binder_init in binders {
    match binder_init {
      (binder, init_expr) => {
        let init_value = self.visit(init_expr)
        self.current_pkg.env.set(binder.name, init_value)
      }
    }
  }

  // 执行循环
  while true {
    // 检查循环条件
    let should_continue = match condition {
      Some(cond) => {
        let condition_result = self.visit(cond) catch { _ => Unit }
        match condition_result {
          Bool(value) => value
          _ => false
        }
      }
      None => true
    }
    if !should_continue {
      break
    }

    // 执行循环体，处理break和continue
    (self.visit_scoped(body, ControlFlow("for")) catch {
      Break(value) => return value
      Continue(arr) => {
        if !arr.is_empty() {
          binders.eachi(fn(i, binder) {
            self.current_pkg.env.update(binder.0.name, arr[i])
          })
        } else {
          self.execute_for_continue_block(continue_block)
        }
        continue
      }
      _ => Unit
    })
    |> ignore
    self.execute_for_continue_block(continue_block)
  }
  if for_else is Some(expr) {
    self.visit_scoped(expr, ControlFlow("for else")) catch {
      _ => Unit
    }
  } else {
    Unit
  }
}

///|
/// 处理 While 循环
fn ClosureInterpreter::visit_while(
  self : ClosureInterpreter,
  loop_cond : @syntax.Expr,
  loop_body : @syntax.Expr,
  while_else : @syntax.Expr?,
) -> RuntimeValue raise ControlFlow {
  let mut result = Unit
  let mut broke = false
  while true {
    let cond_result = self.visit(loop_cond)
    match cond_result {
      Bool(false) => break
      _ => ()
    }

    // 执行循环体，处理break和continue
    (self.visit_scoped(loop_body, ControlFlow("while")) catch {
      Break(value) => {
        result = value
        broke = true
        break
      }
      Continue(_) => continue
      e => raise e
    })
    |> ignore
  }
  // 如果没有break，执行else分支
  if !broke {
    match while_else {
      Some(else_expr) =>
        result = self.visit_scoped(else_expr, ControlFlow("while"))
      None => () // 没有else分支
    }
  }
  result
}

///|
/// 处理 Guard 表达式
fn ClosureInterpreter::visit_guard(
  self : ClosureInterpreter,
  cond : @syntax.Expr,
  otherwise : @syntax.Expr?,
  body : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let cond_val = self.visit(cond)
  match cond_val {
    Bool(true) => self.visit_scoped(body, ControlFlow("guard"))
    Bool(false) =>
      match otherwise {
        Some(expr) => self.visit_scoped(expr, ControlFlow("guard else"))
        None => Unit
      }
    _ => Unit
  }
}

///|
/// 处理 Defer 表达式
fn ClosureInterpreter::visit_defer(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
  body : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  let res = self.visit(body)
  self.visit(expr) |> ignore
  res
}

///|
/// 处理 Try 表达式
fn ClosureInterpreter::visit_try(
  self : ClosureInterpreter,
  body : @syntax.Expr,
  catch_ : @list.List[@syntax.Case],
) -> RuntimeValue raise ControlFlow {
  self.visit(body) catch {
    Raise(value) => self.pattern_match(value, catch_)
    e => raise e
  }
}
