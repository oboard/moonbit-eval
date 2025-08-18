///|
pub let array_methods : Map[String, RuntimeFunction] = {
  "length": array_length_fn,
  "push": array_push_fn,
  "clear": array_clear_fn,
  "is_empty": array_is_empty_fn,
  "rev": array_rev_fn,
  "copy": array_copy_fn,
  "join": array_join_fn,
  "swap": array_swap_fn,
  "get": array_get_fn,
  "append": array_append_fn,
  "set": array_set_fn,
  "pop": array_pop_fn,
  "insert": array_insert_fn,
  "remove": array_remove_fn,
  "contains": array_contains_fn,
  "search": array_search_fn,
  "index_of": array_index_of_fn,
  "last_index_of": array_last_index_of_fn,
  "slice": array_slice_fn,
  "concat": array_concat_fn,
  "any": array_any_fn,
  "all": array_all_fn,
  "capacity": array_capacity_fn,
  "resize": array_resize_fn,
  "truncate": array_truncate_fn,
  "reserve_capacity": array_reserve_capacity_fn,
  "each": array_each_fn,
  "map": array_map_fn,
  "filter": array_filter_fn,
  "fold": array_fold_fn,
}

///| 数组长度
let array_length_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => Int(arr.length())
  _ => Unit
}

///| 数组push操作
let array_push_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: val, .. }, ..] => {
    arr.push(val)
    Array(arr)
  }
  _ => Unit
}

///| 数组slice操作
let array_slice_fn : RuntimeFunction = ctx => match ctx.arguments {
  // slice(start, end)
  [{ value: Array(arr), .. }, { value: Int(start), .. }, { value: Int(end), .. }, ..] => {
    let start_idx = if start < 0 { 0 } else { start }
    let end_idx = if end > arr.length() { arr.length() } else { end }
    if start_idx >= end_idx {
      RuntimeValue::Array([])
    } else {
      let sliced = Array::new()
      for i = start_idx; i < end_idx; i = i + 1 {
        sliced.push(arr[i])
      }
      RuntimeValue::Array(sliced)
    }
  }
  // slice(start) - slice from start to end
  [{ value: Array(arr), .. }, { value: Int(start), .. }, ..] => {
    let start_idx = if start < 0 { 0 } else { start }
    if start_idx >= arr.length() {
      RuntimeValue::Array([])
    } else {
      let sliced = Array::new()
      for i = start_idx; i < arr.length(); i = i + 1 {
        sliced.push(arr[i])
      }
      RuntimeValue::Array(sliced)
    }
  }
  _ => Unit
}

///| 数组concat操作
let array_concat_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr1), .. }, { value: Array(arr2), .. }, ..] => {
    let result = Array::new()
    for i = 0; i < arr1.length(); i = i + 1 {
      result.push(arr1[i])
    }
    for i = 0; i < arr2.length(); i = i + 1 {
      result.push(arr2[i])
    }
    RuntimeValue::Array(result)
  }
  _ => Unit
}

///| 数组any操作
let array_any_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => {
    let mut result = false
    for i = 0; i < arr.length(); i = i + 1 {
      match arr[i] {
        Bool(true) => {
          result = true
          break
        }
        _ => continue
      }
    }
    RuntimeValue::Bool(result)
  }
  _ => Unit
}

///| 数组all操作
let array_all_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => {
    let mut result = true
    for i = 0; i < arr.length(); i = i + 1 {
      match arr[i] {
        Bool(false) => {
          result = false
          break
        }
        Bool(true) => continue
        _ => {
          result = false
          break
        }
      }
    }
    RuntimeValue::Bool(result)
  }
  _ => Unit
}

///| 数组clear操作
let array_clear_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => {
    arr.clear()
    Unit
  }
  _ => Unit
}

///| 数组is_empty操作
let array_is_empty_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => Bool(arr.is_empty())
  _ => Unit
}

///| 数组reverse操作
let array_rev_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => Array(arr.rev())
  _ => Unit
}

///| 数组copy操作
let array_copy_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => Array(arr.copy())
  _ => Unit
}

///| 数组join操作
let array_join_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: String(sep), .. }, ..] =>
    String(arr.map(v => v.to_string()).join(sep))
  _ => Unit
}

