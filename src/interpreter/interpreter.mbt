///| 支持引用系统和泛型的解释器
pub(all) struct ClosureInterpreter {
  extern_fns : Map[String, RuntimeFunction]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, RuntimeFunction]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[String, Map[String, RuntimeFunction]]
  // 函数别名存储 - 存储函数名到其实际实现的映射
  fn_aliases : Map[String, String]
  // 变量
  values : Array[Map[String, RuntimeValue]]
  // 用户定义的函数
  user_functions : Array[Map[String, @syntax.Func]]
  // 类型定义
  type_definitions : Map[String, @syntax.TypeDecl]
  // 结构体方法定义 - 按类型名组织方法
  struct_methods : Map[String, Map[String, @syntax.Func]]
  // 泛型类型环境栈
  type_environments : Array[TypeEnvironment]
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
    values: [{}],
    user_functions: [{}],
    type_definitions: Map::new(),
    struct_methods: Map::new(),
    type_environments: [TypeEnvironment::new()],
  }
}

///|
pub fn ClosureInterpreter::add_extern_fn(
  self : ClosureInterpreter,
  name : String,
  f : RuntimeFunction,
) -> Unit {
  self.extern_fns.set(name, f)
}

///|
pub fn ClosureInterpreter::add_embedded_fn(
  self : ClosureInterpreter,
  name : String,
  f : RuntimeFunction,
) -> Unit {
  self.embedded_fns.set(name, f)
}

