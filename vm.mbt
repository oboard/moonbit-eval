///|
pub(all) struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
  priv mut fast_code : String?
  priv mut fast_value : RuntimeValue?
  priv import_parse_cache : Map[String, @core.ImportParseResult]
  priv eval_parse_cache : Map[String, CachedEvalCode]
  priv import_parse_cache_keys : Array[String]
  priv eval_parse_cache_keys : Array[String]
}

///|
pub enum EvalResult {
  Success(RuntimeValue, ClosureInterpreter)
  Error(String, ClosureInterpreter)
}

///|
pub(all) struct CompiledCode {
  priv imports : Array[@core.PackageImport]
  priv params : Array[String]
  priv parsed : CachedEvalCode
}

///|
let parse_cache_capacity : Int = 256

///|
let max_cached_source_length : Int = 64 * 1024

///|
priv enum CachedEvalCode {
  CachedEvalResult(@core.EvalParseResult, RuntimeValue?)
  CachedEvalError(String)
}

///|
fn source_is_cacheable(code : String) -> Bool {
  code.length() <= max_cached_source_length
}

///|
fn MoonBitVM::remember_import_parse_cache_key(
  self : MoonBitVM,
  code : String,
) -> Unit {
  self.import_parse_cache_keys.push(code)
  if self.import_parse_cache_keys.length() > parse_cache_capacity {
    let evicted = self.import_parse_cache_keys.remove(0)
    self.import_parse_cache.remove(evicted)
  }
}

///|
fn MoonBitVM::remember_eval_parse_cache_key(
  self : MoonBitVM,
  code : String,
) -> Unit {
  self.eval_parse_cache_keys.push(code)
  if self.eval_parse_cache_keys.length() > parse_cache_capacity {
    let evicted = self.eval_parse_cache_keys.remove(0)
    self.eval_parse_cache.remove(evicted)
  }
}

///|
fn MoonBitVM::cached_package_imports(
  self : MoonBitVM,
  code : String,
) -> @core.ImportParseResult {
  if !source_is_cacheable(code) {
    return @core.parse_package_imports(code)
  }
  match self.import_parse_cache.get(code) {
    Some(result) => result
    None => {
      let result = @core.parse_package_imports(code)
      self.import_parse_cache.set(code, result)
      self.remember_import_parse_cache_key(code)
      result
    }
  }
}

///|
fn fold_constant_expr(expr : @syntax.Expr) -> RuntimeValue? {
  match expr {
    Constant(c~, ..) => Some(RuntimeValue::from_constant_with_type(c, None))
    Group(expr~, ..) => fold_constant_expr(expr)
    Unary(op~, expr~, ..) =>
      match (op.name, fold_constant_expr(expr)) {
        (Ident(name="!"), Some(Bool(value))) => Some(Bool(!value))
        (Ident(name="-"), Some(Int(value, ..))) => Some(Int(-value, raw=None))
        (Ident(name="-"), Some(Double(value))) => Some(Double(-value))
        _ => None
      }
    Infix(op~, lhs~, rhs~, ..) =>
      match op.name {
        Ident(name="&&") =>
          match fold_constant_expr(lhs) {
            Some(Bool(false)) => Some(Bool(false))
            Some(Bool(true)) => fold_constant_expr(rhs)
            _ => None
          }
        Ident(name="||") =>
          match fold_constant_expr(lhs) {
            Some(Bool(true)) => Some(Bool(true))
            Some(Bool(false)) => fold_constant_expr(rhs)
            _ => None
          }
        Ident(name~) =>
          match (fold_constant_expr(lhs), fold_constant_expr(rhs)) {
            (Some(left), Some(right)) =>
              Some(@core.runtime_value_infix(name, left, right))
            _ => None
          }
        _ => None
      }
    _ => None
  }
}

///|
fn parse_eval_code_uncached(code : String) -> CachedEvalCode {
  match @core.parse_eval_code(code) {
    Ok(parsed) =>
      match parsed {
        EvalExpr(expr) => CachedEvalResult(parsed, fold_constant_expr(expr))
        _ => CachedEvalResult(parsed, None)
      }
    Err(msg) => CachedEvalError(msg)
  }
}

///|
fn MoonBitVM::cached_eval_code(
  self : MoonBitVM,
  code : String,
) -> CachedEvalCode {
  if !source_is_cacheable(code) {
    return parse_eval_code_uncached(code)
  }
  match self.eval_parse_cache.get(code) {
    Some(entry) => entry
    None => {
      let entry = parse_eval_code_uncached(code)
      self.eval_parse_cache.set(code, entry)
      self.remember_eval_parse_cache_key(code)
      entry
    }
  }
}

///|
fn bind_compiled_args(
  vm : MoonBitVM,
  params : Array[String],
  args : Array[&ToRuntime],
) -> Unit {
  for i in 0..<params.length() {
    vm.interpreter.current_pkg.env.set(params[i], args[i].to_runtime())
  }
}

///|
fn compiled_arg_error(
  params : Array[String],
  args : Array[&ToRuntime],
) -> String? {
  if params.length() != args.length() {
    Some(
      "compiled code expects \{params.length()} arguments, got \{args.length()}",
    )
  } else {
    None
  }
}

