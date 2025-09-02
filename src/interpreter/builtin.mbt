///|
let core_stubs : Map[String, String] = {
  "not": "%bool_not",
  "ignore": "%ignore",
  "println_mono": "%println",
  "println": "%println_mono",
  "typeof": "%typeof",
  "panic": "%panic",
  "abort": "%abort",
}

///|
let builtin_embedded_code : Map[String, RuntimeFunction] = {
  "%abort": abort_fn,
  "%panic": panic_fn,
  "%typeof": typeof_fn,
  "%println_mono": println_mono_fn,
  "%ignore": ignore_fn,
  "%refeq": physical_equal_fn,
  "%panic": panic_fn,
  "%bool_not": bool_not_fn,
  // Bool 类型函数
  "%bool_eq": bool_eq_fn,
  "%bool_compare": bool_compare_fn,
  "%bool_default": bool_default_fn,
  // Int 类型函数
  "%i32_neg": int_neg_fn,
  "%i32_add": int_add_fn,
  "%i32_sub": int_sub_fn,
  "%i32_mul": int_mul_fn,
  "%i32_div": int_div_fn,
  "%i32_mod": int_mod_fn,
  // UInt 类型函数
  "%u32.add": uint_add_fn,
  "%u32.sub": uint_sub_fn,
  "%u32.mul": uint_mul_fn,
  "%u32.div": uint_div_fn,
  "%u32.mod": uint_mod_fn,
  "%u32.eq": uint_eq_fn,
  "%u32.compare": uint_compare_fn,
  "%u32.to_i32_reinterpret": uint_to_int_fn,
  "%u32.to_f64": uint_to_double_fn,
  // Float 类型函数
  "%f32.add": float_add_fn,
  "%f32.sub": float_sub_fn,
  "%f32.mul": float_mul_fn,
  "%f32.div": float_div_fn,
  "%f32.eq": float_eq_fn,
  "%f32.compare": float_compare_fn,
  "%f32.to_f64": float_to_double_fn,
  // Double 类型函数
  "%f64_add": double_add_fn,
  "%f64_sub": double_sub_fn,
  "%f64_mul": double_mul_fn,
  "%f64_div": double_div_fn,
  "%f64_eq": double_eq_fn,
  "%f64_compare": double_compare_fn,
  "%f64_to_i64_saturate": double_to_int64_fn,
  // Char 类型函数
  "%char_eq": char_eq_fn,
  "%char_compare": char_compare_fn,
  "%char_to_int": char_to_int_fn,
  "%char_from_int": char_from_int_fn,
  // Byte 类型函数
  "%byte_eq": byte_eq_fn,
  "%byte_compare": byte_compare_fn,
  "%byte_to_int": byte_to_int_fn,
  "%byte_to_uint": byte_to_uint_fn,
  // Int64 类型函数
  "%i64_add": int64_add_fn,
  "%i64_sub": int64_sub_fn,
  "%i64_mul": int64_mul_fn,
  "%i64_div": int64_div_fn,
  "%i64_mod": int64_mod_fn,
  "%i64_eq": int64_eq_fn,
  "%i64_compare": int64_compare_fn,
  "%i64_to_i32": int64_to_int_fn,
  "%i64_to_f64": int64_to_double_fn,
  // UInt64 类型函数
  "%u64.add": uint64_add_fn,
  "%u64.sub": uint64_sub_fn,
  "%u64.mul": uint64_mul_fn,
  "%u64.div": uint64_div_fn,
  "%u64.mod": uint64_mod_fn,
  "%u64.eq": uint64_eq_fn,
  "%u64.compare": uint64_compare_fn,
  "%u64.to_u32": uint64_to_uint_fn,
  "%u64.to_i64_reinterpret": uint64_to_int64_fn,
  // 类型转换函数
  "%i32_to_f64": to_double_fn,
  "%i32.to_f32": to_float_fn,
  "%i32_to_byte": to_byte_fn,
  "%i32_to_i16": to_int16_fn,
  "%i32_to_u16": to_uint16_fn,
  "%i32_to_i64": to_int64_fn,
  "%u32.to_u64": to_uint64_fn,
  // ArrayView
  // ArrayView functions
  "%arrayview.buf": array_view_buf_fn,
  "%arrayview.start": array_view_start_fn,
  "%arrayview.len": array_view_len_fn,
}

