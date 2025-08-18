///| 函数管理模块

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
          ignore(self.current_immutable_scope().set(name, runtime_value))
        // 标签参数：绑定带标签的参数值
        @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
          ignore(self.current_immutable_scope().set(name, runtime_value))
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, ..) =>
          ignore(self.current_immutable_scope().set(name, runtime_value))
        // 问号可选参数：绑定参数值
        @syntax.Parameter::QuestionOptional(binder={ name, .. }, ..) =>
          ignore(self.current_immutable_scope().set(name, runtime_value))
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
          self.current_immutable_scope().set(name, runtime_value)
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
          self.current_immutable_scope().set(name, arg_value)
        // 标签参数：绑定带标签的参数值
        @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
          self.current_immutable_scope().set(name, arg_value)
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, ..) =>
          self.current_immutable_scope().set(name, arg_value)
        // 问号可选参数：绑定参数值
        @syntax.Parameter::QuestionOptional(binder={ name, .. }, ..) =>
          self.current_immutable_scope().set(name, arg_value)
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
          self.current_immutable_scope().set(name, default_value)
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

      // 绑定参数
      self.bind_function_parameters(parameters, args)

      // 执行函数体
      let result = self.visit(body).to_expr_with_store(self.runtime_store)

      // 恢复作用域
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
    self.struct_methods.set(type_name, Map::new())
  }
  ignore(self.struct_methods.get(type_name).unwrap().set(method_name, func))
}

///| 查找用户定义的函数
pub fn ClosureInterpreter::find_user_function(
  self : ClosureInterpreter,
  name : String,
) -> @syntax.Func? {

  // 从当前作用域开始查找
  for functions in self.user_functions {
    if functions.contains(name) {
      let found_func = functions.get(name).unwrap()
      match found_func {
        @syntax.Func::Lambda(..) => ()
        _ => ()
      }
      return Some(found_func)
    }
  }
  None
}
