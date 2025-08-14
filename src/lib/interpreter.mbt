///|
struct ClosureInterpreter {
  extern_fns : Map[String, @syntax.Func]
  // 性能优化：区分可变和不可变变量
  immutable_values : Array[Map[String, @syntax.Expr]]
  mutable_values : Array[Map[String, @syntax.Expr]]
  // 用户定义的函数
  user_functions : Map[String, @syntax.Func]
}

///|
pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  {
    extern_fns: Map::new(),
    immutable_values: [{}],
    mutable_values: [{}],
    user_functions: Map::new(),
  }
}

///|
pub fn ClosureInterpreter::add_extern_fn(
  self : ClosureInterpreter,
  name : String,
  f : @syntax.Func,
) -> Unit {
  self.extern_fns.set(name, f)
}

// 辅助函数：检查是否为比较运算符

///|
fn is_comparison_op(op : String) -> Bool {
  match op {
    "==" | "!=" | "<" | ">" | "<=" | ">=" => true
    _ => false
  }
}

// 辅助函数：执行比较运算

///|
fn[T : Compare] compare(left : T, right : T, op : String) -> @syntax.Constant {
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
fn eval_int_op(left : Int, right : Int, op : String) -> @syntax.Constant {
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
fn eval_float_op(
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
fn eval_double_op(
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
fn eval_int64_op(left : Int64, right : Int64, op : String) -> @syntax.Constant {
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
fn eval_uint_op(left : UInt, right : UInt, op : String) -> @syntax.Constant {
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
fn eval_uint64_op(
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

///|
fn constant_infix(
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

///|
fn ClosureInterpreter::find(
  self : ClosureInterpreter,
  name : String,
) -> @syntax.Expr {
  // 性能优化：优先查找不可变变量（可以缓存和共享）
  for value in self.immutable_values.rev() {
    match value.get(name) {
      Some(variable) => return variable
      None => continue
    }
  }

  // 然后查找可变变量
  for value in self.mutable_values.rev() {
    match value.get(name) {
      Some(variable) => return variable
      None => continue
    }
  }
  @syntax.Expr::Unit(
    loc={
      start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
      end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
    },
    faked=true,
  )
}

///|
fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @syntax.Expr,
) -> @syntax.Expr {
  let level = 0
  @basic.show_loc.val = true
  // let loc = @basic.Location::{
  //   start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
  //   end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
  // }
  let loc = node.loc()
  let unit = () => @syntax.Expr::Unit(loc~, faked=true)
  match node {
    // 处理常量
    @syntax.Expr::Constant(c~, ..) => @syntax.Expr::Constant(c~, loc~)

    // 处理中缀表达式（如 1+1）
    @syntax.Expr::Infix(op~, lhs~, rhs~, ..) =>
      // 检查操作符
      match op.name {
        @syntax.LongIdent::Ident(name~) =>
          match (self.visit(lhs), self.visit(rhs)) {
            (@syntax.Expr::Constant(c=l, ..), @syntax.Expr::Constant(c=r, ..)) =>
              @syntax.Expr::Constant(c=constant_infix(name, l, r), loc~)
            _ => unit()
          }
        _ => unit()
      }

    // 处理不可变变量（性能优化：存储到专门的不可变变量数组）
    @syntax.Expr::Let(pattern=@syntax.Pattern::Var({ name, .. }), expr~, ..) => {
      let evaluated_expr = self.visit(expr)
      self.immutable_values[level].set(name, evaluated_expr)
      unit()
    }
    // 处理可变变量声明（存储到专门的可变变量数组）
    @syntax.Expr::LetMut(binder={ name, .. }, expr~, ..) => {
      let evaluated_expr = self.visit(expr)
      self.mutable_values[level].set(name, evaluated_expr)
      unit()
    }
    // 处理函数定义
    @syntax.Expr::LetFn(name={ name, .. }, func~, ..) => {
      self.user_functions.set(name, func)
      unit()
    }
    // 处理赋值操作（性能优化：只在可变变量中查找和更新）
    @syntax.Expr::Assign(var_~, expr~, ..) =>
      match var_.name {
        @syntax.LongIdent::Ident(name~) => {
          let new_value = self.visit(expr)
          // 只在可变变量数组中查找和更新（性能优化）
          for i = self.mutable_values.length() - 1; i >= 0; i = i - 1 {
            match self.mutable_values[i].get(name) {
              Some(_) => {
                self.mutable_values[i].set(name, new_value)
                return unit()
              }
              None => continue
            }
          }
          unit()
        }
        _ => unit()
      }
    // Handle variable identifiers
    @syntax.Expr::Ident(id={ name, .. }, ..) =>
      match name {
        @syntax.LongIdent::Ident(name~) => self.find(name)
        _ => unit()
      }
    // 处理函数调用
    @syntax.Expr::Apply(func~, args~, ..) =>
      match func {
        @syntax.Expr::Ident(id={ name, .. }, ..) =>
          match name {
            @syntax.LongIdent::Ident(name~) =>
              match self.user_functions.get(name) {
                Some(function) =>
                  match function {
                    @syntax.Func::Lambda(parameters~, body~, ..) => {
                      // 创建新的作用域
                      self.immutable_values.push(Map::new())
                      self.mutable_values.push(Map::new())
                      // 处理多个参数
                      fn bind_params(
                        params : @list.List[@syntax.Parameter],
                        args : @list.List[@syntax.Argument],
                        interpreter : ClosureInterpreter,
                      ) -> Unit {
                        match (params, args) {
                          (
                            @list.More(param, tail=rest_params),
                            @list.More(arg, tail=rest_args),
                          ) => {
                            match param {
                              @syntax.Parameter::Positional(
                                binder={ name, .. },
                                ..
                              ) => {
                                let arg_value = interpreter.visit(arg.value)
                                interpreter.immutable_values[interpreter.immutable_values.length() -
                                1].set(name, arg_value)
                              }
                              _ => ()
                            }
                            bind_params(rest_params, rest_args, interpreter)
                          }
                          _ => ()
                        }
                      }

                      bind_params(parameters, args, self)
                      // 执行函数体
                      let result = self.visit(body)
                      // 恢复作用域
                      self.immutable_values.pop() |> ignore
                      self.mutable_values.pop() |> ignore
                      result
                    }
                    _ => unit()
                  }
                None => unit()
              }
            _ => unit()
          }
        _ => unit()
      }
    _ => unit()
  }
}
