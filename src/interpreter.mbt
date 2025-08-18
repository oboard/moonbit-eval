///| 支持引用系统的解释器
struct ClosureInterpreter {
  extern_fns : Map[String, (Array[RuntimeArgument]) -> RuntimeValue]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, (Array[RuntimeArgument]) -> RuntimeValue]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[
    String,
    Map[String, (Array[RuntimeArgument]) -> RuntimeValue],
  ]
  // 函数别名存储 - 存储函数名到其实际实现的映射
  fn_aliases : Map[String, String]
  // 性能优化：区分可变和不可变变量 - 现在存储RuntimeValue而非@syntax.Expr
  immutable_values : Array[Map[String, RuntimeValue]]
  mutable_values : Array[Map[String, RuntimeValue]]
  // 运行时存储 - 管理可变对象的引用
  runtime_store : RuntimeStore
  // 用户定义的函数
  user_functions : Array[Map[String, @syntax.Func]]
  // 类型定义
  type_definitions : Map[String, @syntax.TypeDecl]
  // 结构体方法定义 - 按类型名组织方法
  struct_methods : Map[String, Map[String, @syntax.Func]]
}

///|
pub fn ClosureInterpreter::new(core~ : Bool = true) -> ClosureInterpreter {
  {
    extern_fns: Map::new(),
    embedded_fns: if core {
      core_embedded_code
    } else {
      Map::new()
    },
    embedded_methods: if core {
      core_embedded_methods
    } else {
      Map::new()
    },
    fn_aliases: if core {
      core_fn_aliases
    } else {
      Map::new()
    },
    immutable_values: [{}],
    mutable_values: [{}],
    runtime_store: RuntimeStore::new(),
    user_functions: [{}],
    type_definitions: Map::new(),
    struct_methods: Map::new(),
  }
}

///|
pub fn ClosureInterpreter::add_extern_fn(
  self : ClosureInterpreter,
  name : String,
  f : (Array[RuntimeArgument]) -> RuntimeValue,
) -> Unit {
  self.extern_fns.set(name, f)
}

///|
pub fn ClosureInterpreter::add_embedded_fn(
  self : ClosureInterpreter,
  name : String,
  f : (Array[RuntimeArgument]) -> RuntimeValue,
) -> Unit {
  self.embedded_fns.set(name, f)
}

///|
pub fn ClosureInterpreter::add_embedded_method(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  f : (Array[RuntimeArgument]) -> RuntimeValue,
) -> Unit {
  if not(self.embedded_methods.contains(type_name)) {
    self.embedded_methods.set(type_name, Map::new())
  }
  self.embedded_methods.get(type_name).unwrap().set(method_name, f)
}

///| 获取当前函数作用域
fn ClosureInterpreter::current_user_function_scope(
  self : ClosureInterpreter,
) -> Map[String, @syntax.Func] {
  // user_functions 数组永远非空（初始化为 [{}]），直接访问最后一个元素
  self.user_functions[self.user_functions.length() - 1]
}

///| 获取当前不可变变量作用域
fn ClosureInterpreter::current_immutable_scope(
  self : ClosureInterpreter,
) -> Map[String, RuntimeValue] {
  // immutable_values 数组永远非空（初始化为 [{}]），直接访问最后一个元素
  self.immutable_values[self.immutable_values.length() - 1]
}

///| 查找变量并返回其 RuntimeValue（新的优化方法）
fn ClosureInterpreter::find_runtime(
  self : ClosureInterpreter,
  name : String,
) -> RuntimeValue {
  find_variable(self.immutable_values, self.mutable_values, name)
}

