///|
pub let iter_methods : Map[String, RuntimeFunction] = {
  "all": iter_all_fn,
  "any": iter_any_fn,
  "collect": iter_collect_fn,
  "combine": iter_zip_fn,
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
  "head": iter_next_fn,
  "intersperse": iter_intersperse_fn,
  "iter": iter_iter_fn,
  "iter2": iter_iter2_fn,
  "iterator": iter_iter_fn,
  "iterator2": iter_iter2_fn,
  "join": iter_join_fn,
  "just_run": iter_just_run_fn,
  "last": iter_last_fn,
  "map": iter_map_fn,
  "map_while": iter_map_while_fn,
  "mapi": iter_mapi_fn,
  "maximum": iter_maximum_fn,
  "minimum": iter_minimum_fn,
  "new": iter_new_fn,
  "next": iter_next_fn,
  "nth": iter_nth_fn,
  "op_as_view": iter_view_fn,
  "peek": iter_next_fn,
  "repeat": iter_repeat_fn,
  "run": iter_run_fn,
  "singleton": iter_singleton_fn,
  "sub": iter_view_fn,
  "take": iter_take_fn,
  "take_while": iter_take_while_fn,
  "tap": iter_tap_fn,
  "to_array": iter_to_array_fn,
  "view": iter_view_fn,
  "zip": iter_zip_fn,
}

///|
fn runtime_option_to_value(value : RuntimeValue) -> RuntimeValue? {
  match value {
    Constructor({ val: { name: "Some", fields: [{ value, .. }] }, .. }) =>
      Some(value)
    Constructor({ val: { name: "None", fields: [] }, .. }) => None
    _ => None
  }
}

///|
fn runtime_option_to_pair(
  value : RuntimeValue,
) -> (RuntimeValue, RuntimeValue)? {
  match value {
    Constructor(
      {
        val: { name: "Some", fields: [{ value: Tuple([left, right]), .. }] },
        ..,
      }
    ) => Some((left, right))
    Constructor({ val: { name: "None", fields: [] }, .. }) => None
    _ => None
  }
}

///|
fn runtime_value_to_iter(value : RuntimeValue) -> Iter[RuntimeValue] {
  match value {
    Iter(iter) => iter
    Array(arr) => arr.iter()
    _ => Iter::empty()
  }
}

///|
fn iter_result_is_continue(value : RuntimeValue) -> Bool {
  match value {
    Constructor({ val: { name: "IterContinue", fields: [] }, .. }) => true
    _ => false
  }
}

///|
fn iter_result_is_end(value : RuntimeValue) -> Bool {
  match value {
    Constructor({ val: { name: "IterEnd", fields: [] }, .. }) => true
    _ => false
  }
}

// Basic constructor functions

///|
let iter_new_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Fn(func), .. }] => {
      let iterator = Iter::new(fn() {
        let result = ctx.context.call(func.val, ctx.pkg, []) catch {
          _ => RuntimeValue::from_option(None)
        }
        match runtime_option_to_value(result) {
          Some(value) => Some(value)
          None => None
        }
      })
      Iter(iterator)
    }
    _ => Unit
  }
}

///|
let iter_empty_fn : RuntimeFunction = _ctx => Iter(Iter::empty())

///|
let iter_singleton_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val, .. }] => Iter(Iter::singleton(val))
    _ => Unit
  }
}

///|
let iter_repeat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val, .. }] => Iter(Iter::repeat(val))
    _ => Unit
  }
}

// Collection operations

///|
let iter_collect_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => Array(iter.collect())
    _ => Unit
  }
}

///|
let iter_to_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => Array(iter.to_array())
    _ => Unit
  }
}

///|
let iter_count_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => Int(iter.count(), raw=None)
    _ => Int(0, raw=None)
  }
}

// Element access

///|
let iter_last_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.last())
    _ => Unit
  }
}

///|
let iter_next_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.next())
    _ => Unit
  }
}

///|
let iter_nth_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Int(n, ..), .. }] =>
      RuntimeValue::from_option(iter.nth(n))
    _ => Unit
  }
}

// Sequence operations

///|
let iter_concat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter1), .. }, { val: Iter(iter2), .. }] => Iter(iter1 + iter2)
    _ => Unit
  }
}

///|
let iter_zip_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter1), .. }, { val: Iter(iter2), .. }] => {
      let zipped = iter1
        .zip(iter2)
        .map(fn(pair) { RuntimeValue::Tuple([pair.0, pair.1]) })
      Iter(zipped)
    }
    _ => Unit
  }
}

///|
let iter_intersperse_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val, .. }] => Iter(iter.intersperse(val))
    _ => Unit
  }
}

// Slicing operations

///|
let iter_take_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Int(n, ..), .. }] => Iter(iter.take(n))
    _ => Unit
  }
}

///|
let iter_drop_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Int(n, ..), .. }] => Iter(iter.drop(n))
    _ => Unit
  }
}

