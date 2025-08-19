///|
pub(all) struct RuntimeEnvironment {
  values : Map[String, RuntimeValue]
  // 跟踪哪些变量是可变的
  mutable_vars : Map[String, Bool]
  parent : RuntimeEnvironment?
} derive(Show)

///|
pub fn RuntimeEnvironment::new(
  parent? : RuntimeEnvironment,
) -> RuntimeEnvironment {
  { values: Map::new(), mutable_vars: Map::new(), parent }
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
  { values: new_values, mutable_vars: new_mutable_vars, parent: new_parent }
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
  { values: new_values, mutable_vars: new_mutable_vars, parent: Some(self) }
}