///|
let core_embedded_code : Map[String, RuntimeFunction] = [
  builtin_embedded_code, string_embedded_code, int_embedded_code,
].fold(init=Map::new(), (acc, cur) => {
  cur.each(fn(key, value) { acc.set(key, value) })
  acc
})

///|
let core_embedded_methods : Map[String, Map[String, RuntimeFunction]] = {
  "Bool": { "compare": bool_compare_fn, "default": bool_default_fn },
  "Int": int_methods,
  "String": string_methods,
  "UInt": {
    "mod": uint_mod_fn,
    "compare": uint_compare_fn,
    "to_i32_reinterpret": uint_to_int_fn,
    "to_f64": uint_to_double_fn,
  },
  "Float": { "compare": float_compare_fn, "to_f64": float_to_double_fn },
  "Double": {
    "compare": double_compare_fn,
    "to_i64_saturate": double_to_int64_fn,
    "to_int64": double_to_int64_fn,
  },
  "Char": {
    "compare": char_compare_fn,
    "to_int": char_to_int_fn,
    "to_string": char_to_string_fn,
  },
  "Byte": {
    "compare": byte_compare_fn,
    "to_int": byte_to_int_fn,
    "to_uint": byte_to_uint_fn,
  },
  "Int64": {
    "compare": int64_compare_fn,
    "to_i32": int64_to_int_fn,
    "to_f64": int64_to_double_fn,
  },
  "UInt64": {
    "compare": uint64_compare_fn,
    "to_u32": uint64_to_uint_fn,
    "to_i64_reinterpret": uint64_to_int64_fn,
  },
  "Array": array_methods,
  "FixedArray": fixedarray_methods,
  "ArrayView": array_view_methods,
  "Option": option_methods,
  "Map": map_methods,
  "Iter": iter_methods,
  "Iter2": iter2_methods,
  "StringBuilder": stringbuilder_methods,
}

///|
let typeof_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: value, .. }] => String(value.get_type().to_string())
  _ => Unit
}

///|
let println_mono_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: value, .. }] => {
    println(value)
    Unit
  }
  _ => Unit
}

// ===== 整数算术运算 =====

///|
/// 整数取负
let int_neg_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(-i)
  _ => Unit
}

///|
/// 整数加法
let int_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a + b)
  _ => Unit
}

///|
/// 整数减法
let int_sub_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a - b)
  _ => Unit
}

///|
/// 整数乘法
let int_mul_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] => Int(a * b)
  _ => Unit
}

///|
/// 整数除法
let int_div_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] =>
    if b != 0 {
      Int(a / b)
    } else {
      abort("division by zero")
      Unit
    }
  _ => Unit
}

///|
/// 整数取模
let int_mod_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(a), .. }, { val: Int(b), .. }] =>
    if b != 0 {
      Int(a % b)
    } else {
      abort("modulo by zero")
      Unit
    }
  _ => Unit
}

// ===== 基础函数 =====

///|
/// ignore 函数 - 忽略任何值并返回 Unit
let ignore_fn : RuntimeFunction = _ctx => Unit

///|
/// physical_equal 函数 - 检查两个值是否物理相等
let physical_equal_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: a, .. }, { val: b, .. }] => Bool(physical_equal(a, b))
  _ => Bool(false)
}

///|
/// panic 函数 - 触发 panic
let panic_fn : RuntimeFunction = _ctx => {
  error("panic")
  Unit
}

///|
/// abort 函数 - 触发 abort
let abort_fn : RuntimeFunction = ctx => {
  if ctx.args is [{ val: String(msg), .. }] {
    error("abort: \{msg}")
  }
  Unit
}

// ===== 布尔运算 =====

///|
/// 布尔 NOT 运算
let bool_not_fn : RuntimeFunction = ctx => if ctx.args is [{ val: Bool(b), .. }] {
  Bool(not(b))
} else {
  Unit
}

