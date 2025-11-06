///|
pub let iter_methods : Map[String, RuntimeFunction] = {
  // "new": iter_new_fn,
  "all": iter_all_fn,
  "any": iter_any_fn,
  "append": iter_append_fn,
  "collect": iter_collect_fn,
  "concat": iter_concat_fn,
  "contains": iter_contains_fn,
  "count": iter_count_fn,
  "drop": iter_drop_fn,
  "drop_while": iter_drop_while_fn,
  "each": iter_each_fn,
  "eachi": iter_eachi_fn,
  "empty": iter_empty_fn,
  "filter": iter_filter_fn,
  "filter_map": iter_filter_map_fn,
  "find_first": iter_find_first_fn,
  "flat_map": iter_flat_map_fn,
  "flatten": iter_flatten_fn,
  "fold": iter_fold_fn,
  "head": iter_head_fn,
  "intersperse": iter_intersperse_fn,
  "iter": iter_iter_fn,
  "iter2": iter_iter2_fn,
  "join": iter_join_fn,
  "just_run": iter_just_run_fn,
  "last": iter_last_fn,
  "map": iter_map_fn,
  "map_option": iter_map_option_fn,
  "map_while": iter_map_while_fn,
  "mapi": iter_mapi_fn,
  "maximum": iter_maximum_fn,
  "minimum": iter_minimum_fn,
  "nth": iter_nth_fn,
  "op_as_view": iter_op_as_view_fn,
  "peek": iter_peek_fn,
  "prepend": iter_prepend_fn,
  "repeat": iter_repeat_fn,
  "run": iter_run_fn,
  "singleton": iter_singleton_fn,
  "take": iter_take_fn,
  "take_while": iter_take_while_fn,
  "tap": iter_tap_fn,
  "to_array": iter_to_array_fn,
}

// Basic constructor functions

// ///|
// let iter_new_fn : RuntimeFunction = ctx => match ctx.args {
//   [{ val, .. }] => Iter(Iter::new(f => f(val)))
//   _ => Unit
// }

///|
let iter_empty_fn : RuntimeFunction = _ctx => Iter(Iter::empty())

///|
let iter_singleton_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val, .. }] => Iter(Iter::singleton(val))
  _ => Unit
}

///|
let iter_repeat_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val, .. }] => Iter(Iter::repeat(val))
  _ => Unit
}

// Collection operations

///|
let iter_collect_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => Array(iter.collect())
  _ => Unit
}

///|
let iter_to_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => Array(iter.to_array())
  _ => Unit
}

///|
let iter_count_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => Int(iter.count(), raw=None)
  _ => Int(0, raw=None)
}

// Element access

///|
let iter_head_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.head())
  _ => Unit
}

///|
let iter_last_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.last())
  _ => Unit
}

///|
let iter_nth_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Int(n, ..), .. }] =>
    RuntimeValue::from_option(iter.nth(n))
  _ => Unit
}

///|
let iter_peek_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.peek())
  _ => Unit
}

// Sequence operations

///|
let iter_append_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val, .. }] => Iter(iter + Iter::singleton(val))
  _ => Unit
}

///|
let iter_prepend_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val, .. }] => Iter(Iter::singleton(val) + iter)
  _ => Unit
}

///|
let iter_concat_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter1), .. }, { val: Iter(iter2), .. }] => Iter(iter1 + iter2)
  _ => Unit
}

///|
let iter_intersperse_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val, .. }] => Iter(iter.intersperse(val))
  _ => Unit
}

// Slicing operations

///|
let iter_take_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Int(n, ..), .. }] => Iter(iter.take(n))
  _ => Unit
}

///|
let iter_drop_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Int(n, ..), .. }] => Iter(iter.drop(n))
  _ => Unit
}

///|
let iter_op_as_view_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: Iter(iter), .. },
    { val: Int(start, ..), .. },
    { val: Int(end, ..), .. },
  ] => Iter(iter.op_as_view(start~, end~))
  [{ val: Iter(iter), .. }, { val: Int(start, ..), .. }] =>
    Iter(iter.op_as_view(start~))
  [{ val: iter_val, .. }] => iter_val
  _ => Unit
}

// Simple predicates

///|
let iter_contains_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val, .. }] => Bool(iter.contains(val))
  _ => Bool(false)
}

///|
let iter_maximum_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.maximum())
  _ => Unit
}

///|
let iter_minimum_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.minimum())
  _ => Unit
}

// Identity operations

///|
let iter_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: iter_val, .. }] => iter_val
  _ => Unit
}

