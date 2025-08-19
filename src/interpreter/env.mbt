///|
pub(all) struct RuntimeEnvironment {
  extern_fns : Map[String, RuntimeFunction]
  // embedded函数存储 - 全局函数
  embedded_fns : Map[String, RuntimeFunction]
  // embedded方法存储 - 按类型组织的embedded方法定义
  embedded_methods : Map[String, Map[String, RuntimeFunction]]
  // 函数别名存储 - 存储函数名到其实际实现的映射
  fn_aliases : Map[String, String]
  // 类型定义
  type_definitions : Map[String, @syntax.TypeDecl]
  // 结构体方法定义 - 按类型名组织方法
  struct_methods : Map[String, Map[String, @syntax.Func]]
  // 泛型类型环境栈
  type_environments : Array[TypeEnvironment]
  values : Map[String, RuntimeValue]
  // 跟踪哪些变量是可变的
  mutable_vars : Map[String, Bool]
  parent : RuntimeEnvironment?
}

///|
pub fn RuntimeEnvironment::new(
  parent? : RuntimeEnvironment,
) -> RuntimeEnvironment {
  if parent is Some(parent) {
    {
      ..parent,
      values: Map::new(),
      mutable_vars: Map::new(),
      parent: Some(parent),
    }
  } else {
    {
      extern_fns: Map::new(),
      embedded_fns: Map::new(),
      embedded_methods: Map::new(),
      fn_aliases: Map::new(),
      type_definitions: Map::new(),
      struct_methods: Map::new(),
      type_environments: [TypeEnvironment::new()],
      values: Map::new(),
      mutable_vars: Map::new(),
      parent: None,
    }
  }
}

///| 深拷贝环境 - 完全复制所有内容
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

///| 为闭包创建捕获环境 - 实现正确的变量捕获语义
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
    extern_fns: self.extern_fns,
    embedded_fns: self.embedded_fns,
    embedded_methods: self.embedded_methods,
    fn_aliases: self.fn_aliases,
    type_definitions: self.type_definitions,
    struct_methods: self.struct_methods,
    type_environments: self.type_environments,
    values: new_values,
    mutable_vars: new_mutable_vars,
    parent: Some(self),
  }
}
