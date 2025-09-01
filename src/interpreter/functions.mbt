///| 函数管理模块

///|
/// 调用闭包函数，恢复捕获的环境
pub fn ClosureInterpreter::call_closure(
  self : ClosureInterpreter,
  function : @syntax.Func,
  mod : RuntimePackage,
  env : RuntimeEnvironment,
  args : @list.List[@syntax.Argument],
  name? : String,
) -> RuntimeValue raise ControlFlow {
  match function {
    @syntax.Func::Lambda(_) => {
      // 在旧环境中解释参数值并转换为RuntimeArgument
      let runtime_args = self.convert_to_runtime_arguments(args)

      // 调用运行时版本
      self.call(function, mod, env, runtime_args, name?)
    }
    _ => RuntimeValue::Unit
  }
}

///|
/// 调用闭包函数，使用已求值的运行时参数
pub fn ClosureInterpreter::call(
  self : ClosureInterpreter,
  function : @syntax.Func,
  mod : RuntimePackage,
  env : RuntimeEnvironment,
  args : @list.List[RuntimeArgument],
  name? : String,
) -> RuntimeValue raise ControlFlow {
  match function {
    @syntax.Func::Lambda(parameters~, body~, ..) => {
      // 切换到闭包捕获的环境
      let old_mod = self.current_module
      let old_env = mod.env
      self.current_module = mod
      self.current_module.env = env
      self.push_scope(
        RuntimeLocation::FunctionCall(
          "@" +
          mod.meta.name +
          "." +
          name.unwrap_or("<function>") +
          self.get_function_type_string(Closure(function, env)),
        ),
      )
      // 在新环境中绑定已解释的参数值
      self.bind_runtime_parameters(parameters, args)
      defer {
        self.pop_scope()
        self.current_module.env = old_env
        self.current_module = old_mod
      }
      // 执行函数体
      self.visit(body)
    }
    _ => RuntimeValue::Unit
  }
}

///| 处理函数定义、调用和参数绑定

///| 绑定函数参数到作用域

///| 递归处理多个参数，将参数值绑定到函数作用域中

///|
/// 支持所有参数类型：位置参数、标签参数、可选参数、问号可选参数、丢弃参数
pub fn ClosureInterpreter::bind_function_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  args : @list.List[RuntimeArgument],
) -> Unit raise ControlFlow {
  let env = self.current_module.env
  match (params, args) {
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      let value = arg.val
      match param {
        // 位置参数：直接绑定参数值
        Positional(binder={ name, .. }, ..)
        // 标签参数：绑定带标签的参数值
        | Labelled(binder={ name, .. }, ..)
        // 可选参数：当有参数提供时绑定参数值，否则使用默认值
        | Optional(binder={ name, .. }, ..)
        // 问号可选参数：绑定参数值
        | QuestionOptional(binder={ name, .. }, ..) => env.set(name, value)
        // 丢弃位置参数：不绑定到任何变量，直接跳过
        DiscardPositional(..) =>
          // 丢弃参数不需要绑定，但仍需要求值以保持副作用
          ()
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
/// 将语法参数转换为运行时参数
fn ClosureInterpreter::convert_to_runtime_arguments(
  self : ClosureInterpreter,
  args : @list.List[@syntax.Argument],
) -> @list.List[RuntimeArgument] raise ControlFlow {
  args.map(arg => RuntimeArgument::{
    val: self.visit(arg.value),
    kind: RuntimeArgumentKind::from_syntax(arg.kind),
  })
}

///|
/// 绑定运行时参数到新环境
fn ClosureInterpreter::bind_runtime_parameters(
  self : ClosureInterpreter,
  params : @list.List[@syntax.Parameter],
  args : @list.List[RuntimeArgument],
) -> Unit raise ControlFlow {
  loop (params, args) {
    // 处理可选参数的默认值情况
    (
      @list.More(param, tail=rest_params),
      @list.More({ val: Unit, .. }, tail=rest_args),
    ) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        Optional(binder={ name, .. }, default~, ..) => {
          let default_value = self.visit(default)
          self.current_module.env.set(name, default_value)
          continue (rest_params, rest_args)
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        QuestionOptional(..) => continue (rest_params, rest_args)
        _ => ()
      }
    (@list.More(param, tail=rest_params), @list.More(arg, tail=rest_args)) => {
      let value = arg.val
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
      continue (rest_params, rest_args)
    }
    // 处理可选参数的默认值情况
    (@list.More(param, tail=rest_params), @list.Empty) =>
      match param {
        // 可选参数没有对应实参时，使用默认值
        Optional(binder={ name, .. }, default~, ..) => {
          let default_value = self.visit(default)
          self.current_module.env.set(name, default_value)
          continue (rest_params, @list.new())
        }
        // 问号可选参数没有对应实参时，不绑定任何值
        QuestionOptional(..) => continue (rest_params, @list.new())
        _ => ()
      }
    (@list.Empty, @list.Empty) => ()
    _ => ()
  }
}

///|
/// 处理函数定义
pub fn RuntimePackage::define_struct_method(
  self : RuntimePackage,
  type_name : String,
  method_name : String,
  func : @syntax.Func,
) -> Unit {
  let methods = match self.struct_methods.get(type_name) {
    Some(methods) => methods
    None => {
      let methods = Map::new()
      self.struct_methods.set(type_name, methods)
      methods
    }
  }
  methods.set(method_name, RuntimeValue::Closure(func, self.env))
}