///| 数组swap操作
let array_swap_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(i), .. }, { value: Int(j), .. }, ..] => {
    arr.swap(i, j)
    Unit
  }
  _ => Unit
}

///| 数组get操作
let array_get_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(i), .. }, ..] =>
    RuntimeValue::from_option(arr.get(i))
  _ => Unit
}

///| 数组append操作
let array_append_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Array(arr2), .. }, ..] => {
    arr.append(arr2)
    Unit
  }
  _ => Unit
}

///| 数组set操作
let array_set_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(i), .. }, { value: val, .. }, ..] => {
    arr[i] = val
    Unit
  }
  _ => Unit
}

///| 数组pop操作
let array_pop_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => RuntimeValue::from_option(arr.pop())
  _ => Unit
}

///| 数组insert操作
let array_insert_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(i), .. }, { value: val, .. }, ..] => {
    arr.insert(i, val)
    Unit
  }
  _ => Unit
}

///| 数组remove操作
let array_remove_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(i), .. }, ..] => arr.remove(i)
  _ => Unit
}

///| 数组contains操作
let array_contains_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: val, .. }, ..] => Bool(arr.contains(val))
  _ => Unit
}

///| 数组search操作
let array_search_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: val, .. }, ..] =>
    RuntimeValue::from_option(
      arr.search(val).map(fn(i) { RuntimeValue::Int(i) }),
    )
  _ => Unit
}

///| 数组capacity操作
let array_capacity_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, ..] => Int(arr.capacity())
  _ => Unit
}

///| 数组resize操作
let array_resize_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Array(arr), .. },
    { value: Int(new_size), .. },
    { value: fill_val, .. },
    ..,
  ] => {
    arr.resize(new_size, fill_val)
    Unit
  }
  _ => Unit
}

///| 数组truncate操作
let array_truncate_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(len), .. }, ..] => {
    arr.truncate(len)
    Unit
  }
  _ => Unit
}

///| 数组reserve_capacity操作
let array_reserve_capacity_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Int(additional), .. }, ..] => {
    arr.reserve_capacity(additional)
    Unit
  }
  _ => Unit
}

///| 数组each操作
let array_each_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: FuncRef(f), .. }, ..] => {
    arr.each(fn(val) {
      let arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.from_array([arg])) |> ignore
    })
    Unit
  }
  _ => Unit
}

///| 数组map操作
let array_map_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: FuncRef(f), .. }, ..] => {
    let new_arr = arr.map(fn(val) {
      let arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.from_array([arg]))
    })
    Array(new_arr)
  }
  _ => Unit
}

///| 数组filter操作
let array_filter_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: FuncRef(f), .. }, ..] => {
    let new_arr = arr.filter(fn(val) {
      let arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      match ctx.context.call(f, @list.from_array([arg])) {
        Bool(true) => true
        _ => false
      }
    })
    Array(new_arr)
  }
  _ => Unit
}

///| 数组fold操作
let array_fold_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Array(arr), .. },
    { value: init_val, .. },
    { value: FuncRef(f), .. },
    ..,
  ] =>
    arr.fold(init=init_val, fn(acc, val) {
      let acc_arg = @syntax.Argument::{
        value: acc.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      let val_arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.from_array([acc_arg, val_arg]))
    })
  _ => Unit
}

///| 数组index_of操作
let array_index_of_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: val, .. }, ..] => {
    let mut index = 0
    let mut found = false
    while index < arr.length() && not(found) {
      if arr[index] == val {
        found = true
      } else {
        index = index + 1
      }
    }
    if found {
      RuntimeValue::Constructor("Some", [RuntimeValue::Int(index)])
    } else {
      RuntimeValue::Constructor("None", [])
    }
  }
  _ => Unit
}

///| 数组last_index_of操作
let array_last_index_of_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: val, .. }, ..] => {
    let mut index = arr.length() - 1
    let mut found = false
    while index >= 0 && not(found) {
      if arr[index] == val {
        found = true
      } else {
        index = index - 1
      }
    }
    if found {
      RuntimeValue::Constructor("Some", [RuntimeValue::Int(index)])
    } else {
      RuntimeValue::Constructor("None", [])
    }
  }
  _ => Unit
}
