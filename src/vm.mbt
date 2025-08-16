///|
struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
}

///|
pub struct EvalResult {
  value : @syntax.Expr
}

///|
pub impl Show for EvalResult with output(self : EvalResult, logger : &Logger) -> Unit {
  logger.write_string(expr_to_string(self.value))
}

///|
pub impl Show for EvalResult with to_string(self : EvalResult) -> String {
  expr_to_string(self.value)
}

///|
pub impl ToJson for EvalResult with to_json(self : EvalResult) -> Json {
  self.value.to_json()
}

///|
pub fn MoonBitVM::new(log~ : Bool = false) -> MoonBitVM {
  let interpreter = ClosureInterpreter::new()
  interpreter.add_extern_fn("println", fn(parameters) {
    match parameters {
      @list.More(expr, ..) => {
        println(expr_to_string(expr))
        @syntax.Expr::Unit(
          loc={
            start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
            end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
          },
          faked=true,
        )
      }
      @list.Empty => {
        println("")
        @syntax.Expr::Unit(
          loc={
            start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
            end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
          },
          faked=true,
        )
      }
    }
  })
  { interpreter, log }
}

///|
pub fn MoonBitVM::create(log~ : Bool = false) -> MoonBitVM {
  MoonBitVM::new(log~)
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
    // parameters":[{"type":"Parameter::Positional","binder":{"type":"Binder","name":"a","loc":{"file":"","start":{"line":2,"column":8},"end":{"line":2,"column":9}}},"ty":{"type":"Type::Name","constr_id":{"type":"ConstrId","id":{"type":"LongIdent::Ident","0":"Int"},"loc":{"file":"","start":{"line":2,"column":11},"end":{"line":2,"column":14}}},"tys":[],"loc":{"file":"","start":{"line":2,"column":11},"end":{"line":2,"column":10}}}},{"type":"Parameter::Positional","binder":{"type":"Binder","name":"b","loc":{"file":"","start":{"line":2,"column":16},"end":{"line":2,"column":17}}
    Function(func=Lambda(parameters~, return_type~, ..), ..) => {
      // 辅助函数：将Type转换为字符串
      fn type_to_string(ty : @syntax.Type) -> String {
        match ty {
          @syntax.Type::Name(constr_id~, ..) =>
            match constr_id.id {
              @syntax.LongIdent::Ident(name~) => name
              _ => "Unknown"
            }
          _ => "Unknown"
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
    _ => ""
  }
}

///|
pub fn MoonBitVM::eval(
  self : MoonBitVM,
  code : String,
  log? : Bool,
  top~ : Bool = false,
) -> EvalResult raise Failure {
  let buf = @buffer.new()
  @encoding.encode_to(
    if top {
      code
    } else {
      "fn init {\n\{code}\n}"
    },
    buf,
    encoding=UTF8,
  )
  let (impls, diagnostics) = @moonbitlang/parser.parse_bytes(
    buf.to_bytes(),
    parser=Handrolled,
  )
  if top {
    impls.each(node => {
      if log.unwrap_or(self.log) {
        println(node.to_json().stringify())
      }
      self.interpreter.top_visit(node)
    })
    return { value: unit() }
  }
  match impls {
    @list.List::More(
      @syntax.Impl::TopFuncDef(fun_decl=_, decl_body~, loc=_),
      tail=@list.List::Empty
    ) =>
      match decl_body {
        @syntax.DeclBody::DeclBody(local_types=_, expr~) => {
          if log.unwrap_or(self.log) {
            println(expr.to_json().stringify())
          }
          return { value: self.interpreter.visit(expr) }
        }
        _ => ()
      }
    _ => {
      if !top {
        // try top eval
        return self.eval(code, log?, top=true)
      }
      fail(diagnostics.fold(init="", (acc, cur) => "\{acc}\n\{cur}"))
    }
  }
  { value: unit() }
}
