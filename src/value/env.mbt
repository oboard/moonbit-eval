///|
pub(all) struct RuntimeEnvironment {
  values : Map[String, RuntimeValue]
  parent : RuntimeEnvironment?
} derive(Show)

///|
pub fn RuntimeEnvironment::new(
  parent? : RuntimeEnvironment,
) -> RuntimeEnvironment {
  { values: Map::new(), parent }
}

///| 深拷贝环境 - 用于闭包捕获
pub fn RuntimeEnvironment::copy(
  self : RuntimeEnvironment,
) -> RuntimeEnvironment {
  let new_values = Map::new()
  self.values.each(fn(key, value) { new_values.set(key, value) })
  let new_parent = match self.parent {
    Some(parent) => Some(parent.copy())
    None => None
  }
  { values: new_values, parent: new_parent }
}
