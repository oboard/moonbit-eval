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
  "search_by": array_search_by_fn,
  "find_index": array_search_by_fn,
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
    ctx.mod.env.from_option(arr.get(i))
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
  [{ value: Array(arr), .. }, ..] => ctx.mod.env.from_option(arr.pop())
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
    ctx.mod.env.from_option(arr.search(val).map(fn(i) { RuntimeValue::Int(i) }))
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
  [{ value: Array(arr), .. }, { value: Closure(f, _env), .. }, ..] => {
    arr.each(fn(val) {
      let arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.of([arg])) |> ignore
    })
    Unit
  }
  _ => Unit
}

///| 数组map操作
let array_map_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Closure(f, _env), .. }, ..] => {
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
  [{ value: Array(arr), .. }, { value: Closure(f, _env), .. }, ..] => {
    let new_arr = arr.filter(fn(val) {
      let arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      ctx.context.call(f, @list.of([arg])) is Bool(true)
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
    { value: Closure(f, _env), .. },
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
      ctx.context.call(f, @list.of([acc_arg, val_arg]))
    })
  _ => Unit
}

///| 数组index_of操作
let array_search_by_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Array(arr), .. }, { value: Closure(f, _), .. }, ..] => {
    let index = arr.search_by(val => {
      let arg = @syntax.Argument::{
        value: val.to_expr(),
        kind: @syntax.ArgumentKind::Positional,
      }
      (try? ctx.context.call(f, @list.of([arg]))) is Ok(Bool(true))
    })
    ctx.mod.env.from_option(index.map(Int(_)))
  }
  _ => Unit
}
