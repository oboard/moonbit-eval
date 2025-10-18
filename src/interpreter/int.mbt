///|
pub let int_methods : Map[String, RuntimeFunction] = {
  "lnot": int_lnot_fn,
  "land": int_land_fn,
  "lor": int_lor_fn,
  "lxor": int_lxor_fn,
  "shl": int_shl_fn,
  "shr": int_shr_fn,
  "compare": int_compare_fn,
  "is_pos": int_is_pos_fn,
  "is_neg": int_is_neg_fn,
  "ctz": int_ctz_fn,
  "clz": int_clz_fn,
  "popcnt": int_popcnt_fn,
  "to_string": int_to_string_fn,
  "unsafe_to_char": char_from_int_fn,
  "next_power_of_two": int_next_power_of_two_fn,
}

///|
pub let int_embedded_code : Map[String, RuntimeFunction] = {
  "%i32_lnot": int_lnot_fn,
  "%i32_land": int_land_fn,
  "%i32_lor": int_lor_fn,
  "%i32_lxor": int_lxor_fn,
  "%i32_shl": int_shl_fn,
  "%i32_shr": int_shr_fn,
  "%i32_eq": int_eq_fn,
  "%i32_compare": int_compare_fn,
  "%i32_is_pos": int_is_pos_fn,
  "%i32_is_neg": int_is_neg_fn,
  "%i32_ctz": int_ctz_fn,
  "%i32_clz": int_clz_fn,
  "%i32_popcnt": int_popcnt_fn,
}

// ===== 整数位运算 =====

///|
/// 整数按位取反
let int_lnot_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(i.lnot())
  _ => Unit
}

///|
/// 整数按位与
let int_land_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a & b)
  _ => Unit
}

///|
/// 整数按位或
let int_lor_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a | b)
  _ => Unit
}

///|
/// 整数按位异或
let int_lxor_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a ^ b)
  _ => Unit
}

///|
/// 整数左移
let int_shl_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a << b)
  _ => Unit
}

///|
/// 整数右移
let int_shr_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a >> b)
  _ => Unit
}

// ===== 整数比较运算 =====

///|
/// 整数相等比较
let int_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Bool(a == b)
  _ => Bool(false)
}

///|
/// 整数比较
let int_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] =>
    if a == b {
      Int(0)
    } else if a > b {
      Int(1)
    } else {
      Int(-1)
    }
  _ => Int(0)
}

///|
/// 整数是否为正
let int_is_pos_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Bool(i > 0)
  _ => Bool(false)
}

///|
/// 整数是否为负
let int_is_neg_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Bool(i < 0)
  _ => Bool(false)
}

// ===== 整数工具函数 =====

///|
/// 计算尾随零的个数
let int_ctz_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(i.ctz())
  _ => Unit
}

///|
/// 计算前导零的个数
let int_clz_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(i.clz())
  _ => Unit
}

///|
/// 计算设置位的个数
let int_popcnt_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(i.popcnt())
  _ => Unit
}

///|
/// 整数转字符串
let int_to_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => String(i.to_string())
  _ => Unit
}

///|
/// 计算不小于该整数的最小2的幂
let int_next_power_of_two_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(i.next_power_of_two())
  _ => Unit
}
