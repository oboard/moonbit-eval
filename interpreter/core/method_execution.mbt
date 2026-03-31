// Helper enum for function lookup - SIMPLIFIED

///|
priv enum FunctionLookupResult {
  DirectFunction(RuntimeFunction)
  NotFound
}

// Method execution operations for ClosureInterpreter
// This file contains all method calling and static method execution logic

///|
/// 创建RuntimeFunctionContext的辅助函数
fn ClosureInterpreter::create_function_context(
  self : ClosureInterpreter,
  args : FixedArray[RuntimeArgument],
) -> RuntimeFunctionContext {
  RuntimeFunctionContext::{ pkg: self.current_pkg, context: self, args }
}

///|
/// 查找embedded方法的辅助函数
fn ClosureInterpreter::find_embedded_method(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
) -> RuntimeFunction? {
  match self.embedded_methods.get(type_name) {
    Some(methods) => methods.get(method_name)
    None => None
  }
}

///|
/// 执行embedded函数的辅助函数
fn ClosureInterpreter::execute_embedded_function(
  self : ClosureInterpreter,
  func : RuntimeFunction,
  args : FixedArray[RuntimeArgument],
) -> RuntimeValue raise ControlFlow {
  func(self.create_function_context(args))
}

///|
/// 查找函数 - 简化版本
fn ClosureInterpreter::lookup_function(
  self : ClosureInterpreter,
  pkg : RuntimePackage,
  name : String,
) -> FunctionLookupResult {
  // 首先查找用户函数
  match pkg.find(name).unwrap_or(self.current_pkg.find(name).unwrap_or(Unit)) {
    Fn(func) => FunctionLookupResult::DirectFunction(func.val)
    _ =>
      // 查找fn_aliases
      match pkg.fn_aliases.get(name) {
        Some(Fn(func)) => FunctionLookupResult::DirectFunction(func.val)
        _ =>
          // 查找extern函数
          match self.extern_fns.get(name) {
            Some(extern_func) =>
              FunctionLookupResult::DirectFunction(extern_func)
            None =>
              // 查找embedded函数
              match self.embedded_fns.get(name) {
                Some(embedded_func) =>
                  FunctionLookupResult::DirectFunction(embedded_func)
                None => FunctionLookupResult::NotFound
              }
          }
      }
  }
}

///|
/// 根据函数名执行函数
fn ClosureInterpreter::call_by_name(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let evaluated_args : FixedArray[RuntimeArgument] = FixedArray::from_array(
    args
    .map(arg => RuntimeArgument::{
      val: self.visit(arg.value),
      kind: RuntimeArgumentKind::from_syntax(arg.kind),
    })
    .to_array(),
  )
  self.with_ident(long_ident, (pkg, name) => {
    let name = pkg.find_stub(name)
    match self.lookup_function(pkg, name) {
      FunctionLookupResult::DirectFunction(func) =>
        self.execute_embedded_function(func, evaluated_args)
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

  // 尝试embedded方法
  if self_type is (Object(name~, ..) | Name(name~, ..)) {
    match self.find_embedded_method(name, method_name) {
      Some(embedded_method) => {
        let evaluated_args = self.convert_to_runtime_arguments(args)
        return self.execute_embedded_function(
          embedded_method,
          FixedArray::from_array(
            [
              { val: self_value, kind: RuntimeArgumentKind::Positional },
              ..evaluated_args,
            ],
          ),
        )
      }
      None => () // Continue to try regular methods
    }
  }

  // 尝试用户定义的方法
  match self_type.find_method(method_name) {
    Some((pkg, func)) =>
      self.execute_user_method(pkg, func, self_value, method_name, args)
    None =>
      self.error("exec: \{self_type.to_string()}::\{method_name} not found")
  }
}

///|
/// 执行用户定义的方法
fn ClosureInterpreter::execute_user_method(
  self : ClosureInterpreter,
  pkg : RuntimePackage,
  func : RuntimeValue,
  self_value : RuntimeValue,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let old_mod = self.current_pkg
  let args = FixedArray::from_array(
    [
      { val: self_value, kind: RuntimeArgumentKind::Positional },
      ..self.convert_to_runtime_arguments(args),
    ],
  )
  self.push_scope(RuntimeLocation::FunctionCall(method_name))
  defer {
    self.pop_scope()
    self.current_pkg = old_mod
  }
  match func {
    Fn(func) => (func.val)({ context: self, pkg, args })
    _ =>
      self.error(
        "exec method: \{self_value.get_type().to_string()}::\{method_name} not found",
      )
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
  let evaluated_args = FixedArray::from_array(
    args
    .map(arg => {
      val: self.visit(arg.value),
      kind: RuntimeArgumentKind::from_syntax(arg.kind),
    })
    .to_array(),
  )
  // 尝试embedded方法
  if type_info is Object(name~, ..) {
    match self.find_embedded_method(name, method_name) {
      Some(embedded_func) =>
        return self.execute_embedded_function(embedded_func, evaluated_args)
      None => ()
    }
  }

  // 尝试用户定义的静态方法
  match type_info.find_method(method_name) {
    Some((pkg, func)) =>
      match func {
        Fn(func) => self.call(func.val, pkg, evaluated_args)
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
      match pkg.struct_methods.get(name) {
        Some(methods) =>
          match methods.get(method_name) {
            Some(func) => Some((pkg, func))
            None => find_trait_method(pkg, name, method_name)
          }
        None => find_trait_method(pkg, name, method_name)
      }
    _ => None
  }
}

///|
/// 查找trait方法的辅助函数
fn find_trait_method(
  pkg : RuntimePackage,
  type_name : String,
  method_name : String,
) -> (RuntimePackage, RuntimeValue)? {
  match pkg.type_derived_traits.get(type_name) {
    Some(derived_traits) => {
      for trait_name in derived_traits {
        match pkg.trait_methods.get(trait_name) {
          Some(methods) =>
            match methods.get(method_name) {
              Some(func) => return Some((pkg, func))
              None => continue
            }
          None => continue
        }
      }
      None
    }
    None => None
  }
}