///|
fn ClosureInterpreter::top_visit(
  self : ClosureInterpreter,
  node : @syntax.Impl,
) -> Unit {
  match node {
    // TopView(_) => ...
    // TopImpl(_) => ...
    // TopBatchTraitAlias(_) => ...
    // TopBatchTypeAlias(_) => ...
    // TopTrait(_) => ...
    // TopFuncAlias(_) =>

    // 处理顶层常量定义（如 const Zero = 0）
    TopLetDef(binder~, expr~, ..) =>
      self.set_immutable_variable(binder.name, self.visit(expr))
    TopTypeDef(def) =>
      match def {
        { tycon, .. } => self.type_definitions.set(tycon, def)
      }

    // 处理顶层函数定义，包括结构体方法和embedded函数
    TopFuncDef(fun_decl~, decl_body~, loc~) => {
      // 从fun_decl中提取函数名
      let func_name = fun_decl.name.name
      let type_name = match fun_decl.type_name {
        Some({ name: Ident(name=type_name), .. }) => Some(type_name)
        Some({ name: Dot(..), .. }) => None // 处理点号形式的类型名
        None => None
      }
      // 从decl_body中提取函数体
      match decl_body {
        DeclBody(local_types=_, expr~) => {

          // 保持原始的返回类型，不在这里进行推导
          let inferred_return_type = fun_decl.return_type
          let func = @syntax.Func::Lambda(
            parameters=fun_decl.decl_params.unwrap_or(@list.new()),
            params_loc=loc,
            body=expr,
            return_type=inferred_return_type,
            error_type=fun_decl.error_type,
            kind=Arrow,
            has_error=fun_decl.has_error,
            is_async=fun_decl.is_async,
            loc~,
          )
          if type_name is Some(type_name) {
            self.define_struct_method(type_name, func_name, func)
          } else {
            self.define_function(func_name, func)
          }
        }
        // 处理embedded函数声明
        DeclStubs(stubs) =>
          match stubs {
            Embedded(code=@syntax.EmbeddedCode::CodeString(code_str), ..) => {
              let func = self.embedded_fns.get(code_str)
              if (type_name, func) is (Some(type_name), Some(func)) {
                self.add_embedded_method(type_name, func_name, func)
              }
            }
            _ => ()
          }
      }
    }
    _ => ()
  }
  // TopTest(_) => ...
  // TopExpr(_) => ...
  // TopImplRelation(_) => ...
}

