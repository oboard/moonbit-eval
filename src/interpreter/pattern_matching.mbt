///| 模式匹配模块 - 专门处理各种模式匹配逻辑

///| 执行match表达式的模式匹配
pub fn ClosureInterpreter::execute_match(
  self : ClosureInterpreter,
  value : @syntax.Expr,
  cases : @list.List[@syntax.Case],
) -> @syntax.Expr raise ControlFlow {
  for case in cases {
    // 为每个case创建新的作用域
    self.push_scope()
    if self.pattern_matches(value, case.pattern) {
      let result = self.visit(case.body).to_expr()
      self.pop_scope()
      return result
    }
    self.pop_scope()
  }
  unit() // 如果没有匹配的模式，返回unit
}

///| 执行match表达式的模式匹配（返回RuntimeValue）
pub fn ClosureInterpreter::execute_match_runtime(
  self : ClosureInterpreter,
  value : RuntimeValue,
  cases : @list.List[@syntax.Case],
) -> RuntimeValue raise ControlFlow {
  for case in cases {
    // 为每个case创建新的作用域
    self.push_scope()
    if self.pattern_matches_runtime(value, case.pattern) {
      let result = self.visit(case.body)
      self.pop_scope()
      return result
    }
    self.pop_scope()
  }
  RuntimeValue::Unit // 如果没有匹配的模式，返回unit
}

///| 检查值是否匹配模式
pub fn ClosureInterpreter::pattern_matches(
  self : ClosureInterpreter,
  value : @syntax.Expr,
  pattern : @syntax.Pattern,
) -> Bool raise ControlFlow {
  match (value, pattern) {
    // 常量模式匹配
    (Constant(c=value_const, ..), Constant(c=pattern_const, ..)) =>
      self.constants_equal(value_const, pattern_const)

    // 标识符与常量模式匹配
    (Ident(id={ name, .. }, ..), Constant(c=pattern_const, ..)) =>
      self.main.with_ident(name, (env, _pkg, name) => {
        let runtime_value = env.find(name)
        let value_expr = runtime_value.to_expr()
        match value_expr {
          @syntax.Expr::Constant(c=value_const, ..) =>
            self.constants_equal(value_const, pattern_const)
          _ => false
        }
      })

    // 变量模式匹配（总是匹配，并绑定变量）
    (_, Var({ name, .. })) => {
      // 计算表达式的值
      let runtime_value = self.visit(value)

      // 直接绑定RuntimeValue
      self.main.env.current_scope().set(name, runtime_value)
      true
    }

    // 通配符模式（总是匹配）
    (_, Any(..)) => true

    // Tuple模式匹配
    (@syntax.Expr::Tuple(exprs~, ..), Tuple(pats~, ..)) => {
      if exprs.length() != pats.length() {
        return false
      }
      let mut expr_list = exprs
      let mut pat_list = pats
      while true {
        match (expr_list, pat_list) {
          (@list.More(expr, tail=expr_tail), @list.More(pat, tail=pat_tail)) => {
            let expr_runtime = RuntimeValue::from_expr(expr)
            if not(self.pattern_matches_runtime(expr_runtime, pat)) {
              return false
            }
            expr_list = expr_tail
            pat_list = pat_tail
          }
          (@list.Empty, @list.Empty) => break
          _ => return false
        }
      }
      true
    }

    // Array模式匹配
    (@syntax.Expr::Array(exprs~, ..), Array(pats~, ..)) =>
      match pats {
        @syntax.ArrayPatterns::Closed(patterns) => {
          if exprs.length() != patterns.length() {
            return false
          }
          let mut expr_list = exprs
          let mut pat_list = patterns
          while true {
            match (expr_list, pat_list) {
              (
                @list.More(expr, tail=expr_tail),
                @list.More(array_pat, tail=pat_tail),
              ) => {
                match array_pat {
                  @syntax.ArrayPattern::Pattern(pat) => {
                    let expr_runtime = RuntimeValue::from_expr(expr)
                    if not(self.pattern_matches_runtime(expr_runtime, pat)) {
                      return false
                    }
                  }
                  @syntax.ArrayPattern::StringSpread(string_literal) =>
                    match expr {
                      @syntax.Expr::Constant(c=String(string), ..) =>
                        if not(string.contains(string_literal)) {
                          return false
                        }
                      _ => return false
                    }
                  @syntax.ArrayPattern::BytesSpread(bytes_literal) =>
                    match expr {
                      @syntax.Expr::Constant(c=Bytes(bytes), ..) =>
                        if not(bytes.contains(bytes_literal)) {
                          return false
                        }
                      _ => return false
                    }
                  _ => return false // 其他数组模式暂不支持
                }
                expr_list = expr_tail
                pat_list = pat_tail
              }
              (@list.Empty, @list.Empty) => break
              _ => return false
            }
          }
          true
        }
        _ => false // 其他数组模式暂不支持
      }

    // Or模式匹配（任一模式匹配即可）
    (_, Or(pat1~, pat2~, ..)) => {
      let value_runtime = RuntimeValue::from_expr(value)
      self.pattern_matches_runtime(value_runtime, pat1) ||
      self.pattern_matches_runtime(value_runtime, pat2)
    }

    // Record模式匹配
    (value, Record(fields=pat_fields, ..)) => {
      // 处理记录模式匹配
      let record_fields = match value {
        // 处理普通记录
        @syntax.Expr::Record(fields~, ..) => Some(fields.to_array())
        _ => None
      }
      match record_fields {
        Some(fields) => {
          // 检查所有模式字段是否都能在值中找到匹配
          for pat_field in pat_fields {
            let mut found = false
            for field in fields {
              if field.label.name == pat_field.label.name {
                let field_runtime = RuntimeValue::from_expr(field.expr)
                if not(
                    self.pattern_matches_runtime(
                      field_runtime,
                      pat_field.pattern,
                    ),
                  ) {
                  return false
                }
                found = true
                break
              }
            }
            if not(found) {
              return false
            }
          }
          true
        }
        None => false
      }
    }

    // Range模式匹配
    (value, Range(lhs~, rhs~, inclusive~, ..)) =>
      self.value_in_range(value, lhs, rhs, inclusive)

    // Constructor模式匹配
    (value, Constr(constr~, args~, ..)) => {
      // 查找构造函数对应的值
      let name1 = constr.name.name
      let value_runtime = self.visit(value)
      if value_runtime is Constructor({ val: (name2, arr), .. }) {
        if name1 != name2 {
          return false
        }
        if args is Some(args) {
          return args.foldi(init=true, fn(i, acc, arg) {
            acc && self.pattern_matches_runtime(arr[i], arg.pat)
          })
        } else {
          return true
        }
      }
      false
    }
    _ => false // 其他模式暂不支持
  }
}

