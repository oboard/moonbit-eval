///| 函数管理模块

///| 调用闭包函数，恢复捕获的环境
pub fn ClosureInterpreter::call_closure(
  self : ClosureInterpreter,
  function : @syntax.Func,
  captured_env : Map[String, RuntimeValue],
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 创建新的作用域
      self.push_scope()

      // 恢复捕获的环境变量
      captured_env
      .iter()
      .each(fn(entry) {
        let (name, value) = entry
        self.set_variable(name, value)
      })

      // 绑定参数
      self.bind_function_parameters_runtime(parameters, args)

      // 执行函数体
      let result = self.visit(body)

      // 恢复作用域
      self.pop_scope()
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
) -> Unit {
  match (params, args) {
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      let runtime_value = self.visit(arg.value)
      match param {
        // 位置参数：直接绑定参数值
        @syntax.Parameter::Positional(binder={ name, .. }, ..) =>
          ignore(self.current_scope().set(name, runtime_value))
        // 标签参数：绑定带标签的参数值
        @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
          ignore(self.current_scope().set(name, runtime_value))
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, ..) =>
          ignore(self.current_scope().set(name, runtime_value))
        // 问号可选参数：绑定参数值
        @syntax.Parameter::QuestionOptional(binder={ name, .. }, ..) =>
          ignore(self.current_scope().set(name, runtime_value))
        // 丢弃位置参数：不绑定到任何变量，直接跳过
        @syntax.Parameter::DiscardPositional(..) =>
          // 丢弃参数不需要绑定，但仍需要求值以保持副作用
          self.visit(arg.value) |> ignore
      }
      self.bind_function_parameters(rest_params, rest_args)
    }
    // 处理可选参数的默认值情况
    (@list.More(param, tail=rest_params), @list.Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, default~, ..) => {
          let runtime_value = self.visit(default)
          self.current_scope().set(name, runtime_value)
          self.bind_function_parameters(rest_params, @list.new())
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        @syntax.Parameter::QuestionOptional(..) =>
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
) -> Unit {
  match (params, args) {
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      let arg_value = self.visit(arg.value)
      match param {
        // 位置参数：直接绑定参数值
        @syntax.Parameter::Positional(binder={ name, .. }, ..) =>
          self.current_scope().set(name, arg_value)
        // 标签参数：绑定带标签的参数值
        @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
          self.current_scope().set(name, arg_value)
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, ..) =>
          self.current_scope().set(name, arg_value)
        // 问号可选参数：绑定参数值
        @syntax.Parameter::QuestionOptional(binder={ name, .. }, ..) =>
          self.current_scope().set(name, arg_value)
        // 丢弃位置参数：不绑定到任何变量，直接跳过
        @syntax.Parameter::DiscardPositional(..) =>
          // 丢弃参数不需要绑定，但仍需要求值以保持副作用
          self.visit(arg.value) |> ignore
      }
      self.bind_function_parameters_runtime(rest_params, rest_args)
    }
    // 处理可选参数的默认值情况
    (@list.More(param, tail=rest_params), @list.Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, default~, ..) => {
          let default_value = self.visit(default)
          self.current_scope().set(name, default_value)
          self.bind_function_parameters_runtime(rest_params, @list.new())
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        @syntax.Parameter::QuestionOptional(..) =>
          self.bind_function_parameters_runtime(rest_params, @list.new())
        _ => ()
      }
    (@list.Empty, @list.Empty) => ()
    _ => ()
  }
}

///| 执行函数调用

///| 处理用户定义函数的调用，包括作用域管理和参数绑定
pub fn ClosureInterpreter::execute_function_call(
  self : ClosureInterpreter,
  function : @syntax.Func,
  args : @list.List[@syntax.Argument],
) -> @syntax.Expr {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 创建新的作用域
      self.push_scope()
      // TODO: 类型环境管理暂时禁用，调试中
      // self.push_type_environment()

      // 绑定参数
      self.bind_function_parameters(parameters, args)

      // 执行函数体
      let result = self.visit(body).to_expr()

      // 恢复作用域
      // TODO: 类型环境管理暂时禁用，调试中
      // self.pop_type_environment()
      self.pop_scope()
      result
    }
    _ =>
      // 返回Unit表达式作为默认值
      unit()
  }
}

///|
pub fn ClosureInterpreter::call(
  self : ClosureInterpreter,
  function : @syntax.Func,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 检查参数数量是否匹配
      let arg_count = args.length()

      // 检查是否需要部分应用
      // 对于可选参数，需要特殊处理
      let required_param_count = self.count_required_parameters(parameters)
      if arg_count < required_param_count {
        // 部分应用：创建闭包
        // 捕获当前环境
        let captured_env = Map::new()
        self
        .current_scope()
        .iter()
        .each(fn(entry) {
          let (name, value) = entry
          captured_env.set(name, value)
        })

        // 创建新的Lambda函数，包含剩余的参数
        let remaining_params = self.drop_parameters(parameters, arg_count)
        let dummy_loc = @basic.Location::{
          start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
          end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
        }
        let new_lambda = @syntax.Func::Lambda(
          parameters=remaining_params,
          params_loc=dummy_loc,
          body~,
          return_type=None,
          error_type=@syntax.ErrorType::NoErrorType,
          kind=Arrow,
          has_error=None,
          is_async=false,
          loc=dummy_loc,
        )

        // 绑定已提供的参数到捕获的环境
        self.push_scope()
        let taken_params = self.take_parameters(parameters, arg_count)
        self.bind_function_parameters_runtime(taken_params, args)
        // 将绑定的参数添加到捕获的环境
        self
        .current_scope()
        .iter()
        .each(fn(entry) {
          let (name, value) = entry
          captured_env.set(name, value)
        })
        self.pop_scope()
        return RuntimeValue::Closure(new_lambda, captured_env)
      } else {
        // 完全应用：正常执行函数
        // 创建新的作用域
        self.push_scope()

        // 绑定参数
        self.bind_function_parameters_runtime(parameters, args)

        // 执行函数体
        let result = self.visit(body)

        // 恢复作用域
        self.pop_scope()
        result
      }
    }
    _ =>
      // 返回Unit作为默认值
      RuntimeValue::Unit
  }
}

