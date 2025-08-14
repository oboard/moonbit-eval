///| 变量管理模块
///| 处理变量查找、设置和作用域管理

///| 在解释器中查找变量
///| 优先查找不可变变量（性能优化），然后查找可变变量
pub fn find_variable(
  immutable_values : Array[Map[String, @syntax.Expr]],
  mutable_values : Array[Map[String, @syntax.Expr]],
  name : String,
) -> @syntax.Expr {
  // 性能优化：优先查找不可变变量（可以缓存和共享）
  for value in immutable_values.rev() {
    match value.get(name) {
      Some(variable) => return variable
      None => continue
    }
  }

  // 然后查找可变变量
  for value in mutable_values.rev() {
    match value.get(name) {
      Some(variable) => return variable
      None => continue
    }
  }
  
  // 如果找不到变量，返回Unit表达式
  @syntax.Expr::Unit(
    loc={
      start: { fname: "", lnum: 10, bol: 0, cnum: 0 },
      end: { fname: "", lnum: 10, bol: 0, cnum: 0 },
    },
    faked=true,
  )
}

///| 设置不可变变量
pub fn set_immutable_variable(
  immutable_values : Array[Map[String, @syntax.Expr]],
  level : Int,
  name : String,
  value : @syntax.Expr,
) -> Unit {
  immutable_values[level].set(name, value)
}

///| 设置可变变量
pub fn set_mutable_variable(
  mutable_values : Array[Map[String, @syntax.Expr]],
  level : Int,
  name : String,
  value : @syntax.Expr,
) -> Unit {
  mutable_values[level].set(name, value)
}

///| 更新可变变量的值
///| 在可变变量数组中查找并更新指定变量
pub fn update_mutable_variable(
  mutable_values : Array[Map[String, @syntax.Expr]],
  name : String,
  new_value : @syntax.Expr,
) -> Bool {
  // 只在可变变量数组中查找和更新（性能优化）
  for i = mutable_values.length() - 1; i >= 0; i = i - 1 {
    match mutable_values[i].get(name) {
      Some(_) => {
        mutable_values[i].set(name, new_value)
        return true
      }
      None => continue
    }
  }
  false
}

///| 创建新的作用域
pub fn push_scope(
  immutable_values : Array[Map[String, @syntax.Expr]],
  mutable_values : Array[Map[String, @syntax.Expr]],
) -> Unit {
  immutable_values.push(Map::new())
  mutable_values.push(Map::new())
}

///| 销毁当前作用域
pub fn pop_scope(
  immutable_values : Array[Map[String, @syntax.Expr]],
  mutable_values : Array[Map[String, @syntax.Expr]],
) -> Unit {
  immutable_values.pop() |> ignore
  mutable_values.pop() |> ignore
}