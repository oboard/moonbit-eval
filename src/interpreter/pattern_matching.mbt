///| 模式匹配模块 - 专门处理各种模式匹配逻辑

///|
/// 执行match表达式的模式匹配（返回RuntimeValue）
pub fn ClosureInterpreter::execute_match_runtime(
  self : ClosureInterpreter,
  value : RuntimeValue,
  cases : @list.List[@syntax.Case],
) -> RuntimeValue raise ControlFlow {
  self.push_scope(RuntimeLocation::ControlFlow("match"))
  defer self.pop_scope()
  for i, case in cases {
    // 为每个case创建新的作用域
    if self.pattern_matches_runtime(value, case.pattern) {
      return self.visit_scoped(case.body, ControlFlow("case \{i}"))
    }
  }
  error(
    "\{self.lookup_current_function()} No match found for value: " +
    value.to_string() +
    " in patterns: [" +
    self.format_patterns(cases) +
    "]",
  )
}

///|
/// 检查两个常量是否相等
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

///|
/// 检查两个表达式是否相等（用于构造函数匹配）
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

///|
/// 检查值是否在范围内
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

///|
/// 将模式转换为值（用于范围匹配）
pub fn ClosureInterpreter::pattern_to_value(
  self : ClosureInterpreter,
  pattern : @syntax.Pattern,
) -> @syntax.Expr? {
  match pattern {
    Constant(c~, loc~) => Some(Constant(c~, loc~))
    Constr(constr~, ..) => {
      // 查找构造函数的值
      let runtime_value = self.main.env.find(constr.name.name).unwrap_or(Unit)
      Some(runtime_value.to_expr())
    }
    Any(..) => None // 通配符表示开放边界
    _ => None
  }
}

///|
/// 格式化模式列表为可读字符串
pub fn ClosureInterpreter::format_patterns(
  _self : ClosureInterpreter,
  cases : @list.List[@syntax.Case],
) -> String {
  let pattern_strs = []
  for case in cases {
    pattern_strs.push(format_pattern(case.pattern))
  }
  pattern_strs.join(", ")
}

///|
/// 将单个模式转换为可读字符串
fn format_pattern(pattern : @syntax.Pattern) -> String {
  match pattern {
    Constant(c~, ..) =>
      match c {
        Int(v) => v
        Bool(v) => v.to_string()
        String(v) => "\"" + v + "\""
        Double(v) => v
        Char(v) => "'" + v + "'"
        _ => "<constant>"
      }
    Any(..) => "_"
    Tuple(pats~, ..) => {
      let pat_strs = []
      for pat in pats {
        pat_strs.push(format_pattern(pat))
      }
      "(" + pat_strs.join(", ") + ")"
    }
    Array(pats~, ..) => {
      let pat_strs = []
      match pats {
        @syntax.ArrayPatterns::Closed(patterns) =>
          loop patterns {
            @list.More(array_pat, tail=pat_tail) => {
              match array_pat {
                @syntax.ArrayPattern::Pattern(pat) =>
                  pat_strs.push(format_pattern(pat))
                _ => pat_strs.push("<array_pattern>")
              }
              continue pat_tail
            }
            @list.Empty => break
          }
        _ => pat_strs.push("<array_pattern>")
      }
      "[" + pat_strs.join(", ") + "]"
    }
    Or(pat1~, pat2~, ..) => format_pattern(pat1) + " | " + format_pattern(pat2)
    Record(fields~, ..) => {
      let field_strs = []
      for field in fields {
        field_strs.push(field.label.name + ": " + format_pattern(field.pattern))
      }
      "{ " + field_strs.join(", ") + " }"
    }
    Range(lhs~, rhs~, inclusive~, ..) => {
      let lhs_str = format_pattern(lhs)
      let rhs_str = format_pattern(rhs)
      let op = if inclusive { "..=" } else { ".." }
      lhs_str + op + rhs_str
    }
    Constr(constr~, args~, ..) => {
      let name = constr.name.name
      match args {
        Some(arg_list) => {
          let arg_strs = []
          for arg in arg_list {
            arg_strs.push(format_pattern(arg.pat))
          }
          name + "(" + arg_strs.join(", ") + ")"
        }
        None => name
      }
    }
    _ => "<pattern>"
  }
}