///|
pub fn MoonBitVM::compile(
  self : MoonBitVM,
  code : String,
  params? : Array[String] = [],
) -> CompiledCode {
  let import_result = self.cached_package_imports(code)
  {
    imports: import_result.imports,
    params,
    parsed: self.cached_eval_code(import_result.code),
  }
}

///|
pub fn CompiledCode::run(
  self : CompiledCode,
  vm : MoonBitVM,
  args? : Array[&ToRuntime] = [],
  log? : Bool,
) -> EvalResult {
  let should_log = log.unwrap_or(vm.log)
  if !should_log && self.imports.length() == 0 && self.params.length() == 0 {
    match self.parsed {
      CachedEvalResult(EvalExpr(_), Some(value)) =>
        return Success(value, vm.interpreter)
      _ => ()
    }
  }
  try {
    if self.imports.length() > 0 {
      if vm.interpreter.load_declared_imports(self.imports) is Some(msg) {
        return Error(msg, vm.interpreter)
      }
    }
    match compiled_arg_error(self.params, args) {
      Some(msg) => return Error(msg, vm.interpreter)
      None => ()
    }
    match self.parsed {
      CachedEvalResult(EvalTop(_), _) if self.params.length() > 0 =>
        return Error(
          "compiled parameters are only supported for expressions",
          vm.interpreter,
        )
      _ => ()
    }
    let has_params = self.params.length() > 0
    let old_env = vm.interpreter.current_pkg.env
    if has_params {
      vm.interpreter.current_pkg.env = @core.RuntimeEnvironment::new(
        parent=old_env,
      )
      bind_compiled_args(vm, self.params, args)
    }
    defer (if has_params { vm.interpreter.current_pkg.env = old_env })
    match self.parsed {
      CachedEvalResult(EvalExpr(expr), constant_value) => {
        let result_value = match constant_value {
          Some(value) => value
          None => vm.interpreter.visit(expr)
        }
        if should_log {
          println(expr.to_json().stringify())
        }
        Success(result_value, vm.interpreter)
      }
      CachedEvalResult(EvalTop(impls, run_main~), _) => {
        let mut last_result = RuntimeValue::Unit
        impls.each(node => {
          if should_log {
            println(node.to_json().stringify())
          }
          let result = match node {
            @syntax.Impl::TopTest(expr~, is_async~, ..) =>
              vm.interpreter.run_top_test(expr, is_async)
            _ => vm.interpreter.top_visit(node)
          }
          last_result = result
        })
        if run_main {
          last_result = vm.interpreter.run_main()
        }
        Success(last_result, vm.interpreter)
      }
      CachedEvalError(msg) => Error(msg, vm.interpreter)
    }
  } catch {
    @core.ControlFlow::Error(msg) => Error(msg, vm.interpreter)
    _ => panic()
  }
}

///|
pub fn compile(
  vm : MoonBitVM,
  code : String,
  params? : Array[String] = [],
) -> CompiledCode {
  vm.compile(code, params~)
}

///|
pub fn run_compiled(
  vm : MoonBitVM,
  compiled : CompiledCode,
  args? : Array[&ToRuntime] = [],
  log? : Bool,
) -> EvalResult {
  compiled.run(vm, args~, log?)
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
  {
    interpreter,
    log,
    fast_code: None,
    fast_value: None,
    import_parse_cache: {},
    eval_parse_cache: {},
    import_parse_cache_keys: [],
    eval_parse_cache_keys: [],
  }
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
    let should_log = log.unwrap_or(self.log)
    if !should_log {
      match (self.fast_code, self.fast_value) {
        (Some(cached_code), Some(value)) if cached_code == code =>
          return Success(value, self.interpreter)
        _ => ()
      }
    }
    let source_code = code
    let import_result = self.cached_package_imports(code)
    if self.interpreter.load_declared_imports(import_result.imports)
      is Some(msg) {
      return Error(msg, self.interpreter)
    }
    let has_imports = import_result.imports.length() > 0
    let code = import_result.code
    match self.cached_eval_code(code) {
      CachedEvalResult(EvalExpr(expr), constant_value) => {
        let result_value = match constant_value {
          Some(value) => {
            if !has_imports && !should_log {
              self.fast_code = Some(source_code)
              self.fast_value = Some(value)
            }
            value
          }
          None => self.interpreter.visit(expr)
        }
        if should_log {
          println(expr.to_json().stringify())
        }
        return Success(result_value, self.interpreter)
      }
      CachedEvalResult(EvalTop(impls, run_main~), _) => {
        let mut last_result = RuntimeValue::Unit
        impls.each(node => {
          if should_log {
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
      CachedEvalError(msg) => return Error(msg, self.interpreter)
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
  let import_result = self.cached_package_imports(code)
  if self.interpreter.load_declared_imports(import_result.imports) is Some(msg) {
    return failed_test("<import>", msg)
  }
  let code = import_result.code
  let impls = match self.cached_eval_code(code) {
    CachedEvalResult(EvalTop(impls, ..), _) => impls
    CachedEvalResult(EvalExpr(_), _) =>
      return { total: 0, passed: 0, failed: 0, failures: [] }
    CachedEvalError(msg) => return failed_test("<parse>", msg)
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
