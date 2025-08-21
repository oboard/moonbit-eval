///| 支持引用系统和泛型的解释器
pub(all) struct ClosureInterpreter {
  extern_fns : Map[String, RuntimeFunction]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, RuntimeFunction]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[String, Map[String, RuntimeFunction]]
  // 变量
  mut env : RuntimeEnvironment
  // 解释器状态
  mut state : InterpreterState
  // 模块
  modules : Map[String, RuntimeModule]
}

///| 解释器状态
pub(all) enum InterpreterState {
  Running
  Stopped
}

///|
pub fn ClosureInterpreter::new(core~ : Bool = true) -> ClosureInterpreter {
  {
    extern_fns: {},
    embedded_fns: if core {
      core_embedded_code
    } else {
      {}
    },
    embedded_methods: if core {
      core_embedded_methods
    } else {
      {}
    },
    env: {
      traits: {},
      fn_aliases: if core {
        core_fn_aliases
      } else {
        {}
      },
      deps: if core {
        core_modules
      } else {
        {}
      },
      struct_methods: {},
      type_definitions: {},
      type_environment: TypeEnvironment::new(),
      mutable_vars: {},
      values: {},
      parent: None,
    },
    // 模块
    modules: if core {
      core_modules
    } else {
      {}
    },
    state: InterpreterState::Stopped,
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

///| 获取当前变量作用域
pub fn RuntimeEnvironment::current_scope(
  self : RuntimeEnvironment,
) -> Map[String, RuntimeValue] {
  // values 数组永远非空（初始化为 [{}]），直接访问最后一个元素
  self.values
}

///|
pub fn RuntimeEnvironment::find_fn_alias(
  self : RuntimeEnvironment,
  name : String,
) -> String {
  let mut current_env = Some(self)
  while current_env is Some(env) {
    if env.fn_aliases.get(name) is Some(a) {
      return a
    }
    current_env = env.parent
  }
  name
}

///|
pub fn ClosureInterpreter::start(self : ClosureInterpreter) -> Unit {
  self.state = InterpreterState::Running
}

///|
pub fn ClosureInterpreter::stop(self : ClosureInterpreter) -> Unit {
  self.state = InterpreterState::Stopped
}

///|
pub fn ClosureInterpreter::top_visit(
  self : ClosureInterpreter,
  node : @syntax.Impl,
) -> RuntimeValue {
  match node {
    // TopView(_) => ...
    // TopImpl(_) => ...
    // TopBatchTraitAlias(_) => ...
    // TopBatchTypeAlias(_) => ...
    // TopTrait(_) => ...
    // TopFuncAlias(_) =>

    // 处理顶层常量定义（如 const Zero = 0）
    TopLetDef(binder~, expr~, ..) => {
      let value = self.visit(expr)
      self.env.set(binder.name, value)
      value
    }
    TopTypeDef(def) => {
      match def {
        { tycon, params, components, .. } => {
          self.env.type_definitions.set(tycon, def)
          self.env.struct_methods.set(tycon, Map::new())

          // 处理泛型类型参数
          let type_params = []
          for param in params {
            match param {
              { name, .. } => type_params.push(name)
            }
          } else {
            ()
          }

          // 注册枚举构造函数到运行时环境
          match components {
            Variant(constructors) =>
              for constr in constructors {
                let constr_name = constr.name.name
                self.env.type_definitions.set(constr_name, def)
              } else {
                ()
              }
            _ => () // Record类型不需要注册构造函数
          }
        }
      }
      Unit
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
      } else {
        ()
      }

      // 从decl_body中提取函数体
      match decl_body {
        DeclBody(expr~, ..) => {
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
            self.env.define_struct_method(type_name, func_name, func)
          } else {
            self.env.set(func_name, Closure(func, self.env))
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
      Unit
    }
    // 处理顶层表达式（如单独的变量引用、函数调用等）
    TopExpr(expr~, ..) => self.visit(expr) // : Binder
    // : @list.List[TypeVarConstraint]
    // : @list.List[TraitMethodDecl]
    // : Visibility
    // : Location
    // : @list.List[Attribute]
    // : DocString
    TopTrait(decl) => {
      self.env.traits.set(decl.name.name, decl)
      Unit
    }
    _ => error("TopExpr: unimplemented:" + node.to_json().stringify())
  }
  // TopTest(_) => ...
  // TopImplRelation(_) => ...
}

///| 新的优化版本：直接返回 RuntimeValue
pub fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @syntax.Expr,
) -> RuntimeValue {
  if self.state is InterpreterState::Stopped {
    return Unit
  }
  match node {
    // 处理常量
    Constant(c~, ..) => RuntimeValue::from_constant(c)

    // 处理变量标识符
    Ident(id={ name, .. }, ..) =>
      self.env.with_ident(name, fn(env, name) { env.find(name) })

    // 处理中缀表达式（如 1+1）
    Infix(op~, lhs~, rhs~, ..) =>
      match op.name {
        Ident(name~) =>
          // 检查是否为增强赋值操作符
          match name {
            "+=" | "-=" | "*=" | "/=" | "%=" =>
              // 处理增强赋值：var op= value
              match lhs {
                // 处理字段赋值：obj.field += value
                Field(record~, accessor~, ..) => {
                  let right_val = self.visit(rhs) // 获取右侧值
                  // 执行相应的运算
                  let base_op = match name {
                    "+=" => "+"
                    "-=" => "-"
                    "*=" => "*"
                    "/=" => "/"
                    "%=" => "%"
                    _ => "+" // 默认
                  }
                  // 获取当前字段值并执行赋值
                  match self.visit(record) {
                    Struct(refer) =>
                      match accessor {
                        Label(label) => {
                          let current_val = refer.val
                            .get(label.name)
                            .unwrap_or(Int(0))
                          let new_val = runtime_value_infix(
                            base_op, current_val, right_val,
                          )
                          refer.val.set(label.name, new_val)
                        }
                        Index(tuple_index~, ..) => {
                          let current_val = refer.val
                            .get(tuple_index.to_string())
                            .unwrap_or(Int(0))
                          let new_val = runtime_value_infix(
                            base_op, current_val, right_val,
                          )
                          refer.val.set(tuple_index.to_string(), new_val)
                        }
                        Newtype(_) => ()
                      }
                    _ => ()
                  }
                  Unit
                }
                // 处理变量赋值：var += value
                Ident(id={ name: var_name, .. }, ..) => {
                  let var_name_str = match var_name {
                    Ident(name~) => name
                    _ => "unknown"
                  }
                  let current_val = self.env.with_ident(var_name, fn(
                    env,
                    name,
                  ) {
                    env.find(name)
                  })
                  let right_val = self.visit(rhs)
                  // 执行相应的运算
                  let base_op = match name {
                    "+=" => "+"
                    "-=" => "-"
                    "*=" => "*"
                    "/=" => "/"
                    "%=" => "%"
                    _ => "+" // 默认
                  }
                  let new_val = runtime_value_infix(
                    base_op, current_val, right_val,
                  )
                  // 更新变量
                  self.env.update(var_name_str, new_val)
                  Unit
                }
                _ => Unit // 其他情况暂不支持
              }
            "||" => {
              let left_val = self.visit(lhs)
              if left_val is Bool(true) {
                left_val
              } else {
                self.visit(rhs)
              }
            }
            "&&" => {
              let left_val = self.visit(lhs)
              if left_val is Bool(false) {
                left_val
              } else {
                self.visit(rhs)
              }
            }
            _ => {
              // 普通中缀表达式
              let left_val = self.visit(lhs)
              let right_val = self.visit(rhs)
              runtime_value_infix(name, left_val, right_val)
            }
          }
        _ => Unit
      }

    // 处理一元表达式
    Unary(op~, expr~, ..) =>
      match op.name {
        Ident(name~) => {
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
      Struct({ val: evaluated_fields, env: self.env })
    }
    ArraySpread(elems~, ..) => {
      let result_values = []
      for elem in elems {
        match elem {
          Regular(expr) => result_values.push(self.visit(expr))
          Spread(expr~, ..) => {
            let spread_value = self.visit(expr)
            match spread_value {
              Array(arr) =>
                for val in arr {
                  result_values.push(val)
                }
              _ => result_values.push(spread_value)
            }
          }
        }
      }
      Array(result_values)
    }
    ArrayGetSlice(array~, start_index~, end_index~, ..) => {
      let array_value = self.visit(array)
      match array_value {
        Array(arr) => {
          let start = start_index.map(expr => self.visit(expr))
          let end = end_index.map(expr => self.visit(expr))
          Array(
            (match (start, end) {
              (Some(Int(start)), Some(Int(end))) => arr[start:end]
              (Some(Int(start)), None) => arr[start:]
              (None, Some(Int(end))) => arr[:end]
              _ => arr[:]
            }).to_array(),
          )
        }
        _ => Unit
      }
    }
    ArraySet(array~, index~, value~, ..) => {
      let array_value = self.visit(array)
      match array_value {
        Array(arr) => {
          let index = self.visit(index)
          match index {
            Int(index) => {
              let value = self.visit(value)
              arr[index] = value
            }
            _ => ()
          }
        }
        _ => ()
      }
      Unit
    }
    ArrayAugmentedSet(array~, index~, op~, value~, ..) => {
      let array_value = self.visit(array)
      match array_value {
        Array(arr) => {
          let index = self.visit(index)
          match (index, op) {
            (Int(index), { name: Ident(name=op), .. }) => {
              let value = self.visit(value)
              arr[index] = runtime_value_infix(op, arr[index], value)
            }
            _ => ()
          }
        }
        _ => ()
      }
      Unit
    }
    // 处理元组
    Tuple(exprs~, ..) => {
      let evaluated_values = exprs.map(fn(expr) { self.visit(expr) }).to_array()
      Tuple(evaluated_values)
    }

    // 处理数组
    Array(exprs~, ..) => {
      let result_values = []
      for expr in exprs {
        match expr {
          // 处理数组展开语法 ..arr
          Unary(op~, expr~, ..) =>
            match op.name {
              Ident(name~) =>
                if name == ".." {
                  let inner_value = self.visit(expr)
                  match inner_value {
                    Array(arr) =>
                      for val in arr {
                        result_values.push(val)
                      }
                    _ => result_values.push(inner_value)
                  }
                } else {
                  result_values.push(self.visit(expr))
                }
              _ => result_values.push(self.visit(expr))
            }
          _ => result_values.push(self.visit(expr))
        }
      }
      let final_array = Array::new()
      for val in result_values {
        final_array.push(val)
      }
      Array(final_array)
    }

    // 处理函数 - 闭包应该捕获对环境的引用以支持可变变量
    Function(func~, ..) => Closure(func, self.env.create_closure_env())

    // 处理 Let 绑定
    Let(pattern~, expr~, body~, ..) => {
      let evaluated_expr = self.visit(expr)
      ignore(self.pattern_matches_runtime(evaluated_expr, pattern))
      self.visit(body)
    }

    // 处理可变变量声明
    LetMut(binder={ name, .. }, expr~, body~, ..) => {
      let runtime_value = self.visit(expr)
      self.env.set_mutable_variable(name, runtime_value)
      // 执行body部分，这是关键！
      self.visit(body)
    }

    // 处理函数定义
    LetFn(name={ name, .. }, func~, body~, ..) => {
      self.env.set(name, Closure(func, self.env))
      match body {
        Unit(..) => Closure(func, self.env)
        _ => self.visit(body)
      }
    }

    // 处理递归函数定义
    LetRec(bindings~, body~, ..) => {
      for binding in bindings {
        let env = self.env.create_closure_env()
        let name = binding.0.name
        let func = binding.1
        self.env.set(name, Closure(func, env))
      }
      self.visit(body)
    }
    LetAnd(bindings~, body~, ..) => {
      // Create a shared environment for all mutually recursive functions
      let shared_env = self.env.create_closure_env()

      // First pass: Create placeholder closures in the shared environment
      for binding in bindings {
        let name = binding.0.name
        // Initialize with a placeholder closure that will be updated
        shared_env.set(name, Unit)
      }

      // Second pass: Create actual closures with the shared environment
      for binding in bindings {
        let name = binding.0.name
        let func = binding.2
        shared_env.update(name, Closure(func, shared_env))
      }

      // Add all closures to current environment
      for binding in bindings {
        let name = binding.0.name
        self.env.set(name, shared_env.find(name))
      }
      self.visit(body)
    }

    // 处理赋值操作
    Assign(var_={ name, .. }, expr~, augmented_by~, ..) =>
      self.env.with_ident(name, fn(env, name) {
        let new_value = match augmented_by {
          Some(op) => {
            let current_value = env.find(name)
            match op.name {
              Ident(name=op_name) => {
                let rhs_value = self.visit(expr)
                runtime_value_infix(op_name, current_value, rhs_value)
              }
              _ => self.visit(expr)
            }
          }
          None => self.visit(expr)
        }
        self.env.update(name, new_value)
        Unit
      })

    // 处理函数调用
    Apply(func~, args~, ..) =>
      match func {
        Ident(id={ name, .. }, ..) => self.execute_function_by_name(name, args)
        // 处理构造函数调用，如 Some(5)
        Constr(constr~, ..) => {
          let arg_values = args
            .map(fn(arg) { self.visit(arg.value) })
            .to_array()

          // TODO: 对于泛型类型的构造函数，需要根据参数类型推导类型参数
          // 例如：Cons(1, Nil) 应该推导出 List[Int]
          let constr_name = constr.name.name
          Constructor({ val: (constr_name, arg_values), env: self.env })
        }
        // 处理静态方法调用，如 Bool::default()
        Method(type_name~, method_name~, ..) => {
          let type_str = match type_name.name {
            Ident(name~) => name
            _ => "Unknown"
          }
          // self.execute_function_by_name(type_name.name, @list.new())
          // self.env.with_ident(type_name.name, fn(env, name) {
          //   env.find(name)
          // })
          // let type_str = match type_name.name {
          //   Ident(name~) => name
          //   _ => "Unknown"
          // }
          self.execute_static_method_call(type_str, method_name.name, args)
          // 处理其他表达式作为函数的情况，如 a[1](10)
        }
        _ => {
          let func_value = self.visit(func)
          match func_value {
            Closure(function, captured_env) =>
              self.call_closure(function, captured_env, args)
            _ => Unit
          }
        }
      }

    // 处理 if 表达式
    If(cond~, ifso~, ifnot~, ..) => {
      let cond_val = self.visit(cond)
      match cond_val {
        Bool(true) => {
          let result = self.visit(ifso)
          // 如果if分支返回Return值，直接传播
          match result {
            Return(_) => result
            _ => result
          }
        }
        Bool(false) =>
          match ifnot {
            Some(else_expr) => {
              let result = self.visit(else_expr)
              // 如果else分支返回Return值，直接传播
              match result {
                Return(_) => result
                _ => result
              }
            }
            None => Unit
          }
        _ => Unit
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
        (Struct({ val: fields, .. }), Label(label)) =>
          match fields.get(label.name) {
            Some(field_value) => field_value
            None => error("Field: not found")
          }
        (Tuple(values), Index(tuple_index~, ..)) =>
          safe_index_access(values, tuple_index)
        (Array(values), Index(tuple_index~, ..)) =>
          safe_index_access(values, tuple_index)
        _ => error("Field: not implemented")
      }
    }

    // 处理方法调用 (DotApply)
    DotApply(self=self_expr, method_name~, args~, return_self~, ..) => {
      let self_value = self.visit(self_expr)
      let res = self.execute_method_call_runtime(
        self_value,
        method_name.name,
        args,
      )
      if return_self {
        self_value
      } else {
        res
      }
    }

    // 索引访问 (ArrayGet)
    ArrayGet(array~, index~, ..) => {
      let array_val = self.visit(array)
      let index_val = self.visit(index)
      match (array_val, index_val) {
        (Array(values), Int(index_num)) => safe_index_access(values, index_num)
        (String(values), Int(index_num)) => Int(values[index_num])
        (Map(values), index) =>
          values.get(index).unwrap_or_else(fn() { error("MapGet: not found") })
        _ => error("ArrayGet: not implemented")
      }
    }

    // 处理管道表达式 (Pipe) - 将左侧值作为右侧函数的第一个参数
    Pipe(lhs~, rhs~, ..) => {
      // 先评估左侧值
      let left_val = self.visit(lhs)
      match rhs {
        // 处理简单函数调用，如 5 |> ignore
        Ident(id={ name, .. }, ..) => {
          // 创建包含左侧值的参数列表
          let left_expr = left_val.to_expr()
          let pipe_args = @list.construct(
            @syntax.Argument::{ value: left_expr, kind: Positional },
            @list.new(),
          )
          self.execute_function_by_name(name, pipe_args)
        }
        // 处理方法调用，如 [] |> Array::push(5)
        Apply(func~, args~, ..) =>
          match func {
            Method(type_name~, method_name~, ..) =>
              self.env.with_ident(type_name.name, fn(_env, type_name) {
                // 将左侧值添加到参数列表前面
                let left_expr = left_val.to_expr()
                let pipe_args = @list.construct(
                  @syntax.Argument::{ value: left_expr, kind: Positional },
                  args,
                )
                self.execute_static_method_call(
                  type_name,
                  method_name.name,
                  pipe_args,
                )
              })
            Ident(id={ name, .. }, ..) => {
              // 处理函数调用，如 5 |> func(arg1, arg2)
              let left_expr = left_val.to_expr()
              let pipe_args = @list.construct(
                @syntax.Argument::{ value: left_expr, kind: Positional },
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
          Break(_) | Continue(_) | Return(_) | Exception(_) => return result
          _ => () // 继续执行下一个表达式
        }
      }
      self.visit(last_expr)
    }
    Guard(cond~, otherwise~, body~, ..) => {
      let cond_val = self.visit(cond)
      match cond_val {
        Bool(true) => self.visit(body)
        Bool(false) => otherwise.map_or(Unit, expr => self.visit(expr))
        _ => Unit
      }
    }
    Defer(expr~, body~, ..) => {
      let res = self.visit(body)
      self.visit(expr) |> ignore
      res
    }
    Is(expr~, pat~, ..) => Bool(self.pattern_matches(expr, pat))

    // 处理分组表达式
    Group(expr~, ..) => self.visit(expr)

    // 处理 For 循环
    For(binders~, condition~, continue_block~, body~, for_else~, ..) =>
      self.with_scope(fn() {
        // 初始化循环变量
        for binder_init in binders {
          match binder_init {
            (binder, init_expr) => {
              let init_value = self.visit(init_expr)
              self.env.set(binder.name, init_value)
            }
          }
        }

        // 执行更新块的辅助函数
        let execute_continue_block = () => for update_tuple in continue_block {
          match update_tuple {
            (binder, update_expr) => {
              let new_value = self.visit(update_expr)
              self.env.update(binder.name, new_value)
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
                Bool(value) => value
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
            Break(value) => return value.unwrap_or(Unit)
            Continue(arr) => {
              if !arr.is_empty() {
                binders.eachi(fn(i, binder) {
                  self.env.update(binder.0.name, arr[i])
                })
              } else {
                execute_continue_block()
              }
              continue
            }
            _ => execute_continue_block()
          }
        }
        if for_else is Some(expr) {
          self.visit(expr)
        } else {
          Unit
        }
      })

    // 处理 While 循环
    While(loop_cond~, loop_body~, while_else~, ..) => {
      let mut result = Unit
      let mut broke = false
      while true {
        let cond_result = self.visit(loop_cond)
        match cond_result {
          Bool(false) => break
          _ => ()
        }

        // 执行循环体，处理break和continue
        let body_result = self.visit(loop_body)
        match body_result {
          Break(value) => {
            result = match value {
              Some(v) => v
              None => Unit
            }
            broke = true
            break
          }
          Continue(_) =>
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
        Struct(refer) =>
          match accessor {
            Label(label) =>
              match augmented_by {
                Some(op) => {
                  // 增强赋值操作 (+=, -=, 等)
                  let op_name = match op.name {
                    Ident(name~) => name
                    _ => "+"
                  }
                  let base_op = match op_name {
                    "+" => "+"
                    "-" => "-"
                    "*" => "*"
                    "/" => "/"
                    "%" => "%"
                    _ => "+" // 默认
                  }
                  let current_val = refer.val.get(label.name).unwrap_or(Int(0))
                  let right_val = self.visit(field)
                  let new_val = runtime_value_infix(
                    base_op, current_val, right_val,
                  )
                  refer.val.set(label.name, new_val)
                }
                None =>
                  // 普通赋值操作
                  refer.val.set(label.name, self.visit(field))
              }
            Index(tuple_index~, ..) =>
              match augmented_by {
                Some(op) => {
                  // 增强赋值操作 (+=, -=, 等)
                  let op_name = match op.name {
                    Ident(name~) => name
                    _ => "+"
                  }
                  let base_op = match op_name {
                    "+" => "+"
                    "-" => "-"
                    "*" => "*"
                    "/" => "/"
                    "%" => "%"
                    _ => "+" // 默认
                  }
                  let current_val = refer.val
                    .get(tuple_index.to_string())
                    .unwrap_or(Int(0))
                  let right_val = self.visit(field)
                  let new_val = runtime_value_infix(
                    base_op, current_val, right_val,
                  )
                  refer.val.set(tuple_index.to_string(), new_val)
                }
                None =>
                  // 普通赋值操作
                  refer.val.set(tuple_index.to_string(), self.visit(field))
              }
            Newtype(_) => ()
          }
        _ => ()
      }
      Unit
    }

    // 处理 Continue 表达式
    Continue(args~, ..) => {
      let continue_args = args.map(fn(arg) { self.visit(arg) }).to_array()
      Continue(continue_args)
    }

    // 处理单独的构造函数表达式，如 None
    Constr(constr~, ..) =>
      match constr.extra_info {
        TypeName(ty_name) =>
          self.env.with_ident(ty_name.name, fn(env, _name) {
            env.cons(constr.name.name, [])
          })
        Package(_pkg) => self.env.cons(constr.name.name, [])
        _ => self.env.cons(constr.name.name, [])
      }
    // 处理 Break 表达式
    Break(arg~, ..) =>
      match arg {
        Some(expr) => {
          let break_value = self.visit(expr)
          Break(Some(break_value))
        }
        None => Break(None)
      }

    // 处理 Return 表达式
    Return(return_value~, ..) =>
      match return_value {
        Some(expr) => Return(self.visit(expr))
        None => Return(Unit)
      }

    // 处理 Raise 表达式
    Raise(err_value~, ..) => {
      let error_msg = match self.visit(err_value) {
        String(s) => s
        other => other.to_string()
      }
      Exception(error_msg)
    }

    // 处理 Loop 表达式
    Loop(body~, ..) => {
      // 简化实现：执行循环体直到遇到 break
      let mut loop_result = Unit
      let mut should_break = false
      while !should_break {
        for case in body {
          let result = self.visit(case.body)
          match result {
            Break(value) => {
              loop_result = value.unwrap_or(Unit)
              should_break = true
              break
            }
            Continue(_) => continue
            Return(_) => return result
            Exception(_) => return result
            _ => loop_result = result
          }
        }
      }
      loop_result
    }

    // 处理 Try 表达式
    Try(body~, catch_~, ..) => {
      let result = self.visit(body)
      match result {
        Exception(_msg) => {
          // 查找匹配的 catch 分支
          for case in catch_ {
            // 简化实现：执行第一个 catch 分支
            return self.visit(case.body)
          }
          result
        }
        _ => result
      }
    }

    // 处理 TryOperator 表达式 (try? 和 try!)
    TryOperator(body~, kind~, ..) => {
      let result = self.visit(body)
      match (result, kind) {
        (Exception(_), @syntax.TryOperatorKind::Question) => Unit // try? 在异常时返回 None/Unit
        (Exception(_), @syntax.TryOperatorKind::Exclamation) => result // try! 传播异常
        _ => result
      }
    }

    // 处理 As 表达式 (trait casting)
    As(expr~, trait_~, ..) => {
      // 评估表达式
      let value = self.visit(expr)
      // 提取 trait 名称
      let trait_name = match trait_ {
        { name: Ident(name=trait_name), .. } => trait_name
        _ => "Unknown"
      }
      // 创建 TraitObject 来保存原始值和 trait 信息
      TraitObject(value, trait_name)
    }

    // 处理单独的 Method 表达式（如 Calculator::add）
    // 处理记录更新表达式 (RecordUpdate)
    RecordUpdate(record~, fields~, ..) => {
      // 先评估原记录
      let original_record = self.visit(record)
      match original_record {
        Struct(original_ref) => {
          // 创建新的字段映射，复制原有字段
          let new_fields = Map::new()
          original_ref.val.each(fn(key, value) { new_fields.set(key, value) })

          // 更新指定的字段
          for field in fields {
            let field_name = field.label.name
            let field_value = self.visit(field.expr)
            new_fields.set(field_name, field_value)
          }

          // 返回新的结构体
          Struct({ val: new_fields, env: original_ref.env })
        }
        _ => error("RecordUpdate: expected struct")
      }
    }
    Method(type_name~, method_name~, ..) =>
      self.env.with_ident(type_name.name, fn(env, ty_name) {
        // 查找用户定义的静态方法
        match env.struct_methods.get(ty_name) {
          Some(methods) =>
            match methods.get(method_name.name) {
              Some(func) => func
              None => error("Method:\{ty_name}:\{method_name.name} not found")
            }
          None => error("Method:\{ty_name} not found")
        }
      })
    Map(elems~, ..) => {
      let map = elems
        .map(elem => (
          RuntimeValue::from_constant(elem.key),
          self.visit(elem.expr),
        ))
        .iter()
        |> Map::from_iter
      Map(map)
    }
    // 模板字符串中断
    Interp(elems~, ..) => String(self.interp_string(elems))
    MultilineString(elems~, ..) => {
      let buf = @buffer.new()
      elems.eachi(fn(i, elem) {
        match elem {
          String(str) => buf.write_string(str)
          Interp(elems) => buf.write_string(self.interp_string(elems))
        }
        if i < elems.length() - 1 {
          buf.write_string("\n")
        }
      })
      String(buf.to_string())
    }
    Constraint(expr~, ..) => self.visit(expr)
    Unit(_) => Unit
    _ => error("visit: unimplemented " + node.to_json().stringify())
  }
}

///|
fn ClosureInterpreter::interp_string(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.InterpElem],
) -> String {
  let buffer = @buffer.new()
  for elem in elems {
    match elem {
      Expr(expr~, ..) => buffer.write_string(self.visit(expr).to_string())
      Literal(repr~, ..) => buffer.write_string(repr)
      Source({ source, .. }) =>
        match parse_code_to_expr(source) {
          Ok(expr) => buffer.write_string(self.visit(expr).to_string())
          Err(msg) => error(msg)
        }
    }
  }
  buffer.to_string()
}

///| 模式匹配的 RuntimeValue 版本
fn ClosureInterpreter::pattern_matches_runtime(
  self : ClosureInterpreter,
  value : RuntimeValue,
  pattern : @syntax.Pattern,
) -> Bool {
  match pattern {
    // 变量模式匹配（总是匹配，并绑定变量）
    Var({ name, .. }) => {
      self.env.set(name, value)
      true
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
        Constructor({ val: (name, runtime_args), .. }) =>
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
          let constr_runtime_value = self.env.find(constr.name.name)
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
    (Int(v), Some(Int(l)), Some(Int(r))) =>
      if inclusive {
        v >= l && v <= r
      } else {
        v >= l && v < r
      }

    // 字符范围匹配
    (Char(v), Some(Char(l)), Some(Char(r))) => {
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
      Int(v),
      None, // 左边界是通配符
      Some(Int(r)),
    ) => if inclusive { v <= r } else { v < r }
    (
      Int(v),
      Some(Int(l)), // 右边界是通配符
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
      Some(self.env.find(constr.name.name))
    Any(..) => None // 通配符表示开放边界
    _ => None
  }
}

///| 检查函数是否为已知函数（存在于任何函数映射中）
pub fn ClosureInterpreter::is_known_function(
  self : ClosureInterpreter,
  name : String,
) -> Bool {
  let actual_name = self.env.find_fn_alias(name)

  // 检查外部函数
  if self.extern_fns.contains(actual_name) {
    return true
  }

  // 检查嵌入函数
  if self.embedded_fns.contains(actual_name) {
    return true
  }

  // 检查用户定义函数
  if self.env.find(actual_name) is Closure(_) {
    return true
  }
  false
}

///| 查找方法的类型和执行器
priv enum MethodType {
  EmbeddedFunction(String)
  RuntimeClosure(@syntax.Func, RuntimeEnvironment)
  ExternFunction(RuntimeFunction)
  GlobalEmbedded(RuntimeFunction)
  NotFound
}

///| 按名称查找方法
fn ClosureInterpreter::find_method(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
) -> MethodType {
  self.env.with_ident(long_ident, fn(env, name) {
    let name = self.env.find_fn_alias(name)

    // 按优先级查找：用户函数 -> Lambda变量 -> 外部函数 -> embedded函数
    match env.find(name) {
      Closure(func, env) =>
        // 检查是否是embedded函数的标记函数
        match func {
          Lambda(body=Ident(id={ name: Ident(name=embedded_name), .. }, ..), ..) =>
            match embedded_name {
              ['%', ..] => EmbeddedFunction(embedded_name)
              _ => RuntimeClosure(func, env)
            }
          _ => RuntimeClosure(func, env)
        }
      _ =>
        match self.extern_fns.get(name) {
          Some(extern_func) => ExternFunction(extern_func)
          None =>
            match self.embedded_fns.get(name) {
              Some(embedded_func) => GlobalEmbedded(embedded_func)
              None => NotFound
            }
        }
    }
  })
}

///| 按名称执行函数调用
fn ClosureInterpreter::execute_function_by_name(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
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

  match self.find_method(long_ident) {
    EmbeddedFunction(embedded_name) =>
      match self.embedded_fns.get(embedded_name) {
        Some(embedded_func) =>
          embedded_func(RuntimeFunctionContext::{
            env: self.env,
            context: self,
            arguments: get_evaluated_args(),
          })
        None => Unit
      }
    RuntimeClosure(lambda_func, captured_env) =>
      // 调用闭包：使用专门的闭包调用方法
      self.call_closure(lambda_func, captured_env, args)
    ExternFunction(extern_func) =>
      extern_func(RuntimeFunctionContext::{
        env: self.env,
        context: self,
        arguments: get_evaluated_args(),
      })
    GlobalEmbedded(embedded_func) =>
      embedded_func(RuntimeFunctionContext::{
        env: self.env,
        context: self,
        arguments: get_evaluated_args(),
      })
    NotFound => error("Method:\{long_ident.to_json().stringify()} not found")
  }
}

///| 执行结构体方法调用（返回 RuntimeValue）
fn ClosureInterpreter::execute_method_call_runtime(
  self : ClosureInterpreter,
  self_value : RuntimeValue,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  // 处理 TraitObject，提取原始值和类型
  let (actual_self_value, self_type) = match self_value {
    TraitObject(original_value, _trait_name) => {
      // 对于 TraitObject，使用原始值的类型来查找方法
      let original_type = match original_value {
        Struct({ val: struct_data, .. }) => {
          let current_fields = []
          struct_data.each(fn(field_name, _) { current_fields.push(field_name) })
          self.infer_struct_type_from_fields(current_fields)
        }
        _ => self.find_variable_type(original_value)
      }
      (original_value, original_type)
    }
    Struct({ val: struct_data, .. }) => {
      // 收集字段名
      let current_fields = []
      struct_data.each(fn(field_name, _) { current_fields.push(field_name) })
      // 使用公共方法推导类型
      (self_value, self.infer_struct_type_from_fields(current_fields))
    }
    _ => (self_value, self.find_variable_type(self_value))
  }
  let cur_env = if self_value is RuntimeValue::Struct({ env, .. }) {
    env
  } else {
    self.env
  }
  match cur_env.find_method(self_type, method_name) {
    Some(func) =>
      // 普通函数，正常调用
      self.with_scope(fn() {
        // 手动绑定self参数和其他参数
        match func {
          Closure(@syntax.Func::Lambda(parameters~, body~, ..), _env) => {
            // 绑定self参数（第一个参数）
            match parameters {
              @list.More(first_param, tail=rest_params) => {
                match first_param {
                  @syntax.Parameter::Positional(binder={ name, .. }, ..)
                  | @syntax.Parameter::Labelled(binder={ name, .. }, ..) =>
                    self.env.current_scope().set(name, actual_self_value)
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
          _ => Unit
        }
      })
    None =>
      match self.embedded_methods.get(self_type) {
        Some(type_methods) =>
          match type_methods.get(method_name) {
            Some(embedded_method) => {
              // 准备参数：actual_self_value + 其他参数的求值结果
              let evaluated_args = @list.construct(
                actual_self_value,
                args.map(fn(arg) { self.visit(arg.value) }),
              )
              embedded_method(RuntimeFunctionContext::{
                context: self,
                env: self.env,
                arguments: evaluated_args
                .map(fn(arg) {
                  RuntimeArgument::{ value: arg, kind: Positional }
                })
                .to_array(),
              })
            }
            None => error("exec: \{self_type}::\{method_name} not found")
          }
        None => error("exec: \{self_type}::\{method_name} not found")
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
        Ident(name~) => self.find_variable_type(self.env.find(name))
        _ => "Unknown"
      }
    Array(..) => "Array"
    Group(expr~, ..) => self.find_type(expr)
    _ => "Unknown"
  }
}

///|
fn RuntimeEnvironment::find_method(
  self : RuntimeEnvironment,
  type_name : String,
  method_name : String,
) -> RuntimeValue? {
  let mut current_env = Some(self)
  while current_env is Some(env) {
    if env.struct_methods.get(type_name) is Some(methods) {
      if methods.get(method_name) is Some(func) {
        return Some(func)
      }
    }
    current_env = env.parent
  }
  None
}

///| 执行静态方法调用（如 Bool::default()）
fn ClosureInterpreter::execute_static_method_call(
  self : ClosureInterpreter,
  type_name : String,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue {
  // 首先查找用户定义的struct方法
  match self.env.find_method(type_name, method_name) {
    Some(func) =>
      // 执行用户定义的静态方法
      return self.with_scope(fn() {
        match func {
          RuntimeValue::Closure(
            @syntax.Func::Lambda(parameters~, body~, ..),
            _env
          ) => {
            // 绑定参数（静态方法没有self参数）
            self.bind_function_parameters_runtime(parameters, args)
            // 执行函数体
            let result = self.visit(body)
            // 处理Return值：如果函数返回Return包装器，提取其内部值
            match result {
              Return(value) => value
              _ => result
            }
          }
          _ => Unit
        }
      })
    None =>
      // 如果用户方法中没有找到，继续查找嵌入式方法
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
            env: self.env,
            context: self,
            arguments: evaluated_args,
          })
        }
        None => error("Embedded Method:\{type_name} not found")
      }
    None => error("Embedded Method:\{type_name} not found")
  }
}

///| 根据 RuntimeValue 推断类型
// 提取的公共方法：根据字段名推导结构体类型
fn ClosureInterpreter::infer_struct_type_from_fields(
  self : ClosureInterpreter,
  current_fields : Array[String],
) -> String {
  let mut result = "Struct"
  self.env.type_definitions
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
fn ClosureInterpreter::find_variable_type(
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
    BigInt(_) => "BigInt"
    Char(_) => "Char"
    Byte(_) => "Byte"
    String(_) => "String"
    Tuple(_) => "Tuple"
    Array(_) => "Array"
    Map(_) => "Map"
    Struct(struct_data) => {
      // 收集字段名
      let current_fields = []
      struct_data.val.each(fn(field_name, _) { current_fields.push(field_name) })
      // 使用公共方法推导类型
      self.infer_struct_type_from_fields(current_fields)
    }
    Closure(_) => "Closure"
    Break(_) => "Break"
    Continue(_) => "Continue"
    Return(_) => "Return"
    Exception(_) => "Exception"
    Constructor({ val: (name, _), env: env_ }) =>
      // 将Option构造函数映射到Option类型
      match name {
        "Some" | "None" => "Option"
        _ => {
          let mut current_env = Some(env_)
          while current_env is Some(env) {
            if env.type_definitions.get(name) is Some(a) {
              return a.tycon
            }
            current_env = env.parent
          }
          "Any"
        }
      }
    TraitObject(value, _) => self.find_variable_type(value) // 返回原始值的类型
  }
}

///| 安全的索引访问，统一处理数组和元组的边界检查
fn safe_index_access(values : Array[RuntimeValue], index : Int) -> RuntimeValue {
  if index >= 0 && index < values.length() {
    values[index]
  } else {
    Unit
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
    Constant(c~, ..) => infer_type_from_constant(c)
    Unit(..) => "Unit"
    Array(..) => "Array"
    Tuple(..) => "Tuple"
    Record(..) => "Record"
    // 处理函数调用表达式
    Apply(func~, ..) =>
      match func {
        @syntax.Expr::Ident(id={ name: Ident(name~), .. }, ..) =>
          self.find_variable_type(self.env.find(name))
        _ => "Any"
      }
    // 处理 match 表达式
    Match(..) => "Any"
    Sequence(last_expr~, ..) => self.infer_return_type_from_expr(last_expr)
    Infix(op={ name: Ident(name=op_name), .. }, lhs~, ..) =>
      match op_name {
        "==" | "!=" | "<" | ">" | "<=" | ">=" | "&&" | "||" => "Bool"
        _ => self.infer_return_type_from_expr(lhs)
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
    Closure(func, _env) =>
      // 从函数中提取参数和返回类型信息
      match func {
        @syntax.Func::Lambda(parameters~, return_type~, body~, ..) => {
          let param_strs = []
          for param in parameters {
            let param_str = match param {
              @syntax.Parameter::Positional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + ": " + type_to_string(t)
                  None => binder.name
                }
              @syntax.Parameter::Labelled(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + "~: " + type_to_string(t)
                  None => binder.name + "~"
                }
              @syntax.Parameter::Optional(binder~, ty~, default~) => {
                let type_str = match ty {
                  Some(t) => binder.name + "~: " + type_to_string(t)
                  None => binder.name + "~"
                }
                match default {
                  @syntax.Expr::Constant(c=Int(val), ..) =>
                    type_str + " = " + val
                  _ => type_str
                }
              }
              @syntax.Parameter::QuestionOptional(binder~, ty~) =>
                match ty {
                  Some(t) => binder.name + "?: " + type_to_string(t)
                  None => binder.name + "?"
                }
              @syntax.Parameter::DiscardPositional(..) => "_"
            }
            param_strs.push(param_str)
          }
          match return_type {
            Some(t) => "(" + param_strs.join(", ") + ") -> " + type_to_string(t)
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
