///|
pub let option_methods : Map[String, RuntimeFunction] = {
  "unwrap": option_unwrap_fn,
  "map": option_map_fn,
  "map_or": option_map_or_fn,
  "map_or_else": option_map_or_else_fn,
  "bind": option_bind_fn,
  "flatten": option_flatten_fn,
  "is_empty": option_is_empty_fn,
  "filter": option_filter_fn,
  "unwrap_or": option_unwrap_or_fn,
  "unwrap_or_else": option_unwrap_or_else_fn,
  "unwrap_or_default": option_unwrap_or_default_fn,
}

// ===== Option 方法 =====

///|
/// Option unwrap 方法
let option_unwrap_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    ..,
  ] => inner_value
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }] => Unit
  _ => Unit
}

///|
/// Option map 方法
let option_map_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    { val: Closure(func, captured_env), .. },
    ..,
  ] => {
    // 执行闭包调用
    let result = ctx.context.call(
      func,
      ctx.mod,
      captured_env,
      @list.of([{ val: inner_value, kind: Positional }]),
    )
    ctx.mod.cons("Some", [result])
  }
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }, _, ..] =>
    ctx.mod.cons("None", [])
  _ => ctx.mod.cons("None", [])
}

///|
/// Option map_or 方法
let option_map_or_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    _,
    { val: Closure(func, captured_env), .. },
    ..,
  ] =>
    // 对于Some值，执行闭包调用
    ctx.context.call(
      func,
      ctx.mod,
      captured_env,
      @list.of([{ val: inner_value, kind: Positional }]),
    )
  [
    { val: Constructor({ val: { name: "None", fields: [] }, .. }), .. },
    { val: default_value, .. },
    _,
    ..,
  ] => default_value
  _ => Unit
}

///|
/// Option map_or_else 方法
let option_map_or_else_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    _,
    { val: Closure(map_func, captured_env), .. },
    ..,
  ] =>
    // 对于Some值，执行map闭包
    ctx.context.call(
      map_func,
      ctx.mod,
      captured_env,
      @list.of([{ val: inner_value, kind: Positional }]),
    )
  [
    { val: Constructor({ val: { name: "None", fields: [] }, .. }), .. },
    { val: Closure(else_func, captured_env), .. },
    _,
    ..,
  ] =>
    // 对于None值，执行else闭包
    ctx.context.call(else_func, ctx.mod, captured_env, @list.of([]))
  _ => Unit
}

///|
/// Option bind 方法
let option_bind_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    { val: Closure(func, captured_env), .. },
    ..,
  ] =>
    // 执行闭包调用，bind应该返回函数的结果（应该是Option类型）
    ctx.context.call(
      func,
      ctx.mod,
      captured_env,
      @list.of([{ val: inner_value, kind: Positional }]),
    )
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }, _, ..] =>
    ctx.mod.cons("None", [])
  _ => ctx.mod.cons("None", [])
}

///|
/// Option flatten 方法
let option_flatten_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        {
          val: {
            name: "Some",
            fields: [
              {
                value: Constructor(
                  {
                    val: { name: "Some", fields: [{ value: inner_value, .. }] },
                    ..,
                  }
                ),
                ..,
              },
            ],
          },
          ..,
        }
      ),
      ..,
    },
    ..,
  ] => ctx.mod.cons("Some", [inner_value])
  [
    {
      val: Constructor(
        {
          val: {
            name: "Some",
            fields: [
              {
                value: Constructor({ val: { name: "None", fields: [] }, .. }),
                ..,
              },
            ],
          },
          ..,
        }
      ),
      ..,
    },
    ..,
  ] => ctx.mod.cons("None", [])
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }] =>
    ctx.mod.cons("None", [])
  _ => ctx.mod.cons("None", [])
}

///|
/// Option is_empty 方法
let option_is_empty_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Constructor({ val: { name: "Some", .. }, .. }), .. }] => Bool(false)
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }] =>
    Bool(true)
  _ => Bool(true)
}

///|
/// Option filter 方法
let option_filter_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    { val: Closure(predicate, captured_env), .. },
    ..,
  ] => {
    // 执行谓词闭包
    let result = ctx.context.call(
      predicate,
      ctx.mod,
      captured_env,
      @list.of([{ val: inner_value, kind: Positional }]),
    )
    // 根据谓词结果决定是否保留值
    match result {
      Bool(true) => ctx.mod.cons("Some", [inner_value])
      _ => ctx.mod.cons("None", [])
    }
  }
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }, _, ..] =>
    ctx.mod.cons("None", [])
  _ => ctx.mod.cons("None", [])
}

///|
/// Option unwrap_or 方法
let option_unwrap_or_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    _,
    ..,
  ] => inner_value
  [
    { val: Constructor({ val: { name: "None", fields: [] }, .. }), .. },
    { val: default_value, .. },
    ..,
  ] => default_value
  _ => Unit
}

// option_unwrap_or_else_fn 已移除，现在使用支持解释器的版本

///|
/// Option unwrap_or_default 方法
let option_unwrap_or_default_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    ..,
  ] => inner_value
  [{ val: Constructor({ val: { name: "None", fields: [] }, .. }), .. }] =>
    // 返回默认值，对于数值类型返回0，其他类型返回Unit
    // 这里简化实现，实际应该根据泛型类型参数确定默认值
    Int(0)
  _ => Int(0)
}

///|
/// Option unwrap_or_else 方法
let option_unwrap_or_else_fn : RuntimeFunction = ctx => match ctx.args {
  [
    {
      val: Constructor(
        { val: { name: "Some", fields: [{ value: inner_value, .. }] }, .. }
      ),
      ..,
    },
    ..,
  ] => inner_value
  [
    { val: Constructor({ val: { name: "None", fields: [] }, .. }), .. },
    { val: Closure(else_func, captured_env), .. },
    ..,
  ] =>
    // 对于None值，执行else闭包
    ctx.context.call(else_func, ctx.mod, captured_env, @list.new())
  _ => Unit
}
