///| 变量管理模块

///| 处理变量查找、设置和作用域管理

///| 在解释器中查找变量
pub fn find_variable(
  values : Array[Map[String, RuntimeValue]],
  name : String,
) -> RuntimeValue {
  for value in values.rev_iter() {
    if value.get(name) is Some(x) {
      return x
    }
  }
  RuntimeValue::Unit
}

///| 更新变量
pub fn ClosureInterpreter::set_variable(
  self : ClosureInterpreter,
  name : String,
  value : RuntimeValue,
) -> Unit {
  self.current_scope().set(name, value)
}

///| 更新可变变量的值

///| 在可变变量数组中查找并更新指定变量
pub fn ClosureInterpreter::update_variable(
  self : ClosureInterpreter,
  name : String,
  new_value : RuntimeValue,
) -> Unit {
  for values in self.values.rev_iter() {
    if values.contains(name) {
      values.set(name, new_value)
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
