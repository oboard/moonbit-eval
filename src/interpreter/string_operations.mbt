///|
/// 字符串操作模块 - 处理字符串插值和多行字符串

///|
/// 处理字符串插值
pub fn ClosureInterpreter::interp_string(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.InterpElem],
) -> String raise ControlFlow {
  let buffer = @buffer.new()
  for elem in elems {
    match elem {
      Expr(expr~, ..) => buffer.write_string(self.visit(expr).to_string())
      Literal(repr~, ..) => buffer.write_string(repr)
      Source({ source, .. }) =>
        match parse_code_to_expr(source) {
          Ok(expr) => buffer.write_string(self.visit(expr).to_string())
          Err(msg) => self.error(msg)
        }
    }
  }
  buffer.to_string()
}

///|
/// 处理多行字符串
pub fn ClosureInterpreter::visit_multiline_string(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.MultilineStringElem],
) -> RuntimeValue raise ControlFlow {
  let buf = @buffer.new()
  elems.eachi(fn(i, elem) {
    match elem {
      String(str) => buf.write_string(str)
      Interp(elems) => buf.write_string(self.interp_string(elems))
    }
    if i < elems.length() - 1 {
      buf.write_string("\n")
    }
  })
  String(buf.to_string())
}

///|
/// 处理字符串插值表达式 (Interp)
pub fn ClosureInterpreter::visit_interp(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.InterpElem],
) -> RuntimeValue raise ControlFlow {
  String(self.interp_string(elems))
}
