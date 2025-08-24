///| 函数管理模块

///| 调用闭包函数，恢复捕获的环境
pub fn ClosureInterpreter::call_closure(
  self : ClosureInterpreter,
  function : @syntax.Func,
  mod : RuntimeModule,
  env : RuntimeEnvironment,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 在旧环境中解释参数值
      let arg_values = self.evaluate_arguments(args)

      // 切换到闭包捕获的环境
      let old_mod = self.current_module
      let old_env = mod.env
      self.current_module = mod
      self.current_module.env = env
      self.push_scope()
      // 在新环境中绑定已解释的参数值
      self.bind_evaluated_parameters(parameters, arg_values)
      // 执行函数体
      let result = self.visit(body)
      self.pop_scope()
      // 恢复原环境
      self.current_module.env = old_env
      self.current_module = old_mod
      result
    }
    _ => RuntimeValue::Unit
  }
}

///| 处理函数定义、调用和参数绑定

///| 绑定函数参数到作用域

///| 递归处理多个参数，将参数值绑定到函数作用域中

///| 支持所有参数类型：位置参数、标签参数、可选参数、问号可选参数、丢弃参数
pub fn ClosureInterpreter::bind_function_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  args : @list.List[@syntax.Argument],
) -> Unit raise ControlFlow {
  let env = self.current_module.env
  match (params, args) {
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      let runtime_value = self.visit(arg.value)
      match param {
        // 位置参数：直接绑定参数值
        Positional(binder={ name, .. }, ..) => env.set(name, runtime_value)
        // 标签参数：绑定带标签的参数值
        Labelled(binder={ name, .. }, ..) => env.set(name, runtime_value)
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        Optional(binder={ name, .. }, ..) => env.set(name, runtime_value)
        // 问号可选参数：绑定参数值
        QuestionOptional(binder={ name, .. }, ..) =>
          env.set(name, runtime_value)
        // 丢弃位置参数：不绑定到任何变量，直接跳过
        DiscardPositional(..) =>
          // 丢弃参数不需要绑定，但仍需要求值以保持副作用
          self.visit(arg.value) |> ignore
      }
      self.bind_function_parameters(rest_params, rest_args)
    }
    // 处理可选参数的默认值情况
    (@list.More(param, tail=rest_params), @list.Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        Optional(binder={ name, .. }, default~, ..) => {
          let runtime_value = self.visit(default)
          env.set(name, runtime_value)
          self.bind_function_parameters(rest_params, @list.new())
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        QuestionOptional(..) =>
          self.bind_function_parameters(rest_params, @list.new())
        _ => ()
      }
    (@list.Empty, @list.Empty) => ()
    _ => ()
  }
}

///|
pub fn ClosureInterpreter::bind_function_parameters_runtime(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  args : @list.List[@syntax.Argument],
) -> Unit raise ControlFlow {
  match (params, args) {
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      let arg_value = self.visit(arg.value)
      match param {
        // 位置参数：直接绑定参数值
        Positional(binder={ name, .. }, ..) =>
          self.main.env.set(name, arg_value)
        // 标签参数：绑定带标签的参数值
        Labelled(binder={ name, .. }, ..) => self.main.env.set(name, arg_value)
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        Optional(binder={ name, .. }, ..) => self.main.env.set(name, arg_value)
        // 问号可选参数：绑定参数值
        QuestionOptional(binder={ name, .. }, ..) =>
          self.main.env.set(name, arg_value)
        // 丢弃位置参数：不绑定到任何变量，直接跳过
        DiscardPositional(..) =>
          // 丢弃参数不需要绑定，但仍需要求值以保持副作用
          self.visit(arg.value) |> ignore
      }
      self.bind_function_parameters_runtime(rest_params, rest_args)
    }
    // 处理可选参数的默认值情况
    (@list.More(param, tail=rest_params), @list.Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        Optional(binder={ name, .. }, default~, ..) => {
          let default_value = self.visit(default)
          self.main.env.set(name, default_value)
          self.bind_function_parameters_runtime(rest_params, @list.new())
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        QuestionOptional(..) =>
          self.bind_function_parameters_runtime(rest_params, @list.new())
        _ => ()
      }
    (@list.Empty, @list.Empty) => ()
    _ => ()
  }
}

///| 执行函数调用
pub fn ClosureInterpreter::call(
  self : ClosureInterpreter,
  function : @syntax.Func,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 创建新的作用域
      self.push_scope()

      // 绑定参数
      self.bind_function_parameters_runtime(parameters, args)
      // 执行函数体
      let result = self.visit(body) catch {
        Return(v) => v
        e => raise e
      }

      // 恢复作用域
      self.pop_scope()
      result
    }
    _ =>
      // 返回Unit作为默认值
      RuntimeValue::Unit
  }
}

///| 处理函数定义

///|
pub fn RuntimeEnvironment::define_struct_method(
  self : RuntimeEnvironment,
  type_name : String,
  method_name : String,
  func : @syntax.Func,
) -> Unit {
  if !self.struct_methods.contains(type_name) {
    self.struct_methods.set(type_name, Map::new())
  }
  self.struct_methods
  .get(type_name)
  .unwrap()
  .set(method_name, RuntimeValue::Closure(func, self))
}

