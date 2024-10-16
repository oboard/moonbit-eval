// 较大的词法单元列表，参考https://github.com/rust-lang/rust/blob/master/compiler/rustc_ast/src/token.rs

// Token枚举用于表示源代码中识别出的词法单元。
pub enum Token_max {
  Number(Int) //  整数
  Identifier(String)  // 标识符

  // 声明类型or调用函数
  Unit  // Unit
  Bool  // Bool
  Int   // Int
  Double  // Double
  Array // Array
  Main  // main
  Not // not

  // 循环
  Loop  // loop
  For // for
  While // while

  // 关键词
  Let       //  let
  If        //  if
  Else      //  else
  Fn        //  fn
  True    // ture
  False    // false

  // 运算符号
  Add //  +
  Sub //  -
  Mul //  *  
  Div //  /
  
  Assign  // =
  EqEq // ==
  Lt // <
  Le  // <=
  Ne  // !=
  Ge  // >=
  Gt  // >

  // 标点符号
  Comma //  ,
  Semicolon //  ;
  Colon     //  :
  // ！
  Question// ？

  // 括号
  LParen    //  (
  RParen    //  )
  LBracket  //  [
  RBracket  //  ]
  LBrace    //  {
  RBrace    //  }

  // 其他
  Arrow // ->
  Comment // 注释//
  // WS // [ \t\r\n]+ -> skip
  // 等等
  
} derive(Show)