///|
/// Iter2 内置方法映射
pub let iter2_methods : Map[String, RuntimeFunction] = {
  // "new": iter2_new_fn,
  "run": iter2_run_fn,
  "each": iter2_each_fn,
  "iter": iter2_iter_fn,
  "iter2": iter2_iter2_fn,
  "to_array": iter2_to_array_fn,
  "concat": iter2_concat_fn,
}

// Basic constructor functions

// ///|
// let iter2_new_fn : RuntimeFunction = ctx => match ctx.args {
//   [{ val, .. }] => Iter2(Iter2::new(f => f(val, val)))
//   _ => Unit
// }

///|
let iter2_run_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter2(iter2), .. }, { val: Fn(func, env), .. }] => {
    let result = iter2.run(fn(a, b) {
      let runtime_args = @list.of([
        { val: a, kind: Positional },
        { val: b, kind: Positional },
      ])
      try {
        match ctx.context.call(func, ctx.pkg, env, runtime_args) {
          Unit => IterEnd
          _ => IterContinue
        }
      } catch {
        _ => IterEnd
      }
    })
    match result {
      IterEnd => Unit
      IterContinue => Unit
    }
  }
  _ => Unit
}

///|
let iter2_each_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter2(iter2), .. }, { val: Fn(func, env), .. }] => {
    iter2.each(fn(a, b) {
      let runtime_args = @list.of([
        { val: a, kind: Positional },
        { val: b, kind: Positional },
      ])
      try ctx.context.call(func, ctx.pkg, env, runtime_args) |> ignore catch {
        _ => ()
      }
    })
    Unit
  }
  _ => Unit
}

///|
let iter2_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter2(iter2), .. }] => {
    // 将 Iter2 转换为 Iter，每个元素是一个包含两个值的元组
    let iter_impl : Iter[RuntimeValue] = iter2
      .iter()
      .map(fn(pair) { Tuple([pair.0, pair.1]) })
    Iter(iter_impl)
  }
  _ => Unit
}

///|
let iter2_iter2_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: iter2_val, .. }] => iter2_val // 返回自身
  _ => Unit
}

///|
let iter2_to_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter2(iter2), .. }] => {
    let result : Array[RuntimeValue] = iter2
      .to_array()
      .map(fn(pair) { Tuple([pair.0, pair.1]) })
    Array(result)
  }
  _ => Unit
}

///|
let iter2_concat_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Iter2(iter2_1), .. }, { val: Iter2(iter2_2), .. }] => {
    let concatenated = iter2_1.concat(iter2_2)
    Iter2(concatenated)
  }
  _ => Unit
}
