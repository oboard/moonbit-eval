// 词法解析的上下文
///|
struct ParserContext {
  mut is_top_level : Bool // 假定不在block中即为顶级
  // current_scope: Vec<String>, // 用于维护当前作用域的栈
  // defined_variables: HashMap<String, String>, // 变量名与类型的映射
  // defined_functions: HashMap<String, (Vec<String>, String)>, // 函数名与参数及返回类型的映射
  // current_type: Option<String>, // 当前类型
  // errors: Vec<String>, // 收集的错误信息
  // current_module: Option<String>, // 当前模块名称
  // imported_modules: Vec<String>, // 导入的模块
  // in_loop: Bool // 是否在循环内
  // in_conditional: Bool // 是否在条件语句内
  // is_async: Bool // 是否为异步上下文
  // is_generator: Bool // 是否为生成器上下文
  mut token_length : Int
  mut is_main : Bool
} derive(Show)

// pub let parser_context:ParserContext={is_top_level:true, token_length:0, is_main:false} // is_main初始化为false，在fn语句中出现问题！

///|
pub let parser_context : ParserContext = {
  is_top_level: true,
  token_length: 0,
  is_main: false,
}
