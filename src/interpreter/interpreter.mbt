///|
/// 支持引用系统和泛型的解释器
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

///|
/// 解释器状态
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

///|
/// 访问语法树节点，返回运行时值
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
    Infix(op~, lhs~, rhs~, ..) => self.visit_infix_expression(op.name, lhs, rhs)

    // 处理一元表达式
    Unary(op~, expr~, ..) => self.visit_unary_expression(op.name, expr)
    // 处理记录创建
    Record(type_name~, fields~, ..) =>
      self.visit_record_creation(type_name, fields)
    ArraySpread(elems~, ..) => self.visit_array_spread(elems)
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
    ArraySet(array~, index~, value~, ..) =>
      self.visit_array_set(array, index, value)
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
    Tuple(exprs~, ..) => self.visit_tuple(exprs)

    // 处理数组
    Array(exprs~, ..) => self.visit_array(exprs)

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
    Apply(func~, args~, ..) => self.visit_apply(func, args)

    // 处理 if 表达式
    If(cond~, ifso~, ifnot~, ..) => self.visit_if(cond, ifso, ifnot)

    // 处理 match 表达式
    Match(expr~, cases~, ..) => {
      let expr_runtime = self.visit(expr)
      self.execute_match_runtime(expr_runtime, cases)
    }

    // 处理字段访问
    Field(record~, accessor~, ..) => self.visit_field(record, accessor)

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
    Guard(cond~, otherwise~, body~, ..) =>
      self.visit_guard(cond, otherwise, body)
    Defer(expr~, body~, ..) => self.visit_defer(expr, body)
    Is(expr~, pat~, ..) =>
      Bool(self.pattern_matches_runtime(self.visit(expr), pat))

    // 处理分组表达式
    Group(expr~, ..) => self.visit(expr)

    // 控制流表达式 - 委托给control_flow.mbt
    For(binders~, condition~, continue_block~, body~, for_else~, ..) =>
      self.visit_for(binders, condition, continue_block, body, for_else)
    While(loop_cond~, loop_body~, while_else~, ..) =>
      self.visit_while(loop_cond, loop_body, while_else)

    // 处理字段赋值 (Mutate)
    Mutate(record~, accessor~, field~, augmented_by~, ..) =>
      self.visit_mutate(record, accessor, field, augmented_by)

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
    Try(body~, catch_~, ..) => self.visit_try(body, catch_)

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
    As(expr~, ..) => self.visit(expr)
    RecordUpdate(record~, fields~, ..) =>
      self.visit_record_update(record, fields)
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
    Interp(elems~, ..) => self.visit_interp(elems)
    MultilineString(elems~, ..) => self.visit_multiline_string(elems)
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
// interp_string 方法已移动到 string_operations.mbt

// pattern_matches_runtime 方法已移动到 pattern_matching_runtime.mbt

///|
/// 检查类型约束
// check_type_constraint 方法已移动到 type_constraints.mbt

// runtime_value_in_range 方法已移动到 pattern_matching_runtime.mbt

// pattern_to_runtime_value 方法已移动到 pattern_matching_runtime.mbt

///|
/// 检查函数是否为已知函数（存在于任何函数映射中）
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