// String operations

///|
let iter_join_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: String(sep), .. }] => {
    let strings = iter
      .map(fn(val) {
        match val {
          String(s) => s
          _ => val.to_string()
        }
      })
      .collect()
    String(strings.join(sep))
  }
  _ => Unit
}

// Simplified stub implementations for complex functions that require closures
// These avoid the error handling complexity for now

///|
let iter_each_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    iter.each(fn(val) {
      ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) |> ignore
    })
    Unit
  }
  _ => Unit
}

///|
let iter_map_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let mapped = iter.map(val => {
      let _ = try! ctx.context.call(func.val, ctx.pkg, [
          { val, kind: Positional },
        ])
      val
    })
    Iter(mapped)
  }
  _ => Unit
}

///|
let iter_filter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let filtered = iter.filter(fn(val) {
      match
        (try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])) {
        Bool(true) => true
        _ => false
      }
    })
    Iter(filtered)
  }
  _ => Unit
}

///|
let iter_fold_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: init, .. }, { val: Fn(func), .. }] =>
    iter.fold(init~, (acc, val) => ctx.context.call(func.val, ctx.pkg, [
      { val: acc, kind: Positional },
      { val, kind: Positional },
    ]))
  _ => Unit
}

///|
let iter_all_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.all(fn(val) {
      match
        (try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])) {
        Bool(b) => b
        _ => false
      }
    })
    Bool(result)
  }
  _ => Unit
}

///|
let iter_any_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.any(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Bool(true) => true
          _ => false
        }
      } catch {
        _ => false
      }
    })
    Bool(result)
  }
  _ => Unit
}

///|
let iter_find_first_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.find_first(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Bool(b) => b
          _ => false
        }
      } catch {
        _ => false
      }
    })
    RuntimeValue::from_option(result)
  }
  _ => Unit
}

// Stub implementations for complex functions

///|
let iter_eachi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    iter.eachi(fn(index, val) {
      try {
        let _ = ctx.context.call(func.val, ctx.pkg, [
          { val: Int(index, raw=None), kind: Positional },
          { val, kind: Positional },
        ])

      } catch {
        _ => () // Ignore errors
      }
    })
    Unit
  }
  _ => Unit
}

///|
let iter_drop_while_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.drop_while(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Bool(b) => b
          _ => false
        }
      } catch {
        _ => false
      }
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_filter_map_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.filter_map(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Unit => None
          other => Some(other)
        }
      } catch {
        _ => None
      }
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_flat_map_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.flat_map(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Iter(inner_iter) => inner_iter
          Array(arr) => arr.iter()
          _ => Iter::empty()
        }
      } catch {
        _ => Iter::empty()
      }
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_flatten_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => {
    let result = iter.flat_map(fn(val) {
      match val {
        Iter(inner_iter) => inner_iter
        Array(arr) => arr.iter()
        _ => Iter::singleton(val)
      }
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_iter2_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => {
    // iter2 converts an iterator to an indexed iterator
    let result : Iter[RuntimeValue] = iter.mapi(fn(index, val) {
      Tuple([Int(index, raw=None), val])
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_just_run_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => {
    iter.each(fn(_) { () })
    Unit
  }
  _ => Unit
}

///|
let iter_map_option_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.filter_map(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Unit => None
          other => Some(other)
        }
      } catch {
        _ => None
      }
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_map_while_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = Array::new()
    let should_continue = { val: true }
    iter.each(fn(val) {
      if should_continue.val {
        try {
          match
            ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
            Unit => should_continue.val = false
            other => result.push(other)
          }
        } catch {
          _ => should_continue.val = false
        }
      }
    })
    Iter(result.iter())
  }
  _ => Unit
}

///|
let iter_mapi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.mapi((index, val) => try! ctx.context.call(
        func.val,
        ctx.pkg,
        [
          { val: Int(index, raw=None), kind: Positional },
          { val, kind: Positional },
        ],
      ))
    Iter(result)
  }
  _ => Unit
}

///|
let iter_run_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }] => {
    iter.each(fn(_) { () })
    Unit
  }
  _ => Unit
}

///|
let iter_take_while_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.take_while(fn(val) {
      try {
        match ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]) {
          Bool(b) => b
          _ => false
        }
      } catch {
        _ => false
      }
    })
    Iter(result)
  }
  _ => Unit
}

///|
let iter_tap_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
    let result = iter.tap(fn(val) {
      try {
        let _ = ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])

      } catch {
        _ => ()
      }
    })
    Iter(result)
  }
  _ => Unit
}
