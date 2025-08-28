///|
pub(all) struct RuntimeEnvironment {
  traits : Map[String, @syntax.TraitDecl]
  // 函数别名存储 - 存储函数名到其实际实现的映射
  fn_aliases : Map[String, String]
  // 类型定义
  type_definitions : Map[String, @syntax.TypeDecl]
  // 结构体方法定义 - 按类型名组织方法
  struct_methods : Map[String, Map[String, RuntimeValue]]
  // 泛型类型环境
  type_environment : TypeEnvironment
  values : Map[String, RuntimeValue]
  // 跟踪哪些变量是可变的
  mutable_vars : Map[String, Bool]
  parent : RuntimeEnvironment?
} derive(ToJson)

///|
pub fn RuntimeEnvironment::new(
  parent? : RuntimeEnvironment,
  values? : Map[String, RuntimeValue],
  struct_methods? : Map[String, Map[String, RuntimeValue]],
) -> RuntimeEnvironment {
  if parent is Some(parent) {
    {
      ..parent,
      values: values.unwrap_or({}),
      mutable_vars: Map::new(),
      struct_methods: struct_methods.unwrap_or({}),
      parent: Some(parent),
    }
  } else {
    {
      traits: Map::new(),
      fn_aliases: core_fn_aliases.copy(),
      type_definitions: Map::new(),
      struct_methods: struct_methods.unwrap_or({}),
      type_environment: TypeEnvironment::new(),
      values: values.unwrap_or({}),
      mutable_vars: Map::new(),
      parent: None,
    }
  }
}

///|
/// 深拷贝环境 - 完全复制所有内容
pub fn RuntimeEnvironment::copy(
  self : RuntimeEnvironment,
) -> RuntimeEnvironment {
  let new_values = Map::new()
  let new_mutable_vars = Map::new()
  self.values.each(fn(key, value) { new_values.set(key, value) })
  self.mutable_vars.each(fn(key, is_mutable) {
    new_mutable_vars.set(key, is_mutable)
  })
  let new_parent = match self.parent {
    Some(parent) => Some(parent.copy())
    None => None
  }
  {
    ..self,
    values: new_values,
    mutable_vars: new_mutable_vars,
    parent: new_parent,
  }
}

///|
/// 为闭包创建捕获环境 - 实现正确的变量捕获语义
pub fn RuntimeEnvironment::create_closure_env(
  self : RuntimeEnvironment,
) -> RuntimeEnvironment {
  let new_values = Map::new()
  let new_mutable_vars = Map::new()

  // 只捕获不可变变量的值，可变变量通过父环境引用
  self.values.each(fn(key, value) {
    let is_mutable = self.mutable_vars.get(key).unwrap_or(false)
    if not(is_mutable) {
      // 不可变变量：捕获当前值
      new_values.set(key, value)
      new_mutable_vars.set(key, false)
    }
    // 可变变量不在闭包环境中捕获，通过parent引用访问
  })

  // 设置父环境为当前环境，这样可变变量可以通过父环境访问
  // 继承父环境的全局状态（如类型定义、方法等）
  {
    ..self,
    values: new_values,
    mutable_vars: new_mutable_vars,
    parent: Some(self),
  }
}

///|
/// 处理函数声明体，创建Lambda函数
pub fn RuntimeEnvironment::top_func_def_to_closure(
  self : RuntimeEnvironment,
  func : @syntax.Impl,
) -> (String?, RuntimeValue) {
  if func
    is TopFuncDef(fun_decl~, decl_body=DeclBody(local_types=_, expr=body), loc~) {
    let func = @syntax.Func::Lambda(
      parameters=fun_decl.decl_params.unwrap_or(@list.new()),
      params_loc=loc,
      body~,
      return_type=fun_decl.return_type,
      error_type=fun_decl.error_type,
      kind=Arrow,
      has_error=fun_decl.has_error,
      is_async=fun_decl.is_async,
      loc~,
    )
    let type_name = match fun_decl {
      { type_name: Some({ name: Ident(name~), .. }), .. } => Some(name)
      { type_name: Some({ name: Dot(id~, ..), .. }), .. } => Some(id)
      {
        decl_params: Some(
          More(
            Positional(
              binder={ name: "self", .. },
              ty=Some(Name(constr_id={ id: Ident(name~), .. }, ..))
            ),
            ..
          )
        ),
        ..,
      } => Some(name)
      _ => None
    }
    (type_name, RuntimeValue::Closure(func, self.create_closure_env()))
  } else {
    (None, Unit)
  }
}
