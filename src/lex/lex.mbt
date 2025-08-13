// minimoonbit词法解析

///|
pub let token_postion : TokenPosition = {
  token_number: 0,
  line: 1,
  column_start: 1,
  column_end: 1,
}

///|
pub let token_postion_array : Array[TokenPosition] = []

///|
pub(all) struct Context {
  str : String
  mut offset : Int
  array : Array[Token]
} derive(Show)

///|
pub fn lex(context : Context) -> Unit {
  // 方法1
  // 基于字符匹配，进行状态转移
  let { offset, str, array } = context
  if offset >= str.length() {
    return
  }
  match str[offset] {
    // 运算符
    '+' => {
      context.offset += 1
      if context.offset < str.length() && str[context.offset] == '=' {
        context.offset += 1
        array.push(AddEqual)
      } else {
        array.push(Add)
      }
    }
    '-' => {
      context.offset += 1
      if context.offset < str.length() && str[context.offset] == '>' {
        context.offset += 1
        array.push(Arrow)
      } else if context.offset < str.length() && str[context.offset] == '=' {
        context.offset += 1
        array.push(SubEqual)
      } else {
        array.push(Sub)
      }
    }
    '*' => {
      array.push(Mul)
      context.offset += 1
    }
    '/' => {
      context.offset += 1
      if context.offset < str.length() && str[context.offset] == '/' {
        context.offset += 1
        // array.push(Comment)
        // 直到出现换行符，注释才结束
        while context.offset < str.length() {
          if str[context.offset] == '\n' {
            context.offset += 1
            token_postion.line += 1
            token_postion.column_start = 1
            break
          } else if str[context.offset] == '\r' &&
            str[context.offset + 1] == '\n' {
            context.offset += 2
            token_postion.line += 1
            token_postion.column_start = 1
            break
          } else {
            context.offset += 1
            continue
          }
        }
      } else if context.offset < str.length() && str[context.offset] == '=' {
        context.offset += 1
        array.push(DivEqual)
      } else {
        array.push(Div)
      }
    }
    '=' =>
      // 支持 =>
      if context.offset + 1 < str.length() && str[context.offset + 1] == '>' {
        context.offset += 2
        array.push(Arrow)
      } else {
        // ==
        context.offset += 1
        if context.offset < str.length() && str[context.offset] == '=' {
          context.offset += 1
          array.push(EqEq)
        } else {
          array.push(Assign)
        }
      }
    '>' => {
      context.offset += 1
      if context.offset < str.length() && str[context.offset] == '=' {
        context.offset += 1
        array.push(GreaterEqual)
      } else {
        array.push(GreaterThan)
      }
    }
    '<' => {
      context.offset += 1
      if context.offset < str.length() && str[context.offset] == '=' {
        context.offset += 1
        array.push(LessEqual)
      } else {
        array.push(LessThan)
      }
    }
    '(' => {
      array.push(LParen)
      context.offset += 1
    }
    ')' => {
      array.push(RParen)
      context.offset += 1
    }
    '{' => {
      context.array.push(LBrace)
      context.offset += 1

      // push后立刻记录再过滤换行
      if context.array.length() > token_postion.token_number {
        token_postion.token_number = context.array.length()
        token_postion.column_end = token_postion.column_start +
          (context.offset - offset)
        // token_postion_array.push(token_postion) // 同值
        token_postion_array.push({
          token_number: token_postion.token_number,
          line: token_postion.line,
          column_start: token_postion.column_start,
          column_end: token_postion.column_end,
        })
        token_postion.column_start = token_postion.column_end
        // println(token_postion_array)
      }
      // 过滤换行符
      while context.offset < str.length() {
        if str[context.offset] == '\n' {
          context.offset += 1
          token_postion.line += 1
          token_postion.column_start = 1
        } else if str[context.offset] == '\r' && str[context.offset + 1] == '\n' {
          context.offset += 2
          token_postion.line += 1
          token_postion.column_start = 1
        } else {
          break
        }
      }
    }
    '}' => {
      context.array.push(RBrace)
      context.offset += 1

      // push后立刻记录再过滤换行
      if context.array.length() > token_postion.token_number {
        token_postion.token_number = context.array.length()
        token_postion.column_end = token_postion.column_start +
          (context.offset - offset)
        // token_postion_array.push(token_postion) // 同值
        token_postion_array.push({
          token_number: token_postion.token_number,
          line: token_postion.line,
          column_start: token_postion.column_start,
          column_end: token_postion.column_end,
        })
        token_postion.column_start = token_postion.column_end
        // println(token_postion_array)
      }
      // 过滤换行符
      while context.offset < str.length() {
        if str[context.offset] == '\n' {
          context.offset += 1
          token_postion.line += 1
          token_postion.column_start = 1
        } else if str[context.offset] == '\r' && str[context.offset + 1] == '\n' {
          context.offset += 2
          token_postion.line += 1
          token_postion.column_start = 1
        } else {
          break
        }
      }
    }
    '[' => {
      context.array.push(LBracket)
      context.offset += 1
    }
    ']' => {
      context.array.push(RBracket)
      context.offset += 1
    }
    '"' => {
      // context.array.push(DoubleQuote)
      context.offset += 1
      lex_string_or_template(context)
    }
    '\'' => {
      context.array.push(SingleQuote)
      context.offset += 1
    }
    '\n' => {
      context.array.push(Newline) // 识别为LF(Line Feed) 换行符（linux or mac os）
      context.offset += 1
      token_postion.line += 1
      token_postion.column_start = 0
    }
    '\r' => {
      // 检查下一个字符是否为 '\n'，如果是，将其作为单一的 Newline 处理（windows）
      context.offset += 1
      if str[context.offset] == '\n' {
        context.array.push(Newline) // 识别为LF(Line Feed) 换行符
        context.offset += 1
        token_postion.line += 1
        token_postion.column_start = -1
      } else {
        // 没有push词法单元
        token_postion.column_start += 1
      }
    }
    ' ' | '\t' => {
      // 空格等直接忽略，没有push词法单元
      context.offset += 1
      token_postion.column_start += 1
    }
    ',' => {
      context.array.push(Comma)
      context.offset += 1
    }
    ';' => {
      context.array.push(Semicolon)
      context.offset += 1
      // push后：先记录再换行
      if context.array.length() > token_postion.token_number {
        token_postion.token_number = context.array.length()
        token_postion.column_end = token_postion.column_start +
          (context.offset - offset)
        // token_postion_array.push(token_postion) // 同值
        token_postion_array.push({
          token_number: token_postion.token_number,
          line: token_postion.line,
          column_start: token_postion.column_start,
          column_end: token_postion.column_end,
        })
        token_postion.column_start = token_postion.column_end
        // println(token_postion_array)
      }
      // 过滤换行符
      while context.offset < str.length() {
        if str[context.offset] == '\n' {
          context.offset += 1
          token_postion.line += 1
          token_postion.column_start = 1
        } else if str[context.offset] == '\r' && str[context.offset + 1] == '\n' {
          context.offset += 2
          token_postion.line += 1
          token_postion.column_start = 1
        } else {
          break
        }
      }
    }
    ':' => {
      // todo ：：
      context.array.push(Colon)
      context.offset += 1
    }
    ch =>
      if is_number(ch) {
        // 数字
        lex_number(context)
      } else if is_alpha(ch) {
        // 关键字和标识符
        lex_identifier(context)
      } else {
        println("unknown character: \{ch}")
        // panic()
      }
  }
  if context.array.length() > token_postion.token_number {
    token_postion.token_number = context.array.length()
    token_postion.column_end = token_postion.column_start +
      (context.offset - offset)
    // token_postion_array.push(token_postion) // 同值
    token_postion_array.push({
      token_number: token_postion.token_number,
      line: token_postion.line,
      column_start: token_postion.column_start,
      column_end: token_postion.column_end,
    })
    token_postion.column_start = token_postion.column_end
    // println(token_postion_array)
  }
  // println(context.array)
  lex(context)
}

