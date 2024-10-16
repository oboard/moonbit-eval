// 匹配关键词和标识符
// 判断字符是否为字母或下划线
fn is_alpha(ch: Char) -> Bool {
  (ch >= 'a' && ch <= 'z') ||
  (ch >= 'A' && ch <= 'Z') ||
  ch == '_'
}

// 判断字符是否为字母或数字或下划线
fn is_alphanumeric(ch: Char) -> Bool {
  is_alpha(ch) || (ch >= '0' && ch <= '9')
}

// 匹配关键词和标识符
fn lex_identifier(context: Context) -> Unit {
  let start = context.offset
  while context.offset < context.str.length() && is_alphanumeric(context.str[context.offset]) {
    context.offset += 1
  }
  let ident = context.str.substring(start=start,end=context.offset)
  
  if ident[0]=='_' && ident.length()>1{
    @util.die("非法标识符'_' from \{ident}")
  }

  match ident {
    // 关键词
    "let" => context.array.push(Let)
    "if" => context.array.push(If)
    "else" => context.array.push(Else)
    "fn" => context.array.push(Fn)
    "true" => context.array.push(True)
    "false" => context.array.push(False)

    "Unit" => context.array.push(Unit)
    "Bool" => context.array.push(Bool)
    "Int" => context.array.push(Int)
    "Double" => context.array.push(Double)
    "Array" => context.array.push(Array)
    "main" => {
      context.array.push(Main)  // 自定义关键词,添加()方便解析。
      // context.array.push(LParen)  
      // context.array.push(RParen)
    }
    "not" => context.array.push(Not)

    // 标识符
    _ => {
      if context.offset<context.str.length() && context.str[context.offset]=='('{
          context.array.push(Fun_name(ident))
      }else{
          context.array.push(Identifier(ident))
      }
    }
  }
}