///| 新的优化版本：直接返回 RuntimeValue
fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @syntax.Expr,
) -> RuntimeValue {
  match node {
    // 处理常量
    Constant(c~, ..) =>
      match c {
        @syntax.Constant::Bool(b) => RuntimeValue::Bool(b)
        @syntax.Constant::Int(s) =>
          RuntimeValue::Int(@strconv.parse_int(s) catch { _ => 0 })
        @syntax.Constant::UInt(s) =>
          RuntimeValue::UInt(@strconv.parse_uint(s) catch { _ => 0U })
        @syntax.Constant::Int64(s) =>
          RuntimeValue::Int64(@strconv.parse_int64(s) catch { _ => 0L })
        @syntax.Constant::UInt64(s) =>
          RuntimeValue::UInt64(@strconv.parse_uint64(s) catch { _ => 0UL })
        @syntax.Constant::Float(s) =>
          RuntimeValue::Float(
            (@strconv.parse_double(s) catch { _ => 0.0 }).to_float(),
          )
        @syntax.Constant::Double(s) =>
          RuntimeValue::Double(@strconv.parse_double(s) catch { _ => 0.0 })
        @syntax.Constant::Byte(s) => {
          let int_val = @strconv.parse_int(s) catch { _ => 0 }
          RuntimeValue::Byte(int_val.to_byte())
        }
        @syntax.Constant::Char(s) =>
          RuntimeValue::Char(s.get_char(0).unwrap_or(' '))
        @syntax.Constant::String(s) => RuntimeValue::String(s)
        _ => RuntimeValue::Unit
      }

    // 处理变量标识符
    Ident(id={ name, .. }, ..) =>
      match name {
        @syntax.LongIdent::Ident(name~) => self.find_runtime(name)
        _ => RuntimeValue::Unit
      }

    // 处理中缀表达式（如 1+1）
    Infix(op~, lhs~, rhs~, ..) =>
      match op.name {
        @syntax.LongIdent::Ident(name~) => {
          let left_val = self.visit(lhs)
          let right_val = self.visit(rhs)
          runtime_value_infix(name, left_val, right_val)
        }
        _ => Unit
      }

    // 处理一元表达式
    Unary(op~, expr~, ..) =>
      match op.name {
        @syntax.LongIdent::Ident(name~) => {
          let val = self.visit(expr)
          match (name, val) {
            ("!", Bool(value)) => Bool(!value)
            ("-", Int(value)) => Int(-value)
            ("-", Double(value)) => Double(-value)
            _ => Unit
          }
        }
        _ => Unit
      }

    // 处理记录创建
    Record(fields~, ..) => {
      let evaluated_fields = Map::new()
      for field in fields {
        let field_value = self.visit(field.expr)
        ignore(evaluated_fields.set(field.label.name, field_value))
      }
      let ref_id = self.runtime_store.alloc_struct(evaluated_fields)
      RuntimeValue::StructRef(ref_id)
    }

    // 处理元组
    Tuple(exprs~, ..) => {
      let evaluated_values = exprs.map(fn(expr) { self.visit(expr) }).to_array()
      RuntimeValue::Tuple(evaluated_values)
    }

    // 处理数组
    Array(exprs~, ..) => {
      let evaluated_values = exprs.map(fn(expr) { self.visit(expr) }).to_array()
      RuntimeValue::Array(evaluated_values)
    }

    // 处理函数
    Function(func~, ..) => RuntimeValue::Function(func)

    // 处理 Let 绑定
    Let(pattern~, expr~, body~, ..) => {
      let evaluated_expr = match expr {
        @syntax.Expr::Ident(
          id={ name: @syntax.LongIdent::Ident(name~), .. },
          ..
        ) => self.find_runtime(name)
        _ => self.visit(expr)
      }
      ignore(self.pattern_matches_runtime(evaluated_expr, pattern))
      self.visit(body)
    }

    // 处理可变变量声明
    LetMut(binder={ name, .. }, expr~, body~, ..) => {
      let runtime_value = self.visit(expr)
      self.set_mutable_variable(name, runtime_value)
      // 执行body部分，这是关键！
      self.visit(body)
    }

    // 处理函数定义
    LetFn(name={ name, .. }, func~, body~, ..) => {
      self.define_function(name, func)
      match body {
        Unit(..) => RuntimeValue::Function(func)
        _ => self.visit(body)
      }
    }

    // 处理赋值操作
    Assign(var_~, expr~, augmented_by~, ..) =>
      match var_.name {
        @syntax.LongIdent::Ident(name~) => {
          let new_value = match augmented_by {
            Some(op) => {
              let current_value = self.find_runtime(name)
              match op.name {
                @syntax.LongIdent::Ident(name=op_name) => {
                  let rhs_value = self.visit(expr)
                  runtime_value_infix(op_name, current_value, rhs_value)
                }
                _ => self.visit(expr)
              }
            }
            None => self.visit(expr)
          }
          update_mutable_variable(self.mutable_values, name, new_value)
          RuntimeValue::Unit
        }
        _ => RuntimeValue::Unit
      }

    // 处理函数调用
    Apply(func~, args~, ..) =>
      match func {
        Ident(id={ name: @syntax.LongIdent::Ident(name~), .. }, ..) =>
          self.execute_function_by_name(name, args)
        // 处理静态方法调用，如 Bool::default()
        Method(type_name~, method_name~, ..) => {
          let type_str = match type_name.name {
            @syntax.LongIdent::Ident(name~) => name
            _ => "Unknown"
          }
          self.execute_static_method_call(type_str, method_name.name, args)
        }
        _ => RuntimeValue::Unit
      }

    // 处理 if 表达式
    If(cond~, ifso~, ifnot~, ..) => {
      let cond_val = self.visit(cond)
      match cond_val {
        RuntimeValue::Bool(true) => self.visit(ifso)
        RuntimeValue::Bool(false) =>
          match ifnot {
            Some(else_expr) => self.visit(else_expr)
            None => RuntimeValue::Unit
          }
        _ => RuntimeValue::Unit
      }
    }

    // 处理 match 表达式
    Match(expr~, cases~, ..) => {
      let expr_runtime = self.visit(expr)
      self.execute_match_runtime(expr_runtime, cases)
    }

    // 处理字段访问
    Field(record~, accessor~, ..) => {
      let record_val = self.visit(record)
      match (record_val, accessor) {
        (RuntimeValue::StructRef(ref_id), @syntax.Accessor::Label(label)) =>
          match self.runtime_store.get_struct(ref_id) {
            Some(record) =>
              match record.get(label.name) {
                Some(field_value) => field_value
                None => RuntimeValue::Unit
              }
            None => RuntimeValue::Unit
          }
        (RuntimeValue::Tuple(values), @syntax.Accessor::Index(tuple_index~, ..)) =>
          safe_index_access(values, tuple_index)
        (RuntimeValue::Array(values), @syntax.Accessor::Index(tuple_index~, ..)) =>
          safe_index_access(values, tuple_index)
        _ => RuntimeValue::Unit
      }
    }

    // 处理方法调用 (DotApply)
    DotApply(self=self_expr, method_name~, args~, ..) =>
      self.execute_method_call_runtime(self_expr, method_name.name, args)

    // 处理数组索引访问 (ArrayGet)
    ArrayGet(array~, index~, ..) => {
      let array_val = self.visit(array)
      let index_val = self.visit(index)
      match (array_val, index_val) {
        (RuntimeValue::Array(values), RuntimeValue::Int(index_num)) =>
          safe_index_access(values, index_num)
        _ => RuntimeValue::Unit
      }
    }

    // 处理管道表达式 (Pipe) - 将左侧值作为右侧函数的第一个参数
    Pipe(lhs~, rhs~, ..) => {
      // 先评估左侧值
      let left_val = self.visit(lhs)
      match rhs {
        // 处理简单函数调用，如 5 |> ignore
        Ident(id={ name: @syntax.LongIdent::Ident(name~), .. }, ..) => {
          // 创建包含左侧值的参数列表
          let left_expr = left_val.to_expr_with_store(self.runtime_store)
          let pipe_args = @list.construct(
            @syntax.Argument::{
              value: left_expr,
              kind: @syntax.ArgumentKind::Positional,
            },
            @list.new(),
          )
          self.execute_function_by_name(name, pipe_args)
        }
        // 处理方法调用，如 [] |> Array::push(5)
        Apply(func~, args~, ..) =>
          match func {
            Method(type_name~, method_name~, ..) => {
              let type_str = match type_name.name {
                @syntax.LongIdent::Ident(name~) => name
                _ => "Unknown"
              }
              // 将左侧值添加到参数列表前面
              let left_expr = left_val.to_expr_with_store(self.runtime_store)
              let pipe_args = @list.construct(
                @syntax.Argument::{
                  value: left_expr,
                  kind: @syntax.ArgumentKind::Positional,
                },
                args,
              )
              self.execute_static_method_call(
                type_str,
                method_name.name,
                pipe_args,
              )
            }
            Ident(id={ name: @syntax.LongIdent::Ident(name~), .. }, ..) => {
              // 处理函数调用，如 5 |> func(arg1, arg2)
              let left_expr = left_val.to_expr_with_store(self.runtime_store)
              let pipe_args = @list.construct(
                @syntax.Argument::{
                  value: left_expr,
                  kind: @syntax.ArgumentKind::Positional,
                },
                args,
              )
              self.execute_function_by_name(name, pipe_args)
            }
            _ => left_val
          }
        _ => left_val
      }
    }

    // 处理序列表达式
    Sequence(exprs~, last_expr~, ..) => {
      for expr in exprs {
        let result = self.visit(expr)
        match result {
          RuntimeValue::Break(_) | RuntimeValue::Continue(_) => return result
          _ => () // 继续执行下一个表达式
        }
      }
      self.visit(last_expr)
    }

    // 处理分组表达式
    Group(expr~, ..) => self.visit(expr)

    // 处理 For 循环
    For(binders~, condition~, continue_block~, body~, ..) =>
      self.with_scope(fn() {
        // 初始化循环变量
        for binder_init in binders {
          match binder_init {
            (binder, init_expr) => {
              let init_value = self.visit(init_expr)
              self.set_mutable_variable(binder.name, init_value)
            }
          }
        }

        // 执行循环
        while true {
          // 检查循环条件
          let should_continue = match condition {
            Some(cond) => {
              let condition_result = self.visit(cond)
              match condition_result {
                RuntimeValue::Bool(value) => value
                _ => false
              }
            }
            None => true
          }
          if not(should_continue) {
            break
          }

          // 执行循环体，处理break和continue
          let body_result = self.visit(body)
          match body_result {
            RuntimeValue::Break(value) =>
              return match value {
                Some(v) => v
                None => RuntimeValue::Unit
              }
            RuntimeValue::Continue(_) => {
              // continue时也要执行更新块，然后跳到下一次迭代
              for update_tuple in continue_block {
                match update_tuple {
                  (binder, update_expr) => {
                    let new_value = self.visit(update_expr)
                    self.set_mutable_variable(binder.name, new_value)
                  }
                }
              }
              continue
            }
            _ => () // 正常执行，继续
          }

          // 执行 continue 块（更新循环变量）
          for update_tuple in continue_block {
            match update_tuple {
              (binder, update_expr) => {
                let new_value = self.visit(update_expr)
                self.set_mutable_variable(binder.name, new_value)
              }
            }
          }
        }
        RuntimeValue::Unit
      })

    // 处理 While 循环
    While(loop_cond~, loop_body~, while_else~, ..) => {
      let mut result = RuntimeValue::Unit
      let mut broke = false
      while true {
        let cond_result = self.visit(loop_cond)
        match cond_result {
          RuntimeValue::Bool(false) => break
          _ => ()
        }

        // 执行循环体，处理break和continue
        let body_result = self.visit(loop_body)
        match body_result {
          RuntimeValue::Break(value) => {
            result = match value {
              Some(v) => v
              None => RuntimeValue::Unit
            }
            broke = true
            break
          }
          RuntimeValue::Continue(_) =>
            // 跳过剩余循环体，继续下一次迭代
            continue
          _ => () // 正常执行，继续
        }
      }
      // 如果没有break，执行else分支
      if not(broke) {
        match while_else {
          Some(else_expr) => result = self.visit(else_expr)
          None => () // 没有else分支
        }
      }
      result
    }

    // 处理字段赋值 (Mutate)
    Mutate(record~, accessor~, field~, augmented_by~, ..) =>
      match record {
        @syntax.Expr::Ident(id={ name, .. }, ..) =>
          match name {
            @syntax.LongIdent::Ident(name~) => {
              // 获取当前记录的运行时值
              let record_runtime = self.find_runtime(name)
              match record_runtime {
                RuntimeValue::StructRef(ref_id) => {
                  // 计算新字段值
                  let new_field_value = match augmented_by {
                    Some(op) =>
                      // 增强赋值操作（如 +=, -=, *=, /= 等）
                      match accessor {
                        @syntax.Accessor::Label(label) => {
                          // 获取当前字段值
                          let current_field_value = match
                            self.runtime_store.get_struct(ref_id) {
                            Some(struct_data) =>
                              struct_data
                              .get(label.name)
                              .unwrap_or(RuntimeValue::Unit)
                            None => RuntimeValue::Unit
                          }
                          let rhs_value = self.visit(field)
                          match op.name {
                            @syntax.LongIdent::Ident(name=op_name) =>
                              runtime_value_infix(
                                op_name, current_field_value, rhs_value,
                              )
                            _ => rhs_value
                          }
                        }
                        _ => self.visit(field)
                      }
                    None => self.visit(field)
                  }

                  // 更新RuntimeStore中的记录字段
                  match accessor {
                    @syntax.Accessor::Label(label) => {
                      self.runtime_store.update_struct_field(
                        ref_id,
                        label.name,
                        new_field_value,
                      )
                      |> ignore
                      RuntimeValue::Unit
                    }
                    _ => RuntimeValue::Unit
                  }
                }
                _ => RuntimeValue::Unit
              }
            }
            _ => RuntimeValue::Unit
          }
        _ => RuntimeValue::Unit
      }

    // 处理 Continue 表达式
    Continue(args~, ..) => {
      let continue_args = args.map(fn(arg) { self.visit(arg) }).to_array()
      RuntimeValue::Continue(continue_args)
    }

    // 处理 Break 表达式
    Break(arg~, ..) =>
      match arg {
        Some(expr) => {
          let break_value = self.visit(expr)
          RuntimeValue::Break(Some(break_value))
        }
        None => RuntimeValue::Break(None)
      }

    // 其他情况暂时返回 Unit，可以逐步完善
    _ => RuntimeValue::Unit
  }
}