///|
test {
  let array = []
  lex({ str: "-10123 -+ - 523 103 (5))", offset: 0, array })
  inspect(
    array,
    content="[Sub, Number(10123), Sub, Add, Sub, Number(523), Number(103), LParen, Number(5), RParen, RParen]",
  )
  let array = []
  lex({ str: "let a=1", offset: 0, array })
  inspect(array, content="[Let, Identifier(\"a\"), Assign, Number(1)]")
  let array = []
  lex({ str: "let b1=11", offset: 0, array })
  // println(array)
  inspect(array, content="[Let, Identifier(\"b1\"), Assign, Number(11)]")
  let array = []
  lex({ str: "let a=Int(11)", offset: 0, array })
  // println(array)
  inspect(
    array,
    content="[Let, Identifier(\"a\"), Assign, Int, LParen, Number(11), RParen]",
  )
  let array = []
  lex({ str: "let a=Int(11)\nlet b:Int =1", offset: 0, array })
  // println(array)
  inspect(
    array,
    content="[Let, Identifier(\"a\"), Assign, Int, LParen, Number(11), RParen, Newline, Let, Identifier(\"b\"), Colon, Int, Assign, Number(1)]",
  )

  // 多行表达式
  let input = "1/2-3 \n4*5+6"
  let tokens = []
  lex({ str: input, offset: 0, array: tokens })
  // println(tokens)
  inspect(
    tokens,
    content="[Number(1), Div, Number(2), Sub, Number(3), Newline, Number(4), Mul, Number(5), Add, Number(6)]",
  )
  // 多行let todo check type
  let array = []
  lex({ str: "let 1=Int(11)\nlet 2:Int =1", offset: 0, array })
  // println(array)
  inspect(
    array,
    content="[Let, Number(1), Assign, Int, LParen, Number(11), RParen, Newline, Let, Number(2), Colon, Int, Assign, Number(1)]",
  )
}

