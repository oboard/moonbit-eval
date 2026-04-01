///|
/// Iter2 内置方法映射
pub let iter2_methods : Map[String, RuntimeFunction] = {
  "concat": iter2_concat_fn,
  "each": iter2_each_fn,
  "iter": iter2_iter_fn,
  "iter2": iter2_iter2_fn,
  "iterator": iter2_iter_fn,
  "iterator2": iter2_iter2_fn,
  "new": iter2_new_fn,
  "next": iter2_next_fn,
  "output": iter2_output_fn,
  "run": iter2_run_fn,
  "to_array": iter2_to_array_fn,
}

///|
let iter2_new_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Fn(func), .. }] => {
      let iterator = Iter2::new(fn() {
        let result = ctx.context.call(func.val, ctx.pkg, []) catch {
          _ => RuntimeValue::from_option(None)
        }
        match runtime_option_to_pair(result) {
          Some(pair) => Some(pair)
          None => None
        }
      })
      Iter2(iterator.iter2())
    }
    _ => Unit
  }
}

///|
let iter2_next_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2), .. }] =>
      RuntimeValue::from_option(
        iter2.next().map(fn(pair) { RuntimeValue::Tuple([pair.0, pair.1]) }),
      )
    _ => Unit
  }
}

///|
let iter2_run_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2), .. }, { val: Fn(func), .. }] =>
      while iter2.next() is Some((a, b)) {
        guard iter_result_is_continue(
          try! ctx.context.call(func.val, ctx.pkg, [
            { val: a, kind: Positional },
            { val: b, kind: Positional },
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
let iter2_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2), .. }, { val: Fn(func), .. }] => {
      iter2.each(fn(a, b) {
        let _ = try! ctx.context.call(func.val, ctx.pkg, [
          { val: a, kind: Positional },
          { val: b, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let iter2_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2), .. }] => {
      let iter_impl : Iter[RuntimeValue] = iter2
        .iter()
        .map(fn(pair) { RuntimeValue::Tuple([pair.0, pair.1]) })
      Iter(iter_impl)
    }
    _ => Unit
  }
}

///|
let iter2_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: iter2_val, .. }] => iter2_val
    _ => Unit
  }
}

///|
let iter2_to_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2), .. }] => {
      let result : Array[RuntimeValue] = iter2
        .to_array()
        .map(fn(pair) { RuntimeValue::Tuple([pair.0, pair.1]) })
      Array(result)
    }
    _ => Unit
  }
}

///|
let iter2_concat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2_1), .. }, { val: Iter2(iter2_2), .. }] => {
      let concatenated = iter2_1.concat(iter2_2)
      Iter2(concatenated)
    }
    _ => Unit
  }
}

///|
let iter2_output_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter2(iter2), .. }, { val: StringBuilder(logger), .. }] => {
      iter2.output(logger)
      Unit
    }
    _ => Unit
  }
}