///|
let iter_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Iter(iter), .. },
      { val: Int(start, ..), kind: LabelledOption("start") },
      { val: Int(end_, ..), kind: LabelledOption("end") },
      ..,
    ] => Iter(iter.view(start~, end=end_))
    [
      { val: Iter(iter), .. },
      { val: Int(start, ..), kind: LabelledOption("start") },
      ..,
    ] => Iter(iter.view(start~))
    [
      { val: Iter(iter), .. },
      { val: Int(end_, ..), kind: LabelledOption("end") },
      ..,
    ] => Iter(iter.view(end=end_))
    [
      { val: Iter(iter), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] => Iter(iter.view(start~, end=end_))
    [{ val: Iter(iter), .. }, { val: Int(start, ..), .. }] =>
      Iter(iter.view(start~))
    [{ val: Iter(iter), .. }] => Iter(iter.view())
    _ => Unit
  }
}

// Simple predicates

///|
let iter_contains_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val, .. }] => Bool(iter.contains(val))
    _ => Bool(false)
  }
}

///|
let iter_maximum_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.maximum())
    _ => Unit
  }
}

///|
let iter_minimum_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => RuntimeValue::from_option(iter.minimum())
    _ => Unit
  }
}

// Identity operations

///|
let iter_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: iter_val, .. }] => iter_val
    _ => Unit
  }
}

// String operations

///|
let iter_join_fn : RuntimeFunction = ctx => {
  match ctx.args {
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
}

// Higher-order operations

///|
let iter_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      iter.each(val => {
        let _ = try! ctx.context.call(func.val, ctx.pkg, [
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let iter_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let mapped = iter.map(val => {
        try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])
      })
      Iter(mapped)
    }
    _ => Unit
  }
}

///|
let iter_filter_fn : RuntimeFunction = ctx => {
  match ctx.args {
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
}

///|
let iter_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: init, .. }, { val: Fn(func), .. }] =>
      iter.fold(init~, (acc, val) => {
        try! ctx.context.call(func.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let iter_all_fn : RuntimeFunction = ctx => {
  match ctx.args {
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
}

///|
let iter_any_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.any(fn(val) {
        match
          (try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])) {
          Bool(true) => true
          _ => false
        }
      })
      Bool(result)
    }
    _ => Unit
  }
}

///|
let iter_find_first_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.find_first(fn(val) {
        match
          (try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])) {
          Bool(b) => b
          _ => false
        }
      })
      RuntimeValue::from_option(result)
    }
    _ => Unit
  }
}

///|
let iter_eachi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      iter.eachi(fn(index, val) {
        let _ = try! ctx.context.call(func.val, ctx.pkg, [
          { val: Int(index, raw=None), kind: Positional },
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let iter_drop_while_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.drop_while(fn(val) {
        match
          (try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])) {
          Bool(b) => b
          _ => false
        }
      })
      Iter(result)
    }
    _ => Unit
  }
}

///|
let iter_filter_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.filter_map(fn(val) {
        match
          runtime_option_to_value(
            try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]),
          ) {
          Some(v) => Some(v)
          None => None
        }
      })
      Iter(result)
    }
    _ => Unit
  }
}

///|
let iter_flat_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.flat_map(fn(val) {
        runtime_value_to_iter(
          try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]),
        )
      })
      Iter(result)
    }
    _ => Unit
  }
}

///|
let iter_flatten_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] =>
      Iter(iter.flat_map(val => runtime_value_to_iter(val)))
    _ => Unit
  }
}

///|
let iter_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => {
      let mut index = 0
      let iterator = Iter2::new(fn() {
        match iter.next() {
          Some(value) => {
            let key = Int(index, raw=None)
            index += 1
            Some((key, value))
          }
          None => None
        }
      })
      Iter2(iterator.iter2())
    }
    _ => Unit
  }
}

///|
let iter_just_run_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      while iter.next() is Some(x) {
        if iter_result_is_end(
            try! ctx.context.call(func.val, ctx.pkg, [
              { val: x, kind: Positional },
            ]),
          ) {
          break
        }
      }
      Unit
    }
    _ => Unit
  }
}

///|
let iter_map_while_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.map_while(fn(val) {
        match
          runtime_option_to_value(
            try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }]),
          ) {
          Some(v) => Some(v)
          None => None
        }
      })
      Iter(result)
    }
    _ => Unit
  }
}

///|
let iter_mapi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.mapi((index, val) => {
        try! ctx.context.call(func.val, ctx.pkg, [
          { val: Int(index, raw=None), kind: Positional },
          { val, kind: Positional },
        ])
      })
      Iter(result)
    }
    _ => Unit
  }
}

///|
let iter_run_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] =>
      while iter.next() is Some(x) {
        guard iter_result_is_continue(
          try! ctx.context.call(func.val, ctx.pkg, [
            { val: x, kind: Positional },
          ]),
        ) else {
          break ctx.pkg.cons("IterEnd", [])
        }
      } nobreak {
        ctx.pkg.cons("IterContinue", [])
      }
    _ => Unit
  }
}

///|
let iter_take_while_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.take_while(fn(val) {
        match
          (try! ctx.context.call(func.val, ctx.pkg, [{ val, kind: Positional }])) {
          Bool(b) => b
          _ => false
        }
      })
      Iter(result)
    }
    _ => Unit
  }
}

///|
let iter_tap_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }, { val: Fn(func), .. }] => {
      let result = iter.tap(fn(val) {
        let _ = try! ctx.context.call(func.val, ctx.pkg, [
          { val, kind: Positional },
        ])
      })
      Iter(result)
    }
    _ => Unit
  }
}
