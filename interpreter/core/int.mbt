///|
pub let int_methods : Map[String, RuntimeFunction] = {
  "lnot": int_lnot_fn,
  "land": int_land_fn,
  "lor": int_lor_fn,
  "lxor": int_lxor_fn,
  "shl": int_shl_fn,
  "lsl": int_shl_fn,
  "shr": int_shr_fn,
  "asr": int_shr_fn,
  "lsr": int_lsr_fn,
  "compare": int_compare_fn,
  "min": int_min_fn,
  "max": int_max_fn,
  "clamp": int_clamp_fn,
  "is_pos": int_is_pos_fn,
  "is_neg": int_is_neg_fn,
  "is_non_pos": int_is_non_pos_fn,
  "is_non_neg": int_is_non_neg_fn,
  "is_leading_surrogate": int_is_leading_surrogate_fn,
  "is_trailing_surrogate": int_is_trailing_surrogate_fn,
  "is_surrogate": int_is_surrogate_fn,
  "ctz": int_ctz_fn,
  "clz": int_clz_fn,
  "popcnt": int_popcnt_fn,
  "to_string": int_to_string_fn,
  "reinterpret_as_uint": int_reinterpret_as_uint_fn,
  "to_uint": int_reinterpret_as_uint_fn,
  "to_uint64": int_to_uint64_fn,
  "to_double": int_to_double_fn,
  "to_float": int_to_float_fn,
  "reinterpret_as_float": int_reinterpret_as_float_fn,
  "to_byte": int_to_byte_fn,
  "unsafe_to_char": char_from_int_fn,
  "to_char": int_to_char_fn,
  "to_int16": int_to_int16_fn,
  "to_uint16": int_to_uint16_fn,
  "until": int_until_fn,
  "to_be_bytes": int_to_be_bytes_fn,
  "to_le_bytes": int_to_le_bytes_fn,
  "next_power_of_two": int_next_power_of_two_fn,
  "abs": int_abs_fn,
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
  "%i32_is_non_pos": int_is_non_pos_fn,
  "%i32_is_non_neg": int_is_non_neg_fn,
  "%i32.to_u32_reinterpret": int_reinterpret_as_uint_fn,
  "%i32_to_u32_reinterpret": int_reinterpret_as_uint_fn,
  "%i32.to_f32_reinterpret": int_reinterpret_as_float_fn,
  "%i32_to_f32_reinterpret": int_reinterpret_as_float_fn,
  "%i32_ctz": int_ctz_fn,
  "%i32_clz": int_clz_fn,
  "%i32_popcnt": int_popcnt_fn,
}

// ===== 整数位运算 =====

///|
/// 整数按位取反
let int_lnot_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i.lnot(), raw=None)
    _ => Unit
  }
}

///|
/// 整数按位与
let int_land_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Int(a & b, raw=None)
    _ => Unit
  }
}

///|
/// 整数按位或
let int_lor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Int(a | b, raw=None)
    _ => Unit
  }
}

///|
/// 整数按位异或
let int_lxor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Int(a ^ b, raw=None)
    _ => Unit
  }
}

///|
/// 整数左移
let int_shl_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Int(a << b, raw=None)
    _ => Unit
  }
}

///|
/// 整数右移
let int_shr_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Int(a >> b, raw=None)
    _ => Unit
  }
}

///|
/// 整数逻辑右移
let int_lsr_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] =>
      Int((a.reinterpret_as_uint() >> b).reinterpret_as_int(), raw=None)
    _ => Unit
  }
}

// ===== 整数比较运算 =====

///|
/// 整数相等比较
let int_eq_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Bool(a == b)
    _ => Bool(false)
  }
}

///|
/// 整数比较
let int_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] =>
      if a == b {
        Int(0, raw=None)
      } else if a > b {
        Int(1, raw=None)
      } else {
        Int(-1, raw=None)
      }
    _ => Int(0, raw=None)
  }
}

///|
/// 整数最小值
let int_min_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] =>
      if a < b {
        Int(a, raw=None)
      } else {
        Int(b, raw=None)
      }
    _ => Unit
  }
}

///|
/// 整数最大值
let int_max_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] =>
      if a > b {
        Int(a, raw=None)
      } else {
        Int(b, raw=None)
      }
    _ => Unit
  }
}

///|
/// 整数区间裁剪
let int_clamp_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Int(self, ..), .. },
      { val: Int(min, ..), .. },
      { val: Int(max, ..), .. },
    ] =>
      if min > max {
        Unit
      } else if self < min {
        Int(min, raw=None)
      } else if self > max {
        Int(max, raw=None)
      } else {
        Int(self, raw=None)
      }
    _ => Unit
  }
}

///|
/// 整数是否为正
let int_is_pos_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(i > 0)
    _ => Bool(false)
  }
}

