// 匹配关键词和标识符
// 判断字符是否为字母或下划线
fn is_alpha(ch : Char) -> Bool {
  (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_'
}

// 判断字符是否为字母或数字或下划线
fn is_alphanumeric(ch : Char) -> Bool {
  is_alpha(ch) || (ch >= '0' && ch <= '9')
}

// 匹配关键词和标识符
fn lex_identifier(context : Context) -> Unit {
  let start = context.offset
  while context.offset < context.str.length() &&
        is_alphanumeric(context.str[context.offset]) {
    context.offset += 1
  }
  let ident = context.str.substring(start~, end=context.offset)
  if ident[0] == '_' && ident.length() > 1 {
    @util.die("非法标识符'_' from \{ident}")
  }
  let array = context.array
  array.push(
    match ident {
      // 关键词
      "let" => Let
      "for" => For
      "mut" => Mut
      "if" => If
      "else" => Else
      "fn" => Fn
      "true" => True
      "false" => False
      "Unit" => Unit
      "Bool" => Bool
      "Int" => Int
      "Double" => Double
      "String" => String
      "Array" => Array
      "main" => Main // 自定义关键词,添加()方便解析。
      // context.array.push(LParen)  
      // context.array.push(RParen)
      "not" => Not

      // 标识符
      _ =>
        if context.offset < context.str.length() &&
          context.str[context.offset] == '(' {
          Fun_name(ident)
        } else {
          Identifier(ident)
        }
    },
  )
}
