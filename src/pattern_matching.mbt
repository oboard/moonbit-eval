///| 模式匹配模块 - 专门处理各种模式匹配逻辑

///| 执行match表达式的模式匹配
pub fn ClosureInterpreter::execute_match(
  self : ClosureInterpreter,
  value : @syntax.Expr,
  cases : @list.List[@syntax.Case],
) -> @syntax.Expr {
  for case in cases {
    // 为每个case创建新的作用域
    self.push_scope()
    if self.pattern_matches(value, case.pattern) {
      let result = self.visit(case.body)
      self.pop_scope()
      return result
    }
    self.pop_scope()
  }
  unit() // 如果没有匹配的模式，返回unit
}

///| 检查值是否匹配模式
pub fn ClosureInterpreter::pattern_matches(
  self : ClosureInterpreter,
  value : @syntax.Expr,
  pattern : @syntax.Pattern,
) -> Bool {
  match (value, pattern) {
    // 常量模式匹配
    (
      @syntax.Expr::Constant(c=value_const, ..),
      @syntax.Pattern::Constant(c=pattern_const, ..),
    ) => self.constants_equal(value_const, pattern_const)

    // 变量模式匹配（总是匹配，并绑定变量）
    (_, @syntax.Pattern::Var({ name, .. })) => {
      // 绑定变量到当前作用域
      self.current_immutable_scope().set(name, value)
      true
    }

    // 通配符模式（总是匹配）
    (_, @syntax.Pattern::Any(..)) => true

    // Tuple模式匹配
    (@syntax.Expr::Tuple(exprs~, ..), @syntax.Pattern::Tuple(pats~, ..)) => {
      if exprs.length() != pats.length() {
        return false
      }
      let mut expr_list = exprs
      let mut pat_list = pats
      while true {
        match (expr_list, pat_list) {
          (@list.More(expr, tail=expr_tail), @list.More(pat, tail=pat_tail)) => {
            if not(self.pattern_matches(expr, pat)) {
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
    (@syntax.Expr::Array(exprs~, ..), @syntax.Pattern::Array(pats~, ..)) =>
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
                  @syntax.ArrayPattern::Pattern(pat) =>
                    if not(self.pattern_matches(expr, pat)) {
                      return false
                    }
                  @syntax.ArrayPattern::StringSpread(string_literal) =>
                    match expr {
                      @syntax.Expr::Constant(
                        c=@syntax.Constant::String(string),
                        ..
                      ) =>
                        if not(string.contains(string_literal)) {
                          return false
                        }
                      _ => return false
                    }
                  @syntax.ArrayPattern::BytesSpread(bytes_literal) =>
                    match expr {
                      @syntax.Expr::Constant(
                        c=@syntax.Constant::Bytes(bytes),
                        ..
                      ) =>
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
    (_, @syntax.Pattern::Or(pat1~, pat2~, ..)) =>
      self.pattern_matches(value, pat1) || self.pattern_matches(value, pat2)

    // Record模式匹配
    (
      @syntax.Expr::Record(fields~, ..),
      @syntax.Pattern::Record(fields=pat_fields, ..),
    ) => {
      // 检查所有模式字段是否都能在值中找到匹配
      for pat_field in pat_fields {
        let mut found = false
        for field in fields {
          if field.label.name == pat_field.label.name {
            if not(self.pattern_matches(field.expr, pat_field.pattern)) {
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

    // Range模式匹配
    (value, @syntax.Pattern::Range(lhs~, rhs~, inclusive~, ..)) =>
      self.value_in_range(value, lhs, rhs, inclusive)

    // Constructor模式匹配
    (value, @syntax.Pattern::Constr(constr~, ..)) => {
      // 查找构造函数对应的值
      let constr_value = self.find(constr.name.name)
      match (value, constr_value) {
        // 如果构造函数是常量值，直接比较
        (@syntax.Expr::Constant(..), @syntax.Expr::Constant(..)) =>
          self.constants_equal_expr(value, constr_value)
        _ => false
      }
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
    (@syntax.Constant::Int(v1), @syntax.Constant::Int(v2)) => v1 == v2
    (@syntax.Constant::Double(v1), @syntax.Constant::Double(v2)) => v1 == v2
    (@syntax.Constant::String(v1), @syntax.Constant::String(v2)) => v1 == v2
    (@syntax.Constant::Char(v1), @syntax.Constant::Char(v2)) => v1 == v2
    (@syntax.Constant::Bool(v1), @syntax.Constant::Bool(v2)) => v1 == v2
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
      @syntax.Expr::Constant(c=@syntax.Constant::Int(v), ..),
      Some(@syntax.Expr::Constant(c=@syntax.Constant::Int(l), ..)),
      Some(@syntax.Expr::Constant(c=@syntax.Constant::Int(r), ..)),
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
      @syntax.Expr::Constant(c=@syntax.Constant::Char(v), ..),
      Some(@syntax.Expr::Constant(c=@syntax.Constant::Char(l), ..)),
      Some(@syntax.Expr::Constant(c=@syntax.Constant::Char(r), ..)),
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
      @syntax.Expr::Constant(c=@syntax.Constant::Int(v), ..),
      None, // 左边界是通配符
      Some(@syntax.Expr::Constant(c=@syntax.Constant::Int(r), ..)),
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
      @syntax.Expr::Constant(c=@syntax.Constant::Int(v), ..),
      Some(@syntax.Expr::Constant(c=@syntax.Constant::Int(l), ..)), // 右边界是通配符
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
    @syntax.Pattern::Constant(c~, ..) =>
      Some(
        @syntax.Expr::Constant(c~, loc={
          start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
          end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
        }),
      )
    @syntax.Pattern::Constr(constr~, ..) => {
      // 查找构造函数的值
      let value = self.find(constr.name.name)
      Some(value)
    }
    @syntax.Pattern::Any(..) => None // 通配符表示开放边界
    _ => None
  }
}
