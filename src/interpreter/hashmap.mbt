///|
pub let hash_map_methods : Map[String, RuntimeFunction] = {
  "clear": hash_map_clear_fn,
  "is_empty": hash_map_is_empty_fn,
  "capacity": hash_map_capacity_fn,
  "contains": hash_map_contains_fn,
  "contains_kv": hash_map_contains_kv_fn,
  "copy": hash_map_copy_fn,
  "default": hash_map_default_fn,
  "each": hash_map_each_fn,
  "eachi": hash_map_eachi_fn,
  "equal": hash_map_equal_fn,
  "from_array": hash_map_from_array_fn,
  "from_iter": hash_map_from_iter_fn,
  "get": hash_map_get_fn,
  "get_or_default": hash_map_get_or_default_fn,
  "get_or_init": hash_map_get_or_init_fn,
  "iter": hash_map_iter_fn,
  "iter2": hash_map_iter2_fn,
  "keys": hash_map_keys_fn,
  "length": hash_map_length_fn,
  "map": hash_map_map_fn,
  "new": hash_map_new_fn,
  "of": hash_map_of_fn,
  "remove": hash_map_remove_fn,
  "retain": hash_map_retain_fn,
  "set": hash_map_set_fn,
  "size": hash_map_size_fn,
  "to_array": hash_map_to_array_fn,
  "to_json": hash_map_to_json_fn,
  "to_string": hash_map_to_string_fn,
  "values": hash_map_values_fn,
}

///|
let hash_map_clear_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => {
    map.clear()
    Unit
  }
  _ => Unit
}

///|
let hash_map_values_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => Iter(map.values())
  _ => Unit
}

///|
/// HashMap is_empty操作
let hash_map_is_empty_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => Bool(map.is_empty())
  _ => Unit
}

///|
/// HashMap capacity操作
let hash_map_capacity_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => Int(map.capacity())
  _ => Unit
}

///|
/// HashMap contains操作
let hash_map_contains_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }] => Bool(map.contains(key))
  _ => Unit
}

///|
/// HashMap contains_kv操作
let hash_map_contains_kv_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }, { val, .. }] =>
    Bool(map.get(key) == Some(val))
  _ => Unit
}

///|
/// HashMap copy操作
let hash_map_copy_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => HashMap(map.copy())
  _ => Unit
}

///|
/// HashMap default操作
let hash_map_default_fn : RuntimeFunction = ctx => match ctx.args {
  _ => HashMap(@hashmap.HashMap::new())
}

///|
/// HashMap each操作
let hash_map_each_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: Fn(f), .. }] => {
    map.each(fn(key, val) {
      ctx.context.call(f.val, ctx.pkg, [
        { val: key, kind: Positional },
        { val, kind: Positional },
      ])
      |> ignore
    })
    Unit
  }
  _ => Unit
}

///|
/// HashMap eachi操作
let hash_map_eachi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: Fn(f), .. }] => {
    map.eachi(fn(i, key, val) {
      ctx.context.call(f.val, ctx.pkg, [
        { val: Int(i), kind: Positional },
        { val: key, kind: Positional },
        { val, kind: Positional },
      ])
      |> ignore
    })
    Unit
  }
  _ => Unit
}

///|
/// HashMap equal操作
let hash_map_equal_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map1), .. }, { val: HashMap(map2), .. }] => Bool(map1 == map2)
  _ => Unit
}

///|
/// HashMap from_array操作
let hash_map_from_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }] => {
    let map = @hashmap.HashMap::new()
    arr.each(fn(item) {
      match item {
        Tuple([key, val]) => map.set(key, val)
        _ => ()
      }
    })
    HashMap(map)
  }
  _ => Unit
}

///|
/// HashMap from_iter操作
let hash_map_from_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] =>
    HashMap(
      @hashmap.HashMap::from_iter(
        iter.map(item => match item {
          Tuple([key, val]) => (key, val)
          _ => panic()
        }),
      ),
    )
  _ => Unit
}

///|
/// HashMap get操作
let hash_map_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }] =>
    RuntimeValue::from_option(map.get(key))
  _ => Unit
}

