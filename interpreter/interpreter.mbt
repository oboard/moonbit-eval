///|
/// 支持引用系统和泛型的解释器
pub(all) struct ClosureInterpreter {
  extern_fns : Map[String, RuntimeFunction]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, RuntimeFunction]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[String, Map[String, RuntimeFunction]]
  main_pkg : RuntimePackage
  mut current_pkg : RuntimePackage
  // 调用栈跟踪
  call_stack : Array[RuntimeLocation]
}

///|
pub fn ClosureInterpreter::new() -> ClosureInterpreter {
  let main = RuntimePackage::new("main", deps=core_modules)
  main.deps.set("fs", fs_package)
  let self = {
    extern_fns: {},
    embedded_fns: core_embedded_code,
    embedded_methods: core_embedded_methods,
    main_pkg: main,
    current_pkg: main,
    call_stack: [],
  }
  self.load_package(main)
  self
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
pub fn RuntimePackage::find_stub(
  self : RuntimePackage,
  name : String,
) -> String {
  self.stubs.get(name).unwrap_or(name)
}

///|
pub fn ClosureInterpreter::top_eval(
  self : ClosureInterpreter,
  code : String,
) -> Unit {
  let (impls, _diagnostics) = @moonbitlang/parser.parse_string(code)
  impls.each(node => self.top_visit(node) |> ignore)
}

///|
pub fn ClosureInterpreter::load_module(
  self : ClosureInterpreter,
  mod : RuntimeModule,
) -> Unit {
  mod.pkgs.values().each(pkg => self.load_package(pkg))
}

///|
pub fn ClosureInterpreter::load_package(
  self : ClosureInterpreter,
  pkg : RuntimePackage,
  target? : String = "wasm",
) -> Unit {
  if pkg.loaded {
    return
  }
  pkg.loaded = true
  // load dependencies
  for dep in pkg.deps.values() {
    self.load_package(dep)
  }
  // filter target source file
  if pkg.files.get("moon.pkg.json") is Some(pkg_file) {
    if (try? @json.parse(pkg_file))
      is Ok({ "targets": Object(targets_map), .. }) {
      for file_name, option_json in targets_map {
        let option_list = if option_json is Array(arr) {
          arr.map(i => if i is String(s) { s } else { "" })
        } else {
          continue
        }
        match
          (option_list.get(0) is Some("not"), option_list.contains(target)) {
          (true, true) => pkg.files.remove(file_name)
          (false, false) => pkg.files.remove(file_name)
          _ => ()
        }
      }
    }
  }
  let old_module = self.current_pkg
  self.current_pkg = pkg
  defer {
    self.current_pkg = old_module
  }
  for file_name, code in pkg.files {
    if file_name.has_suffix(".mbt") {
      self.top_eval(code)
    }
  }
}

///|
pub fn ClosureInterpreter::top_visit(
  self : ClosureInterpreter,
  node : @syntax.Impl,
) -> RuntimeValue {
  match node {
    TopView(_) => Unit
    TopUsing(_) => Unit
    TopImpl(self_ty~, trait_~, method_name~, params~, body~, ..) => {
      // 处理 trait 实现，如 impl Show for A with to_string
      let type_name = match self_ty {
        Some(Name(constr_id={ id: Ident(name~), .. }, ..)) => Some(name)
        Some(Name(constr_id={ id: Dot(id~, ..), .. }, ..)) => Some(id)
        _ => None // 无法确定类型名，但仍需处理 trait 方法
      }
      let trait_name = match trait_.name {
        Ident(name~) => name
        Dot(id~, ..) => id
      }
      let method_name = method_name.name

      // 从 body 中提取函数实现
      match body {
        DeclBody(expr~, ..) => {
          // 构造函数对象
          let func = @syntax.Func::{
            parameters: params,
            params_loc: dummy_loc(),
            body: expr,
            return_type: None,
            error_type: @syntax.ErrorType::NoErrorType,
            kind: @syntax.FnKind::Lambda,
            has_error: None,
            is_async: None,
            loc: dummy_loc(),
          }

          // 如果能确定类型名，将 trait 方法注册为结构体方法
          match type_name {
            Some(name) =>
              self.define_struct_method(
                self.current_pkg,
                name,
                method_name,
                func,
              )
            None => () // 无法确定类型名时不注册到具体类型，但仍处理 trait
          }
          self.current_pkg.define_trait_method(
            trait_name,
            method_name,
            Fn(self.create_function(func, self.current_pkg)),
          )
          Unit
        }
        _ => Unit
      }
    }
    TopBatchTraitAlias(pkg~, targets~, ..) => {
      let pkg = pkg.map(l => l.name)
      // 处理每个 trait 别名目标
      for target in targets {
        let binder_name = target.binder.name
        let target_name = target.target.map(l => l.name).unwrap_or(binder_name)
        let mod = match pkg {
          Some(pkg) => self.find_pkg(pkg)
          None => self.current_pkg
        }
        let target_value = mod.traits.get(binder_name)
        // 将别名映射到目标 trait
        if target_value is Some(target_value) {
          self.current_pkg.trait_aliases.set(target_name, {
            val: target_value,
            ty: Object(pkg=mod, name=binder_name),
          })
        }
      } nobreak {
        Unit
      }
    }
    TopBatchTypeAlias(pkg~, targets~, ..) => {
      let pkg = pkg.map(l => l.name)
      // 处理每个类型别名目标
      for target in targets {
        let binder_name = target.binder.name
        let target_name = target.target.map(l => l.name).unwrap_or(binder_name)
        let mod = match pkg {
          Some(pkg) => self.find_pkg(pkg)
          None => self.current_pkg
        }
        let target_value = mod.type_definitions.get(binder_name)
        // 将别名映射到目标函数
        if target_value is Some(target_value) {
          self.current_pkg.type_aliases.set(target_name, {
            val: target_value,
            ty: Object(pkg=mod, name=binder_name),
          })
        }
      }
      Unit
    }
    TopTest(_) => Unit
    TopImplRelation(_) => Unit
    // 处理函数别名定义（如 fnalias @int.abs）
    TopFuncAlias(pkg~, type_name~, targets~, ..) => {
      let pkg = pkg.map(l => l.name)
      let type_name = type_name.map(l => l.name)
      // 处理每个别名目标
      for target in targets {
        let binder_name = target.binder.name
        let target_name = target.target.map(l => l.name).unwrap_or(binder_name)
        let mod = match (pkg, type_name) {
          (Some(pkg), Some(id)) =>
            self.with_ident(@syntax.LongIdent::Dot(pkg~, id~), (mod, _name) => 
              mod
            )
          (None, Some(name)) =>
            self.with_ident(@syntax.LongIdent::Ident(name~), (mod, _name) => mod)
          (Some(pkg), None) => self.find_pkg(pkg)
          (None, None) => self.current_pkg
        }
        let target_value = mod.find(binder_name)
        // 将别名映射到目标函数
        if target_value is Some(target_value) {
          self.current_pkg.fn_aliases.set(target_name, target_value)
          self.current_pkg.set(binder_name, target_value)
        }
      }
      Unit
    }

    // 处理顶层常量定义（如 const Zero = 0）
    TopLetDef(binder~, expr~, ..) => {
      let value = self.visit(expr) catch { _ => Unit }
      let name = binder.name
      self.current_pkg.env.set(name, value)
      value
    }
    TopTypeDef(def) => {
      match def {
        { tycon, params, components, deriving, .. } => {
          self.current_pkg.type_definitions.set(tycon, def)

          // 处理泛型类型参数
          let type_params = []
          for param in params {
            match param {
              { name, .. } => type_params.push(name)
            }
          } nobreak {
            ()
          }

          // 保存deriving信息到type_derived_traits
          let derived_traits = []
          for derive_directive in deriving {
            derived_traits.push(
              match derive_directive.type_name.name {
                Ident(name~) => name
                Dot(id~, ..) => id
              },
            )
          } nobreak {
            ()
          }
          if derived_traits.length() > 0 {
            self.current_pkg.type_derived_traits.set(tycon, derived_traits)
          }

          // 注册枚举构造函数到运行时环境
          match components {
            Variant(constructors) =>
              for constr in constructors {
                let constr_name = constr.name.name
                // 将构造函数注册到constructors集合中
                self.current_pkg.constructors.set(constr_name, tycon)
              } nobreak {
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
      let attrs = fun_decl.attrs
      let type_name = match fun_decl.type_name {
        Some({ name: Ident(name=type_name), .. }) => Some(type_name)
        Some({ name: Dot(..), .. }) => None // 处理点号形式的类型名
        None =>
          match fun_decl.decl_params {
            Some(More(Positional(ty=Some(ty), ..), ..)) =>
              Some(extract_type_name(ty))
            _ => None
          }
      }

      // 处理泛型函数的类型参数
      let type_params = []
      for quantifier in fun_decl.quantifiers {
        match quantifier {
          { name, .. } => type_params.push(name)
        }
      } nobreak {
        ()
      }

      // 从decl_body中提取函数体
      match decl_body {
        DeclBody(expr~, ..) => {
          // 如果是泛型函数，需要在函数调用时进行类型参数绑定
          // TODO: 实现泛型函数的类型参数推导机制

          // 保持原始的返回类型，不在这里进行推导
          let inferred_return_type = fun_decl.return_type
          let func = @syntax.Func::{
            parameters: fun_decl.decl_params.unwrap_or(@list.new()),
            params_loc: loc,
            body: expr,
            return_type: inferred_return_type,
            error_type: fun_decl.error_type,
            kind: @syntax.FnKind::Lambda,
            has_error: fun_decl.has_error,
            is_async: fun_decl.is_async,
            loc,
          }
          if type_name is Some(type_name) {
            self.define_struct_method(
              self.current_pkg,
              type_name,
              func_name,
              func,
            )
          }
          let func_value = Fn(
            self.create_function(func, self.current_pkg, name=func_name),
          )
          self.current_pkg.set(func_name, func_value)
          // 处理alias属性，将别名映射到函数
          attrs.each(attr => {
            match attr {
              {
                parsed: Some(
                  Apply(
                    { name: "alias", .. },
                    More(Expr(Ident({ name: alias_name, .. })), ..)
                  )
                ),
                ..,
              } =>
                // println("\{alias_name} -> \{func_name}")
                self.current_pkg.fn_aliases.set(alias_name, func_value)
              _ => ()
            }
          })
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
      self.current_pkg.traits.set(decl.name.name, decl)
      Unit
    }
    // _ => self.error("TopExpr: unimplemented:" + node.to_json().stringify())
  }
}

///|
pub fn[A] ClosureInterpreter::error(
  self : ClosureInterpreter,
  msg : String,
) -> A raise ControlFlow {
  raise Error("\{self.lookup_current_function()}\{msg}")
}

///|
/// 从模式中推导类型
pub fn ClosureInterpreter::infer_pattern_type(
  _ : ClosureInterpreter,
  pattern : @syntax.Pattern,
) -> String? {
  match pattern {
    // 类型注解模式，如 x : Int
    Constraint(pat=_, ty~, ..) =>
      // 从类型中提取类型名
      match ty {
        Name(constr_id={ id: Ident(name=type_name), .. }, ..) => Some(type_name)
        Name(constr_id={ id: Dot(id=type_name, ..), .. }, ..) => Some(type_name)
        _ => None
      }
    // 变量模式，无法推导类型
    Var({ name: _, .. }) => None
    // 构造函数模式，如 Some(x)
    Constr(constr~, ..) => {
      let constr_name = constr.name.name
      // 根据构造函数名推导类型
      match constr_name {
        "Some" | "None" => Some("Option")
        "Ok" | "Err" => Some("Result")
        _ => None
      }
    }
    // 其他模式暂不支持类型推导
    _ => None
  }
}

///|
/// 带期望类型的访问语法树节点
pub fn ClosureInterpreter::visit(
  self : ClosureInterpreter,
  node : @syntax.Expr,
  expected_type? : String,
) -> RuntimeValue raise ControlFlow {
  match node {
    // 处理常量 - 支持重载字面量
    Constant(c~, ..) => RuntimeValue::from_constant_with_type(c, expected_type)

    // 处理变量标识符
    Ident(id={ name, .. }, ..) =>
      self.with_ident(name, (pkg, name) => {
        // 首先检查是否为构造函数
        if pkg.is_constructor(name) {
          // 如果是构造函数，直接创建零参数构造函数实例
          pkg.cons(name, [])
        } else {
          // 否则查找变量值
          match pkg.find(name) {
            Some(v) => v
            None => self.error("variable @\{pkg.name}.\{name} not found")
          }
        }
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
              (Some(Int(start, ..)), Some(Int(end, ..))) => arr[start:end]
              (Some(Int(start, ..)), None) => arr[start:]
              (None, Some(Int(end, ..))) => arr[:end]
              _ => arr[:]
            },
          )
        // 调用op_as_view
        _ => {
          let ty = self_value.get_type()
          match ty.find_method("op_as_view") {
            Some((pkg, Fn(func))) =>
              self.call(func.val, pkg, [
                { val: self_value, kind: Positional },
                { val: start.unwrap_or(Unit), kind: LabelledOption("start") },
                { val: end.unwrap_or(Unit), kind: LabelledOption("end") },
              ])
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
            (Int(index, ..), { name: Ident(name=op), .. }) => {
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

    // 处理数组 - 支持重载字面量
    Array(exprs~, ..) => {
      let array_result = self.visit_array(exprs)
      match expected_type {
        Some(ty) => array_result.overload_array_literal(ty)
        None => array_result
      }
    }

    // 处理函数 - 闭包应该捕获对环境的引用以支持可变变量
    Function(func~, ..) => Fn(self.create_function(func, self.current_pkg))

    // 处理 Let 绑定
    Let(pattern~, expr~, body~, ..) => {
      ignore(self.match_case(self.visit(expr), pattern))
      self.visit(body)
    }

    // 处理可变变量声明
    LetMut(binder={ name, .. }, expr~, body~, ..) => {
      let runtime_value = self.visit(expr)
      self.push_scope(RuntimeLocation::LetMut(name))
      self.current_pkg.env.set_mutable_variable(name, runtime_value)
      // 执行body部分，这是关键！
      self.visit(body)
    }

    // 处理函数定义
    LetFn(name={ name, .. }, func~, body~, ..) => {
      self.current_pkg.env.set(
        name,
        Fn(self.create_function(func, self.current_pkg)),
      )
      match body {
        Unit(..) => Fn(self.create_function(func, self.current_pkg))
        _ => self.visit(body)
      }
    }

    // 处理递归函数定义
    LetRec(bindings~, body~, ..) => {
      for binding in bindings {
        let name = binding.0.name
        let func = binding.1
        self.current_pkg.env.set(
          name,
          Fn(self.create_function(func, self.current_pkg, name~)),
        )
      }
      self.visit(body)
    }
    LetAnd(bindings~, body~, ..) => {
      // Create a shared environment for all mutually recursive functions
      let shared_env = self.current_pkg.env.create_closure_env()

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
        shared_env.update(
          name,
          Fn(self.create_function(func, self.current_pkg, name~)),
        )
      }

      // Add all closures to current environment
      for binding in bindings {
        let name = binding.0.name
        self.current_pkg.env.set(name, shared_env.find(name).unwrap_or(Unit))
      }
      self.visit(body)
    }

    // 处理赋值操作
    Assign(var_={ name, .. }, expr~, augmented_by~, ..) =>
      self.with_ident(name, (pkg, name) => {
        let new_value = match augmented_by {
          Some(op) => {
            let current_value = pkg.find(name).unwrap_or(Unit)
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
        pkg.env.update(name, new_value)
        Unit
      })

    // 处理函数调用
    Apply(func~, args~, ..) => self.visit_apply(func, args)

    // 处理 if 表达式
    If(cond~, ifso~, ifnot~, ..) => self.visit_if(cond, ifso, ifnot)

    // 处理 match 表达式
    Match(expr~, cases~, ..) => {
      let expr_runtime = self.visit(expr)
      self.pattern_match(expr_runtime, cases)
    }

    // 处理字段访问
    Field(record~, accessor~, ..) => self.visit_field(record, accessor)

    // 处理方法调用 (DotApply)
    DotApply(self=self_expr, method_name~, args~, return_self~, ..) => {
      let self_value = self.visit(self_expr)
      let res = self.method_call(self_value, method_name.name, args)
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
        (Array(values), Int(index_num, ..)) => values[index_num]
        (ArrayView(values), Int(index_num, ..)) => values[index_num]
        (UninitializedArray(values), Int(index_num, ..)) => values[index_num]
        (Map(values), index) =>
          match values.get(index) {
            Some(value) => value
            None => self.error("MapGet: not found")
          }
        _ => self.error("ArrayGet: \{array_val}[\{index_val}] not implemented")
      }
    }

    // 处理管道表达式 (Pipe) - 将左侧值作为右侧函数的第一个参数
    Pipe(lhs~, rhs~, ..) =>
      match rhs {
        // 处理简单函数调用，如 5 |> ignore
        Ident(id={ name, .. }, ..) => {
          let pipe_args = @list.cons(
            @syntax.Argument::{ value: lhs, kind: Positional },
            @list.new(),
          )
          self.call_by_name(name, pipe_args)
        }
        // 处理方法调用，如 [] |> Array::push(5)
        Apply(func~, args~, ..) => {
          let pipe_args = @list.cons(
            @syntax.Argument::{ value: lhs, kind: Positional },
            args,
          )
          match func {
            Method(type_name~, method_name~, ..) =>
              self.with_ident(type_name.name, (pkg, type_name) => {
                self.execute_static_method_call(
                  pkg.find_static_type(type_name),
                  method_name.name,
                  pipe_args,
                )
              })
            Ident(id={ name, .. }, ..) => {
              // 处理函数调用，如 5 |> func(arg1, arg2)
              let pipe_args = @list.cons(
                @syntax.Argument::{ value: lhs, kind: Positional },
                args,
              )
              self.call_by_name(name, pipe_args)
            }
            _ => panic()
          }
        }
        _ => panic()
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
    Is(expr~, pat~, ..) => Bool(self.match_case(self.visit(expr), pat))

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
      let continue_args = args.map(arg => self.visit(arg)).to_array()
      raise Continue(continue_args)
    }

    // 处理单独的构造函数表达式，如 None
    Constr(constr~, ..) => {
      let name = constr.name.name
      match constr.extra_info {
        TypeName(ty_name) =>
          self.with_ident(ty_name.name, (_env, _name) => {
            self.current_pkg.cons(name, [])
          })
        Package(pkg) =>
          self.find_pkg(pkg).env
          .find(name)
          .unwrap_or(self.current_pkg.cons(name, []))
        _ =>
          self.current_pkg.env
          .find(name)
          .unwrap_or(self.current_pkg.cons(name, []))
      }
    }
    // 处理 Break 表达式
    Break(arg~, ..) =>
      match arg {
        Some(expr) => {
          let break_value = self.visit(expr)
          raise Break(break_value)
        }
        None => raise Break(Unit)
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
    Loop(arg~, body~, ..) => {
      let mut arg : RuntimeValue = self.visit(arg)
      let cases = body.map(case => @syntax.Case::{
        pattern: case.pattern,
        body: case.body,
        guard_: None,
      })
      let mut is_continue = true
      let mut result = Unit
      while is_continue {
        is_continue = false
        result = self.pattern_match(arg, cases) catch {
          Break(value) => return value
          Continue(arr) => {
            arg = arr[0]
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
    As(expr~, trait_~, ..) => {
      let value = self.visit(expr)
      self.with_ident(trait_.name, fn(_env, name) {
        // 使用重载字面量函数进行类型转换
        value.overload_literal(name)
      })
    }
    RecordUpdate(record~, fields~, ..) =>
      self.visit_record_update(record, fields)
    Method(type_name~, method_name~, ..) =>
      self.with_ident(type_name.name, (pkg, ty_name) => {
        // 查找用户定义的静态方法
        match pkg.struct_methods.get(ty_name) {
          Some(methods) =>
            match methods.get(method_name.name) {
              Some(func) => func
              None =>
                self.error("method \{ty_name}:\{method_name.name} not found")
            }
          None => self.error("type \{ty_name} not found")
        }
      })
    Map(elems~, ..) => {
      let map = elems
        .map(elem => {
          (RuntimeValue::from_constant(elem.key), self.visit(elem.expr))
        })
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

      // 检查是否为范围表达式，否则使用默认迭代器
      let range_iterator : RuntimeValue? = match expr {
        Infix(op~, lhs~, rhs~, ..) =>
          match op.name {
            Ident(name="..<") => {
              let start_val = self.visit(lhs)
              let end_val = self.visit(rhs)
              match (start_val, end_val) {
                (Int(start, ..), Int(end, ..)) =>
                  Some(
                    RuntimeValue::Iter(
                      start.until(end).map(fn(i) { Int(i, raw=None) }),
                    ),
                  )
                _ => None
              }
            }
            Ident(name="..=") => {
              let start_val = self.visit(lhs)
              let end_val = self.visit(rhs)
              match (start_val, end_val) {
                (Int(start, ..), Int(end, ..)) =>
                  Some(
                    RuntimeValue::Iter(
                      start
                      .until(end, inclusive=true)
                      .map(fn(i) { Int(i, raw=None) }),
                    ),
                  )
                _ => None
              }
            }
            _ => None
          }
        _ => None
      }
      let binder_count = binders.length()
      // 如果不是范围表达式，使用默认迭代器逻辑
      let final_iterator = match range_iterator {
        Some(iter) => iter
        None =>
          match iterable_value {
            Iter(_) => iterable_value // 已经是迭代器，直接使用
            _ =>
              // 如果有多个绑定变量，使用 iter2()，否则使用 iter()
              if binder_count > 1 {
                let iter2 = self.method_call(
                  iterable_value,
                  "iter2",
                  @list.new(),
                )
                if iter2 is Iter2(_) {
                  iter2
                } else {
                  self.error("iter2 method not found")
                }
              } else {
                let iter = self.method_call(iterable_value, "iter", @list.new())
                if iter is Iter(_) {
                  iter
                } else {
                  self.error("iter method not found")
                }
              }
          }
      }

      // 使用迭代器进行迭代
      match final_iterator {
        Iter(iter_impl) =>
          for value in iter_impl {
            // 创建新作用域来隔离循环变量
            self.push_scope(RuntimeLocation::ControlFlow("foreach"))
            defer self.pop_scope()
            // 绑定循环变量
            match binders {
              More(Some(binder), tail=Empty) =>
                // 单个绑定变量：直接绑定值
                self.current_pkg.env.set(binder.name, value)
              _ => ()
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
        Iter2(iter2_impl) =>
          for first, second in iter2_impl {
            // 创建新作用域来隔离循环变量
            self.push_scope(RuntimeLocation::ControlFlow("foreach"))
            defer self.pop_scope()
            // 绑定循环变量
            match binders {
              More(Some(binder1), tail=More(Some(binder2), ..)) => {
                self.current_pkg.env.set(binder1.name, first)
                self.current_pkg.env.set(binder2.name, second)
              }
              _ => self.error("foreach: invalid binders")
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
        _ => self.error("foreach: invalid iterator")
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
/// 检查函数是否为已知函数（存在于任何函数映射中）
pub fn ClosureInterpreter::is_known_function(
  self : ClosureInterpreter,
  name : String,
) -> Bool {
  let actual_name = self.current_pkg.find_stub(name)

  // 检查外部函数
  if self.extern_fns.contains(actual_name) {
    return true
  }

  // 检查嵌入函数
  if self.embedded_fns.contains(actual_name) {
    return true
  }

  // 检查用户定义函数
  if self.current_pkg.find(actual_name).unwrap_or(Unit) is Fn(_) {
    return true
  }
  false
}