///| 处理函数定义

///| 将函数存储到用户函数映射中
pub fn ClosureInterpreter::define_function(
  self : ClosureInterpreter,
  name : String,
  func : @syntax.Func,
) -> Unit {
  self.current_user_function_scope().set(name, func)
}

///|
pub fn ClosureInterpreter::define_struct_method(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  func : @syntax.Func,
) -> Unit {
  if !self.struct_methods.contains(type_name) {
    ignore(self.struct_methods.set(type_name, Map::new()))
  }
  ignore(self.struct_methods.get(type_name).unwrap().set(method_name, func))
}

///| 查找用户定义的函数
pub fn ClosureInterpreter::find_user_function(
  self : ClosureInterpreter,
  name : String,
) -> @syntax.Func? {

  // 从当前作用域开始查找
  for functions in self.user_functions.rev_iter() {
    if functions.contains(name) {
      let found_func = functions.get(name).unwrap()
      return Some(found_func)
    }
  }
  None
}

///| 分析函数体中的自由变量（未绑定的变量引用）
fn ClosureInterpreter::analyze_free_variables(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
  bound_vars : Map[String, Unit],
) -> Map[String, Unit] {
  let free_vars = Map::new()
  self.collect_free_variables(expr, bound_vars, free_vars)
  free_vars
}

///| 递归收集表达式中的自由变量
fn ClosureInterpreter::collect_free_variables(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
  bound_vars : Map[String, Unit],
  free_vars : Map[String, Unit],
) -> Unit {
  match expr {
    @syntax.Expr::Ident(id={ name: @syntax.LongIdent::Ident(name~), .. }, ..) =>
      // 如果变量未绑定且不在当前环境中，则为自由变量
      if not(bound_vars.contains(name)) &&
        not(self.current_scope().contains(name)) {
        free_vars.set(name, ())
      }
    @syntax.Expr::Apply(func~, args~, ..) => {
      self.collect_free_variables(func, bound_vars, free_vars)
      for arg in args {
        self.collect_free_variables(arg.value, bound_vars, free_vars)
      }
    }
    @syntax.Expr::Let(pattern~, expr~, body~, ..) => {
      // 先处理绑定表达式
      self.collect_free_variables(expr, bound_vars, free_vars)
      // 提取模式中绑定的变量
      let new_bound_vars = bound_vars.copy()
      self.extract_pattern_variables(pattern, new_bound_vars)
      // 处理let体
      self.collect_free_variables(body, new_bound_vars, free_vars)
    }
    @syntax.Expr::Function(func~, ..) =>
      // Function表达式包含Lambda
      match func {
        @syntax.Func::Lambda(parameters~, body~, ..) => {
          // Lambda引入新的绑定变量
          let new_bound_vars = bound_vars.copy()
          for param in parameters {
            match param {
              @syntax.Parameter::Positional(binder={ name, .. }, ..)
              | @syntax.Parameter::Labelled(binder={ name, .. }, ..)
              | @syntax.Parameter::Optional(binder={ name, .. }, ..)
              | @syntax.Parameter::QuestionOptional(binder={ name, .. }, ..) =>
                new_bound_vars.set(name, ())
              _ => ()
            }
          }
          self.collect_free_variables(body, new_bound_vars, free_vars)
        }
        _ => ()
      }
    @syntax.Expr::If(cond~, ifso~, ifnot~, ..) => {
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
fn ClosureInterpreter::extract_pattern_variables(
  self : ClosureInterpreter,
  pattern : @syntax.Pattern,
  bound_vars : Map[String, Unit],
) -> Unit {
  match pattern {
    @syntax.Pattern::Var({ name, .. }) => bound_vars.set(name, ())
    // 其他模式类型的处理...
    _ => ()
  }
}

///| 计算必需参数的数量
fn ClosureInterpreter::count_required_parameters(
  self : ClosureInterpreter,
  parameters : @list.List[@syntax.Parameter],
) -> Int {
  let mut count = 0
  for param in parameters {
    match param {
      @syntax.Parameter::Positional(..) | @syntax.Parameter::Labelled(..) =>
        count += 1
      @syntax.Parameter::Optional(..)
      | @syntax.Parameter::QuestionOptional(..) => ()
      _ => ()
    }
  }
  count
}

///| 检查是否还有未绑定的参数
fn ClosureInterpreter::has_unbound_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
) -> Bool {
  match params {
    @list.More(param, tail=rest) =>
      match param {
        @syntax.Parameter::Optional(..)
        | @syntax.Parameter::QuestionOptional(..) =>
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