///|
/// 布尔相等比较
let bool_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Bool(a), .. }, { val: Bool(b), .. }] => Bool(a == b)
  _ => Bool(false)
}

///|
/// 布尔比较
let bool_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Bool(a), .. }, { val: Bool(b), .. }] =>
    if a == b {
      Int(0)
    } else if a {
      Int(1) // true > false
    } else {
      Int(-1) // false < true
    }
  _ => Int(0)
}

///|
/// 布尔默认值
let bool_default_fn : RuntimeFunction = _ctx => Bool(false)

// ===== 类型转换函数 =====

///|
/// 转换为 Double
let to_double_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Double(i.to_double())
  [{ val: Float(f), .. }] => Double(f.to_double())
  [{ val: Double(d), .. }] => Double(d)
  [{ val: UInt(u), .. }] => Double(u.to_double())
  [{ val: Int64(i64), .. }] => Double(i64.to_double())
  [{ val: UInt64(u64), .. }] => Double(u64.to_double())
  _ => Unit
}

///|
/// 转换为 Float
let to_float_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Float(i.to_float())
  [{ val: Float(f), .. }] => Float(f)
  [{ val: Double(d), .. }] => Float(d.to_float())
  [{ val: UInt(u), .. }] => Float(u.to_float())
  _ => Unit
}

///|
/// 转换为 Byte
let to_byte_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Byte(i.to_byte())
  [{ val: UInt(u), .. }] => Byte(u.to_byte())
  [{ val: Byte(b), .. }] => Byte(b)
  _ => Unit
}

///|
/// 转换为 Int16 (使用 Int 表示)
let to_int16_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int(i & 0xFFFF)
  [{ val: UInt(u), .. }] => Int(u.reinterpret_as_int() & 0xFFFF)
  _ => Unit
}

///|
/// 转换为 UInt16 
let to_uint16_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => UInt16(i.to_uint16())
  _ => Unit
}

///|
/// 转换为 Int64
let to_int64_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Int64(i.to_int64())
  [{ val: UInt(u), .. }] => Int64(u.to_int64())
  [{ val: Int64(i64), .. }] => Int64(i64)
  [{ val: UInt64(u64), .. }] => Int64(u64.reinterpret_as_int64())
  [{ val: Double(d), .. }] => Int64(d.to_int64())
  _ => Unit
}

///|
/// 转换为 UInt64
let to_uint64_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => UInt64(i.to_uint64())
  [{ val: UInt(u), .. }] => UInt64(u.to_uint64())
  [{ val: Int64(i64), .. }] => UInt64(i64.reinterpret_as_uint64())
  [{ val: UInt64(u64), .. }] => UInt64(u64)
  _ => Unit
}

// ===== UInt 运算函数 =====

///|
/// UInt 加法
let uint_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a + b)
  _ => Unit
}

///|
/// UInt 减法
let uint_sub_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a - b)
  _ => Unit
}

///|
/// UInt 乘法
let uint_mul_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a * b)
  _ => Unit
}

///|
/// UInt 除法
let uint_div_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a / b)
  _ => Unit
}

///|
/// UInt 取模
let uint_mod_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a % b)
  _ => Unit
}

///|
/// UInt 相等比较
let uint_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// UInt 比较
let uint_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// UInt 转 Int
let uint_to_int_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(u), .. }] => Int(u.reinterpret_as_int())
  _ => Unit
}

///|
/// UInt 转 Double
let uint_to_double_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt(u), .. }] => Double(u.to_double())
  _ => Unit
}

// ===== Float 运算函数 =====

///|
/// Float 加法
let float_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(a), .. }, { val: Float(b), .. }] => Float(a + b)
  _ => Unit
}

///|
/// Float 减法
let float_sub_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(a), .. }, { val: Float(b), .. }] => Float(a - b)
  _ => Unit
}

///|
/// Float 乘法
let float_mul_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(a), .. }, { val: Float(b), .. }] => Float(a * b)
  _ => Unit
}

///|
/// Float 除法
let float_div_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(a), .. }, { val: Float(b), .. }] => Float(a / b)
  _ => Unit
}

