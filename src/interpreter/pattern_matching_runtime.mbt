///|
/// 运行时模式匹配模块 - 处理所有模式匹配逻辑

///|
/// 模式匹配的 RuntimeValue 版本
pub fn ClosureInterpreter::pattern_matches_runtime(
  self : ClosureInterpreter,
  value : RuntimeValue,
  pattern : @syntax.Pattern,
) -> Bool {
  match pattern {
    // 变量模式匹配（总是匹配，并绑定变量）
    Var({ name, .. }) => {
      self.current_module.env.set(name, value)
      true
    }
    Constraint(pat~, ty~, ..) =>
      // 首先尝试类型约束检查
      if self.current_module.check_type_constraint(value, ty) {
        // 类型检查通过，继续检查模式匹配
        self.pattern_matches_runtime(value, pat)
      } else {
        // 类型不匹配，尝试隐式转换
        match (value, ty) {
          // Char 到 Int 的隐式转换
          (Char(c), Name(constr_id={ id: Ident(name="Int"), .. }, ..))
          | (Char(c), Name(constr_id={ id: Dot(id="Int", ..), .. }, ..)) => {
            let converted_value = Int(c.to_int())
            self.pattern_matches_runtime(converted_value, pat)
          }
          // Array 到 ArrayView
          (Array(arr), Name(constr_id={ id: Dot(id="ArrayView", ..), .. }, ..)) => {
            let converted_value = ArrayView(arr)
            self.pattern_matches_runtime(converted_value, pat)
          }
          _ => false
        }
      }

    // 常量模式匹配
    Constant(c=pattern_const, ..) =>
      match (value, pattern_const) {
        (Int(v), Int(s)) => {
          let pattern_int = @strconv.parse_int(s) catch { _ => 0 }
          v == pattern_int
        }
        (Bool(v), Bool(b)) => v == b
        (String(v), String(s)) => v == s
        (Double(v), Double(s)) => {
          let pattern_double = @strconv.parse_double(s) catch { _ => 0.0 }
          v == pattern_double
        }
        (Char(v), Char(s)) => {
          let pattern_char = s.get_char(0).unwrap_or(' ')
          v == pattern_char
        }
        _ => false
      }

    // 通配符模式（总是匹配）
    Any(..) => true

    // Tuple模式匹配
    Tuple(pats~, ..) =>
      match value {
        Tuple(values) => {
          if values.length() != pats.length() {
            return false
          }
          let mut pat_list = pats
          let mut index = 0
          while true {
            match pat_list {
              @list.More(pat, tail=pat_tail) => {
                if not(self.pattern_matches_runtime(values[index], pat)) {
                  return false
                }
                pat_list = pat_tail
                index = index + 1
              }
              @list.Empty => break
            }
          }
          true
        }
        _ => false
      }

    // Array模式匹配
    Array(pats~, ..) =>
      match value {
        Array(values) =>
          match pats {
            @syntax.ArrayPatterns::Closed(patterns) => {
              if values.length() != patterns.length() {
                return false
              }
              let mut index = 0
              loop patterns {
                @list.More(array_pat, tail=pat_tail) => {
                  match array_pat {
                    @syntax.ArrayPattern::Pattern(pat) =>
                      if not(self.pattern_matches_runtime(values[index], pat)) {
                        return false
                      }
                    _ => return false // 其他数组模式暂不支持
                  }
                  index = index + 1
                  continue pat_tail
                }
                @list.Empty => break
              }
              true
            }
            _ => false // 其他数组模式暂不支持
          }
        _ => false
      }

    // Or模式匹配（任一模式匹配即可）
    Or(pat1~, pat2~, ..) =>
      self.pattern_matches_runtime(value, pat1) ||
      self.pattern_matches_runtime(value, pat2)

    // Record模式匹配
    Record(fields=pat_fields, ..) =>
      match value {
        Struct({ val: record_fields, .. }) => {
          for pat_field in pat_fields {
            match record_fields.get(pat_field.label.name) {
              Some(field_value) =>
                if not(
                    self.pattern_matches_runtime(field_value, pat_field.pattern),
                  ) {
                  return false
                }
              None => return false
            }
          }
          true
        }
        _ => false
      }

    // Range模式匹配
    Range(lhs~, rhs~, inclusive~, ..) =>
      self.runtime_value_in_range(value, lhs, rhs, inclusive)

    // Constructor模式匹配
    Constr(constr~, args=pattern_args, ..) =>
      match value {
        Constructor({ val: { name, fields }, .. }) =>
          if name == constr.name.name {
            // 检查参数匹配
            match pattern_args {
              // 无参数的构造函数，只需要名称匹配
              Some(More({ pat: Any(_), .. }, tail=Empty)) => true
              Some(pat_args) => {
                // 有参数的构造函数，需要递归匹配每个参数
                if fields.length() != pat_args.length() {
                  return false
                }
                let mut index = 0
                loop pat_args {
                  @list.More(pat_arg, tail=pat_tail) => {
                    // 提取参数模式并递归匹配
                    let arg_pattern = pat_arg.pat
                    if not(
                        self.pattern_matches_runtime(
                          fields[index].value,
                          arg_pattern,
                        ),
                      ) {
                      return false
                    }
                    match pat_arg.kind {
                      Positional => ()
                      Labelled(label)
                      | LabelledPun(label)
                      | LabelledOption(label~, ..)
                      | LabelledOptionPun(label~, ..) =>
                        self.current_module.env.set(
                          label.name,
                          fields[index].value,
                        )
                    }
                    index += 1
                    continue pat_tail
                  }
                  @list.Empty => break
                }
                true
              }
              None =>
                // 无参数的构造函数，只需要名称匹配
                fields.length() == 0
            }
          } else {
            false
          }
        _ => {
          // 查找构造函数对应的值
          let constr_runtime_value = self.current_module.env
            .find(constr.name.name)
            .unwrap_or(Unit)
          match (value, constr_runtime_value) {
            // 如果构造函数是常量值，直接比较
            (Int(v1), Int(v2)) => v1 == v2
            (Bool(v1), Bool(v2)) => v1 == v2
            (String(v1), String(v2)) => v1 == v2
            (Double(v1), Double(v2)) => v1 == v2
            (Char(v1), Char(v2)) => v1 == v2
            _ => false
          }
        }
      }

    // Alias模式匹配（as模式）
    Alias(pat~, alias_~, ..) =>
      // 先检查内部模式是否匹配
      if self.pattern_matches_runtime(value, pat) {
        // 如果匹配成功，将值绑定到别名变量
        self.current_module.env.set(alias_.name, value)
        true
      } else {
        false
      }

    // 其他模式暂不支持
    _ => false
  }
}

