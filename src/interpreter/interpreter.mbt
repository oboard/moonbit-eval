///| 支持引用系统和泛型的解释器
pub(all) struct ClosureInterpreter {
  extern_fns : Map[String, RuntimeFunction]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, RuntimeFunction]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[String, Map[String, RuntimeFunction]]
  main : RuntimeModule
  mut current_module : RuntimeModule
  // 解释器状态
  mut state : InterpreterState
  // 调用栈跟踪
  call_stack : Array[RuntimeLocation]
}

///| 解释器状态
pub(all) enum InterpreterState {
  Running
  Stopped
}

///|
pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  let main = {
    ..moonbitlang_core_builtin_module,
    meta: ModuleMeta::new("main"),
    deps: core_modules,
  }
  {
    extern_fns: {},
    embedded_fns: core_embedded_code,
    embedded_methods: core_embedded_methods,
    main,
    current_module: main,
    state: InterpreterState::Stopped,
    call_stack: [],
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
) -> RuntimeValue raise ControlFlow {
  match node {
    // TopView(_) => ...
    // TopImpl(_) => ...
    // TopBatchTraitAlias(_) => ...
    // TopBatchTypeAlias(_) => ...
    // TopTrait(_) => ...
    // TopFuncAlias(_) =>

    // 处理顶层常量定义（如 const Zero = 0）
    TopLetDef(binder~, expr~, ..) => {
      let value = self.visit(expr) catch { _ => Unit }
      self.current_module.env.set(binder.name, value)
      value
    }
    TopTypeDef(def) => {
      match def {
        { tycon, params, components, .. } => {
          self.current_module.env.type_definitions.set(tycon, def)
          self.current_module.env.struct_methods.set(tycon, Map::new())

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
                self.current_module.env.type_definitions.set(constr_name, def)
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
            self.current_module.env.define_struct_method(
              type_name, func_name, func,
            )
          } else {
            self.current_module.env.set(
              func_name,
              Closure(func, self.current_module.env),
            )
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
    TopExpr(expr~, ..) => self.visit(expr) catch { _ => Unit } // : Binder
    // : @list.List[TypeVarConstraint]
    // : @list.List[TraitMethodDecl]
    // : Visibility
    // : Location
    // : @list.List[Attribute]
    // : DocString
    TopTrait(decl) => {
      self.current_module.env.traits.set(decl.name.name, decl)
      Unit
    }
    _ => self.error("TopExpr: unimplemented:" + node.to_json().stringify())
  }
  // TopTest(_) => ...
  // TopImplRelation(_) => ...
}

///|
pub fn[A] ClosureInterpreter::error(
  self : ClosureInterpreter,
  msg : String,
) -> A raise ControlFlow {
  error("\{self.lookup_current_function()} \{msg}")
}

///| 访问语法树节点，返回运行时值
pub fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @syntax.Expr,
) -> RuntimeValue raise ControlFlow {
  if self.state is InterpreterState::Stopped {
    return Unit
  }
  match node {
    // 处理常量
    Constant(c~, ..) => RuntimeValue::from_constant(c)

    // 处理变量标识符
    Ident(id={ name, .. }, ..) =>
      self.current_module.with_ident(name, (mod, _pkg, name) => match
        mod.env.find(name) {
        Some(v) => v
        None => self.error("variable \{name} not found")
      })

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
                    _ => "Any"
                  }
                  let current_val = self.current_module.with_ident(var_name, fn(
                    mod,
                    _pkg,
                    name,
                  ) {
                    mod.env.find(name).unwrap_or(Unit)
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
                  self.current_module.env.update(var_name_str, new_val)
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
    Record(type_name~, fields~, ..) => {
      let evaluated_fields = Map::new()
      for field in fields {
        let field_value = self.visit(field.expr)
        evaluated_fields.set(field.label.name, field_value)
      }
      fn alloc(
        env : RuntimeEnvironment,
        pkg : String,
        name : String,
      ) -> RuntimeValue {
        Struct({ val: evaluated_fields, type_info: { pkg, name, env } })
      }

      if type_name is Some(type_name) {
        self.current_module.with_ident(type_name.name, (mod, pkg, name) => alloc(
          mod.env,
          pkg,
          name,
        ))
      } else {
        let type_name = self.current_module.env.infer_struct_type_from_fields(
          evaluated_fields.keys().to_array(),
        )
        alloc(self.current_module.env, "main", type_name)
      }
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
      let self_value = self.visit(array)
      let start = match start_index {
        Some(expr) => Some(self.visit(expr))
        _ => None
      }
      let end = match end_index {
        Some(expr) => Some(self.visit(expr))
        _ => None
      }
      match self_value {
        Array(arr) =>
          ArrayView(
            match (start, end) {
              (Some(Int(start)), Some(Int(end))) => arr[start:end]
              (Some(Int(start)), None) => arr[start:]
              (None, Some(Int(end))) => arr[:end]
              _ => arr[:]
            },
          )
        // 调用op_as_view
        _ => {
          let ty = self.current_module.env.type_of(self_value)
          match ty.find_method("op_as_view") {
            Some(Closure(func, env)) =>
              self.call(
                func,
                self.current_module,
                env,
                @list.of([
                  { val: self_value, kind: Positional },
                  { val: start.unwrap_or(Unit), kind: LabelledOption("start") },
                  { val: end.unwrap_or(Unit), kind: LabelledOption("end") },
                ]),
                name="op_as_view",
              )
            Some(_) =>
              self.error("\{ty.to_string()}::op_as_view is not a function")
            None => self.error("\{ty.to_string()}::op_as_view not found")
          }
        }
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
        ArrayView(view) => {
          let index = self.visit(index)
          match index {
            Int(index) => {
              let value = self.visit(value)
              view[index] = value
            }
            _ => ()
          }
        }
        Map(map) => {
          let index = self.visit(index)
          let value = self.visit(value)
          map.set(index, value)
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
    Function(func~, ..) =>
      Closure(func, self.current_module.env.create_closure_env())

    // 处理 Let 绑定
    Let(pattern~, expr~, body~, ..) => {
      let evaluated_expr = self.visit(expr)
      ignore(self.pattern_matches_runtime(evaluated_expr, pattern))
      self.visit(body)
    }

    // 处理可变变量声明
    LetMut(binder={ name, .. }, expr~, body~, ..) => {
      let runtime_value = self.visit(expr)
      self.push_scope(RuntimeLocation::LetMut(name))
      self.current_module.env.set_mutable_variable(name, runtime_value)
      // 执行body部分，这是关键！
      self.visit(body)
    }

    // 处理函数定义
    LetFn(name={ name, .. }, func~, body~, ..) => {
      self.current_module.env.set(name, Closure(func, self.current_module.env))
      match body {
        Unit(..) => Closure(func, self.current_module.env)
        _ => self.visit(body)
      }
    }

    // 处理递归函数定义
    LetRec(bindings~, body~, ..) => {
      for binding in bindings {
        let env = self.current_module.env.create_closure_env()
        let name = binding.0.name
        let func = binding.1
        self.current_module.env.set(name, Closure(func, env))
      }
      self.visit(body)
    }
    LetAnd(bindings~, body~, ..) => {
      // Create a shared environment for all mutually recursive functions
      let shared_env = self.current_module.env.create_closure_env()

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
        self.current_module.env.set(name, shared_env.find(name).unwrap_or(Unit))
      }
      self.visit(body)
    }

    // 处理赋值操作
    Assign(var_={ name, .. }, expr~, augmented_by~, ..) =>
      self.current_module.with_ident(name, fn(mod, _pkg, name) {
        let env = mod.env
        let new_value = match augmented_by {
          Some(op) => {
            let current_value = env.find(name).unwrap_or(Unit)
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
        mod.env.update(name, new_value)
        Unit
      })

    // 处理函数调用
    Apply(func~, args~, ..) =>
      try {
        match func {
          Ident(id={ name, .. }, ..) =>
            self.execute_function_by_name(name, args)
          // 处理构造函数调用，如 Some(5)
          Constr(constr~, ..) => {
            let fields = args
              .map(arg => match arg.kind {
                Positional =>
                  ConstructorField::{
                    name: None,
                    value: self.visit(arg.value),
                    mutable: false,
                  }
                Labelled(label)
                | LabelledPun(label)
                | LabelledOption(label~, ..)
                | LabelledOptionPun(label~, ..) =>
                  ConstructorField::{
                    name: Some(label.name),
                    value: self.visit(arg.value),
                    mutable: false,
                  }
              })
              .to_array()
            let constr_name = constr.name.name
            Constructor({
              val: { name: constr_name, fields },
              type_info: self.current_module.find_static_type(constr_name),
            })
          }
          // 处理静态方法调用，如 Bool::default()
          Method(type_name~, method_name~, ..) =>
            self.current_module.with_ident(type_name.name, (mod, _pkg, name) => self.execute_static_method_call(
              mod.find_static_type(name),
              method_name.name,
              args,
            ))
          // 处理其他表达式作为函数的情况，如 a[1](10)
          _ => {
            let func_value = self.visit(func)
            match func_value {
              Closure(function, captured_env) =>
                self.call_closure(
                  function,
                  self.current_module,
                  captured_env,
                  args,
                )
              _ => Unit
            }
          }
        }
      } catch {
        Return(v) => v
        e => raise e
      }

    // 处理 if 表达式
    If(cond~, ifso~, ifnot~, ..) => {
      let cond_val = self.visit(cond)
      match (cond_val, ifnot) {
        (Bool(true), _) =>
          self.visit_scoped(ifso, RuntimeLocation::ControlFlow("if"))
        (Bool(false), Some(else_expr)) =>
          self.visit_scoped(else_expr, RuntimeLocation::ControlFlow("else"))
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
            None => self.error("Field: not found")
          }
        (Tuple(values), Index(tuple_index~, ..)) => values[tuple_index]
        (Array(values), Index(tuple_index~, ..)) => values[tuple_index]
        (Constructor(refer), Label(label)) => {
          // 构造函数字段访问处理
          let field_name = label.name

          // 按名称查找字段
          for i = 0; i < refer.val.fields.length(); i = i + 1 {
            let field = refer.val.fields[i]
            if field.name == Some(field_name) {
              break field.value
            }
          } else {
            self.error(
              "Field: " +
              field_name +
              " not found in constructor " +
              refer.val.name,
            )
          }
        }
        (Map(fields), Label(label)) =>
          match fields.get(String(label.name)) {
            Some(field_value) => field_value
            None => self.error("Field: not found")
          }
        _ => self.error("Field: not implemented")
      }
    }

    // 处理方法调用 (DotApply)
    DotApply(self=self_expr, method_name~, args~, return_self~, ..) => {
      let self_value = self.visit(self_expr)
      let res = self.execute_method_call(self_value, method_name.name, args)
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
        (Array(values), Int(index_num)) => values[index_num]
        (ArrayView(values), Int(index_num)) => values[index_num]
        (UninitializedArray(values), Int(index_num)) => values[index_num]
        (String(values), Int(index_num)) => Int(values[index_num])
        (Map(values), index) =>
          match values.get(index) {
            Some(value) => value
            None => self.error("MapGet: not found")
          }
        _ => self.error("ArrayGet: \{array_val}[\{index_val}] not implemented")
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
              self.current_module.with_ident(type_name.name, fn(
                mod,
                _pkg,
                type_name,
              ) raise ControlFlow {
                // 将左侧值添加到参数列表前面
                let left_expr = left_val.to_expr()
                let pipe_args = @list.construct(
                  @syntax.Argument::{ value: left_expr, kind: Positional },
                  args,
                )
                self.execute_static_method_call(
                  mod.find_static_type(type_name),
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
          Exception(_) => return result
          _ => continue
        }
      }
      self.visit(last_expr)
    }
    Guard(cond~, otherwise~, body~, ..) => {
      let cond_val = self.visit(cond)
      match cond_val {
        Bool(true) =>
          self.visit_scoped(body, RuntimeLocation::ControlFlow("guard"))
        Bool(false) =>
          match otherwise {
            Some(expr) =>
              self.visit_scoped(
                expr,
                RuntimeLocation::ControlFlow("guard else"),
              )
            None => Unit
          }
        _ => Unit
      }
    }
    Defer(expr~, body~, ..) => {
      let res = self.visit(body)
      self.visit(expr) |> ignore
      res
    }
    Is(expr~, pat~, ..) =>
      Bool(self.pattern_matches_runtime(self.visit(expr), pat))

    // 处理分组表达式
    Group(expr~, ..) => self.visit(expr)

    // 处理 For 循环
    For(binders~, condition~, continue_block~, body~, for_else~, ..) => {
      // 初始化循环变量
      for binder_init in binders {
        match binder_init {
          (binder, init_expr) => {
            let init_value = self.visit(init_expr)
            self.current_module.env.set(binder.name, init_value)
          }
        }
      }

      // 执行更新块的辅助函数
      let execute_continue_block = () => for update_tuple in continue_block {
        match update_tuple {
          (binder, update_expr) => {
            let new_value = self.visit(update_expr) catch { _ => Unit }
            self.current_module.env.update(binder.name, new_value)
          }
        }
      }

      // 执行循环
      while true {
        // 检查循环条件
        let should_continue = match condition {
          Some(cond) => {
            let condition_result = self.visit(cond) catch { _ => Unit }
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
        (self.visit_scoped(body, RuntimeLocation::ControlFlow("for")) catch {
          Break(value) => return value.unwrap_or(Unit)
          Continue(arr) => {
            if !arr.is_empty() {
              binders.eachi(fn(i, binder) {
                self.current_module.env.update(binder.0.name, arr[i])
              })
            } else {
              execute_continue_block()
            }
            continue
          }
          _ => Unit
        })
        |> ignore
        execute_continue_block()
      }
      if for_else is Some(expr) {
        self.visit_scoped(expr, RuntimeLocation::ControlFlow("for else")) catch {
          _ => Unit
        }
      } else {
        Unit
      }
    }

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
        (self.visit_scoped(loop_body, RuntimeLocation::ControlFlow("while")) catch {
          Break(value) => {
            result = match value {
              Some(v) => v
              None => Unit
            }
            broke = true
            break
          }
          Continue(_) => continue
          e => raise e
        })
        |> ignore
      }
      // 如果没有break，执行else分支
      if not(broke) {
        match while_else {
          Some(else_expr) =>
            result = self.visit_scoped(
              else_expr,
              RuntimeLocation::ControlFlow("while"),
            )
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
        Constructor(refer) =>
          match accessor {
            Label({ name, .. }) => {
              // 构造函数字段赋值处理
              let new_field_value = self.visit(field)
              let field = refer.val.fields.search_by(field => field.name ==
                Some(name))
              // 处理构造函数的字段赋值
              if field is Some(i) {
                refer.val.fields[i].value = new_field_value
              }
            }
            _ => () // 其他访问器类型暂不支持
          }
        _ => ()
      }
      Unit
    }

    // 处理 Continue 表达式
    Continue(args~, ..) => {
      let continue_args = args.map(fn(arg) { self.visit(arg) }).to_array()
      raise Continue(continue_args)
    }

    // 处理单独的构造函数表达式，如 None
    Constr(constr~, ..) =>
      match constr.extra_info {
        TypeName(ty_name) =>
          self.current_module.with_ident(ty_name.name, fn(_env, _pkg, _name) {
            self.current_module.cons(constr.name.name, [])
          })
        Package(_pkg) => self.current_module.cons(constr.name.name, [])
        _ => self.current_module.cons(constr.name.name, [])
      }
    // 处理 Break 表达式
    Break(arg~, ..) =>
      match arg {
        Some(expr) => {
          let break_value = self.visit(expr)
          raise Break(Some(break_value))
        }
        None => raise Break(None)
      }

    // 处理 Return 表达式
    Return(return_value~, ..) =>
      raise match return_value {
        Some(expr) => Return(self.visit(expr))
        None => Return(Unit)
      }

    // 处理 Raise 表达式
    Raise(err_value~, ..) => raise Raise(self.visit(err_value))

    // 处理 Loop 表达式
    Loop(args~, body~, ..) => {
      let mut arg = Tuple(args.map(arg => self.visit(arg)).to_array())
      let cases = body.map(case => @syntax.Case::{
        pattern: Tuple(pats=case.patterns, loc=dummy_loc()),
        body: case.body,
        guard_: None,
      })
      let mut is_continue = true
      let mut result = Unit
      while is_continue {
        is_continue = false
        result = self.execute_match_runtime(arg, cases) catch {
          Break(value) => return value.unwrap_or(Unit)
          Continue(arr) => {
            arg = Tuple(arr)
            is_continue = true
            continue
          }
          e => raise e
        }
      }
      result
    }

    // 处理 Try 表达式
    Try(body~, catch_~, ..) =>
      self.visit(body) catch {
        Raise(value) => self.execute_match_runtime(value, catch_)
        e => raise e
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
    As(expr~, ..) =>
      // TODO: 评估表达式
      self.visit(expr)
    // // 提取 trait 名称
    // let trait_name = match trait_ {
    //   { name: Ident(name=trait_name), .. } => trait_name
    //   _ => "Any"
    // }
    // // 创建 TraitObject 来保存原始值和 trait 信息
    // TraitObject(value, trait_name)

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
          Struct({ val: new_fields, type_info: original_ref.type_info })
        }
        _ => self.error("RecordUpdate: expected struct")
      }
    }
    Method(type_name~, method_name~, ..) =>
      self.current_module.with_ident(type_name.name, fn(mod, _pkg, ty_name) {
        let env = mod.env
        // 查找用户定义的静态方法
        match env.struct_methods.get(ty_name) {
          Some(methods) =>
            match methods.get(method_name.name) {
              Some(func) => func
              None =>
                self.error("Method:\{ty_name}:\{method_name.name} not found")
            }
          None => self.error("Method:\{ty_name} not found")
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

    // 处理 ForEach 表达式 (for i in expr)
    ForEach(binders~, expr~, body~, ..) => {
      let iterable_value = self.visit(expr)

      // 获取迭代器：如果已经是 Iter 类型就直接使用，否则调用 iter() 方法
      let get_iterator = fn(value) {
        match value {
          Iter(_) => value // 已经是迭代器，直接使用
          _ => value.iter() // 调用 iter() 方法转换为迭代器
        }
      }

      // 首先检查是否为范围表达式
      let iterator = match expr {
        Infix(op~, lhs~, rhs~, ..) =>
          match op.name {
            Ident(name="..<") => {
              let start_val = self.visit(lhs)
              let end_val = self.visit(rhs)
              match (start_val, end_val) {
                (Int(start), Int(end)) =>
                  Iter(
                    Iter::new(visit_fn => {
                      for i in start..<end {
                        match visit_fn(Int(i)) {
                          IterEnd => return IterEnd
                          IterContinue => ()
                        }
                      }
                      IterEnd
                    }),
                  )
                _ => get_iterator(iterable_value)
              }
            }
            Ident(name="..=") => {
              let start_val = self.visit(lhs)
              let end_val = self.visit(rhs)
              match (start_val, end_val) {
                (Int(start), Int(end)) =>
                  Iter(
                    Iter::new(visit_fn => {
                      for i in start..=end {
                        match visit_fn(Int(i)) {
                          IterEnd => return IterEnd
                          IterContinue => ()
                        }
                      }
                      IterEnd
                    }),
                  )
                _ => get_iterator(iterable_value)
              }
            }
            _ => get_iterator(iterable_value)
          }
        _ => get_iterator(iterable_value)
      }

      // 使用迭代器进行迭代
      match iterator {
        Iter(iter_impl) =>
          for value in iter_impl {
            // 创建新作用域来隔离循环变量
            self.push_scope(RuntimeLocation::ControlFlow("foreach"))
            defer self.pop_scope()
            // 绑定循环变量
            match binders {
              @list.List::More(Some(binder), tail=@list.List::Empty) =>
                self.current_module.env.set(binder.name, value)
              _ =>
                match binders {
                  @list.List::More(Some(binder), tail=_) =>
                    self.current_module.env.set(binder.name, value)
                  _ => ()
                }
            }
            try {
              self.visit(body) |> ignore
              continue
            } catch {
              Break(_) => break
              Continue(_) => continue
              e => raise e
            }
          }
        _ => () // 如果不是迭代器，什么都不做
      }
      Unit
    }
    _ => self.error("visit: unimplemented " + node.to_json().stringify())
  }
}

///|
pub fn ClosureInterpreter::visit_scoped(
  self : ClosureInterpreter,
  node : @syntax.Expr,
  loc : RuntimeLocation,
) -> RuntimeValue raise ControlFlow {
  self.push_scope(loc)
  defer self.pop_scope()
  self.visit(node)
}

///|
fn ClosureInterpreter::interp_string(
  self : ClosureInterpreter,
  elems : @list.List[@syntax.InterpElem],
) -> String raise ControlFlow {
  let buffer = @buffer.new()
  for elem in elems {
    match elem {
      Expr(expr~, ..) => buffer.write_string(self.visit(expr).to_string())
      Literal(repr~, ..) => buffer.write_string(repr)
      Source({ source, .. }) =>
        match parse_code_to_expr(source) {
          Ok(expr) => buffer.write_string(self.visit(expr).to_string())
          Err(msg) => self.error(msg)
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

///| 检查类型约束
fn RuntimeModule::check_type_constraint(
  self : RuntimeModule,
  value : RuntimeValue,
  expected_type : @syntax.Type,
) -> Bool {
  match (value, expected_type) {
    // 基本类型检查
    (Bool(_), Name(constr_id={ id: Ident(name="Bool"), .. }, ..))
    | (Bool(_), Name(constr_id={ id: Dot(pkg="", id="Bool"), .. }, ..)) => true
    (Int(_), Name(constr_id={ id: Ident(name="Int"), .. }, ..))
    | (Int(_), Name(constr_id={ id: Dot(pkg="", id="Int"), .. }, ..)) => true
    (UInt(_), Name(constr_id={ id: Ident(name="UInt"), .. }, ..))
    | (UInt(_), Name(constr_id={ id: Dot(pkg="", id="UInt"), .. }, ..)) => true
    (Int64(_), Name(constr_id={ id: Ident(name="Int64"), .. }, ..))
    | (Int64(_), Name(constr_id={ id: Dot(pkg="", id="Int64"), .. }, ..)) =>
      true
    (UInt64(_), Name(constr_id={ id: Ident(name="UInt64"), .. }, ..))
    | (UInt64(_), Name(constr_id={ id: Dot(pkg="", id="UInt64"), .. }, ..)) =>
      true
    (Float(_), Name(constr_id={ id: Ident(name="Float"), .. }, ..))
    | (Float(_), Name(constr_id={ id: Dot(pkg="", id="Float"), .. }, ..)) =>
      true
    (Double(_), Name(constr_id={ id: Ident(name="Double"), .. }, ..))
    | (Double(_), Name(constr_id={ id: Dot(pkg="", id="Double"), .. }, ..)) =>
      true
    (String(_), Name(constr_id={ id: Ident(name="String"), .. }, ..))
    | (String(_), Name(constr_id={ id: Dot(pkg="", id="String"), .. }, ..)) =>
      true
    (Char(_), Name(constr_id={ id: Ident(name="Char"), .. }, ..))
    | (Char(_), Name(constr_id={ id: Dot(pkg="", id="Char"), .. }, ..)) => true
    (Byte(_), Name(constr_id={ id: Ident(name="Byte"), .. }, ..))
    | (Byte(_), Name(constr_id={ id: Dot(pkg="", id="Byte"), .. }, ..)) => true
    (BigInt(_), Name(constr_id={ id: Ident(name="BigInt"), .. }, ..))
    | (BigInt(_), Name(constr_id={ id: Dot(pkg="bigint", id="BigInt"), .. }, ..)
    ) => true

    // 复合类型检查
    (Array(_), Name(constr_id={ id: Ident(name="Array"), .. }, ..))
    | (Array(_), Name(constr_id={ id: Dot(pkg="", id="Array"), .. }, ..)) =>
      true
    (Tuple(_), Tuple(..))
    | (Tuple(_), Name(constr_id={ id: Ident(name="Tuple"), .. }, ..))
    | (Tuple(_), Name(constr_id={ id: Dot(pkg="", id="Tuple"), .. }, ..)) =>
      true
    (Map(_), Name(constr_id={ id: Ident(name="Map"), .. }, ..))
    | (Map(_), Name(constr_id={ id: Dot(pkg="", id="Map"), .. }, ..)) => true

    // Unit 类型
    (Unit, Name(constr_id={ id: Ident(name="Unit"), .. }, ..))
    | (Unit, Name(constr_id={ id: Dot(pkg="", id="Unit"), .. }, ..)) => true

    // Any 类型总是匹配
    (_, Any(..))
    | (_, Name(constr_id={ id: Ident(name="Any"), .. }, ..))
    | (_, Name(constr_id={ id: Dot(pkg="", id="Any"), .. }, ..)) => true

    // Option 类型检查
    (_, Option(..))
    | (_, Name(constr_id={ id: Ident(name="Option"), .. }, ..))
    | (_, Name(constr_id={ id: Dot(pkg="", id="Option"), .. }, ..)) => true

    // 自定义结构体类型检查
    (Struct({ type_info, .. }), Name(constr_id={ id: Ident(name~), .. }, ..)) =>
      type_info.pkg == self.meta.name && type_info.name == name
    (Struct({ type_info, .. }), Name(constr_id={ id: Dot(pkg~, id~), .. }, ..)) =>
      type_info.pkg == pkg && type_info.name == id

    // 构造函数类型检查
    (
      Constructor({ type_info, .. }),
      Name(constr_id={ id: Ident(name~), .. }, ..),
    )
    | (
      Constructor({ type_info, .. }),
      Name(constr_id={ id: Dot(pkg="", id=name), .. }, ..),
    ) => type_info.name == name

    // 默认情况：类型不匹配
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
      Some(self.current_module.env.find(constr.name.name).unwrap_or(Unit))
    Any(..) => None // 通配符表示开放边界
    _ => None
  }
}

///| 检查函数是否为已知函数（存在于任何函数映射中）
pub fn ClosureInterpreter::is_known_function(
  self : ClosureInterpreter,
  name : String,
) -> Bool {
  let actual_name = self.current_module.env.find_fn_alias(name)

  // 检查外部函数
  if self.extern_fns.contains(actual_name) {
    return true
  }

  // 检查嵌入函数
  if self.embedded_fns.contains(actual_name) {
    return true
  }

  // 检查用户定义函数
  if self.current_module.env.find(actual_name).unwrap_or(Unit) is Closure(_) {
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

///| 按名称执行函数调用
fn ClosureInterpreter::execute_function_by_name(
  self : ClosureInterpreter,
  long_ident : @syntax.LongIdent,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let evaluated_args = args
    .map(arg => RuntimeArgument::{
      val: self.visit(arg.value),
      kind: RuntimeArgumentKind::from_syntax(arg.kind),
    })
    .to_array()
  self.current_module.with_ident(long_ident, fn(mod, _pkg, name) {
    let env = mod.env
    let name = env.find_fn_alias(name)

    // 按优先级查找：用户函数 -> Lambda变量 -> 外部函数 -> embedded函数
    let func = match
      env
      .find(name)
      .unwrap_or(self.current_module.env.find(name).unwrap_or(Unit)) {
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
    match func {
      EmbeddedFunction(embedded_name) =>
        match self.embedded_fns.get(embedded_name) {
          Some(embedded_func) =>
            embedded_func(RuntimeFunctionContext::{
              mod: self.current_module,
              context: self,
              args: evaluated_args,
            })
          None => self.error("Embedded function:\{embedded_name} not found")
        }
      RuntimeClosure(lambda_func, captured_env) =>
        // 调用闭包：使用专门的闭包调用方法
        self.call_closure(lambda_func, mod, captured_env, args, name~)
      ExternFunction(extern_func) =>
        extern_func(RuntimeFunctionContext::{
          mod: self.current_module,
          context: self,
          args: evaluated_args,
        })
      GlobalEmbedded(embedded_func) =>
        embedded_func(RuntimeFunctionContext::{
          mod: self.current_module,
          context: self,
          args: evaluated_args,
        })
      NotFound => self.error("method \{name} not found")
    }
  })
}

///| 执行结构体方法调用（返回 RuntimeValue）
fn ClosureInterpreter::execute_method_call(
  self : ClosureInterpreter,
  self_value : RuntimeValue,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  let self_type = self.current_module.env.type_of(self_value)
  match self.embedded_methods.get(self_type.name) {
    Some(type_methods) =>
      match type_methods.get(method_name) {
        Some(embedded_method) => {
          // Prepare args: actual_self_value + evaluated args
          let evaluated_args = @list.construct(
            self_value,
            args.map(fn(arg) { self.visit(arg.value) }),
          )
          return embedded_method(RuntimeFunctionContext::{
            context: self,
            mod: self.current_module,
            args: evaluated_args
            .map(arg => { val: arg, kind: Positional })
            .to_array(),
          })
        }
        None => () // Continue to try regular methods
      }
    None => () // Continue to try regular methods
  }
  match self_type.find_method(method_name) {
    Some(func) => {
      let old_env = self.current_module.env
      let args = args.map(arg => {
        val: self.visit(arg.value),
        kind: RuntimeArgumentKind::from_syntax(arg.kind),
      })
      self.current_module.env = self_type.env
      self.push_scope(RuntimeLocation::FunctionCall(method_name))
      defer {
        self.pop_scope()
        self.current_module.env = old_env
      }
      // Bind self parameter and other args
      match func {
        Closure(Lambda(parameters~, body~, ..), _env) => {
          // Bind parameters
          match parameters {
            More(Positional(binder={ name: "self", .. }, ..), ..) =>
              self.bind_function_parameters(
                parameters,
                @list.construct({ val: self_value, kind: Positional }, args),
              )
            _ => self.bind_function_parameters(parameters, args)
          }

          // Execute function body
          self.visit(body)
        }
        _ =>
          self.error(
            "exec method: \{self_type.to_string()}::\{method_name} not found",
          )
      }
    }
    None =>
      self.error("exec: \{self_type.to_string()}::\{method_name} not found")
  }
}

///|
fn RuntimeType::find_method(
  self : RuntimeType,
  method_name : String,
) -> RuntimeValue? {
  let mut current_env = Some(self.env)
  while current_env is Some(env) {
    if env.struct_methods.get(self.name) is Some(methods) {
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
  type_info : RuntimeType,
  method_name : String,
  args : @list.List[@syntax.Argument],
) -> RuntimeValue raise ControlFlow {
  match self.embedded_methods.get(type_info.name) {
    Some(methods) =>
      match methods.get(method_name) {
        Some(embedded_func) => {
          let evaluated_args = args
            .map(arg => {
              val: self.visit(arg.value),
              kind: RuntimeArgumentKind::from_syntax(arg.kind),
            })
            .to_array()
          return embedded_func(RuntimeFunctionContext::{
            mod: self.current_module,
            context: self,
            args: evaluated_args,
          })
        }
        None => ()
      }
    None => ()
  }

  // If no embedded method found, try user-defined struct methods
  match type_info.find_method(method_name) {
    Some(func) =>
      match func {
        Closure(func, env) =>
          self.call_closure(
            func,
            self.current_module,
            env,
            args,
            name=method_name,
          )
        _ => Unit
      }
    None =>
      self.error("Method \{method_name} not found for type \{type_info.name}")
  }
}

///| 根据 RuntimeValue 推断类型
// 提取的公共方法：根据字段名推导结构体类型
fn RuntimeEnvironment::infer_struct_type_from_fields(
  self : RuntimeEnvironment,
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
fn RuntimeModule::find_static_type(
  self : RuntimeModule,
  name : String,
) -> RuntimeType {
  match name {
    "Bool" => RuntimeType::bool()
    "Int" => RuntimeType::int()
    "UInt" => RuntimeType::uint()
    "Int64" => RuntimeType::int64()
    "UInt64" => RuntimeType::uint64()
    "Float" => RuntimeType::float()
    "Double" => RuntimeType::double()
    "BigInt" => RuntimeType::bigint()
    "Char" => RuntimeType::char()
    "Byte" => RuntimeType::byte()
    "String" => RuntimeType::string()
    "Tuple" => RuntimeType::tuple()
    "Array" => RuntimeType::array()
    "ArrayView" | "View" => RuntimeType::array_view()
    "UninitializedArray" => RuntimeType::uninitialized_array()
    "Map" => RuntimeType::map()
    "Iter" => RuntimeType::iter()
    "Option" => RuntimeType::option()
    _ =>
      {
        pkg: self.meta.name,
        name: if self.env.type_definitions.get(name) is Some(decl) {
          decl.tycon
        } else {
          "Any"
        },
        env: self.env,
      }
  }
}

///|
fn RuntimeEnvironment::type_of(
  self : RuntimeEnvironment,
  runtime_value : RuntimeValue,
) -> RuntimeType {
  match runtime_value {
    Unit => { pkg: "std", name: "Unit", env: self }
    Bool(_) => RuntimeType::bool()
    Int(_) => RuntimeType::int()
    UInt(_) => RuntimeType::uint()
    Int64(_) => RuntimeType::int64()
    UInt64(_) => RuntimeType::uint64()
    Float(_) => RuntimeType::float()
    Double(_) => RuntimeType::double()
    BigInt(_) => RuntimeType::bigint()
    Char(_) => RuntimeType::char()
    Byte(_) => RuntimeType::byte()
    String(_) => RuntimeType::string()
    Bytes(_) => RuntimeType::string()
    StringView(_) => RuntimeType::string()
    Tuple(_) => RuntimeType::tuple()
    Array(_) => RuntimeType::array()
    ArrayView(_) => RuntimeType::array_view()
    UninitializedArray(_) => RuntimeType::uninitialized_array()
    Map(_) => RuntimeType::map()
    Struct(data) => data.type_info
    Closure(_) => { pkg: "main", name: runtime_value.to_string(), env: self }
    Exception(_) => { pkg: "std", name: "Exception", env: self }
    Constructor({ val: { name, .. }, type_info }) =>
      match name {
        "Some" | "None" => RuntimeType::option()
        _ => type_info
      }
    Iter(_) => RuntimeType::iter()
  }
}

///| 从函数体推导返回类型
fn ClosureInterpreter::infer_return_type_from_expr(
  self : ClosureInterpreter,
  body : @syntax.Expr,
) -> RuntimeType {
  match body {
    // 处理函数调用表达式
    Apply(func~, ..) =>
      match func {
        @syntax.Expr::Ident(id={ name: ident, .. }, ..) =>
          self.current_module.with_ident(ident, (mod, _pkg, name) => mod.env.type_of(
            mod.env.find(name).unwrap_or(Unit),
          ))
        _ => RuntimeType::any()
      }
    // 处理 match 表达式
    Match(..) => RuntimeType::any()
    Sequence(last_expr~, ..) => self.infer_return_type_from_expr(last_expr)
    Infix(op={ name: Ident(name=op_name), .. }, lhs~, ..) =>
      match op_name {
        "==" | "!=" | "<" | ">" | "<=" | ">=" | "&&" | "||" =>
          RuntimeType::bool()
        _ => self.infer_return_type_from_expr(lhs)
      }
    _ => RuntimeType::any()
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
        Lambda(parameters~, return_type~, body~, ..) => {
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
              let inferred_type = self
                .infer_return_type_from_expr(body)
                .to_string()
              "(" + param_strs.join(", ") + ") -> " + inferred_type
            }
          }
        }
        _ => "<function>"
      }
    _ => value.to_string()
  }
}
