// 常量运算模块
// 处理各种数据类型的运算操作

// 辅助函数：检查是否为比较运算符

///|
pub fn is_comparison_op(op : String) -> Bool {
  match op {
    "==" | "!=" | "<" | ">" | "<=" | ">=" => true
    _ => false
  }
}

// 辅助函数：执行比较运算

///|
pub fn[T : Compare] compare(
  left : T,
  right : T,
  op : String,
) -> @syntax.Constant {
  match op {
    "==" => @syntax.Constant::Bool(left == right)
    "!=" => @syntax.Constant::Bool(left != right)
    "<" => @syntax.Constant::Bool(left < right)
    ">" => @syntax.Constant::Bool(left > right)
    "<=" => @syntax.Constant::Bool(left <= right)
    ">=" => @syntax.Constant::Bool(left >= right)
    _ => @syntax.Constant::Bool(false)
  }
}

// 辅助函数：执行整数运算

///|
pub fn eval_int_op(left : Int, right : Int, op : String) -> @syntax.Constant {
  if is_comparison_op(op) {
    return compare(left, right, op)
  }
  let result = match op {
    "+" => left + right
    "-" => left - right
    "*" => left * right
    "/" => if right == 0 { 0 } else { left / right }
    "%" => if right == 0 { 0 } else { left % right }
    ">>" => left >> right
    "<<" => left << right
    "^" => left ^ right
    "&" => left & right
    "|" => left | right
    _ => 0
  }
  @syntax.Constant::Int(result.to_string())
}

// 辅助函数：执行浮点数运算

///|
pub fn eval_float_op(
  left : Double,
  right : Double,
  op : String,
) -> @syntax.Constant {
  if is_comparison_op(op) {
    return compare(left, right, op)
  }
  let result = match op {
    "+" => left + right
    "-" => left - right
    "*" => left * right
    "/" => if right == 0.0 { 0.0 } else { left / right }
    _ => 0.0
  }
  @syntax.Constant::Float(result.to_string())
}

// 辅助函数：执行Double运算

///|
pub fn eval_double_op(
  left : Double,
  right : Double,
  op : String,
) -> @syntax.Constant {
  if is_comparison_op(op) {
    return compare(left, right, op)
  }
  let result = match op {
    "+" => left + right
    "-" => left - right
    "*" => left * right
    "/" => if right == 0.0 { 0.0 } else { left / right }
    _ => 0.0
  }
  @syntax.Constant::Double(result.to_string())
}

// 辅助函数：执行Int64运算

///|
pub fn eval_int64_op(
  left : Int64,
  right : Int64,
  op : String,
) -> @syntax.Constant {
  if is_comparison_op(op) {
    return compare(left, right, op)
  }
  let result = match op {
    "+" => left + right
    "-" => left - right
    "*" => left * right
    "/" => if right == 0L { 0L } else { left / right }
    "%" => if right == 0L { 0L } else { left % right }
    _ => 0L
  }
  @syntax.Constant::Int64(result.to_string())
}

// 辅助函数：执行UInt运算

///|
pub fn eval_uint_op(left : UInt, right : UInt, op : String) -> @syntax.Constant {
  if is_comparison_op(op) {
    return compare(left, right, op)
  }
  let result = match op {
    "+" => left + right
    "-" => left - right
    "*" => left * right
    "/" => if right == 0U { 0U } else { left / right }
    "%" => if right == 0U { 0U } else { left % right }
    _ => 0U
  }
  @syntax.Constant::UInt(result.to_string())
}

// 辅助函数：执行UInt64运算

///|
pub fn eval_uint64_op(
  left : UInt64,
  right : UInt64,
  op : String,
) -> @syntax.Constant {
  if is_comparison_op(op) {
    return compare(left, right, op)
  }
  let result = match op {
    "+" => left + right
    "-" => left - right
    "*" => left * right
    "/" => if right == 0UL { 0UL } else { left / right }
    "%" => if right == 0UL { 0UL } else { left % right }
    _ => 0UL
  }
  @syntax.Constant::UInt64(result.to_string())
}

// 主要的常量中缀运算函数

///|
pub fn constant_infix(
  name : String,
  lhs : @syntax.Constant,
  rhs : @syntax.Constant,
) -> @syntax.Constant {
  match (lhs, rhs) {
    // Int 运算
    (@syntax.Constant::Int(left_val), @syntax.Constant::Int(right_val)) => {
      let left_int = @strconv.parse_int(left_val) catch { _ => 0 }
      let right_int = @strconv.parse_int(right_val) catch { _ => 0 }
      eval_int_op(left_int, right_int, name)
    }
    // Float 运算
    (@syntax.Constant::Float(left_val), @syntax.Constant::Float(right_val)) => {
      let left_float = @strconv.parse_double(left_val) catch { _ => 0.0 }
      let right_float = @strconv.parse_double(right_val) catch { _ => 0.0 }
      eval_float_op(left_float, right_float, name)
    }
    // Double 运算
    (@syntax.Constant::Double(left_val), @syntax.Constant::Double(right_val)) => {
      let left_double = @strconv.parse_double(left_val) catch { _ => 0.0 }
      let right_double = @strconv.parse_double(right_val) catch { _ => 0.0 }
      eval_double_op(left_double, right_double, name)
    }
    // Bool 运算
    (@syntax.Constant::Bool(left_val), @syntax.Constant::Bool(right_val)) => {
      let result = match name {
        "&&" => left_val && right_val
        "||" => left_val || right_val
        "==" => left_val == right_val
        "!=" => left_val != right_val
        _ => false
      }
      @syntax.Constant::Bool(result)
    }
    // String 运算
    (@syntax.Constant::String(left_val), @syntax.Constant::String(right_val)) =>
      match name {
        "+" => @syntax.Constant::String(left_val + right_val)
        "==" => @syntax.Constant::Bool(left_val == right_val)
        "!=" => @syntax.Constant::Bool(left_val != right_val)
        _ => @syntax.Constant::String("")
      }
    // Int64 运算
    (@syntax.Constant::Int64(left_val), @syntax.Constant::Int64(right_val)) => {
      let left_int64 = @strconv.parse_int64(left_val) catch { _ => 0L }
      let right_int64 = @strconv.parse_int64(right_val) catch { _ => 0L }
      eval_int64_op(left_int64, right_int64, name)
    }
    // UInt 运算
    (@syntax.Constant::UInt(left_val), @syntax.Constant::UInt(right_val)) => {
      let left_uint = @strconv.parse_uint(left_val) catch { _ => 0U }
      let right_uint = @strconv.parse_uint(right_val) catch { _ => 0U }
      eval_uint_op(left_uint, right_uint, name)
    }
    // UInt64 运算
    (@syntax.Constant::UInt64(left_val), @syntax.Constant::UInt64(right_val)) => {
      let left_uint64 = @strconv.parse_uint64(left_val) catch { _ => 0UL }
      let right_uint64 = @strconv.parse_uint64(right_val) catch { _ => 0UL }
      eval_uint64_op(left_uint64, right_uint64, name)
    }
    // 混合类型或不支持的运算
    _ => @syntax.Constant::Int("0")
  }
}
