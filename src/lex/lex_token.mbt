// minimoonbit编程语言的词法单元列表，参考MiniMoonBit.g4文件

// Token枚举用于表示源代码中识别出的词法单元。
// issues
// 1、暂时保留所有token，等待删除部分token
// 2、minimoonbit中token部分命名和moonbit关键词相同
///|
pub(all) enum Token {
  // 数据
  Number(Int) //  整数
  Number_Double(Double) //  浮点数

  // 标识符 对应语法中Var(String)
  Identifier(String) // 变量名
  Fun_name(String) // 函数名
  StringLiteral(String) // 字符串

  // 声明类型or调用函数
  Unit // Unit
  Bool // Bool
  Int // Int
  Double // Double
  String // String
  Tuple // Tuple
  Array // Array
  Main // main
  Not // not

  // 循环
  Loop // loop
  For // for
  While // while

  // 一般关键词
  Let //  let
  Mut //  mut
  If //  if
  Else //  else
  Fn //  fn
  True // ture
  False // false

  // 运算符号
  Add //  +
  AddEqual // +=
  Sub //  -
  SubEqual // -=
  Mul //  *  
  MulEqual // *=
  Div //  /
  DivEqual // /=
  Assign // =
  EqEq // ==
  LessThan // <
  LessEqual // <=
  NotEqual // !=
  GreaterThan // >
  GreaterEqual // >=

  // 标点符号
  Comma //  ,
  Semicolon //  ;
  Colon //  :
  PathSep // ::
  // ！
  Question // ？

  // 双引号
  DoubleQuote //  "
  // 单引号
  SingleQuote //  '

  // 括号
  LParen //  (
  RParen //  )
  LBracket //  [
  RBracket //  ]
  LBrace //  {
  RBrace //  }

  // 其他
  Arrow // ->
  Comment // 注释
  Newline // \n on linux or mac, \r\n on windows
  // WS // [ \t\r\n]+ -> skip
  // 等等
  Skip // ptoken skip!
} derive(Show, Eq)

// todo support debug etc.

///|
pub(all) struct TokenPosition {
  mut token_number : Int
  mut line : Int // 行号
  mut column_start : Int // 列号开始
  mut column_end : Int // 列号结束
} derive(Show)
