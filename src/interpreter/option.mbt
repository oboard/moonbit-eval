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

///| Option unwrap 方法
let option_unwrap_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Constructor("Some", [inner_value]), .. }, ..] => inner_value
  [{ value: Constructor("None", []), .. }, ..] => Unit
  _ => Unit
}

///| Option map 方法
let option_map_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Constructor("Some", [inner_value]), .. },
    { value: Closure(func, captured_env), .. },
    ..,
  ] => {
    // 执行闭包调用
    let result = ctx.context.call_closure(
      func,
      captured_env,
      @list.construct(
        @syntax.Argument::{ value: inner_value.to_expr(), kind: Positional },
        @list.new(),
      ),
    )
    Constructor("Some", [result])
  }
  [{ value: Constructor("None", []), .. }, _, ..] => Constructor("None", [])
  _ => Constructor("None", [])
}

///| Option map_or 方法
let option_map_or_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Constructor("Some", [inner_value]), .. },
    _,
    { value: Closure(func, captured_env), .. },
    ..,
  ] =>
    // 对于Some值，执行闭包调用
    ctx.context.call_closure(
      func,
      captured_env,
      @list.construct(
        @syntax.Argument::{ value: inner_value.to_expr(), kind: Positional },
        @list.new(),
      ),
    )
  [{ value: Constructor("None", []), .. }, { value: default_value, .. }, _, ..] =>
    default_value
  _ => Unit
}

///| Option map_or_else 方法
let option_map_or_else_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Constructor("Some", [inner_value]), .. },
    _,
    { value: Closure(map_func, captured_env), .. },
    ..,
  ] =>
    // 对于Some值，执行map闭包
    ctx.context.call_closure(
      map_func,
      captured_env,
      @list.construct(
        @syntax.Argument::{ value: inner_value.to_expr(), kind: Positional },
        @list.new(),
      ),
    )
  [
    { value: Constructor("None", []), .. },
    { value: Closure(else_func, captured_env), .. },
    _,
    ..,
  ] =>
    // 对于None值，执行else闭包
    ctx.context.call_closure(else_func, captured_env, @list.new())
  _ => Unit
}

///| Option bind 方法
let option_bind_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Constructor("Some", [inner_value]), .. },
    { value: Closure(func, captured_env), .. },
    ..,
  ] =>
    // 执行闭包调用，bind应该返回函数的结果（应该是Option类型）
    ctx.context.call_closure(
      func,
      captured_env,
      @list.construct(
        @syntax.Argument::{ value: inner_value.to_expr(), kind: Positional },
        @list.new(),
      ),
    )
  [{ value: Constructor("None", []), .. }, _, ..] => Constructor("None", [])
  _ => Constructor("None", [])
}

///| Option flatten 方法
let option_flatten_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Constructor("Some", [Constructor("Some", [inner_value])]), .. }, ..] =>
    Constructor("Some", [inner_value])
  [{ value: Constructor("Some", [Constructor("None", [])]), .. }, ..] =>
    Constructor("None", [])
  [{ value: Constructor("None", []), .. }, ..] => Constructor("None", [])
  _ => Constructor("None", [])
}

///| Option is_empty 方法
let option_is_empty_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Constructor("Some", _), .. }, ..] => Bool(false)
  [{ value: Constructor("None", []), .. }, ..] => Bool(true)
  _ => Bool(true)
}

///| Option filter 方法
let option_filter_fn : RuntimeFunction = ctx => match ctx.arguments {
  [
    { value: Constructor("Some", [inner_value]), .. },
    { value: Closure(predicate, captured_env), .. },
    ..,
  ] => {
    // 执行谓词闭包
    let result = ctx.context.call_closure(
      predicate,
      captured_env,
      @list.construct(
        @syntax.Argument::{ value: inner_value.to_expr(), kind: Positional },
        @list.new(),
      ),
    )
    // 根据谓词结果决定是否保留值
    match result {
      Bool(true) => Constructor("Some", [inner_value])
      _ => Constructor("None", [])
    }
  }
  [{ value: Constructor("None", []), .. }, _, ..] => Constructor("None", [])
  _ => Constructor("None", [])
}

///| Option unwrap_or 方法
let option_unwrap_or_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Constructor("Some", [inner_value]), .. }, _, ..] => inner_value
  [{ value: Constructor("None", []), .. }, { value: default_value, .. }, ..] =>
    default_value
  _ => Unit
}

// option_unwrap_or_else_fn 已移除，现在使用支持解释器的版本

///| Option unwrap_or_default 方法
let option_unwrap_or_default_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Constructor("Some", [inner_value]), .. }, ..] => inner_value
  [{ value: Constructor("None", []), .. }, ..] =>
    // 返回默认值，对于数值类型返回0，其他类型返回Unit
    // 这里简化实现，实际应该根据泛型类型参数确定默认值
    Int(0)
  _ => Int(0)
}

///| Option unwrap_or_else 方法
let option_unwrap_or_else_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ value: Constructor("Some", [inner_value]), .. }, ..] => inner_value
  [
    { value: Constructor("None", []), .. },
    { value: Closure(else_func, captured_env), .. },
    ..,
  ] =>
    // 对于None值，执行else闭包
    ctx.context.call_closure(else_func, captured_env, @list.new())
  _ => Unit
}
