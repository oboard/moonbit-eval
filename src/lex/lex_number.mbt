// 匹配数字
// 整数和浮点数判断，在词法解析环节的实现

///|
fn is_number(ch : Int) -> Bool {
  ch >= '0' && ch <= '9'
}

///|
fn is_dot(ch : Int) -> Bool {
  ch == '.'
}

///|
priv struct ContextOfNumber {
  mut is_double : Bool
}

///|
fn lex_number(context : Context) -> Unit {
  let { offset, str, .. } = context
  let context_of_number = { is_double: false }
  let number = str.get_char(offset).unwrap_or('0').to_string()
  // println(str)
  // println(offset)
  context.offset += 1
  lex_number_rest(context, number, context_of_number)
}

///|
fn lex_number_rest(
  context : Context,
  number : String,
  context_of_number : ContextOfNumber,
) -> Unit {
  // println(number)
  let { offset, str, array } = context
  if offset >= str.length() {
    if context_of_number.is_double {
      array.push(Number_Double((try? @strconv.parse_double(number)).unwrap()))
    } else {
      array.push(Number((try? @strconv.parse_int(number)).unwrap()))
    }
    return
  }
  let ch = str[offset]
  if is_number(ch) {
    if ch.to_char() is Some(num) {
      context.offset += 1
      lex_number_rest(context, number + num.to_string(), context_of_number)
    }
  } else if is_dot(ch) {
    context.offset += 1
    if context_of_number.is_double {
      // 多个dot
      @util.die_with_error(@util.ErrorType::FloatMultiDot)
      return
    } else {
      context_of_number.is_double = true
      if ch.to_char() is Some(num) {
        lex_number_rest(context, number + num.to_string(), context_of_number)
      }
    }
  } else if context_of_number.is_double {
    array.push(Number_Double((try? @strconv.parse_double(number)).unwrap()))
  } else {
    array.push(Number((try? @strconv.parse_int(number)).unwrap()))
  }
}
