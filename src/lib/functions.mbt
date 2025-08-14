///| 函数管理模块

///| 处理函数定义、调用和参数绑定

///| 绑定函数参数到作用域

///| 递归处理多个参数，将参数值绑定到函数作用域中

///| 支持所有参数类型：位置参数、标签参数、可选参数、问号可选参数、丢弃参数
pub fn bind_function_parameters(
  params : @list.List[@syntax.Parameter],
  args : @list.List[@syntax.Argument],
  immutable_values : Array[Map[String, @syntax.Expr]],
  visit_fn : (@syntax.Expr) -> @syntax.Expr,
) -> Unit {
  match (params, args) {
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      match param {
        // 位置参数：直接绑定参数值
        @syntax.Parameter::Positional(binder={ name, .. }, ..) => {
          let arg_value = visit_fn(arg.value)
          immutable_values.last().unwrap().set(name, arg_value)
        }
        // 标签参数：绑定带标签的参数值
        @syntax.Parameter::Labelled(binder={ name, .. }, ..) => {
          let arg_value = visit_fn(arg.value)
          immutable_values.last().unwrap().set(name, arg_value)
        }
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, default~, ..) => {
          let arg_value = visit_fn(arg.value)
          immutable_values.last().unwrap().set(name, arg_value)
        }
        // 问号可选参数：绑定参数值
        @syntax.Parameter::QuestionOptional(binder={ name, .. }, ..) => {
          let arg_value = visit_fn(arg.value)
          immutable_values.last().unwrap().set(name, arg_value)
        }
        // 丢弃位置参数：不绑定到任何变量，直接跳过
        @syntax.Parameter::DiscardPositional(..) =>
          // 丢弃参数不需要绑定，但仍需要求值以保持副作用
          visit_fn(arg.value) |> ignore
      }
      bind_function_parameters(
        rest_params, rest_args, immutable_values, visit_fn,
      )
    }
    // 处理可选参数的默认值情况
    (@list.More(param, tail=rest_params), @list.Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        @syntax.Parameter::Optional(binder={ name, .. }, default~, ..) => {
          let default_value = visit_fn(default)
          immutable_values.last().unwrap().set(name, default_value)
          bind_function_parameters(
            rest_params,
            @list.new(),
            immutable_values,
            visit_fn,
          )
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        @syntax.Parameter::QuestionOptional(..) =>
          bind_function_parameters(
            rest_params,
            @list.new(),
            immutable_values,
            visit_fn,
          )
        _ => ()
      }
    _ => ()
  }
}

///| 执行函数调用

///| 处理用户定义函数的调用，包括作用域管理和参数绑定
pub fn execute_function_call(
  function : @syntax.Func,
  args : @list.List[@syntax.Argument],
  immutable_values : Array[Map[String, @syntax.Expr]],
  mutable_values : Array[Map[String, @syntax.Expr]],
  visit_fn : (@syntax.Expr) -> @syntax.Expr,
) -> @syntax.Expr {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 创建新的作用域
      immutable_values.push(Map::new())
      mutable_values.push(Map::new())

      // 绑定参数
      bind_function_parameters(parameters, args, immutable_values, visit_fn)

      // 执行函数体
      let result = visit_fn(body)

      // 恢复作用域
      immutable_values.pop() |> ignore
      mutable_values.pop() |> ignore
      result
    }
    _ =>
      // 返回Unit表达式作为默认值
      @syntax.Expr::Unit(
        loc={
          start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
          end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
        },
        faked=true,
      )
  }
}

///| 处理函数定义

///| 将函数存储到用户函数映射中
pub fn define_function(
  user_functions : Map[String, @syntax.Func],
  name : String,
  func : @syntax.Func,
) -> Unit {
  user_functions.set(name, func)
}

///| 查找用户定义的函数
pub fn find_user_function(
  user_functions : Map[String, @syntax.Func],
  name : String,
) -> @syntax.Func? {
  user_functions.get(name)
}