///|
pub fn ClosureInterpreter::add_embedded_method(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  f : RuntimeFunction,
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

///| 获取当前变量作用域
fn ClosureInterpreter::current_scope(
  self : ClosureInterpreter,
) -> Map[String, RuntimeValue] {
  // values 数组永远非空（初始化为 [{}]），直接访问最后一个元素
  self.values[self.values.length() - 1]
}

///| 查找变量并返回其 RuntimeValue（新的优化方法）
fn ClosureInterpreter::find_runtime(
  self : ClosureInterpreter,
  name : String,
) -> RuntimeValue {
  find_variable(self.values, name)
}

///|
pub fn ClosureInterpreter::top_visit(
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
      self.set_variable(binder.name, self.visit(expr))
    TopTypeDef(def) =>
      match def {
        { tycon, params, components, .. } => {
          self.type_definitions.set(tycon, def)

          // 处理泛型类型参数
          let type_params = []
          for param in params {
            match param {
              { name, .. } => type_params.push(name)
            }
          }

          // 注册枚举构造函数到运行时环境
          match components {
            Variant(constructors) =>
              for constr in constructors {
                let constr_name = constr.name.name
                // 将构造函数注册为无参数的Constructor
                // TODO: 对于泛型类型，需要在实例化时处理类型参数
                self.set_variable(
                  constr_name,
                  RuntimeValue::Constructor(constr_name, []),
                )
              }
            _ => () // Record类型不需要注册构造函数
          }
        }
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

      // 处理泛型函数的类型参数
      let type_params = []
      for quantifier in fun_decl.quantifiers {
        match quantifier {
          { name, .. } => type_params.push(name)
        }
      }

      // 从decl_body中提取函数体
      match decl_body {
        DeclBody(local_types=_, expr~) => {
          // 如果是泛型函数，需要在函数调用时进行类型参数绑定
          // TODO: 实现泛型函数的类型参数推导机制

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
pub fn ClosureInterpreter::visit(
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
          @value.runtime_value_infix(name, left_val, right_val)
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
      RuntimeValue::Struct(@ref.new(evaluated_fields))
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
    Function(func~, ..) => RuntimeValue::FuncRef(func)

    // 处理 Let 绑定
    Let(pattern~, expr~, body~, ..) => {
      let evaluated_expr = self.visit(expr)
      ignore(self.pattern_matches_runtime(evaluated_expr, pattern))
      self.visit(body)
    }

    // 处理可变变量声明
    LetMut(binder={ name, .. }, expr~, body~, ..) => {
      let runtime_value = self.visit(expr)
      self.set_variable(name, runtime_value)
      // 执行body部分，这是关键！
      self.visit(body)
    }

    // 处理函数定义
    LetFn(name={ name, .. }, func~, body~, ..) => {
      self.define_function(name, func)
      match body {
        Unit(..) => RuntimeValue::FuncRef(func)
        _ => self.visit(body)
      }
    }

    // 处理赋值操作
    Assign(var_~, expr~, augmented_by~, ..) =>
      match var_.name {
        Ident(name~) => {
          let new_value = match augmented_by {
            Some(op) => {
              let current_value = self.find_runtime(name)
              match op.name {
                Ident(name=op_name) => {
                  let rhs_value = self.visit(expr)
                  @value.runtime_value_infix(op_name, current_value, rhs_value)
                }
                _ => self.visit(expr)
              }
            }
            None => self.visit(expr)
          }
          self.update_variable(name, new_value)
          RuntimeValue::Unit
        }
        _ => RuntimeValue::Unit
      }

    // 处理函数调用
    Apply(func~, args~, ..) =>
      match func {
        Ident(id={ name: @syntax.LongIdent::Ident(name~), .. }, ..) =>
          self.execute_function_by_name(name, args)
        // 处理构造函数调用，如 Some(5)
        Constr(constr~, ..) => {
          let arg_values = args
            .map(fn(arg) { self.visit(arg.value) })
            .to_array()

          // TODO: 对于泛型类型的构造函数，需要根据参数类型推导类型参数
          // 例如：Cons(1, Nil) 应该推导出 List[Int]
          let constr_name = constr.name.name
          RuntimeValue::Constructor(constr_name, arg_values)
        }
        // 处理静态方法调用，如 Bool::default()
        Method(type_name~, method_name~, ..) => {
          let type_str = match type_name.name {
            @syntax.LongIdent::Ident(name~) => name
            _ => "Unknown"
          }
          self.execute_static_method_call(type_str, method_name.name, args)
        }
        // 处理其他表达式作为函数的情况，如 a[1](10)
        _ => {
          let func_value = self.visit(func)
          match func_value {
            RuntimeValue::FuncRef(function) => self.call(function, args)
            RuntimeValue::Closure(function, captured_env) => {
              // 调用闭包：恢复捕获的环境
              self.push_scope()
              // 将捕获的环境变量绑定到当前作用域
              captured_env
              .iter()
              .each(fn(entry) {
                let (var_name, value) = entry
                self.current_scope().set(var_name, value)
              })
              let result = self.call(function, args)
              self.pop_scope()
              result
            }
            _ => RuntimeValue::Unit
          }
        }
      }

    // 处理 if 表达式
    If(cond~, ifso~, ifnot~, ..) => {
      let cond_val = self.visit(cond)
      match cond_val {
        Bool(true) => self.visit(ifso)
        Bool(false) =>
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
        (RuntimeValue::Struct({ val: fields }), @syntax.Accessor::Label(label)) =>
          match fields.get(label.name) {
            Some(field_value) => field_value
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
          let left_expr = left_val.to_expr()
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
              let left_expr = left_val.to_expr()
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
              let left_expr = left_val.to_expr()
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
              self.set_variable(binder.name, init_value)
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
                    self.set_variable(binder.name, new_value)
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
                self.set_variable(binder.name, new_value)
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
    Mutate(record~, accessor~, field~, augmented_by~, ..) => {

      // 获取记录的运行时值（支持嵌套字段访问）
      match self.visit(record) {
        RuntimeValue::Struct(refer) =>
          match accessor {
            Label(label) => refer.val.set(label.name, self.visit(field))
            Index(tuple_index~, ..) =>
              refer.val.set(tuple_index.to_string(), self.visit(field))
            Newtype(_) => ()
          }
        _ => ()
      }
      RuntimeValue::Unit
    }

    // 处理 Continue 表达式
    Continue(args~, ..) => {
      let continue_args = args.map(fn(arg) { self.visit(arg) }).to_array()
      RuntimeValue::Continue(continue_args)
    }

    // 处理单独的构造函数表达式，如 None
    Constr(constr~, ..) =>
      // 单独的构造函数没有参数
      RuntimeValue::Constructor(constr.name.name, [])

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
      self.set_variable(name, value)
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
        RuntimeValue::Struct({ val: record_fields }) => {
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
    @syntax.Pattern::Range(lhs~, rhs~, inclusive~, ..) =>
      self.runtime_value_in_range(value, lhs, rhs, inclusive)

    // Constructor模式匹配
    @syntax.Pattern::Constr(constr~, args=pattern_args, ..) =>
      match value {
        RuntimeValue::Constructor(name, runtime_args) =>
          if name == constr.name.name {
            // 检查参数匹配
            match pattern_args {
              Some(pat_args) => {
                // 有参数的构造函数，需要递归匹配每个参数
                if runtime_args.length() != pat_args.length() {
                  return false
                }
                let mut pat_list = pat_args
                let mut index = 0
                while true {
                  match pat_list {
                    @list.More(pat_arg, tail=pat_tail) => {
                      // 提取参数模式并递归匹配
                      let arg_pattern = pat_arg.pat
                      if not(
                          self.pattern_matches_runtime(
                            runtime_args[index],
                            arg_pattern,
                          ),
                        ) {
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
              None =>
                // 无参数的构造函数，只需要名称匹配
                runtime_args.length() == 0
            }
          } else {
            false
          }
        _ => {
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

///| 检查函数是否为已知函数（存在于任何函数映射中）
pub fn ClosureInterpreter::is_known_function(
  self : ClosureInterpreter,
  name : String,
) -> Bool {
  let actual_name = self.fn_aliases.get(name).unwrap_or(name)

  // 检查外部函数
  if self.extern_fns.contains(actual_name) {
    return true
  }

  // 检查嵌入函数
  if self.embedded_fns.contains(actual_name) {
    return true
  }

  // 检查用户定义函数
  if self.find_user_function(actual_name) is Some(_) {
    return true
  }
  false
}

///| 查找方法的类型和执行器
priv enum MethodType {
  UserFunction(@syntax.Func)
  EmbeddedFunction(String)
  RuntimeFunction(@syntax.Func)
  RuntimeClosure(@syntax.Func, Map[String, RuntimeValue])
  ExternFunction(RuntimeFunction)
  GlobalEmbedded(RuntimeFunction)
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
        Lambda(body=Ident(id={ name: Ident(name=embedded_name), .. }, ..), ..) =>
          match embedded_name {
            ['%', ..] => MethodType::EmbeddedFunction(embedded_name)
            _ => MethodType::UserFunction(function)
          }
        _ => MethodType::UserFunction(function)
      }
    None => {
      let var_runtime_value = self.find_runtime(name)
      match var_runtime_value {
        RuntimeValue::FuncRef(lambda_func) =>
          MethodType::RuntimeFunction(lambda_func)
        RuntimeValue::Closure(lambda_func, captured_env) =>
          MethodType::RuntimeClosure(lambda_func, captured_env)
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
  fn get_evaluated_args() -> Array[RuntimeArgument] {
    args
    .map(arg => RuntimeArgument::{
      value: self.visit(arg.value),
      kind: arg.kind,
    })
    .to_array()
  }

  match self.find_method(name) {
    MethodType::UserFunction(function) =>
      // 检查是否为泛型函数，如果是则进行类型参数推导
      // TODO: 实现基于参数类型的类型参数推导
      // 目前先直接调用，后续可以根据实际参数类型推导类型参数
      self.call(function, args)
    MethodType::EmbeddedFunction(embedded_name) =>
      match self.embedded_fns.get(embedded_name) {
        Some(embedded_func) =>
          embedded_func(RuntimeFunctionContext::{
            context: self,
            arguments: get_evaluated_args(),
          })
        None => RuntimeValue::Unit
      }
    MethodType::RuntimeFunction(lambda_func) => self.call(lambda_func, args)
    MethodType::RuntimeClosure(lambda_func, captured_env) => {
      // 调用闭包：恢复捕获的环境
      self.push_scope()
      // 将捕获的环境变量绑定到当前作用域
      captured_env
      .iter()
      .each(fn(entry) {
        let (var_name, value) = entry
        self.current_scope().set(var_name, value)
      })
      let result = self.call(lambda_func, args)
      self.pop_scope()
      result
    }
    MethodType::ExternFunction(extern_func) =>
      extern_func(RuntimeFunctionContext::{
        context: self,
        arguments: get_evaluated_args(),
      })
    MethodType::GlobalEmbedded(embedded_func) =>
      embedded_func(RuntimeFunctionContext::{
        context: self,
        arguments: get_evaluated_args(),
      })
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
    RuntimeValue::Struct({ val: struct_data }) => {
      // 收集字段名
      let current_fields = []
      struct_data.each(fn(field_name, _) { current_fields.push(field_name) })
      // 使用公共方法推导类型
      self.infer_struct_type_from_fields(current_fields)
    }
    _ => self.find_runtime_type(self_value)
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
                        ignore(self.current_scope().set(name, self_value))
                      @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
                        ignore(self.current_scope().set(name, self_value))
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
              embedded_method(RuntimeFunctionContext::{
                context: self,
                arguments: evaluated_args
                .map(fn(arg) {
                  @value.RuntimeArgument::{ value: arg, kind: Positional }
                })
                .to_array(),
              })
            }
            None => Unit
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
    Constant(c~, ..) => @value.infer_type_from_constant(c)
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
  // 首先查找用户定义的struct方法
  match self.struct_methods.get(type_name) {
    Some(methods) =>
      match methods.get(method_name) {
        Some(func) =>
          // 执行用户定义的静态方法
          return self.with_scope(fn() {
            match func {
              @syntax.Func::Lambda(parameters~, body~, ..) => {
                // 绑定参数（静态方法没有self参数）
                self.bind_function_parameters_runtime(parameters, args)
                // 执行函数体
                self.visit(body)
              }
              _ => RuntimeValue::Unit
            }
          })
        None =>
          // 如果用户方法中没有找到，继续查找嵌入式方法
          self.execute_embedded_static_method(type_name, method_name, args)
      }
    None =>
      // 如果用户方法中没有找到，查找嵌入式方法
      self.execute_embedded_static_method(type_name, method_name, args)
  }
}

///| 执行嵌入式静态方法调用
fn ClosureInterpreter::execute_embedded_static_method(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  match self.embedded_methods.get(type_name) {
    Some(methods) =>
      match methods.get(method_name) {
        Some(embedded_func) => {
          let evaluated_args = args
            .map(arg => RuntimeArgument::{
              value: self.visit(arg.value),
              kind: arg.kind,
            })
            .to_array()
          embedded_func(RuntimeFunctionContext::{
            context: self,
            arguments: evaluated_args,
          })
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
    Unit => "Unit"
    Bool(_) => "Bool"
    Int(_) => "Int"
    UInt(_) => "UInt"
    Int64(_) => "Int64"
    UInt64(_) => "UInt64"
    Float(_) => "Float"
    Double(_) => "Double"
    Char(_) => "Char"
    Byte(_) => "Byte"
    String(_) => "String"
    Tuple(_) => "Tuple"
    Array(_) => "Array"
    Struct(struct_data) => {
      // 收集字段名
      let current_fields = []
      struct_data.val.each(fn(field_name, _) { current_fields.push(field_name) })
      // 使用公共方法推导类型
      self.infer_struct_type_from_fields(current_fields)
    }
    Closure(_) => "Closure"
    FuncRef(_) => "Function"
    Break(_) => "Break"
    Continue(_) => "Continue"
    Constructor(name, _) =>
      // 将Option构造函数映射到Option类型
      match name {
        "Some" | "None" => "Option"
        _ => name
      }
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

///| 从函数体推导返回类型
fn ClosureInterpreter::infer_return_type_from_expr(
  self : ClosureInterpreter,
  body : @syntax.Expr,
) -> String {
  match body {
    Constant(c~, ..) => @value.infer_type_from_constant(c)
    Unit(..) => "Unit"
    Array(..) => "Array"
    Tuple(..) => "Tuple"
    Record(..) => "Record"
    // 处理函数调用表达式
    Apply(func~, ..) =>
      match func {
        @syntax.Expr::Ident(
          id={ name: @syntax.LongIdent::Ident(name~), .. },
          ..
        ) =>
          // 查找函数定义并获取其返回类型
          match self.find_user_function(name) {
            Some(@syntax.Func::Lambda(return_type=Some(ret_type), ..)) =>
              @value.type_to_string(ret_type)
            Some(@syntax.Func::Lambda(return_type=None, body~, ..)) =>
              // 递归推导函数体的返回类型
              self.infer_return_type_from_expr(body)
            Some(@syntax.Func::Match(..)) => "Any"
            None => "Any"
          }
        _ => "Any"
      }
    // 处理 match 表达式
    Match(..) => "Any"
    Sequence(last_expr~, ..) => self.infer_return_type_from_expr(last_expr)
    Infix(op={ name: Ident(name=op_name), .. }, lhs~, rhs~, ..) =>
      match op_name {
        "+" | "-" | "*" | "/" | "%" => {
          // 算术运算，检查操作数类型
          let lhs_type = self.infer_return_type_from_expr(lhs)
          let rhs_type = self.infer_return_type_from_expr(rhs)
          // 如果任一操作数是数值类型，结果也是数值类型
          match (lhs_type, rhs_type) {
            ("Int", _) | (_, "Int") => "Int"
            ("Float", _) | (_, "Float") => "Float"
            ("Double", _) | (_, "Double") => "Double"
            _ => "Int" // 默认为Int
          }
        }
        "==" | "!=" | "<" | ">" | "<=" | ">=" => "Bool"
        "&&" | "||" => "Bool"
        _ => {
          let lhs_type = self.infer_return_type_from_expr(lhs)
          lhs_type
        }
      }
    _ => "Any"
  }
}

///| 将RuntimeValue转换为字符串表示（带解释器支持，用于正确的类型推导）
pub fn ClosureInterpreter::get_function_type_string(
  self : ClosureInterpreter,
  value : RuntimeValue,
) -> String {
  match value {
    Closure(func, values) => {
      self.values.push(values)
      let result = self.get_function_type_string(FuncRef(func))
      self.pop_scope()
      result
    }
    FuncRef(func) =>
      // 从函数中提取参数和返回类型信息
      match func {
        @syntax.Func::Lambda(parameters~, return_type~, body~, ..) => {
          let param_strs = []
          for param in parameters {
            let param_str = match param {
              @syntax.Parameter::Positional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + ": " + @value.type_to_string(t)
                  None => binder.name
                }
              @syntax.Parameter::Labelled(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + "~: " + @value.type_to_string(t)
                  None => binder.name + "~"
                }
              @syntax.Parameter::Optional(binder~, ty~, default~) => {
                let type_str = match ty {
                  Some(t) => binder.name + "~: " + @value.type_to_string(t)
                  None => binder.name + "~"
                }
                match default {
                  @syntax.Expr::Constant(c=@syntax.Constant::Int(val), ..) =>
                    type_str + " = " + val
                  _ => type_str
                }
              }
              @syntax.Parameter::QuestionOptional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + "?: " + @value.type_to_string(t)
                  None => binder.name + "?"
                }
              @syntax.Parameter::DiscardPositional(..) => "_"
            }
            param_strs.push(param_str)
          }
          match return_type {
            Some(t) =>
              "(" + param_strs.join(", ") + ") -> " + @value.type_to_string(t)
            None => {
              // 推断返回类型，对于柯里化函数需要特殊处理
              let inferred_type = self.infer_return_type_from_expr(body)
              "(" + param_strs.join(", ") + ") -> " + inferred_type
            }
          }
        }
        _ => "<function>"
      }
    _ => value.to_string()
  }
}
