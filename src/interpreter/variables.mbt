///| 变量管理模块

///| 处理变量查找、设置和作用域管理

///| 在解释器中查找变量
pub fn find_variable(
  values : Array[Map[String, RuntimeValue]],
  name : String,
) -> RuntimeValue {
  for value in values.rev() {
    if value.contains(name) {
      return value.get(name).unwrap()
    }
  }
  RuntimeValue::Unit
}

///| 设置可变变量
pub fn ClosureInterpreter::set_variable(
  self : ClosureInterpreter,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.values[self.values.length() - 1].set(name, value)
}

///| 更新可变变量的值

///| 在可变变量数组中查找并更新指定变量
pub fn update_variable(
  values : Array[Map[String, RuntimeValue]],
  name : String,
  new_value : RuntimeValue,
) -> Unit {
  // 只在可变变量数组中查找和更新（性能优化）
  for i = values.length() - 1; i >= 0; i = i - 1 {
    if values[i].contains(name) {
      values[i].set(name, new_value)
    }
  }
}

///| 创建新的作用域
pub fn ClosureInterpreter::push_scope(self : ClosureInterpreter) -> Unit {
  self.values.push(Map::new())
  self.user_functions.push(Map::new())
}

///| 销毁当前作用域
pub fn ClosureInterpreter::pop_scope(self : ClosureInterpreter) -> Unit {
  self.values.pop() |> ignore
  self.user_functions.pop() |> ignore
}