///|
/// HashMap get_or_default操作
let hash_map_get_or_default_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }, { val: default, .. }] =>
    match map.get(key) {
      Some(val) => val
      None => default
    }
  _ => Unit
}

///|
/// HashMap get_or_init操作
let hash_map_get_or_init_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }, { val: Fn(f), .. }] =>
    match map.get(key) {
      Some(val) => val
      None => {
        let val = ctx.context.call(f.val, ctx.pkg, [])
        map.set(key, val)
        val
      }
    }
  _ => Unit
}

///|
/// HashMap iter操作
let hash_map_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(self), .. }] =>
    Iter(
      self
      .iter()
      .map(item => match item {
        (key, val) => Tuple([key, val])
      }),
    )
  _ => Unit
}

///|
/// HashMap iter2操作
let hash_map_iter2_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(self), .. }] => Iter2(self.iter2())
  _ => Unit
}

///|
/// HashMap keys操作
let hash_map_keys_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => {
    let arr = Array::new()
    map.each(fn(key, _val) { arr.push(key) })
    Array(arr)
  }
  _ => Unit
}

///|
/// HashMap length操作
let hash_map_length_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => Int(map.length())
  _ => Unit
}

///|
/// HashMap map操作
let hash_map_map_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: Fn(f), .. }] => {
    let new_map = @hashmap.HashMap::new()
    map.each(fn(key, val) {
      let new_val = ctx.context.call(f.val, ctx.pkg, [
        { val: key, kind: Positional },
        { val, kind: Positional },
      ])
      new_map.set(key, new_val)
    })
    HashMap(new_map)
  }
  _ => Unit
}

///|
/// HashMap new操作
let hash_map_new_fn : RuntimeFunction = ctx => match ctx.args {
  _ => HashMap(@hashmap.HashMap::new())
}

///|
/// HashMap of操作
let hash_map_of_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }] => {
    let result_map = @hashmap.HashMap::new()
    for item in arr {
      match item {
        Tuple([key, val]) => result_map.set(key, val)
        _ => return Unit // 如果格式不正确，返回Unit
      }
    }
    HashMap(result_map)
  }
  _ => Unit
}

///|
/// HashMap remove操作
let hash_map_remove_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }] => {
    map.remove(key)
    Unit
  }
  _ => Unit
}

///|
/// HashMap retain操作
let hash_map_retain_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: Fn(f), .. }] => {
    map.retain(fn(key, val) {
      try {
        match
          ctx.context.call(f.val, ctx.pkg, [
            { val: key, kind: Positional },
            { val, kind: Positional },
          ]) {
          Bool(b) => b
          _ => false
        }
      } catch {
        _ => false
      }
    })
    Unit
  }
  _ => Unit
}

///|
/// HashMap set操作
let hash_map_set_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }, { val: key, .. }, { val, .. }] => {
    map.set(key, val)
    Unit
  }
  _ => Unit
}

///|
/// HashMap size操作
let hash_map_size_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => Int(map.length())
  _ => Unit
}

///|
/// HashMap to_array操作
let hash_map_to_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => {
    let arr : Array[RuntimeValue] = Array::new()
    map.each(fn(key, val) { arr.push(Tuple([key, val])) })
    Array(arr)
  }
  _ => Unit
}

///|
/// HashMap to_json操作
let hash_map_to_json_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => {
    // 简化的JSON转换，将HashMap转换为Map[RuntimeValue, RuntimeValue]
    let json_obj : Map[RuntimeValue, RuntimeValue] = Map::new()
    map.each(fn(key, val) { json_obj.set(key, val) })
    Map(json_obj)
  }
  _ => Unit
}

///|
/// HashMap to_string操作
let hash_map_to_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: HashMap(map), .. }] => {
    let sb = StringBuilder::new()
    sb.write_string("{")
    let mut first = true
    map.each(fn(key, val) {
      if not(first) {
        sb.write_string(", ")
      }
      first = false
      sb.write_string(key.to_string())
      sb.write_string(": ")
      sb.write_string(val.to_string())
    })
    sb.write_string("}")
    String(sb.to_string())
  }
  _ => Unit
}
