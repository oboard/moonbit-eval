///|
struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
}

///|
pub fn MoonBitVM::new(log~ : Bool = false) -> MoonBitVM {
  let interpreter = ClosureInterpreter::new()
  // interpreter.add_extern_fn("println", fn(arr) {
  //   match arr[0] {
  //     Int(i) => println(i)
  //     Double(i) => println(i)
  //     Bool(i) => println(i)
  //     String(i) => println(i)
  //     _ => println("Unknown type")
  //   }
  //   @syntax.Constant::Int("0")
  // })
  { interpreter, log }
}

///|
pub fn MoonBitVM::eval_to_str(
  self : MoonBitVM,
  code : String,
  log? : Bool,
) -> String {
  self.eval(code, log?) |> expr_to_string
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
    Unit(..) => "Unit"
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
    _ => ""
  }
}

///|
pub fn MoonBitVM::eval(
  self : MoonBitVM,
  code : String,
  log? : Bool,
) -> @syntax.Expr {
  // let tokens = []
  // @lex.lex({ str: code, offset: 0, array: tokens })
  // if log.unwrap_or(self.log) {
  //   println(tokens)
  // }
  let buf = @buffer.new()
  @encoding.encode_to("fn init {\n\{code}\n}", buf, encoding=UTF8)
  let (impls, _diagnostics) = @moonbitlang/parser.parse_bytes(
    buf.to_bytes(),
    parser=Handrolled,
  )
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
          return self.interpreter.visit(expr)
        }
        _ => ()
      }
    _ => ()
  }
  @syntax.Expr::Unit(
    loc={
      start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
      end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
    },
    faked=true,
  )
  // match @parser.parse_syntax(tokens) {
  //   Some((expr, _)) => {
  //     if log.unwrap_or(self.log) {
  //       println(expr)
  //     }
  //     self.interpreter.visit(expr)
  //   }
  //   None => @syntax.Constant::Int("0")
  // }
}