///|
/// 整数是否为负
let int_is_neg_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(i < 0)
    _ => Bool(false)
  }
}

///|
/// 整数是否非正
let int_is_non_pos_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(i <= 0)
    _ => Bool(false)
  }
}

///|
/// 整数是否非负
let int_is_non_neg_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(i >= 0)
    _ => Bool(false)
  }
}

///|
/// UTF-16 leading surrogate 判断
let int_is_leading_surrogate_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(0xD800 <= i && i <= 0xDBFF)
    _ => Bool(false)
  }
}

///|
/// UTF-16 trailing surrogate 判断
let int_is_trailing_surrogate_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(0xDC00 <= i && i <= 0xDFFF)
    _ => Bool(false)
  }
}

///|
/// UTF-16 surrogate 判断
let int_is_surrogate_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Bool(0xD800 <= i && i <= 0xDFFF)
    _ => Bool(false)
  }
}

// ===== 整数工具函数 =====

///|
/// 计算尾随零的个数
let int_ctz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i.ctz(), raw=None)
    _ => Unit
  }
}

///|
/// 计算前导零的个数
let int_clz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i.clz(), raw=None)
    _ => Unit
  }
}

///|
/// 计算设置位的个数
let int_popcnt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i.popcnt(), raw=None)
    _ => Unit
  }
}

///|
/// 整数转字符串
let int_to_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => String(i.to_string())
    _ => Unit
  }
}

///|
/// Int 重新解释为 UInt
let int_reinterpret_as_uint_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => UInt(i.reinterpret_as_uint())
    _ => Unit
  }
}

///|
/// Int 转 UInt64
let int_to_uint64_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => UInt64(i.to_int64().reinterpret_as_uint64())
    _ => Unit
  }
}

///|
/// Int 转 Double
let int_to_double_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Double(i.to_double())
    _ => Unit
  }
}

///|
/// Int 转 Float
let int_to_float_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Float(Float::from_int(i))
    _ => Unit
  }
}

///|
/// Int 按位重解释为 Float
let int_reinterpret_as_float_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Float(Float::reinterpret_from_int(i))
    _ => Unit
  }
}

///|
/// Int 转 Byte
let int_to_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Byte(i.to_byte())
    _ => Unit
  }
}

///|
/// Int 安全转 Char
let int_to_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(
        if (0x0 <= i && i <= 0xD7FF) || (0xE000 <= i && i <= 0x10FFFF) {
          Some(Char(i.unsafe_to_char()))
        } else {
          None
        },
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
/// Int 转 Int16（解释器里沿用现有 Int 截断表示）
let int_to_int16_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i & 0xFFFF, raw=None)
    _ => Unit
  }
}

///|
/// Int 转 UInt16
let int_to_uint16_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => UInt16(i.to_uint16())
    _ => Unit
  }
}

///|
/// Int 转大端字节序 Bytes
let int_to_be_bytes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => {
      let self = i.reinterpret_as_uint()
      Bytes(
        Bytes::from_array([
          (self >> 24).to_byte(),
          (self >> 16).to_byte(),
          (self >> 8).to_byte(),
          self.to_byte(),
        ]),
      )
    }
    _ => Unit
  }
}

///|
/// Int 转小端字节序 Bytes
let int_to_le_bytes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => {
      let self = i.reinterpret_as_uint()
      Bytes(
        Bytes::from_array([
          self.to_byte(),
          (self >> 8).to_byte(),
          (self >> 16).to_byte(),
          (self >> 24).to_byte(),
        ]),
      )
    }
    _ => Unit
  }
}

///|
/// Int 生成区间迭代器
let int_until_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(start, ..), .. }, { val: Int(end, ..), .. }, ..] => {
      let step = match ctx.named("step") {
        Some(Int(i, ..)) => i
        _ => 1
      }
      let inclusive = match ctx.named("inclusive") {
        Some(Bool(b)) => b
        _ => false
      }
      if step == 0 {
        Iter(Iter::empty())
      } else {
        let mut current = start
        let mut done = false
        Iter(
          Iter::new(fn() {
            guard !done else { None }
            guard (step > 0 && current < end) ||
              (step < 0 && current > end) ||
              (inclusive && current == end) else {
              None
            }
            let value = current
            let next = current + step
            if (step > 0 && next >= current) || (step < 0 && next <= current) {
              current = next
            } else {
              done = true
            }
            Some(Int(value, raw=None))
          }),
        )
      }
    }
    _ => Unit
  }
}

///|
/// 计算不小于该整数的最小2的幂
let int_next_power_of_two_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i.next_power_of_two(), raw=None)
    _ => Unit
  }
}

///|
let int_abs_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i.abs(), raw=None)
    _ => Unit
  }
}
