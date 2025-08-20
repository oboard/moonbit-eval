///|
pub(all) struct MoonBitVM {
  interpreter : ClosureInterpreter
  log : Bool
}

///|
pub struct EvalResult {
  value : RuntimeValue
  interpreter : ClosureInterpreter
}

///|
pub impl Show for EvalResult with output(self : EvalResult, logger : &Logger) -> Unit {
  logger.write_string(self.to_string())
}

///|
pub impl Show for EvalResult with to_string(self : EvalResult) -> String {
  match self.value {
    RuntimeValue::Closure(_) =>
      self.interpreter.get_function_type_string(self.value)
    _ => self.value.to_string()
  }
}

///|
pub fn MoonBitVM::new(log~ : Bool = false, core~ : Bool = true) -> MoonBitVM {
  let interpreter = ClosureInterpreter::new(core~)
  interpreter.add_extern_fn("println", ctx => match ctx.arguments {
    [{ value, .. }, ..] => {
      println(value)
      Unit
    }
    _ => Unit
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
  top~ : Bool = false,
) -> EvalResult raise Failure {
  if top {
    let buf = @buffer.new()
    @encoding.encode_to(code, buf, encoding=UTF8)
    let (impls, diagnostics) = @moonbitlang/parser.parse_bytes(
      buf.to_bytes(),
      parser=Handrolled,
    )
    impls.each(node => {
      if log.unwrap_or(self.log) {
        println(node.to_json().stringify())
      }
      self.interpreter.start()
      self.interpreter.top_visit(node)
      self.interpreter.stop()
    })
    return { value: RuntimeValue::Unit, interpreter: self.interpreter }
  }
  match @interpreter.parse_code_to_expr(code) {
    Ok(expr) => {
      self.interpreter.start()
      let result_value = self.interpreter.visit(expr)
      self.interpreter.stop()
      if log.unwrap_or(self.log) {
        println(expr.to_json().stringify())
      }
      { value: result_value, interpreter: self.interpreter }
    }
    Err(_) =>
      // try top eval
      return self.eval(code, log?, top=true)
  }
}