///|
/// 检查 RuntimeValue 是否在指定范围内
pub fn ClosureInterpreter::runtime_value_in_range(
  self : ClosureInterpreter,
  value : RuntimeValue,
  lhs : @syntax.Pattern,
  rhs : @syntax.Pattern,
  inclusive : Bool,
) -> Bool {
  // 将模式转换为运行时值
  let lhs_value = self.pattern_to_runtime_value(lhs)
  let rhs_value = self.pattern_to_runtime_value(rhs)
  match (value, lhs_value, rhs_value) {
    (Int(v), Some(Int(start)), Some(Int(end))) =>
      if inclusive {
        v >= start && v <= end
      } else {
        v >= start && v < end
      }
    (Double(v), Some(Double(start)), Some(Double(end))) =>
      if inclusive {
        v >= start && v <= end
      } else {
        v >= start && v < end
      }
    (Char(v), Some(Char(start)), Some(Char(end))) =>
      if inclusive {
        v >= start && v <= end
      } else {
        v >= start && v < end
      }
    // 处理开放范围（如 _..<Zero 或 1..<_）
    (Int(v), None, Some(Int(end))) =>
      // 左边界是通配符，如 _..<Zero
      if inclusive {
        v <= end
      } else {
        v < end
      }
    (Int(v), Some(Int(start)), None) =>
      // 右边界是通配符，如 1..<_
      v >= start
    (Double(v), None, Some(Double(end))) =>
      if inclusive {
        v <= end
      } else {
        v < end
      }
    (Double(v), Some(Double(start)), None) => v >= start
    (Char(v), None, Some(Char(end))) =>
      if inclusive {
        v <= end
      } else {
        v < end
      }
    (Char(v), Some(Char(start)), None) => v >= start
    _ => false
  }
}

///|
/// 将模式转换为运行时值（用于范围检查等）
pub fn ClosureInterpreter::pattern_to_runtime_value(
  self : ClosureInterpreter,
  pattern : @syntax.Pattern,
) -> RuntimeValue? {
  match pattern {
    Constant(c~, ..) =>
      match c {
        Int(v) => {
          let int_val = @strconv.parse_int(v) catch { _ => return None }
          Some(Int(int_val))
        }
        Double(v) => {
          let double_val = @strconv.parse_double(v) catch { _ => return None }
          Some(Double(double_val))
        }
        String(v) => Some(String(v))
        Char(v) =>
          if v.length() > 0 && v.get(0) is Some(ch) {
            Some(Char(ch.unsafe_to_char()))
          } else {
            None
          }
        Bool(v) => Some(Bool(v))
        Bytes(_) => None
        Byte(_) => None
        Int64(_) => None
        UInt64(_) => None
        UInt(_) => None
        Float(_) => None
        BigInt(_) => None
      }
    Constr(constr~, ..) =>
      // 查找构造函数的值
      Some(self.current_module.env.find(constr.name.name).unwrap_or(Unit))
    Any(..) => None // 通配符表示开放边界
    _ => None
  }
}