///|
/// Float 相等比较
let float_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(a), .. }, { val: Float(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// Float 比较
let float_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(a), .. }, { val: Float(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// Float 转 Double
let float_to_double_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Float(f), .. }] => Double(f.to_double())
  _ => Unit
}

// ===== Double 运算函数 =====

///|
/// Double 加法
let double_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(a), .. }, { val: Double(b), .. }] => Double(a + b)
  _ => Unit
}

///|
/// Double 减法
let double_sub_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(a), .. }, { val: Double(b), .. }] => Double(a - b)
  _ => Unit
}

///|
/// Double 乘法
let double_mul_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(a), .. }, { val: Double(b), .. }] => Double(a * b)
  _ => Unit
}

///|
/// Double 除法
let double_div_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(a), .. }, { val: Double(b), .. }] => Double(a / b)
  _ => Unit
}

///|
/// Double 相等比较
let double_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(a), .. }, { val: Double(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// Double 比较
let double_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(a), .. }, { val: Double(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// Double 转 Int64
let double_to_int64_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Double(d), .. }] => Int64(d.to_int64())
  _ => Unit
}

// ===== Char 运算函数 =====

///|
/// Char 相等比较
let char_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Char(a), .. }, { val: Char(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// Char 比较
let char_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Char(a), .. }, { val: Char(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// Char 转 Int
let char_to_int_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Char(c), .. }] => Int(c.to_int())
  _ => Unit
}

///|
/// Char 转 String
let char_to_string_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Char(c), .. }] => String(c.to_string())
  _ => Unit
}

///|
/// Char 从 Int 构造
let char_from_int_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(i), .. }] => Char(i.unsafe_to_char())
  _ => Unit
}

// ===== Byte 运算函数 =====

///|
/// Byte 相等比较
let byte_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Byte(a), .. }, { val: Byte(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// Byte 比较
let byte_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Byte(a), .. }, { val: Byte(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// Byte 转 Int
let byte_to_int_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Byte(b), .. }] => Int(b.to_int())
  _ => Unit
}

///|
/// Byte 转 UInt
let byte_to_uint_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Byte(b), .. }] => UInt(b.to_uint())
  _ => Unit
}

// ===== Int64 运算函数 =====

///|
/// Int64 加法
let int64_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a + b)
  _ => Unit
}

///|
/// Int64 减法
let int64_sub_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a - b)
  _ => Unit
}

///|
/// Int64 乘法
let int64_mul_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a * b)
  _ => Unit
}

///|
/// Int64 除法
let int64_div_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a / b)
  _ => Unit
}

///|
/// Int64 取模
let int64_mod_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a % b)
  _ => Unit
}

///|
/// Int64 相等比较
let int64_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// Int64 比较
let int64_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// Int64 转 Int
let int64_to_int_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(i64), .. }] => Int(i64.to_int())
  _ => Unit
}

///|
/// Int64 转 Double
let int64_to_double_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int64(i64), .. }] => Double(i64.to_double())
  _ => Unit
}

// ===== UInt64 运算函数 =====

///|
/// UInt64 加法
let uint64_add_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a + b)
  _ => Unit
}

///|
/// UInt64 减法
let uint64_sub_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a - b)
  _ => Unit
}

///|
/// UInt64 乘法
let uint64_mul_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a * b)
  _ => Unit
}

///|
/// UInt64 除法
let uint64_div_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a / b)
  _ => Unit
}

///|
/// UInt64 取模
let uint64_mod_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a % b)
  _ => Unit
}

///|
/// UInt64 相等比较
let uint64_eq_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Bool(a == b)
  _ => Unit
}

///|
/// UInt64 比较
let uint64_compare_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Int(a.compare(b))
  _ => Unit
}

///|
/// UInt64 转 UInt
let uint64_to_uint_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(u64), .. }] => UInt(u64.to_uint())
  _ => Unit
}

///|
/// UInt64 转 Int64
let uint64_to_int64_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: UInt64(u64), .. }] => Int64(u64.reinterpret_as_int64())
  _ => Unit
}
