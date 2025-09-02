///|
/// 控制流处理 - For、While、Try、Guard、Defer等

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
        self.current_module.env.set(binder.name, init_value)
      }
    }
  }

  // 执行更新块的辅助函数
  let execute_continue_block = () => for update_tuple in continue_block {
    match update_tuple {
      (binder, update_expr) => {
        let new_value = self.visit(update_expr) catch { _ => Unit }
        self.current_module.env.update(binder.name, new_value)
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
    if not(should_continue) {
      break
    }

    // 执行循环体，处理break和continue
    (self.visit_scoped(body, RuntimeLocation::ControlFlow("for")) catch {
      Break(value) => return value
      Continue(arr) => {
        if !arr.is_empty() {
          binders.eachi(fn(i, binder) {
            self.current_module.env.update(binder.0.name, arr[i])
          })
        } else {
          execute_continue_block()
        }
        continue
      }
      _ => Unit
    })
    |> ignore
    execute_continue_block()
  }
  if for_else is Some(expr) {
    self.visit_scoped(expr, RuntimeLocation::ControlFlow("for else")) catch {
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
    (self.visit_scoped(loop_body, RuntimeLocation::ControlFlow("while")) catch {
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
  if not(broke) {
    match while_else {
      Some(else_expr) =>
        result = self.visit_scoped(
          else_expr,
          RuntimeLocation::ControlFlow("while"),
        )
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
    Bool(true) => self.visit_scoped(body, RuntimeLocation::ControlFlow("guard"))
    Bool(false) =>
      match otherwise {
        Some(expr) =>
          self.visit_scoped(expr, RuntimeLocation::ControlFlow("guard else"))
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
