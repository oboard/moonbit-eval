// 使用type定义一个新类型：这个新类型是一个函数(输入token数组，输出解析V和剩余token数组)

///|
type Parser[V] (ArrayView[@lex.Token]) -> (V, ArrayView[@lex.Token])?

// 基础解析器：解析词法单元（并将词法单元映射为语法单元）

///|
let lparen : Parser[@lex.Token] = ptoken(x => match x {
  LParen => true
  _ => false
})

///|
let rparen : Parser[@lex.Token] = ptoken(x => match x {
  RParen => true
  _ => false
})

// let lparen_skip : Parser[@lex.Token] = ptoken_skip(
//   x => match x {
//     LParen => true
//     _ => false
//   },
// )

// let rparen_skip : Parser[@lex.Token] = ptoken_skip(
//   x => match x {
//     RParen => true
//     _ => false
//   },
// )

// let lparen_not : Parser[@lex.Token] = ptoken_not(
//   x => match x {
//     LParen => true
//     _ => false
//   },
// )

// let rparen_not : Parser[@lex.Token] = ptoken_not(
//   x => match x {
//     RParen => true
//     _ => false
//   },
// )

///|
let lbrace : Parser[@lex.Token] = ptoken(x => match x {
  LBrace => true
  _ => false
})

///|
let rbrace : Parser[@lex.Token] = ptoken(x => match x {
  RBrace => true
  _ => false
})

///|
let compares : Parser[@lex.Token] = ptoken(x => match x {
  EqEq | GreaterEqual | GreaterThan | LessEqual | LessThan => true
  _ => false
})

///|
let mul_div : Parser[@lex.Token] = ptoken(x => match x {
  Mul | Div => true
  _ => false
})

///|
let add_sub : Parser[@lex.Token] = ptoken(x => match x {
  Add | Sub => true
  _ => false
})

///|
let semicolon : Parser[@lex.Token] = ptoken(x => match x {
  Semicolon => true
  _ as neg_semicolon => {
    println("\{neg_semicolon}并非Semicolon")
    false
  }
})

// let newline : Parser[@lex.Token] = ptoken(
//   x => match x {
//     Newline => true
//     _ => false
//   },
// )

// let newline_skip : Parser[@lex.Token] = ptoken_skip(
//   x => match x {
//     Newline => true
//     _ => false
//   },
// )

///|
let separator : Parser[@lex.Token] = ptoken(x => match x {
  Semicolon | Newline => true
  _ => false
})

///|
let separator_skip : Parser[@lex.Token] = ptoken_skip(x => match x {
  Semicolon | Newline => true
  _ => false
})

///|
let semicolon_skip : Parser[@lex.Token] = ptoken_skip(x => match x {
  Semicolon => true
  _ => false
})

// let colon : Parser[@lex.Token] = ptoken(
//   x => match x {
//     Colon => true
//     _ => false
//   },
// )

///|
let colon_skip : Parser[@lex.Token] = ptoken_skip(x => match x {
  Colon => true
  _ => false
})

// let comma : Parser[@lex.Token] = ptoken(
//   x => match x {
//     Comma => true
//     _ => false
//   },
// )

///|
let comma_skip : Parser[@lex.Token] = ptoken_skip(x => match x {
  Comma => true
  _ => false
})

///|
let assign : Parser[@lex.Token] = ptoken(x => match x {
  Assign => true
  AddEqual => true
  SubEqual => true
  MulEqual => true
  DivEqual => true
  _ => false
})

// let arrow : Parser[@lex.Token] = ptoken(
//   x => match x {
//     Array => true
//     _ => false
//   },
// )

// let pure : Parser[@lex.Token] = ptoken(
//     x => match x {
//       _ => true
//     },
// )

///|
let string : Parser[@types.Syntax] = ptoken(x => match x {
  StringLiteral(_) => true
  _ => false
}).map(x => match x {
  StringLiteral(value) => @types.Syntax::String(value)
  _ => @util.die("")
})

///|
let number : Parser[@types.Syntax] = ptoken(x => match x {
  Number(_) => true
  Number_Double(_) => true
  _ => false
}).map(x => match x {
  Number(value) => @types.Syntax::Int(value)
  Number_Double(value) => @types.Syntax::Double(value)
  _ => @util.die("")
})

///|
let add_sub_number : Parser[@types.Syntax] = add_sub
  .andBind(
    ptoken(x => match x {
      @lex.Token::Number(_) => true
      @lex.Token::Number_Double(_) => true
      _ => false
    }),
  )
  .map(x => match x {
    (Add, Number(value)) => @types.Syntax::Neg(@types.Syntax::Int(value))
    (Sub, Number(value)) => @types.Syntax::Neg(@types.Syntax::Int(value))
    (Add, Number_Double(value)) =>
      @types.Syntax::Neg(@types.Syntax::Double(value))
    (Sub, Number_Double(value)) =>
      @types.Syntax::Neg(@types.Syntax::Double(value))
    _ => @util.die("")
  })

///|
let boolean : Parser[@types.Syntax] = ptoken(x => match x {
  @lex.Token::True | @lex.Token::False => true
  _ => false
}).map(x => match x {
  @lex.Token::True => @types.Syntax::Bool(true)
  @lex.Token::False => @types.Syntax::Bool(false)
  _ => @util.die("Unexpected token in boolean parser")
})

///|
let variable : Parser[@types.Syntax] = ptoken(x => match x { // 变量
  Identifier(_) => true
  _ => false
}).map(x => match x {
  @lex.Token::Identifier(name) => @types.Syntax::Var(name)
  _ => @util.die("Unexpected token in var parser")
})

///|
let add_sub_var : Parser[@types.Syntax] = add_sub
  .andBind(
    ptoken(x => match x { // 变量
      Identifier(_) => true
      _ => false
    }),
  )
  .map(x => match x {
    (Add, Identifier(name)) => @types.Syntax::Neg(@types.Syntax::Var(name))
    (Sub, Identifier(name)) => @types.Syntax::Neg(@types.Syntax::Var(name))
    _ => @util.die("add_sub_var错误")
  })

// let parse_type : Parser[@types.Type] = ptoken(
//   x => match x {
//       Unit => true
//       Bool => true
//       Int => true
//       Double => true
//       Tuple => true
//       Array => true
//       _ => false
//     },
//   ).map(x => match x {
//     Unit => @types.Type::Unit
//     Bool => @types.Type::Bool
//     Int => @types.Type::Int
//     Double => @types.Type::Double
//     // Tuple => @types.Type::Tuple(Array[Type])  // todo
//     // todo
//     })

///|
let parse_type_skip : Parser[@types.Type] = ptoken_skip(x => match x {
  Unit => true
  Bool => true
  Int => true
  String => true
  Double => true
  Tuple => true
  Array => true
  _ => false
}).map(x => match x {
  Unit => @types.Type::Unit
  Bool => @types.Type::Bool
  Int => @types.Type::Int
  Double => @types.Type::Double
  String => @types.Type::String
  // Tuple => @types.Type::Tuple(Array[Type])  // todo
  // todo
  _ => @types.Type::Var({ val: None })
})
