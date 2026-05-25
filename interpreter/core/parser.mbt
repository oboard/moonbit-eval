///|
fn diagnostics_to_string(
  diagnostics : Array[@moonbitlang/parser/basic.Report],
) -> String {
  diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}")
}

///|
pub fn parse_code_to_expr(code : String) -> Result[@syntax.Expr, String] {
  let code = normalize_v092_syntax(code)
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    "fn init{\n  \{code}\n}",
    parser=Handrolled,
  )
  match impls {
    More(TopFuncDef(fun_decl=_, decl_body~, where_clause=_, loc=_), tail=Empty) =>
      match decl_body {
        DeclBody(expr~) => Ok(expr)
        _ => Err("Invalid function declaration body")
      }
    _ => Err(diagnostics_to_string(diagnostics))
  }
}

///|
pub fn parse_code_to_impl(code : String) -> Result[@syntax.Impl, String] {
  let code = normalize_v092_syntax(code)
  let (impls, diagnostics) = @moonbitlang/parser.parse_string(
    code,
    parser=Handrolled,
  )
  match impls {
    More(top, tail=Empty) => Ok(top)
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
  let code = normalize_v092_syntax(code)
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
  let code = normalize_v092_syntax(code)
  let (impls, _) = @moonbitlang/parser.parse_string(code, parser=Handrolled)
  impls
}

///|
fn impls_have_main(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    More(TopFuncDef(fun_decl={ name: { name: "main", .. }, .. }, ..), ..) =>
      true
    More(_, tail~) => impls_have_main(tail)
    Empty => false
  }
}

///|
fn impls_have_top_decl(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    More(TopExpr(_), tail~) => impls_have_top_decl(tail)
    More(_, ..) => true
    Empty => false
  }
}

///|
fn impls_have_top_expr(impls : @list.List[@syntax.Impl]) -> Bool {
  match impls {
    More(TopExpr(_), ..) => true
    More(_, tail~) => impls_have_top_expr(tail)
    Empty => false
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
    More(item, tail~) =>
      if top_item_requires_top(item) {
        true
      } else {
        impls_require_top(tail)
      }
    Empty => false
  }
}

///|
fn repair_top_expr_hole(item : @syntax.Impl, code : String) -> @syntax.Impl {
  match item {
    TopExpr(expr=Hole(loc~, ..), is_main~, is_async~, loc=top_loc) => {
      let start = loc.start.cnum.clamp(min=0, max=code.length())
      let snippet = code[start:].to_owned()
      match parse_code_to_expr(snippet) {
        Ok(expr) => TopExpr(expr~, is_main~, is_async~, loc=top_loc)
        Err(_) => item
      }
    }
    _ => item
  }
}

///|
fn repair_top_expr_holes(
  impls : @list.List[@syntax.Impl],
  code : String,
) -> @list.List[@syntax.Impl] {
  match impls {
    More(item, tail~) =>
      @list.cons(
        repair_top_expr_hole(item, code),
        repair_top_expr_holes(tail, code),
      )
    Empty => @list.new()
  }
}

///|
pub fn parse_eval_code(code : String) -> Result[EvalParseResult, String] {
  let code = normalize_v092_syntax(code)
  let top_result = parse_code_to_impls(code)
  match top_result {
    Ok(impls) if impls_have_main(impls) => Ok(EvalTop(impls, run_main=true))
    Ok(impls) if impls_require_top(impls) =>
      Ok(EvalTop(repair_top_expr_holes(impls, code), run_main=false))
    _ => {
      let lenient_impls = parse_code_to_impls_lenient(code)
      if impls_require_top(lenient_impls) && !impls_have_top_expr(lenient_impls) {
        return Ok(
          EvalTop(repair_top_expr_holes(lenient_impls, code), run_main=false),
        )
      }
      match parse_code_to_expr(code) {
        Ok(expr) => Ok(EvalExpr(expr))
        Err(expr_err) =>
          match top_result {
            Ok(impls) => Ok(EvalTop(impls, run_main=false))
            Err(top_err) =>
              if impls_have_top_decl(lenient_impls) {
                Ok(
                  EvalTop(
                    repair_top_expr_holes(lenient_impls, code),
                    run_main=false,
                  ),
                )
              } else {
                Err("\{expr_err}\n\{top_err}")
              }
          }
      }
    }
  }
}