///| 检查两个常量是否相等
pub fn ClosureInterpreter::constants_equal(
  _self : ClosureInterpreter,
  c1 : @syntax.Constant,
  c2 : @syntax.Constant,
) -> Bool {
  match (c1, c2) {
    (Int(v1), Int(v2))
    | (Double(v1), Double(v2))
    | (String(v1), String(v2))
    | (Char(v1), Char(v2)) => v1 == v2
    (Bool(v1), Bool(v2)) => v1 == v2
    _ => false
  }
}

///| 检查两个表达式是否相等（用于构造函数匹配）
pub fn ClosureInterpreter::constants_equal_expr(
  self : ClosureInterpreter,
  expr1 : @syntax.Expr,
  expr2 : @syntax.Expr,
) -> Bool {
  match (expr1, expr2) {
    (@syntax.Expr::Constant(c=c1, ..), @syntax.Expr::Constant(c=c2, ..)) =>
      self.constants_equal(c1, c2)
    _ => false
  }
}

///| 检查值是否在范围内
pub fn ClosureInterpreter::value_in_range(
  self : ClosureInterpreter,
  value : @syntax.Expr,
  lhs : @syntax.Pattern,
  rhs : @syntax.Pattern,
  inclusive : Bool,
) -> Bool {
  // 获取范围的左右边界值
  let lhs_value = self.pattern_to_value(lhs)
  let rhs_value = self.pattern_to_value(rhs)
  match (value, lhs_value, rhs_value) {
    // 整数范围匹配
    (
      @syntax.Expr::Constant(c=Int(v), ..),
      Some(@syntax.Expr::Constant(c=Int(l), ..)),
      Some(@syntax.Expr::Constant(c=Int(r), ..)),
    ) => {
      let val = @strconv.parse_int(v) catch { _ => return false }
      let left = @strconv.parse_int(l) catch { _ => return false }
      let right = @strconv.parse_int(r) catch { _ => return false }
      if inclusive {
        val >= left && val <= right
      } else {
        val >= left && val < right
      }
    }

    // 字符范围匹配
    (
      @syntax.Expr::Constant(c=Char(v), ..),
      Some(@syntax.Expr::Constant(c=Char(l), ..)),
      Some(@syntax.Expr::Constant(c=Char(r), ..)),
    ) =>
      if v.length() > 0 && l.length() > 0 && r.length() > 0 {
        let val = v.get(0)
        let left = l.get(0)
        let right = r.get(0)
        if inclusive {
          val >= left && val <= right
        } else {
          val >= left && val < right
        }
      } else {
        false
      }

    // 处理开放范围（如 _..<Zero 或 1..<_）
    (
      @syntax.Expr::Constant(c=Int(v), ..),
      None, // 左边界是通配符
      Some(@syntax.Expr::Constant(c=Int(r), ..)),
    ) => {
      let val = @strconv.parse_int(v) catch { _ => return false }
      let right = @strconv.parse_int(r) catch { _ => return false }
      if inclusive {
        val <= right
      } else {
        val < right
      }
    }
    (
      @syntax.Expr::Constant(c=Int(v), ..),
      Some(@syntax.Expr::Constant(c=Int(l), ..)), // 右边界是通配符
      None,
    ) => {
      let val = @strconv.parse_int(v) catch { _ => return false }
      let left = @strconv.parse_int(l) catch { _ => return false }
      val >= left
    }
    _ => false
  }
}

///| 将模式转换为值（用于范围匹配）
pub fn ClosureInterpreter::pattern_to_value(
  self : ClosureInterpreter,
  pattern : @syntax.Pattern,
) -> @syntax.Expr? {
  match pattern {
    Constant(c~, loc~) => Some(Constant(c~, loc~))
    Constr(constr~, ..) => {
      // 查找构造函数的值
      let runtime_value = self.main.env.find(constr.name.name)
      Some(runtime_value.to_expr())
    }
    Any(..) => None // 通配符表示开放边界
    _ => None
  }
}
