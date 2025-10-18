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
fn ClosureInterpreter::call_by_name(
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
  self.with_ident(long_ident, fn(pkg, name) {
    let name = pkg.find_stub(name)

    // 按优先级查找：用户函数 -> Lambda变量 -> 外部函数 -> embedded函数
    let func = match
      pkg.find(name).unwrap_or(self.current_pkg.find(name).unwrap_or(Unit)) {
      Fn(func, env) =>
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
              mod: self.current_pkg,
              context: self,
              args: evaluated_args,
            })
          None => self.error("Embedded function:\{embedded_name} not found")
        }
      FunctionLookupResult::RuntimeClosure(lambda_func, captured_env) =>
        // 调用闭包：使用专门的闭包调用方法
        self.call_closure(lambda_func, pkg, captured_env, args, name~)
      FunctionLookupResult::ExternFunction(extern_func) =>
        extern_func(RuntimeFunctionContext::{
          mod: self.current_pkg,
          context: self,
          args: evaluated_args,
        })
      FunctionLookupResult::GlobalEmbedded(embedded_func) =>
        embedded_func(RuntimeFunctionContext::{
          mod: self.current_pkg,
          context: self,
          args: evaluated_args,
        })
      FunctionLookupResult::NotFound =>
        self.error(
          "execute_function_by_name method @\{pkg.name}.\{name} not found",
        )
    }
  })
}

///|
/// 执行结构体方法调用（返回 RuntimeValue）
fn ClosureInterpreter::method_call(
  self : ClosureInterpreter,
  self_value : RuntimeValue,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let self_type = self_value.get_type()
  if self_type is (Object(name~, ..) | Name(name~, ..)) {
    match self.embedded_methods.get(name) {
      Some(type_methods) =>
        match type_methods.get(method_name) {
          Some(embedded_method) => {
            // Prepare args: actual_self_value + evaluated args
            let evaluated_args = @list.cons(
              self_value,
              args.map(fn(arg) { self.visit(arg.value) }),
            )
            return embedded_method(RuntimeFunctionContext::{
              context: self,
              mod: self.current_pkg,
              args: evaluated_args
              .map(arg => { val: arg, kind: Positional })
              .to_array(),
            })
          }
          None => () // Continue to try regular methods
        }
      None => () // Continue to try regular methods
    }
  }
  match self_type.find_method(method_name) {
    Some((pkg, func)) => {
      let old_mod = self.current_pkg
      let args = args.map(arg => {
        val: self.visit(arg.value),
        kind: RuntimeArgumentKind::from_syntax(arg.kind),
      })
      self.push_scope(RuntimeLocation::FunctionCall(method_name))
      defer {
        self.pop_scope()
        self.current_pkg = old_mod
      }
      // Bind self parameter and other args
      match func {
        Fn(Lambda(parameters~, body~, ..), captured_env) => {
          // Switch to closure's captured environment
          let old_env = pkg.env
          self.current_pkg = pkg
          self.current_pkg.env = captured_env
          defer {
            self.current_pkg.env = old_env
          }
          // Bind parameters - always include self_value as first parameter
          self.bind_function_parameters(
            parameters,
            @list.cons({ val: self_value, kind: Positional }, args),
          )

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
  if type_info is Object(name~, ..) {
    match self.embedded_methods.get(name) {
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
              mod: self.current_pkg,
              context: self,
              args: evaluated_args,
            })
          }
          None => ()
        }
      None => ()
    }
  }

  // If no embedded method found, try user-defined struct methods
  match type_info.find_method(method_name) {
    Some((pkg, func)) =>
      match func {
        Fn(func, env) =>
          self.call_closure(func, pkg, env, args, name=method_name)
        _ => Unit
      }
    None => self.error("static method \{type_info}::\{method_name} not found")
  }
}

///|
/// 查找类型的方法
fn RuntimeType::find_method(
  self : RuntimeType,
  method_name : String,
) -> (RuntimePackage, RuntimeValue)? {
  match self {
    Object(pkg~, name~) =>
      // 首先查找struct方法
      if pkg.struct_methods.get(name).map(x => x.get(method_name))
        is Some(Some(func)) {
        Some((pkg, func))
      } else {
        // 如果没有找到struct方法，查找trait方法
        // 只遍历当前类型derive的trait，而不是所有trait
        let mut found_trait_method = None

        // 直接使用当前类型名查找derive的trait
        match pkg.type_derived_traits.get(name) {
          Some(derived_traits) =>
            // 只遍历该类型derive的trait
            for trait_name in derived_traits {
              match pkg.trait_methods.get(trait_name) {
                Some(methods) =>
                  match methods.get(method_name) {
                    Some(func) => {
                      found_trait_method = Some((pkg, func))
                      break
                    }
                    None => ()
                  }
                None => ()
              }
            }
          None => ()
        }
        found_trait_method
      }
    _ => None
  }
}
