///|
pub(all) struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
}

///|
pub enum EvalResult {
  Success(RuntimeValue, ClosureInterpreter)
  Error(String, ClosureInterpreter)
}

///|
pub(all) struct TestFailure {
  name : String
  message : String
} derive(ToJson)

///|
pub(all) struct TestResult {
  total : Int
  passed : Int
  failed : Int
  failures : Array[TestFailure]
} derive(ToJson)

///|
pub impl Show for TestFailure with output(self : TestFailure, logger : &Logger) -> Unit {
  logger.write_string(self.name + ": " + self.message)
}

///|
pub impl Show for TestResult with output(self : TestResult, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub impl Show for TestResult with to_string(self : TestResult) -> String {
  let summary = "TestResult(total=\{self.total}, passed=\{self.passed}, failed=\{self.failed})"
  if self.failed == 0 {
    summary
  } else {
    summary +
    "\n" +
    self.failures.map(failure => "FAILED " + failure.to_string()).join("\n")
  }
}

///|
pub impl Show for EvalResult with output(self : EvalResult, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub impl Show for EvalResult with to_string(self : EvalResult) -> String {
  match self {
    Success(value, _) => value.to_string()
    Error(msg, _) => "Error: " + msg
  }
}

///|
fn assertion_message(
  ctx : @core.RuntimeFunctionContext,
  fallback : String,
) -> String {
  match ctx.named("msg") {
    Some(String(msg)) => msg
    Some(StringView(msg)) => msg.to_owned()
    _ => fallback
  }
}

///|
fn fail_assertion(
  ctx : @core.RuntimeFunctionContext,
  message : String,
) -> RuntimeValue raise @core.ControlFlow {
  raise @core.control_error(ctx.context.lookup_current_function() + message)
}

///|
#alias(new)
pub fn MoonBitVM::MoonBitVM(
  log? : Bool = false,
  modules? : Array[RuntimeModule] = [],
) -> MoonBitVM {
  let interpreter = ClosureInterpreter::new()
  for mod in modules {
    interpreter.load_module(mod)
  }
  interpreter.add_extern_fn("println", ctx => {
    match ctx.args {
      [{ val: value, .. }] => {
        println(value)
        Unit
      }
      _ => Unit
    }
  })
  interpreter.add_extern_fn("assert_true", ctx => {
    match ctx.args {
      [{ val: Bool(true), .. }, ..] => Unit
      [{ val: Bool(false), .. }, ..] =>
        fail_assertion(ctx, assertion_message(ctx, "`false` is not true"))
      _ => fail_assertion(ctx, "assert_true expects Bool")
    }
  })
  interpreter.add_extern_fn("assert_false", ctx => {
    match ctx.args {
      [{ val: Bool(false), .. }, ..] => Unit
      [{ val: Bool(true), .. }, ..] =>
        fail_assertion(ctx, assertion_message(ctx, "`true` is not false"))
      _ => fail_assertion(ctx, "assert_false expects Bool")
    }
  })
  { interpreter, log }
}

///|
pub fn expr_to_string(expr : @syntax.Expr) -> String {
  match expr {
    Constant(c~, ..) =>
      match c {
        Bool(b) => b.to_string()
        Byte(b) => b
        Bytes(b) => b
        Char(c) => c
        Int(str) => str
        Int64(str) => str
        UInt(str) => str
        UInt64(str) => str
        Float(str) => str
        Double(str) => str
        String(str) => str
        BigInt(str) => str
      }
    Unit(..) => "()"
    Function(
      func={ kind: @syntax.FnKind::Lambda, parameters, return_type, .. },
      ..
    ) => {
      // 辅助函数：将Type转换为字符串
      fn type_to_string(ty : @syntax.Type) -> String {
        match ty {
          @syntax.Type::Name(constr_id~, ..) =>
            match constr_id.id {
              @syntax.LongIdent::Ident(name~) => name
              _ => "Any"
            }
          _ => "Any"
        }
      }

      let param_strs = []
      for param in parameters {
        let param_str = match param {
          @syntax.Parameter::DiscardPositional(ty~, ..) =>
            match ty {
              Some(t) => "_: " + type_to_string(t)
              None => "_"
            }
          @syntax.Parameter::Positional(binder~, ty~) =>
            match ty {
              Some(t) => binder.name + ": " + type_to_string(t)
              None => binder.name
            }
          @syntax.Parameter::Labelled(binder~, ty~) =>
            match ty {
              Some(t) => binder.name + "~: " + type_to_string(t)
              None => binder.name + "~"
            }
          @syntax.Parameter::Optional(binder~, ty~, default~) =>
            (match ty {
              Some(t) => binder.name + "~: " + type_to_string(t)
              None => binder.name + "~"
            }) +
            " = " +
            expr_to_string(default)
          @syntax.Parameter::QuestionOptional(binder~, ty~) =>
            match ty {
              Some(t) => binder.name + "?: " + type_to_string(t)
              None => binder.name + "?"
            }
        }
        param_strs.push(param_str)
      }
      let params_str = if param_strs.length() == 0 {
        "()"
      } else {
        let mut joined = ""
        for i = 0; i < param_strs.length(); i = i + 1 {
          if i > 0 {
            joined = joined + ", "
          }
          joined = joined + param_strs[i]
        }
        "(" + joined + ")"
      }
      let return_str = match return_type {
        Some(rt) => " -> " + type_to_string(rt)
        None => ""
      }
      params_str + return_str
    }

    // 处理 Tuple 表达式
    Tuple(exprs~, ..) => {
      let expr_strs = []
      for expr in exprs {
        expr_strs.push(expr_to_string(expr))
      }
      let mut joined = ""
      for i = 0; i < expr_strs.length(); i = i + 1 {
        if i > 0 {
          joined = joined + ", "
        }
        joined = joined + expr_strs[i]
      }
      "(" + joined + ")"
    }

    // 处理 Record 表达式
    Record(type_name~, fields~, ..) => {
      let field_strs = []
      for field in fields {
        let field_str = field.label.name + ": " + expr_to_string(field.expr)
        field_strs.push(field_str)
      }
      let mut joined = ""
      for i = 0; i < field_strs.length(); i = i + 1 {
        if i == 0 {
          joined = field_strs[i]
        } else {
          joined = joined + ",\n  " + field_strs[i]
        }
      }
      let type_prefix = match type_name {
        Some(name) =>
          match name.name {
            @syntax.LongIdent::Ident(name~) => name + " "
            _ => ""
          }
        None => ""
      }
      if joined == "" {
        type_prefix + "{}"
      } else {
        type_prefix + "{\n  " + joined + "\n}"
      }
    }

    // 处理 Array 表达式
    Array(exprs~, ..) => {
      let expr_strs = []
      for expr in exprs {
        expr_strs.push(expr_to_string(expr))
      }
      let mut joined = ""
      for i = 0; i < expr_strs.length(); i = i + 1 {
        if i > 0 {
          joined = joined + ", "
        }
        joined = joined + expr_strs[i]
      }
      "[" + joined + "]"
    }
    // 处理Apply表达式 - 包括构造函数调用如Some(5)
    Apply(func~, args~, ..) => {
      let func_str = expr_to_string(func)
      let arg_strs = []
      for arg in args {
        arg_strs.push(expr_to_string(arg.value))
      }
      let args_joined = arg_strs.join(", ")
      func_str + "(" + args_joined + ")"
    }

    // 处理Constr表达式 - 构造函数
    Constr(constr~, ..) => constr.name.name

    // 处理Ident表达式
    Ident(id~, ..) =>
      match id.name {
        @syntax.LongIdent::Ident(name~) => name
        @syntax.LongIdent::Dot(pkg~, id~) =>
          if pkg == "" {
            id
          } else {
            pkg + "." + id
          }
      }

    // 处理Sequence表达式 - 只显示最后一个表达式的结果
    Sequence(last_expr~, ..) => expr_to_string(last_expr)

    // 其他未处理的表达式
    _ => ""
  }
}

///|
pub fn MoonBitVM::eval(
  self : MoonBitVM,
  code : String,
  log? : Bool,
) -> EvalResult {
  try {
    let import_result = @core.parse_package_imports(code)
    if self.interpreter.load_declared_imports(import_result.imports)
      is Some(msg) {
      return Error(msg, self.interpreter)
    }
    let code = import_result.code
    match @core.parse_eval_code(code) {
      Ok(EvalExpr(expr)) => {
        let result_value = self.interpreter.visit(expr)
        if log.unwrap_or(self.log) {
          println(expr.to_json().stringify())
        }
        return Success(result_value, self.interpreter)
      }
      Ok(EvalTop(impls, run_main~)) => {
        let mut last_result = RuntimeValue::Unit
        impls.each(node => {
          if log.unwrap_or(self.log) {
            println(node.to_json().stringify())
          }
          let result = match node {
            @syntax.Impl::TopTest(expr~, is_async~, ..) =>
              self.interpreter.run_top_test(expr, is_async)
            _ => self.interpreter.top_visit(node)
          }
          last_result = result
        })
        if run_main {
          last_result = self.interpreter.run_main()
        }
        return Success(last_result, self.interpreter)
      }
      Err(msg) => return Error(msg, self.interpreter)
    }
  } catch {
    @core.ControlFlow::Error(msg) => Error(msg, self.interpreter)
    _ => panic()
  }
}

///|
fn test_name(name : (String, @basic.Location)?) -> String {
  match name {
    Some((name, _)) => name
    None => "<anonymous>"
  }
}

///|
fn control_flow_to_string(flow : @core.ControlFlow) -> String {
  match flow {
    @core.ControlFlow::Error(msg) => msg
    @core.ControlFlow::Raise(value) => "raise " + value.to_string()
    @core.ControlFlow::Return(value) => "return " + value.to_string()
    @core.ControlFlow::Break(value) => "break " + value.to_string()
    @core.ControlFlow::Continue(values) =>
      "continue " + RuntimeValue::Array(values).to_string()
  }
}

///|
fn failed_test(name : String, message : String) -> TestResult {
  { total: 1, passed: 0, failed: 1, failures: [{ name, message }] }
}

///|
pub fn MoonBitVM::test_all(
  self : MoonBitVM,
  code : String,
  log? : Bool,
) -> TestResult {
  let import_result = @core.parse_package_imports(code)
  if self.interpreter.load_declared_imports(import_result.imports) is Some(msg) {
    return failed_test("<import>", msg)
  }
  let code = import_result.code
  let impls = match @core.parse_eval_code(code) {
    Ok(EvalTop(impls, ..)) => impls
    Ok(EvalExpr(_)) => return { total: 0, passed: 0, failed: 0, failures: [] }
    Err(msg) => return failed_test("<parse>", msg)
  }
  let mut total = 0
  let mut passed = 0
  let failures : Array[TestFailure] = []
  impls.each(node => {
    if log.unwrap_or(self.log) {
      println(node.to_json().stringify())
    }
    match node {
      @syntax.Impl::TopTest(expr~, name~, is_async~, ..) => {
        total = total + 1
        let case_name = test_name(name)
        try {
          self.interpreter.run_top_test_checked(expr, is_async) |> ignore
          passed = passed + 1
        } catch {
          flow =>
            failures.push({
              name: case_name,
              message: control_flow_to_string(flow),
            })
        }
      }
      _ => self.interpreter.top_visit(node) |> ignore
    }
  })
  { total, passed, failed: failures.length(), failures }
}

///|
pub fn test_all(vm : MoonBitVM, code : String, log? : Bool) -> TestResult {
  vm.test_all(code, log?)
}

///|
pub fn MoonBitVM::run(self : MoonBitVM, code : String, log? : Bool) -> Unit {
  self.eval(code, log?) |> ignore
}
