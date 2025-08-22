///|
pub let map_methods : Map[String, RuntimeFunction] = {
  "clear": map_clear_fn,
  "is_empty": map_is_empty_fn,
  "capacity": map_capacity_fn,
  "contains": map_contains_fn,
  "contains_kv": map_contains_kv_fn,
  "copy": map_copy_fn,
  "each": map_each_fn,
  "eachi": map_eachi_fn,
  "from_array": map_from_array_fn,
  "from_iter": map_from_iter_fn,
  "get": map_get_fn,
  "get_or_default": map_get_or_default_fn,
  "get_or_init": map_get_or_init_fn,
  "iter": map_iter_fn,
  "iter2": map_iter2_fn,
  "keys": map_keys_fn,
  "map": map_map_fn,
  "new": map_new_fn,
  "of": map_of_fn,
  "remove": map_remove_fn,
  "set": map_set_fn,
  "size": map_size_fn,
  "to_array": map_to_array_fn,
  "update": map_update_fn,
  "values": map_values_fn,
}

///| Map clear操作
let map_clear_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => {
    map.clear()
    Unit
  }
  _ => Unit
}

///| Map is_empty操作
let map_is_empty_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => Bool(map.is_empty())
  _ => Unit
}

///| Map capacity操作
let map_capacity_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => Int(map.capacity())
  _ => Unit
}

///| Map contains操作
let map_contains_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: key, .. }, ..] => Bool(map.contains(key))
  _ => Unit
}

///| Map contains_kv操作
let map_contains_kv_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: key, .. }, { value: val, .. }, ..] =>
    Bool(map.get(key) == Some(val))
  _ => Unit
}

///| Map copy操作
let map_copy_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => Map(map.copy())
  _ => Unit
}

///| Map each操作
let map_each_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: Closure(f, _env), .. }, ..] => {
    map.each(fn(key, val) {
      let key_arg = @syntax.Argument::{
        value: key.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      let val_arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.of([key_arg, val_arg])) |> ignore
    })
    Unit
  }
  _ => Unit
}

///| Map eachi操作
let map_eachi_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: Closure(f, _env), .. }, ..] => {
    map.eachi(fn(i, key, val) {
      let i_arg = @syntax.Argument::{
        value: Int(i).to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      let key_arg = @syntax.Argument::{
        value: key.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      let val_arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.of([i_arg, key_arg, val_arg])) |> ignore
    })
    Unit
  }
  _ => Unit
}

///| Map from_array操作
let map_from_array_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => {
    let map = Map::new()
    arr.each(fn(item) {
      match item {
        Tuple([key, val]) => map.set(key, val)
        _ => ()
      }
    })
    Map(map)
  }
  _ => Unit
}

///| Map from_iter操作
let map_from_iter_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: iter, .. }, ..] =>
    // 简化实现，实际需要迭代器支持
    Map(Map::new())
  _ => Unit
}

///| Map get操作
let map_get_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: key, .. }, ..] =>
    ctx.mod.env.from_option(map.get(key))
  _ => Unit
}

///| Map get_or_default操作
let map_get_or_default_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: key, .. }, { value: default, .. }, ..] =>
    match map.get(key) {
      Some(val) => val
      None => default
    }
  _ => Unit
}

///| Map get_or_init操作
let map_get_or_init_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Map(map), .. },
    { value: key, .. },
    { value: Closure(f, _env), .. },
    ..,
  ] =>
    match map.get(key) {
      Some(val) => val
      None => {
        let val = ctx.context.call(f, @list.of([]))
        map.set(key, val)
        val
      }
    }
  _ => Unit
}

///| Map iter操作
let map_iter_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => {
    // 简化实现，返回键值对数组
    let arr = Array::new()
    map.each(fn(key, val) { arr.push(Tuple([key, val])) })
    Array(arr)
  }
  _ => Unit
}

///| Map iter2操作
let map_iter2_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => {
    // 简化实现，返回键值对数组
    let arr = Array::new()
    map.each(fn(key, val) { arr.push(Tuple([key, val])) })
    Array(arr)
  }
  _ => Unit
}

///| Map keys操作
let map_keys_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => {
    let arr = Array::new()
    map.each(fn(key, _val) { arr.push(key) })
    Array(arr)
  }
  _ => Unit
}

///| Map map操作
let map_map_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: Closure(f, _env), .. }, ..] => {
    let new_map = Map::new()
    map.each(fn(key, val) {
      let key_arg = @syntax.Argument::{
        value: key.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      let val_arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      let new_val = ctx.context.call(f, @list.of([key_arg, val_arg]))
      new_map.set(key, new_val)
    })
    Map(new_map)
  }
  _ => Unit
}

///| Map new操作
let map_new_fn : RuntimeFunction = ctx => match ctx.arguments {
  _ => Map(Map::new())
}

///| Map of操作
let map_of_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => {
    let map = Map::new()
    arr.each(fn(item) {
      match item {
        Tuple([key, val]) => map.set(key, val)
        _ => ()
      }
    })
    Map(map)
  }
  _ => {
    // 处理可变参数情况：Map::of(key1, val1, key2, val2, ...)
    let map = Map::new()
    let args = ctx.arguments
    let mut i = 0
    while i + 1 < args.length() {
      map.set(args[i].value, args[i + 1].value)
      i = i + 2
    }
    Map(map)
  }
}

///| Map remove操作
let map_remove_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: key, .. }, ..] => {
    map.remove(key)
    Unit
  }
  _ => Unit
}

///| Map set操作
let map_set_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, { value: key, .. }, { value: val, .. }, ..] => {
    map.set(key, val)
    Unit
  }
  _ => Unit
}

///| Map size操作
let map_size_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => Int(map.size())
  _ => Unit
}

///| Map to_array操作
let map_to_array_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => {
    let arr = Array::new()
    map.each(fn(key, val) { arr.push(Tuple([key, val])) })
    Array(arr)
  }
  _ => Unit
}

///| Map update操作
let map_update_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Map(map), .. },
    { value: key, .. },
    { value: Closure(f, _env), .. },
    ..,
  ] => {
    match map.get(key) {
      Some(old_val) => {
        let arg = @syntax.Argument::{
          value: old_val.to_expr(),
          kind: @syntax.ArgumentKind::Positional,
        }
        let new_val = ctx.context.call(f, @list.of([arg]))
        map.set(key, new_val)
      }
      None => ()
    }
    Unit
  }
  _ => Unit
}

///| Map values操作
let map_values_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Map(map), .. }, ..] => {
    let arr = Array::new()
    map.each(fn(_key, val) { arr.push(val) })
    Array(arr)
  }
  _ => Unit
}