///|
fn lex_string_or_template(context : Context) -> Unit {
  let parts : Array[(String, @types.Syntax?)] = []
  let mut current_text = ""
  while context.offset < context.str.length() &&
        context.str[context.offset] != '"' {
    if context.str[context.offset] == '\\' &&
      context.offset + 1 < context.str.length() &&
      context.str[context.offset + 1] == '{' {
      // 找到模板字符串插值开始
      if current_text.length() > 0 {
        parts.push((current_text, None))
        current_text = ""
      }
      context.offset += 2 // 跳过 \{
      let expr_start = context.offset
      let mut brace_count = 1

      // 找到匹配的右大括号
      while context.offset < context.str.length() && brace_count > 0 {
        if context.str[context.offset] == '{' {
          brace_count += 1
        } else if context.str[context.offset] == '}' {
          brace_count -= 1
        }
        if brace_count > 0 {
          context.offset += 1
        }
      }
      if brace_count == 0 {
        let expr_str = context.str.substring(
          start=expr_start,
          end=context.offset,
        )
        // 解析表达式字符串为 Syntax
        let tokens = []
        lex({ str: expr_str, offset: 0, array: tokens })
        // 简单解析：尝试解析基本的二元表达式
        let expr_syntax = match parse_simple_expression(tokens[:]) {
          Some(syntax) => Some(syntax)
          None => Some(@types.Syntax::Var(expr_str)) // fallback
        }
        parts.push(("", expr_syntax))
        context.offset += 1 // 跳过 }
      } else {
        // 未匹配的大括号，当作普通文本处理
        current_text += "\\{"
        context.offset = expr_start
      }
    } else {
      match context.str[context.offset].to_char() {
        Some(ch) => current_text += ch.to_string()
        None => current_text += "?"
      }
      context.offset += 1
    }
  }

  // 添加剩余的文本部分
  if current_text.length() > 0 {
    parts.push((current_text, None))
  }

  // 判断是普通字符串还是模板字符串
  let mut has_interpolation = false
  for part in parts {
    match part.1 {
      Some(_) => {
        has_interpolation = true
        break
      }
      None => continue
    }
  }
  if has_interpolation {
    context.array.push(TemplateString(parts))
  } else {
    // 普通字符串 - 如果没有插值，直接合并所有文本部分
    let mut literal = ""
    for part in parts {
      literal += part.0
    }
    context.array.push(StringLiteral(literal))
  }
  context.offset += 1 // 跳过结束的双引号
}

// 简单表达式解析器，用于模板字符串中的表达式

///|
fn parse_simple_expression(tokens : ArrayView[Token]) -> @types.Syntax? {
  match tokens {
    // 解析 "var + var" 形式
    [Identifier(var1), Add, Identifier(var2)] =>
      Some(
        @types.Syntax::Prim(
          @types.Syntax::Var(var1),
          @types.Syntax::Var(var2),
          @types.Op::Add,
        ),
      )
    // 解析 "var - var" 形式
    [Identifier(var1), Sub, Identifier(var2)] =>
      Some(
        @types.Syntax::Prim(
          @types.Syntax::Var(var1),
          @types.Syntax::Var(var2),
          @types.Op::Sub,
        ),
      )
    // 解析单个变量
    [Identifier(variable)] => Some(@types.Syntax::Var(variable))
    // 解析单个数字
    [Number(num)] => Some(@types.Syntax::Int(num))
    // 其他情况返回 None
    _ => None
  }
}