///| 递归收集表达式中的自由变量
fn ClosureInterpreter::collect_free_variables(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
  bound_vars : Map[String, Unit],
  free_vars : Map[String, Unit],
) -> Unit {
  match expr {
    Ident(id={ name: Ident(name~), .. }, ..) =>
      // 如果变量未绑定且不在当前环境中，则为自由变量
      if not(bound_vars.contains(name)) &&
        not(self.main.env.values.contains(name)) {
        free_vars.set(name, ())
      }
    Apply(func~, args~, ..) => {
      self.collect_free_variables(func, bound_vars, free_vars)
      for arg in args {
        self.collect_free_variables(arg.value, bound_vars, free_vars)
      }
    }
    Let(pattern~, expr~, body~, ..) => {
      // 先处理绑定表达式
      self.collect_free_variables(expr, bound_vars, free_vars)
      // 提取模式中绑定的变量
      let new_bound_vars = bound_vars.copy()
      extract_pattern_variables(pattern, new_bound_vars)
      // 处理let体
      self.collect_free_variables(body, new_bound_vars, free_vars)
    }
    Function(func~, ..) =>
      // Function表达式包含Lambda
      match func {
        @syntax.Func::Lambda(parameters~, body~, ..) => {
          // Lambda引入新的绑定变量
          let new_bound_vars = bound_vars.copy()
          for param in parameters {
            match param {
              Positional(binder={ name, .. }, ..)
              | Labelled(binder={ name, .. }, ..)
              | Optional(binder={ name, .. }, ..)
              | QuestionOptional(binder={ name, .. }, ..) =>
                new_bound_vars.set(name, ())
              _ => ()
            }
          }
          self.collect_free_variables(body, new_bound_vars, free_vars)
        }
        _ => ()
      }
    If(cond~, ifso~, ifnot~, ..) => {
      self.collect_free_variables(cond, bound_vars, free_vars)
      self.collect_free_variables(ifso, bound_vars, free_vars)
      match ifnot {
        Some(else_expr) =>
          self.collect_free_variables(else_expr, bound_vars, free_vars)
        None => ()
      }
    }
    // 其他表达式类型的处理...
    _ => ()
  }
}

///| 从模式中提取绑定的变量名
fn extract_pattern_variables(
  pattern : @syntax.Pattern,
  bound_vars : Map[String, Unit],
) -> Unit {
  match pattern {
    @syntax.Pattern::Var({ name, .. }) => bound_vars.set(name, ())
    // 其他模式类型的处理...
    _ => ()
  }
}

///| 检查是否还有未绑定的参数
fn ClosureInterpreter::has_unbound_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
) -> Bool {
  match params {
    @list.More(param, tail=rest) =>
      match param {
        Optional(..) | QuestionOptional(..) =>
          // 可选参数不强制需要绑定
          self.has_unbound_parameters(rest)
        _ => true // 有必需参数未绑定
      }
    @list.Empty => false
  }
}

///| 从参数列表中取前n个参数
fn ClosureInterpreter::take_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  n : Int,
) -> @list.List[@syntax.Parameter] {
  if n <= 0 {
    return @list.new()
  }
  match params {
    @list.More(param, tail=rest) =>
      if n == 1 {
        @list.construct(param, @list.new())
      } else {
        @list.construct(param, self.take_parameters(rest, n - 1))
      }
    @list.Empty => @list.new()
  }
}

///| 从参数列表中丢弃前n个参数
fn ClosureInterpreter::drop_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  n : Int,
) -> @list.List[@syntax.Parameter] {
  if n <= 0 {
    return params
  }
  match params {
    @list.More(_, tail=rest) => self.drop_parameters(rest, n - 1)
    @list.Empty => @list.new()
  }
}

///| 在当前环境中解释参数值
fn ClosureInterpreter::evaluate_arguments(
  self : ClosureInterpreter,
  args : @list.List[@syntax.Argument],
) -> @list.List[RuntimeValue] raise ControlFlow {
  match args {
    @list.More(arg, tail=rest) => {
      let value = self.visit(arg.value)
      @list.construct(value, self.evaluate_arguments(rest))
    }
    @list.Empty => @list.new()
  }
}

///| 绑定已解释的参数值到新环境
fn ClosureInterpreter::bind_evaluated_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  values : @list.List[RuntimeValue],
) -> Unit raise ControlFlow {
  match (params, values) {
    (More(param, tail=rest_params), More(value, tail=rest_values)) => {
      match param {
        // 位置参数：直接绑定参数值
        Positional(binder={ name, .. }, ..)
        // 标签参数：绑定带标签的参数值
        | Labelled(binder={ name, .. }, ..)
        // 问号可选参数：绑定参数值
        | QuestionOptional(binder={ name, .. }, ..)
        // 可选参数：当有参数提供时绑定参数值
        | Optional(binder={ name, .. }, ..) =>
          self.current_module.env.set(name, value)
        // 丢弃位置参数：不绑定到任何变量
        DiscardPositional(..) => ()
      }
      self.bind_evaluated_parameters(rest_params, rest_values)
    }
    // 处理可选参数的默认值情况
    (More(param, tail=rest_params), Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        Optional(binder={ name, .. }, default~, ..) => {
          let default_value = self.visit(default)
          self.current_module.env.set(name, default_value)
          self.bind_evaluated_parameters(rest_params, @list.new())
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        QuestionOptional(..) =>
          self.bind_evaluated_parameters(rest_params, @list.new())
        _ => ()
      }
    (Empty, Empty) => ()
    _ => ()
  }
}
