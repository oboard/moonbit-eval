// 错误类型定义
///|
pub(all) enum ErrorType {
  UnreachableCode
  LambdaPatternError
  OperatorPatternError
  TokenParseError
  IdentifierError
  AssignError
  FunctionNameError
  TypeInstantiationError
  InvalidType
  FloatMultiDot
  IllegalIdentifier
  UnexpectedToken
  MissingAlignment
} derive(Show)

// 获取错误信息

///|
pub fn error_message(error_type : ErrorType) -> String {
  match error_type {
    UnreachableCode =>
      "Unreachable code: This code path should never be executed. Please check your logic and control flow."
    LambdaPatternError =>
      "Lambda pattern error: The lambda expression does not match the expected pattern. Please ensure the syntax and structure are correct."
    OperatorPatternError =>
      "Operator pattern error: The operator pattern matching failed. Please verify the operator usage and its operands."
    TokenParseError =>
      "Token parse error: Failed to parse the token. Please check the input for invalid or unexpected tokens."
    IdentifierError =>
      "Identifier error: There is an issue with the identifier. It may be missing, invalid, or used incorrectly."
    AssignError =>
      "Assignment error: An error occurred during assignment. Please ensure the left-hand side is a valid assignable target and the types are compatible."
    FunctionNameError =>
      "Function name error: The function name is invalid or not found. Please check the function declaration and usage."
    TypeInstantiationError =>
      "Type instantiation error: There is an uninstantiated type variable. Please provide a concrete type or check type inference."
    InvalidType =>
      "Invalid type: The type provided is not valid in this context. Please check the type declaration and usage."
    FloatMultiDot =>
      "Float number error: The floating-point number contains multiple dots. Please ensure the number format is correct."
    IllegalIdentifier =>
      "Illegal identifier: The identifier used is not allowed. Please use a valid identifier name according to the language rules."
    UnexpectedToken =>
      "Unexpected token: An unexpected token was encountered during parsing. Please check the syntax near this location."
    MissingAlignment =>
      "Missing alignment: The top-level statement is not properly left-aligned. Please check the indentation and alignment of your code."
  }
}

///|
pub fn[T] die(msg : String) -> T {
  println("Error: " + msg)
  panic()
}

// 使用错误类型的die函数

///|
pub fn[T] die_with_error(error_type : ErrorType) -> T {
  die(error_message(error_type))
}

///|
pub fn[T] die_with_context(error_type : ErrorType, context : String) -> T {
  die("\{error_message(error_type)}: \{context}")
}

// 常用的快捷函数

///|
pub fn[T] unreachable() -> T {
  die_with_error(UnreachableCode)
}

///|
pub fn[T] lambda_pattern_error() -> T {
  die_with_error(LambdaPatternError)
}

///|
pub fn[T] operator_pattern_error() -> T {
  die_with_error(OperatorPatternError)
}

///|
pub fn[T] identifier_error(context : String) -> T {
  die_with_context(IdentifierError, context)
}

///|
pub fn[T] assign_error() -> T {
  die_with_error(AssignError)
}

///|
pub fn[T] function_name_error() -> T {
  die_with_error(FunctionNameError)
}
