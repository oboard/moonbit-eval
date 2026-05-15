///|
fn diagnostics_to_string(
  diagnostics : Array[@moonbitlang/parser/basic.Report],
) -> String {
  diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}")
}

///|
pub fn parse_code_to_expr(code : String) -> Result[@syntax.Expr, String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    "fn init{\n  \{code}\n}",
    parser=Handrolled,
  )
  match impls {
    @list.List::More(
      @syntax.Impl::TopFuncDef(fun_decl=_, decl_body~, loc=_),
      tail=@list.List::Empty
    ) =>
      match decl_body {
        @syntax.DeclBody::DeclBody(local_types=_, expr~) => Ok(expr)
        _ => Err("Invalid function declaration body")
      }
    _ => Err(diagnostics_to_string(diagnostics))
  }
}

///|
pub fn parse_code_to_impl(code : String) -> Result[@syntax.Impl, String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    code,
    parser=Handrolled,
  )
  match impls {
    @list.List::More(top, tail=@list.List::Empty) => Ok(top)
    _ => Err(diagnostics_to_string(diagnostics))
  }
}

///|
pub(all) enum EvalParseResult {
  EvalExpr(@syntax.Expr)
  EvalTop(@list.List[@syntax.Impl], run_main~ : Bool)
}

///|
fn parse_code_to_impls(
  code : String,
) -> Result[@list.List[@syntax.Impl], String] {
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    code,
    parser=Handrolled,
  )
  if diagnostics.length() == 0 {
    Ok(impls)
  } else {
    Err(diagnostics_to_string(diagnostics))
  }
}

///|
fn parse_code_to_impls_lenient(code : String) -> @list.List[@syntax.Impl] {
  let (impls, _) = @moonbitlang/parser.parse_string(code, parser=Handrolled)
  impls
}

///|
fn impls_have_main(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    @list.List::More(
      @syntax.Impl::TopFuncDef(fun_decl={ name: { name: "main", .. }, .. }, ..),
      ..
    ) => true
    @list.List::More(_, tail~) => impls_have_main(tail)
    @list.List::Empty => false
  }
}

///|
fn impls_have_top_decl(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    @list.List::More(@syntax.Impl::TopExpr(_), tail~) =>
      impls_have_top_decl(tail)
    @list.List::More(_, ..) => true
    @list.List::Empty => false
  }
}

///|
fn impls_have_top_expr(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    @list.List::More(@syntax.Impl::TopExpr(_), ..) => true
    @list.List::More(_, tail~) => impls_have_top_expr(tail)
    @list.List::Empty => false
  }
}

///|
fn top_item_requires_top(item : @syntax.Impl) -> Bool {
  match item {
    TopFuncDef(fun_decl~, decl_body~, ..) =>
      fun_decl.type_name is Some(_) || decl_body is DeclStubs(_)
    TopExpr(_) | TopLetDef(_) => false
    _ => true
  }
}

///|
fn impls_require_top(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    @list.List::More(item, tail~) =>
      if top_item_requires_top(item) {
        true
      } else {
        impls_require_top(tail)
      }
    @list.List::Empty => false
  }
}

///|
pub fn parse_eval_code(code : String) -> Result[EvalParseResult, String] {
  let top_result = parse_code_to_impls(code)
  match top_result {
    Ok(impls) if impls_have_main(impls) => Ok(EvalTop(impls, run_main=true))
    _ => {
      let lenient_impls = parse_code_to_impls_lenient(code)
      if impls_require_top(lenient_impls) && !impls_have_top_expr(lenient_impls) {
        return Ok(EvalTop(lenient_impls, run_main=false))
      }
      match parse_code_to_expr(code) {
        Ok(expr) => Ok(EvalExpr(expr))
        Err(expr_err) =>
          match top_result {
            Ok(impls) => Ok(EvalTop(impls, run_main=false))
            Err(top_err) =>
              if impls_have_top_decl(lenient_impls) {
                Ok(EvalTop(lenient_impls, run_main=false))
              } else {
                Err("\{expr_err}\n\{top_err}")
              }
          }
      }
    }
  }
}
