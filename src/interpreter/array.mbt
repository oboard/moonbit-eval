///|
pub let array_methods : Map[String, RuntimeFunction] = {
  "new": array_new_fn,
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
  "eachi": array_eachi_fn,
  "map": array_map_fn,
  "filter": array_filter_fn,
  "fold": array_fold_fn,
  "make": array_make_fn,
  "iter": array_iter_fn,
  "sort": array_sort_fn,
}

///| 数组排序
let array_sort_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => {
    arr.sort()
    Unit
  }
  _ => Unit
}

///| 数组make操作
let array_make_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(len), .. }, { val, .. }, ..] => Array(Array::make(len, val))
  _ => Unit
}

///| 数组new操作
let array_new_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Int(len),
      kind: LabelledOption("capacity")
      | LabelledOptionPun("capacity"),
    },
    ..,
  ] => Array(Array::new(capacity=len))
  _ => Array(Array::new())
}

///| 数组长度
let array_length_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => Int(arr.length())
  _ => Unit
}

///| 数组push操作
let array_push_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val, .. }, ..] => {
    arr.push(val)
    Array(arr)
  }
  _ => Unit
}

///| 数组clear操作
let array_clear_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => {
    arr.clear()
    Unit
  }
  _ => Unit
}

///| 数组is_empty操作
let array_is_empty_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => Bool(arr.is_empty())
  _ => Unit
}

///| 数组reverse操作
let array_rev_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => Array(arr.rev())
  _ => Unit
}

///| 数组copy操作
let array_copy_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => Array(arr.copy())
  _ => Unit
}

///| 数组join操作
let array_join_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: String(sep), .. }, ..] =>
    String(arr.map(v => v.to_string()).join(sep))
  _ => Unit
}

///| 数组swap操作
let array_swap_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(i), .. }, { val: Int(j), .. }, ..] => {
    arr.swap(i, j)
    Unit
  }
  _ => Unit
}

///| 数组get操作
let array_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(i), .. }, ..] =>
    ctx.mod.env.from_option(arr.get(i))
  _ => Unit
}

///| 数组append操作
let array_append_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Array(arr2), .. }, ..] => {
    arr.append(arr2)
    Unit
  }
  _ => Unit
}

///| 数组set操作
let array_set_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(i), .. }, { val, .. }, ..] => {
    arr[i] = val
    Unit
  }
  _ => Unit
}

///| 数组pop操作
let array_pop_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => ctx.mod.env.from_option(arr.pop())
  _ => Unit
}

///| 数组insert操作
let array_insert_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(i), .. }, { val, .. }, ..] => {
    arr.insert(i, val)
    Unit
  }
  _ => Unit
}

///| 数组remove操作
let array_remove_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(i), .. }, ..] => arr.remove(i)
  _ => Unit
}

///| 数组contains操作
let array_contains_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val, .. }, ..] => Bool(arr.contains(val))
  _ => Unit
}

///| 数组search操作
let array_search_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val, .. }, ..] =>
    ctx.mod.env.from_option(arr.search(val).map(fn(i) { Int(i) }))
  _ => Unit
}

///| 数组capacity操作
let array_capacity_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => Int(arr.capacity())
  _ => Unit
}

///| 数组resize操作
let array_resize_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: Array(arr), .. },
    { val: Int(new_size), .. },
    { val: fill_val, .. },
    ..,
  ] => {
    arr.resize(new_size, fill_val)
    Unit
  }
  _ => Unit
}

///| 数组truncate操作
let array_truncate_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(len), .. }, ..] => {
    arr.truncate(len)
    Unit
  }
  _ => Unit
}

///| 数组reserve_capacity操作
let array_reserve_capacity_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Int(additional), .. }, ..] => {
    arr.reserve_capacity(additional)
    Unit
  }
  _ => Unit
}

///| 数组each操作
let array_each_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Closure(f, env), .. }, ..] => {
    arr.each(fn(val) {
      ctx.context.call_closure_runtime(
        f,
        ctx.mod,
        env,
        @list.singleton({ val, kind: Positional }),
      )
      |> ignore
    })
    Unit
  }
  _ => Unit
}

///| 数组eachi操作
let array_eachi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Closure(f, env), .. }, ..] => {
    arr.eachi(fn(i, val) {
      ctx.context.call_closure_runtime(
        f,
        ctx.mod,
        env,
        @list.of([{ val: Int(i), kind: Positional }, { val, kind: Positional }]),
      )
      |> ignore
    })
    Unit
  }
  _ => Unit
}

///| 数组map操作
let array_map_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Closure(f, env), .. }, ..] => {
    let new_arr = arr.map(fn(val) {
      ctx.context.call_closure_runtime(
        f,
        ctx.mod,
        env,
        @list.singleton({ val, kind: Positional }),
      )
    })
    Array(new_arr)
  }
  _ => Unit
}

///| 数组filter操作
let array_filter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Closure(f, env), .. }, ..] => {
    let new_arr = arr.filter(fn(val) {
      ctx.context.call_closure_runtime(
        f,
        ctx.mod,
        env,
        @list.singleton({ val, kind: Positional }),
      )
      is Bool(true)
    })
    Array(new_arr)
  }
  _ => Unit
}

///| 数组fold操作
let array_fold_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: Array(arr), .. },
    { val: init_val, .. },
    { val: Closure(f, env), .. },
    ..,
  ] =>
    arr.fold(init=init_val, fn(acc, val) {
      ctx.context.call_closure_runtime(
        f,
        ctx.mod,
        env,
        @list.of([{ val: acc, kind: Positional }, { val, kind: Positional }]),
      )
    })
  _ => Unit
}

///| 数组index_of操作
let array_search_by_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, { val: Closure(f, env), .. }, ..] => {
    let index = arr.search_by(val => (try? ctx.context.call_closure_runtime(
        f,
        ctx.mod,
        env,
        @list.singleton({ val, kind: Positional }),
      ))
      is Ok(Bool(true)))
    ctx.mod.env.from_option(index.map(Int(_)))
  }
  _ => Unit
}

///| 数组iter操作
let array_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Array(arr), .. }, ..] => Iter(arr.iter())
  _ => Unit
}