///| 模式匹配的 RuntimeValue 版本
fn ClosureInterpreter::pattern_matches_runtime(
  self : ClosureInterpreter,
  value : RuntimeValue,
  pattern : @syntax.Pattern,
) -> Bool {
  match pattern {
    // 变量模式匹配（总是匹配，并绑定变量）
    @syntax.Pattern::Var({ name, .. }) => {
      self.set_immutable_variable(name, value)
      true
    }

    // 常量模式匹配
    @syntax.Pattern::Constant(c=pattern_const, ..) =>
      match (value, pattern_const) {
        (RuntimeValue::Int(v), @syntax.Constant::Int(s)) => {
          let pattern_int = @strconv.parse_int(s) catch { _ => 0 }
          v == pattern_int
        }
        (RuntimeValue::Bool(v), @syntax.Constant::Bool(b)) => v == b
        (RuntimeValue::String(v), @syntax.Constant::String(s)) => v == s
        (RuntimeValue::Double(v), @syntax.Constant::Double(s)) => {
          let pattern_double = @strconv.parse_double(s) catch { _ => 0.0 }
          v == pattern_double
        }
        (RuntimeValue::Char(v), @syntax.Constant::Char(s)) => {
          let pattern_char = s.get_char(0).unwrap_or(' ')
          v == pattern_char
        }
        _ => false
      }

    // 通配符模式（总是匹配）
    @syntax.Pattern::Any(..) => true

    // Tuple模式匹配
    @syntax.Pattern::Tuple(pats~, ..) =>
      match value {
        RuntimeValue::Tuple(values) => {
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
    @syntax.Pattern::Array(pats~, ..) =>
      match value {
        RuntimeValue::Array(values) =>
          match pats {
            @syntax.ArrayPatterns::Closed(patterns) => {
              if values.length() != patterns.length() {
                return false
              }
              let mut pat_list = patterns
              let mut index = 0
              while true {
                match pat_list {
                  @list.More(array_pat, tail=pat_tail) => {
                    match array_pat {
                      @syntax.ArrayPattern::Pattern(pat) =>
                        if not(self.pattern_matches_runtime(values[index], pat)) {
                          return false
                        }
                      _ => return false // 其他数组模式暂不支持
                    }
                    pat_list = pat_tail
                    index = index + 1
                  }
                  @list.Empty => break
                }
              }
              true
            }
            _ => false // 其他数组模式暂不支持
          }
        _ => false
      }

    // Or模式匹配（任一模式匹配即可）
    @syntax.Pattern::Or(pat1~, pat2~, ..) =>
      self.pattern_matches_runtime(value, pat1) ||
      self.pattern_matches_runtime(value, pat2)

    // Record模式匹配
    @syntax.Pattern::Record(fields=pat_fields, ..) =>
      match value {
        RuntimeValue::StructRef(ref_id) =>
          match self.runtime_store.get_struct(ref_id) {
            Some(record_fields) => {
              for pat_field in pat_fields {
                match record_fields.get(pat_field.label.name) {
                  Some(field_value) =>
                    if not(
                        self.pattern_matches_runtime(
                          field_value,
                          pat_field.pattern,
                        ),
                      ) {
                      return false
                    }
                  None => return false
                }
              }
              true
            }
            None => false
          }
        _ => false
      }

    // Range模式匹配
    @syntax.Pattern::Range(lhs~, rhs~, inclusive~, ..) =>
      self.runtime_value_in_range(value, lhs, rhs, inclusive)

    // Constructor模式匹配
    @syntax.Pattern::Constr(constr~, ..) => {
      // 查找构造函数对应的值
      let constr_runtime_value = self.find_runtime(constr.name.name)
      match (value, constr_runtime_value) {
        // 如果构造函数是常量值，直接比较
        (RuntimeValue::Int(v1), RuntimeValue::Int(v2)) => v1 == v2
        (RuntimeValue::Bool(v1), RuntimeValue::Bool(v2)) => v1 == v2
        (RuntimeValue::String(v1), RuntimeValue::String(v2)) => v1 == v2
        (RuntimeValue::Double(v1), RuntimeValue::Double(v2)) => v1 == v2
        (RuntimeValue::Char(v1), RuntimeValue::Char(v2)) => v1 == v2
        _ => false
      }
    }

    // 其他模式暂不支持
    _ => false
  }
}

///| 检查 RuntimeValue 是否在指定范围内
fn ClosureInterpreter::runtime_value_in_range(
  self : ClosureInterpreter,
  value : RuntimeValue,
  lhs : @syntax.Pattern,
  rhs : @syntax.Pattern,
  inclusive : Bool,
) -> Bool {
  // 获取范围的左右边界值
  let lhs_value = self.pattern_to_runtime_value(lhs)
  let rhs_value = self.pattern_to_runtime_value(rhs)
  match (value, lhs_value, rhs_value) {
    // 整数范围匹配
    (
      RuntimeValue::Int(v),
      Some(RuntimeValue::Int(l)),
      Some(RuntimeValue::Int(r)),
    ) => if inclusive { v >= l && v <= r } else { v >= l && v < r }

    // 字符范围匹配
    (
      RuntimeValue::Char(v),
      Some(RuntimeValue::Char(l)),
      Some(RuntimeValue::Char(r)),
    ) => {
      let val = v
      let left = l
      let right = r
      if inclusive {
        val >= left && val <= right
      } else {
        val >= left && val < right
      }
    }

    // 处理开放范围（如 _..<Zero 或 1..<_）
    (
      RuntimeValue::Int(v),
      None, // 左边界是通配符
      Some(RuntimeValue::Int(r)),
    ) => if inclusive { v <= r } else { v < r }
    (
      RuntimeValue::Int(v),
      Some(RuntimeValue::Int(l)), // 右边界是通配符
      None,
    ) => v >= l
    _ => false
  }
}

///| 将模式转换为 RuntimeValue（用于范围匹配）
fn ClosureInterpreter::pattern_to_runtime_value(
  self : ClosureInterpreter,
  pattern : @syntax.Pattern,
) -> RuntimeValue? {
  match pattern {
    @syntax.Pattern::Constant(c~, ..) =>
      match c {
        @syntax.Constant::Int(v) => {
          let int_val = @strconv.parse_int(v) catch { _ => return None }
          Some(RuntimeValue::Int(int_val))
        }
        @syntax.Constant::Double(v) => {
          let double_val = @strconv.parse_double(v) catch { _ => return None }
          Some(RuntimeValue::Double(double_val))
        }
        @syntax.Constant::String(v) => Some(RuntimeValue::String(v))
        @syntax.Constant::Char(v) =>
          if v.length() > 0 && v.get(0) is Some(ch) {
            Some(RuntimeValue::Char(ch.unsafe_to_char()))
          } else {
            None
          }
        @syntax.Constant::Bool(v) => Some(RuntimeValue::Bool(v))
        @syntax.Constant::Bytes(_) => None
        @syntax.Constant::Byte(_) => None
        @syntax.Constant::Int64(_) => None
        @syntax.Constant::UInt64(_) => None
        @syntax.Constant::UInt(_) => None
        @syntax.Constant::Float(_) => None
        @syntax.Constant::BigInt(_) => None
      }
    @syntax.Pattern::Constr(constr~, ..) =>
      // 查找构造函数的值
      Some(self.find_runtime(constr.name.name))
    @syntax.Pattern::Any(..) => None // 通配符表示开放边界
    _ => None
  }
}

///| 查找方法的类型和执行器
priv enum MethodType {
  UserFunction(@syntax.Func)
  EmbeddedFunction(String)
  RuntimeFunction(@syntax.Func)
  ExternFunction((Array[RuntimeArgument]) -> RuntimeValue)
  GlobalEmbedded((Array[RuntimeArgument]) -> RuntimeValue)
  NotFound
}

///| 按名称查找方法
fn ClosureInterpreter::find_method(
  self : ClosureInterpreter,
  name : String,
) -> MethodType {
  let name = self.fn_aliases.get(name).unwrap_or(name)

  // 按优先级查找：用户函数 -> Lambda变量 -> 外部函数 -> embedded函数
  match self.find_user_function(name) {
    Some(function) =>
      // 检查是否是embedded函数的标记函数
      match function {
        Lambda(body=Ident(id~, ..), ..) =>
          match id.name {
            Ident(name=embedded_name) =>
              MethodType::EmbeddedFunction(embedded_name)
            _ => MethodType::UserFunction(function)
          }
        _ => MethodType::UserFunction(function)
      }
    None => {
      let var_runtime_value = self.find_runtime(name)
      match var_runtime_value {
        RuntimeValue::Function(lambda_func) =>
          MethodType::RuntimeFunction(lambda_func)
        _ =>
          match self.extern_fns.get(name) {
            Some(extern_func) => MethodType::ExternFunction(extern_func)
            None =>
              match self.embedded_fns.get(name) {
                Some(embedded_func) => MethodType::GlobalEmbedded(embedded_func)
                None => MethodType::NotFound
              }
          }
      }
    }
  }
}

///| 按名称执行函数调用
fn ClosureInterpreter::execute_function_by_name(
  self : ClosureInterpreter,
  name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  match self.find_method(name) {
    MethodType::UserFunction(function) =>
      self.execute_function_call_runtime(function, args)
    MethodType::EmbeddedFunction(embedded_name) => {
      let evaluated_args = args
        .map(arg => { value: self.visit(arg.value), kind: arg.kind })
        .to_array()
      match self.embedded_fns.get(embedded_name) {
        Some(embedded_func) => embedded_func(evaluated_args)
        None => RuntimeValue::Unit
      }
    }
    MethodType::RuntimeFunction(lambda_func) =>
      self.execute_function_call_runtime(lambda_func, args)
    MethodType::ExternFunction(extern_func) => {
      let evaluated_args = args
        .map(arg => { value: self.visit(arg.value), kind: arg.kind })
        .to_array()
      extern_func(evaluated_args)
    }
    MethodType::GlobalEmbedded(embedded_func) => {
      let evaluated_args = args
        .map(arg => { value: self.visit(arg.value), kind: arg.kind })
        .to_array()
      embedded_func(evaluated_args)
    }
    MethodType::NotFound => RuntimeValue::Unit
  }
}

///| 执行结构体方法调用（返回 RuntimeValue）
fn ClosureInterpreter::execute_method_call_runtime(
  self : ClosureInterpreter,
  self_expr : @syntax.Expr,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  // 先获取self的运行时值
  let self_value = self.visit(self_expr)

  // 根据运行时值推断类型
  let self_type = match self_value {
    RuntimeValue::StructRef(ref_id) =>
      // 对于StructRef，尝试从store中获取字段信息来推断类型
      match self.runtime_store.get_struct(ref_id) {
        Some(struct_data) => {
          // 收集字段名
          let current_fields = []
          struct_data.each(fn(field_name, _) { current_fields.push(field_name) })
          // 使用公共方法推导类型
          self.infer_struct_type_from_fields(current_fields)
        }
        None => "Struct"
      }
    _ => self.find_type(self_expr)
  }
  match self.struct_methods.get(self_type) {
    Some(methods) =>
      match methods.get(method_name) {
        Some(func) =>
          // 普通函数，正常调用
          self.with_scope(fn() {
            // 手动绑定self参数和其他参数
            match func {
              @syntax.Func::Lambda(parameters~, body~, ..) => {
                // 绑定self参数（第一个参数）
                match parameters {
                  @list.More(first_param, tail=rest_params) => {
                    match first_param {
                      @syntax.Parameter::Positional(binder={ name, .. }, ..) =>
                        ignore(
                          self.current_immutable_scope().set(name, self_value),
                        )
                      @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
                        ignore(
                          self.current_immutable_scope().set(name, self_value),
                        )
                      _ => ()
                    }
                    // 绑定其他参数
                    self.bind_function_parameters_runtime(rest_params, args)
                  }
                  @list.Empty => ()
                }

                // 执行函数体
                self.visit(body)
              }
              _ => RuntimeValue::Unit
            }
          })
        None => RuntimeValue::Unit
      }
    None =>
      match self.embedded_methods.get(self_type) {
        Some(type_methods) =>
          match type_methods.get(method_name) {
            Some(embedded_method) => {
              // 准备参数：self_value + 其他参数的求值结果
              let evaluated_args = @list.construct(
                self_value,
                args.map(fn(arg) { self.visit(arg.value) }),
              )
              embedded_method(
                evaluated_args
                .map(fn(arg) { { value: arg, kind: Positional } })
                .to_array(),
              )
            }
            None => RuntimeValue::Unit
          }
        None => RuntimeValue::Unit
      }
  }
}

///| 从表达式中提取类型名称
fn ClosureInterpreter::find_type(
  self : ClosureInterpreter,
  expr : @syntax.Expr,
) -> String {
  match expr {
    Constant(c~, ..) => infer_type_from_constant(c)
    Record(type_name=Some(type_name), ..) =>
      match type_name {
        { name: Ident(name=type_name), .. } => type_name
        _ => "Unknown"
      }
    Record(type_name=None, fields~, ..) => {
      let current_fields = []
      for field in fields {
        current_fields.push(field.label.name)
      }
      self.infer_struct_type_from_fields(current_fields)
    }
    Ident(id={ name, .. }, ..) =>
      match name {
        Ident(name~) => self.find_runtime_type(self.find_runtime(name))
        _ => "Unknown"
      }
    Array(..) => "Array"
    Group(expr~, ..) => self.find_type(expr)
    _ => "Unknown"
  }
}

///| 执行静态方法调用（如 Bool::default()）
fn ClosureInterpreter::execute_static_method_call(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  // 查找嵌入式方法
  match self.embedded_methods.get(type_name) {
    Some(methods) =>
      match methods.get(method_name) {
        Some(embedded_func) => {
          let evaluated_args = args
            .map(arg => { value: self.visit(arg.value), kind: arg.kind })
            .to_array()
          embedded_func(evaluated_args)
        }
        None => RuntimeValue::Unit
      }
    None => RuntimeValue::Unit
  }
}

///| 根据 RuntimeValue 推断类型
// 提取的公共方法：根据字段名推导结构体类型
fn ClosureInterpreter::infer_struct_type_from_fields(
  self : ClosureInterpreter,
  current_fields : Array[String],
) -> String {
  let mut result = "Struct"
  self.type_definitions
  .iter()
  .each(fn(entry) {
    let (type_name, type_def) = entry
    match type_def.components {
      Record(struct_fields) =>
        if struct_fields.length() == current_fields.length() {
          let mut all_match = true
          for struct_field in struct_fields {
            let mut found = false
            for current_field in current_fields {
              if struct_field.name.label == current_field {
                found = true
                break
              }
            }
            if not(found) {
              all_match = false
              break
            }
          }
          if all_match {
            result = type_name
          }
        }
      _ => ()
    }
  })
  result
}

///|
fn ClosureInterpreter::find_runtime_type(
  self : ClosureInterpreter,
  runtime_value : RuntimeValue,
) -> String {
  match runtime_value {
    RuntimeValue::Unit => "Unit"
    RuntimeValue::Bool(_) => "Bool"
    RuntimeValue::Int(_) => "Int"
    RuntimeValue::UInt(_) => "UInt"
    RuntimeValue::Int64(_) => "Int64"
    RuntimeValue::UInt64(_) => "UInt64"
    RuntimeValue::Float(_) => "Float"
    RuntimeValue::Double(_) => "Double"
    RuntimeValue::Char(_) => "Char"
    RuntimeValue::Byte(_) => "Byte"
    RuntimeValue::String(_) => "String"
    RuntimeValue::Tuple(_) => "Tuple"
    RuntimeValue::Array(_) => "Array"
    RuntimeValue::StructRef(ref_id) =>
      // 对于StructRef，尝试从store中获取字段信息来推断类型
      match self.runtime_store.get_struct(ref_id) {
        Some(struct_data) => {
          // 收集字段名
          let current_fields = []
          struct_data.each(fn(field_name, _) { current_fields.push(field_name) })
          // 使用公共方法推导类型
          self.infer_struct_type_from_fields(current_fields)
        }
        None => "Struct"
      }
    RuntimeValue::Function(_) => "Function"
    RuntimeValue::Break(_) => "Break"
    RuntimeValue::Continue(_) => "Continue"
  }
}

///| 安全的索引访问，统一处理数组和元组的边界检查
fn safe_index_access(values : Array[RuntimeValue], index : Int) -> RuntimeValue {
  if index >= 0 && index < values.length() {
    values[index]
  } else {
    RuntimeValue::Unit
  }
}

///| 作用域管理辅助函数，确保作用域正确清理
fn[T] ClosureInterpreter::with_scope(
  self : ClosureInterpreter,
  f : () -> T,
) -> T {
  self.push_scope()
  let result = f()
  self.pop_scope()
  result
}
