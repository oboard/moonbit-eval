// Helper enum for function lookup

///|
priv enum FunctionLookupResult {
  EmbeddedFunction(String)
  RuntimeClosure(@syntax.Func, RuntimeEnvironment)
  ExternFunction(RuntimeFunction)
  GlobalEmbedded(RuntimeFunction)
  NotFound
}

// Method execution operations for ClosureInterpreter
// This file contains all method calling and static method execution logic

///|
/// 根据函数名执行函数
fn ClosureInterpreter::execute_function_by_name(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let evaluated_args = args
    .map(arg => RuntimeArgument::{
      val: self.visit(arg.value),
      kind: RuntimeArgumentKind::from_syntax(arg.kind),
    })
    .to_array()
  self.current_module.with_ident(long_ident, fn(mod, _pkg, name) {
    let env = mod.env
    let name = env.find_fn_alias(name)

    // 按优先级查找：用户函数 -> Lambda变量 -> 外部函数 -> embedded函数
    let func = match
      env
      .find(name)
      .unwrap_or(self.current_module.env.find(name).unwrap_or(Unit)) {
      Closure(func, env) =>
        // 检查是否是embedded函数的标记函数
        match func {
          Lambda(body=Ident(id={ name: Ident(name=embedded_name), .. }, ..), ..) =>
            match embedded_name {
              ['%', ..] => FunctionLookupResult::EmbeddedFunction(embedded_name)
              _ => FunctionLookupResult::RuntimeClosure(func, env)
            }
          _ => FunctionLookupResult::RuntimeClosure(func, env)
        }
      _ =>
        match self.extern_fns.get(name) {
          Some(extern_func) => FunctionLookupResult::ExternFunction(extern_func)
          None =>
            match self.embedded_fns.get(name) {
              Some(embedded_func) =>
                FunctionLookupResult::GlobalEmbedded(embedded_func)
              None => FunctionLookupResult::NotFound
            }
        }
    }
    match func {
      FunctionLookupResult::EmbeddedFunction(embedded_name) =>
        match self.embedded_fns.get(embedded_name) {
          Some(embedded_func) =>
            embedded_func(RuntimeFunctionContext::{
              mod: self.current_module,
              context: self,
              args: evaluated_args,
            })
          None => self.error("Embedded function:\{embedded_name} not found")
        }
      FunctionLookupResult::RuntimeClosure(lambda_func, captured_env) =>
        // 调用闭包：使用专门的闭包调用方法
        self.call_closure(lambda_func, mod, captured_env, args, name~)
      FunctionLookupResult::ExternFunction(extern_func) =>
        extern_func(RuntimeFunctionContext::{
          mod: self.current_module,
          context: self,
          args: evaluated_args,
        })
      FunctionLookupResult::GlobalEmbedded(embedded_func) =>
        embedded_func(RuntimeFunctionContext::{
          mod: self.current_module,
          context: self,
          args: evaluated_args,
        })
      FunctionLookupResult::NotFound => self.error("method \{name} not found")
    }
  })
}

///|
/// 执行结构体方法调用（返回 RuntimeValue）
fn ClosureInterpreter::execute_method_call(
  self : ClosureInterpreter,
  self_value : RuntimeValue,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let self_type = self.current_module.env.type_of(self_value)
  match self.embedded_methods.get(self_type.name) {
    Some(type_methods) =>
      match type_methods.get(method_name) {
        Some(embedded_method) => {
          // Prepare args: actual_self_value + evaluated args
          let evaluated_args = @list.construct(
            self_value,
            args.map(fn(arg) { self.visit(arg.value) }),
          )
          return embedded_method(RuntimeFunctionContext::{
            context: self,
            mod: self.current_module,
            args: evaluated_args
            .map(arg => { val: arg, kind: Positional })
            .to_array(),
          })
        }
        None => () // Continue to try regular methods
      }
    None => () // Continue to try regular methods
  }
  match self_type.find_method(method_name) {
    Some(func) => {
      let old_env = self.current_module.env
      let args = args.map(arg => {
        val: self.visit(arg.value),
        kind: RuntimeArgumentKind::from_syntax(arg.kind),
      })
      self.current_module.env = self_type.env
      self.push_scope(RuntimeLocation::FunctionCall(method_name))
      defer {
        self.pop_scope()
        self.current_module.env = old_env
      }
      // Bind self parameter and other args
      match func {
        Closure(Lambda(parameters~, body~, ..), _env) => {
          // Bind parameters
          match parameters {
            More(Positional(binder={ name: "self", .. }, ..), ..) =>
              self.bind_function_parameters(
                parameters,
                @list.construct({ val: self_value, kind: Positional }, args),
              )
            _ => self.bind_function_parameters(parameters, args)
          }

          // Execute function body
          self.visit(body)
        }
        _ =>
          self.error(
            "exec method: \{self_type.to_string()}::\{method_name} not found",
          )
      }
    }
    None =>
      self.error("exec: \{self_type.to_string()}::\{method_name} not found")
  }
}

///|
/// 执行静态方法调用（如 Bool::default()）
fn ClosureInterpreter::execute_static_method_call(
  self : ClosureInterpreter,
  type_info : RuntimeType,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  match self.embedded_methods.get(type_info.name) {
    Some(methods) =>
      match methods.get(method_name) {
        Some(embedded_func) => {
          let evaluated_args = args
            .map(arg => {
              val: self.visit(arg.value),
              kind: RuntimeArgumentKind::from_syntax(arg.kind),
            })
            .to_array()
          return embedded_func(RuntimeFunctionContext::{
            mod: self.current_module,
            context: self,
            args: evaluated_args,
          })
        }
        None => ()
      }
    None => ()
  }

  // If no embedded method found, try user-defined struct methods
  match type_info.find_method(method_name) {
    Some(func) =>
      match func {
        Closure(func, env) =>
          self.call_closure(
            func,
            self.current_module,
            env,
            args,
            name=method_name,
          )
        _ => Unit
      }
    None => self.error("Method \{type_info.name}::\{method_name} not found")
  }
}

///|
/// 查找类型的方法
fn RuntimeType::find_method(
  self : RuntimeType,
  method_name : String,
) -> RuntimeValue? {
  let mut current_env = Some(self.env)
  while current_env is Some(env) {
    if env.struct_methods.get(self.name) is Some(methods) {
      if methods.get(method_name) is Some(func) {
        return Some(func)
      }
    }
    current_env = env.parent
  }
  None
}
