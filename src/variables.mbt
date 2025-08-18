///| 变量管理模块

///| 处理变量查找、设置和作用域管理

///| 在解释器中查找变量

///| 优先查找不可变变量（性能优化），然后查找可变变量
pub fn find_variable(
  immutable_values : Array[Map[String, RuntimeValue]],
  mutable_values : Array[Map[String, RuntimeValue]],
  name : String,
) -> RuntimeValue {
  // 优先查找可变变量（优先级更高）
  for value in mutable_values.rev() {
    if value.contains(name) {
      return value.get(name).unwrap()
    }
  }

  // 然后查找不可变变量
  for value in immutable_values.rev() {
    if value.contains(name) {
      return value.get(name).unwrap()
    }
  }
  RuntimeValue::Unit
}

///| 设置不可变变量
pub fn ClosureInterpreter::set_immutable_variable(
  self : ClosureInterpreter,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.immutable_values[self.immutable_values.length() - 1].set(name, value)
}

///| 设置可变变量
pub fn ClosureInterpreter::set_mutable_variable(
  self : ClosureInterpreter,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.mutable_values[self.mutable_values.length() - 1].set(name, value)
}

///| 更新可变变量的值

///| 在可变变量数组中查找并更新指定变量
pub fn update_mutable_variable(
  mutable_values : Array[Map[String, RuntimeValue]],
  name : String,
  new_value : RuntimeValue,
) -> Unit {
  // 只在可变变量数组中查找和更新（性能优化）
  for i = mutable_values.length() - 1; i >= 0; i = i - 1 {
    if mutable_values[i].contains(name) {
      mutable_values[i].set(name, new_value)
    }
  }
}

///| 创建新的作用域
pub fn ClosureInterpreter::push_scope(self : ClosureInterpreter) -> Unit {
  self.immutable_values.push(Map::new())
  self.mutable_values.push(Map::new())
  self.user_functions.push(Map::new())
}

///| 销毁当前作用域
pub fn ClosureInterpreter::pop_scope(self : ClosureInterpreter) -> Unit {
  self.immutable_values.pop() |> ignore
  self.mutable_values.pop() |> ignore
  self.user_functions.pop() |> ignore
}
