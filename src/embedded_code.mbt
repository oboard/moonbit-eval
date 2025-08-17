///|
let core_fn_aliases : Map[String, String] = { "not": "%bool_not" }

///|
let core_embedded_code : Map[String, (Array[RuntimeArgument]) -> RuntimeValue] = {
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
  // String 类型函数
  "%string_length": string_length,
  "%string_get": string_get_fn,
  "%string.unsafe_get": string_unsafe_get_fn,
  "%string_add": string_add_fn,
  "%string_eq": string_eq_fn,
  "%string_to_string": string_to_string_fn,
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
}

///|
let core_embedded_methods : Map[
  String,
  Map[String, (Array[RuntimeArgument]) -> RuntimeValue],
] = {
  "Bool": {
    "eq": bool_eq_fn,
    "compare": bool_compare_fn,
    "default": bool_default_fn,
  },
  "Int": {
    "neg": int_neg_fn,
    "add": int_add_fn,
    "sub": int_sub_fn,
    "mul": int_mul_fn,
    "div": int_div_fn,
    "mod": int_mod_fn,
    "lnot": int_lnot_fn,
    "land": int_land_fn,
    "lor": int_lor_fn,
    "lxor": int_lxor_fn,
    "shl": int_shl_fn,
    "shr": int_shr_fn,
    "eq": int_eq_fn,
    "compare": int_compare_fn,
    "is_pos": int_is_pos_fn,
    "is_neg": int_is_neg_fn,
    "ctz": int_ctz_fn,
    "clz": int_clz_fn,
    "popcnt": int_popcnt_fn,
  },
  "String": {
    "length": string_length,
    "get": string_get_fn,
    "unsafe_get": string_unsafe_get_fn,
    "add": string_add_fn,
    "eq": string_eq_fn,
    "to_string": string_to_string_fn,
  },
  "UInt": {
    "add": uint_add_fn,
    "sub": uint_sub_fn,
    "mul": uint_mul_fn,
    "div": uint_div_fn,
    "mod": uint_mod_fn,
    "eq": uint_eq_fn,
    "compare": uint_compare_fn,
    "to_i32_reinterpret": uint_to_int_fn,
    "to_f64": uint_to_double_fn,
  },
  "Float": {
    "add": float_add_fn,
    "sub": float_sub_fn,
    "mul": float_mul_fn,
    "div": float_div_fn,
    "eq": float_eq_fn,
    "compare": float_compare_fn,
    "to_f64": float_to_double_fn,
  },
  "Double": {
    "add": double_add_fn,
    "sub": double_sub_fn,
    "mul": double_mul_fn,
    "div": double_div_fn,
    "eq": double_eq_fn,
    "compare": double_compare_fn,
    "to_i64_saturate": double_to_int64_fn,
    "to_int64": double_to_int64_fn,
  },
  "Char": {
    "eq": char_eq_fn,
    "compare": char_compare_fn,
    "to_int": char_to_int_fn,
  },
  "Byte": {
    "eq": byte_eq_fn,
    "compare": byte_compare_fn,
    "to_int": byte_to_int_fn,
    "to_uint": byte_to_uint_fn,
  },
  "Int64": {
    "add": int64_add_fn,
    "sub": int64_sub_fn,
    "mul": int64_mul_fn,
    "div": int64_div_fn,
    "mod": int64_mod_fn,
    "eq": int64_eq_fn,
    "compare": int64_compare_fn,
    "to_i32": int64_to_int_fn,
    "to_f64": int64_to_double_fn,
  },
  "UInt64": {
    "add": uint64_add_fn,
    "sub": uint64_sub_fn,
    "mul": uint64_mul_fn,
    "div": uint64_div_fn,
    "mod": uint64_mod_fn,
    "eq": uint64_eq_fn,
    "compare": uint64_compare_fn,
    "to_u32": uint64_to_uint_fn,
    "to_i64_reinterpret": uint64_to_int64_fn,
  },
}

///|
let string_length : (Array[RuntimeArgument]) -> RuntimeValue = params => if params
  is [{ value: String(s), .. }, ..] {
  Int(s.length())
} else {
  Unit
}

// ===== 基础函数 =====

///| ignore 函数 - 忽略任何值并返回 Unit
let ignore_fn : (Array[RuntimeArgument]) -> RuntimeValue = _params => Unit

///| physical_equal 函数 - 检查两个值是否物理相等
let physical_equal_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: a, .. }, { value: b, .. }, ..] => Bool(physical_equal(a, b))
  _ => Bool(false)
}

///| panic 函数 - 触发 panic
let panic_fn : (Array[RuntimeArgument]) -> RuntimeValue = _params => {
  abort("panic called")
  Unit
}

// ===== 布尔运算 =====

///| 布尔 NOT 运算
let bool_not_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Bool(b), .. }, ..] => Bool(not(b))
  _ => Unit
}

///| 布尔相等比较
let bool_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Bool(a), .. }, { value: Bool(b), .. }, ..] => Bool(a == b)
  _ => Bool(false)
}

///| 布尔比较
let bool_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Bool(a), .. }, { value: Bool(b), .. }, ..] =>
    if a == b {
      Int(0)
    } else if a {
      Int(1) // true > false
    } else {
      Int(-1) // false < true
    }
  _ => Int(0)
}

///| 布尔默认值
let bool_default_fn : (Array[RuntimeArgument]) -> RuntimeValue = _params => Bool(
  false,
)

// ===== 整数算术运算 =====

///| 整数取负
let int_neg_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int(-i)
  _ => Unit
}

///| 整数加法
let int_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a + b)
  _ => Unit
}

///| 整数减法
let int_sub_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a - b)
  _ => Unit
}

///| 整数乘法
let int_mul_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a * b)
  _ => Unit
}

///| 整数除法
let int_div_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] =>
    if b != 0 {
      Int(a / b)
    } else {
      abort("division by zero")
      Unit
    }
  _ => Unit
}

///| 整数取模
let int_mod_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] =>
    if b != 0 {
      Int(a % b)
    } else {
      abort("modulo by zero")
      Unit
    }
  _ => Unit
}

// ===== 整数位运算 =====

///| 整数按位取反
let int_lnot_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int(i.lnot())
  _ => Unit
}

///| 整数按位与
let int_land_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a & b)
  _ => Unit
}

///| 整数按位或
let int_lor_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a | b)
  _ => Unit
}

///| 整数按位异或
let int_lxor_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a ^ b)
  _ => Unit
}

///| 整数左移
let int_shl_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a << b)
  _ => Unit
}

///| 整数右移
let int_shr_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Int(a >> b)
  _ => Unit
}

// ===== 整数比较运算 =====

///| 整数相等比较
let int_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] => Bool(a == b)
  _ => Bool(false)
}

///| 整数比较
let int_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(a), .. }, { value: Int(b), .. }, ..] =>
    if a == b {
      Int(0)
    } else if a > b {
      Int(1)
    } else {
      Int(-1)
    }
  _ => Int(0)
}

///| 整数是否为正
let int_is_pos_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Bool(i > 0)
  _ => Bool(false)
}

///| 整数是否为负
let int_is_neg_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Bool(i < 0)
  _ => Bool(false)
}

// ===== 整数工具函数 =====

///| 计算尾随零的个数
let int_ctz_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int(i.ctz())
  _ => Unit
}

///| 计算前导零的个数
let int_clz_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int(i.clz())
  _ => Unit
}

///| 计算设置位的个数
let int_popcnt_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int(i.popcnt())
  _ => Unit
}

// ===== 字符串操作 =====

///| 字符串索引访问
let string_get_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(s), .. }, { value: Int(idx), .. }, ..] =>
    if idx >= 0 && idx < s.length() {
      Int(s[idx])
    } else {
      abort("string index out of bounds")
      Unit
    }
  _ => Unit
}

///| 字符串不安全索引访问
let string_unsafe_get_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(s), .. }, { value: Int(idx), .. }, ..] =>
    Int(s.unsafe_charcode_at(idx))
  _ => Unit
}

///| 字符串连接
let string_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(a), .. }, { value: String(b), .. }, ..] => String(a + b)
  _ => Unit
}

///| 字符串相等比较
let string_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(a), .. }, { value: String(b), .. }, ..] => Bool(a == b)
  _ => Bool(false)
}

///| 字符串 to_string
let string_to_string_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: String(s), .. }, ..] => String(s)
  _ => Unit
}

// ===== 类型转换函数 =====

///| 转换为 Double
let to_double_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Double(i.to_double())
  [{ value: Float(f), .. }, ..] => Double(f.to_double())
  [{ value: Double(d), .. }, ..] => Double(d)
  [{ value: UInt(u), .. }, ..] => Double(u.to_double())
  [{ value: Int64(i64), .. }, ..] => Double(i64.to_double())
  [{ value: UInt64(u64), .. }, ..] => Double(u64.to_double())
  _ => Unit
}

///| 转换为 Float
let to_float_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Float(i.to_float())
  [{ value: Float(f), .. }, ..] => Float(f)
  [{ value: Double(d), .. }, ..] => Float(d.to_float())
  [{ value: UInt(u), .. }, ..] => Float(u.to_float())
  _ => Unit
}

///| 转换为 Byte
let to_byte_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Byte(i.to_byte())
  [{ value: UInt(u), .. }, ..] => Byte(u.to_byte())
  [{ value: Byte(b), .. }, ..] => Byte(b)
  _ => Unit
}

///| 转换为 Int16 (使用 Int 表示)
let to_int16_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int(i & 0xFFFF)
  [{ value: UInt(u), .. }, ..] => Int(u.reinterpret_as_int() & 0xFFFF)
  _ => Unit
}

///| 转换为 UInt16 (使用 UInt 表示)
let to_uint16_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => UInt(i.land(0xFFFF).reinterpret_as_uint())
  [{ value: UInt(u), .. }, ..] => UInt(u & 0xFFFFU)
  _ => Unit
}

///| 转换为 Int64
let to_int64_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => Int64(i.to_int64())
  [{ value: UInt(u), .. }, ..] => Int64(u.to_int64())
  [{ value: Int64(i64), .. }, ..] => Int64(i64)
  [{ value: UInt64(u64), .. }, ..] => Int64(u64.reinterpret_as_int64())
  [{ value: Double(d), .. }, ..] => Int64(d.to_int64())
  _ => Unit
}

///| 转换为 UInt64
let to_uint64_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int(i), .. }, ..] => UInt64(i.to_uint64())
  [{ value: UInt(u), .. }, ..] => UInt64(u.to_uint64())
  [{ value: Int64(i64), .. }, ..] => UInt64(i64.reinterpret_as_uint64())
  [{ value: UInt64(u64), .. }, ..] => UInt64(u64)
  _ => Unit
}

// ===== UInt 运算函数 =====

///| UInt 加法
let uint_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => UInt(a + b)
  _ => Unit
}

///| UInt 减法
let uint_sub_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => UInt(a - b)
  _ => Unit
}

///| UInt 乘法
let uint_mul_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => UInt(a * b)
  _ => Unit
}

///| UInt 除法
let uint_div_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => UInt(a / b)
  _ => Unit
}

///| UInt 取模
let uint_mod_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => UInt(a % b)
  _ => Unit
}

///| UInt 相等比较
let uint_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| UInt 比较
let uint_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(a), .. }, { value: UInt(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| UInt 转 Int
let uint_to_int_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(u), .. }, ..] => Int(u.reinterpret_as_int())
  _ => Unit
}

///| UInt 转 Double
let uint_to_double_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt(u), .. }, ..] => Double(u.to_double())
  _ => Unit
}

// ===== Float 运算函数 =====

///| Float 加法
let float_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(a), .. }, { value: Float(b), .. }, ..] => Float(a + b)
  _ => Unit
}

///| Float 减法
let float_sub_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(a), .. }, { value: Float(b), .. }, ..] => Float(a - b)
  _ => Unit
}

///| Float 乘法
let float_mul_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(a), .. }, { value: Float(b), .. }, ..] => Float(a * b)
  _ => Unit
}

///| Float 除法
let float_div_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(a), .. }, { value: Float(b), .. }, ..] => Float(a / b)
  _ => Unit
}

///| Float 相等比较
let float_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(a), .. }, { value: Float(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| Float 比较
let float_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(a), .. }, { value: Float(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| Float 转 Double
let float_to_double_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Float(f), .. }, ..] => Double(f.to_double())
  _ => Unit
}

// ===== Double 运算函数 =====

///| Double 加法
let double_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(a), .. }, { value: Double(b), .. }, ..] => Double(a + b)
  _ => Unit
}

///| Double 减法
let double_sub_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(a), .. }, { value: Double(b), .. }, ..] => Double(a - b)
  _ => Unit
}

///| Double 乘法
let double_mul_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(a), .. }, { value: Double(b), .. }, ..] => Double(a * b)
  _ => Unit
}

///| Double 除法
let double_div_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(a), .. }, { value: Double(b), .. }, ..] => Double(a / b)
  _ => Unit
}

///| Double 相等比较
let double_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(a), .. }, { value: Double(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| Double 比较
let double_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(a), .. }, { value: Double(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| Double 转 Int64
let double_to_int64_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Double(d), .. }, ..] => Int64(d.to_int64())
  _ => Unit
}

// ===== Char 运算函数 =====

///| Char 相等比较
let char_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Char(a), .. }, { value: Char(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| Char 比较
let char_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Char(a), .. }, { value: Char(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| Char 转 Int
let char_to_int_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Char(c), .. }, ..] => Int(c.to_int())
  _ => Unit
}

// ===== Byte 运算函数 =====

///| Byte 相等比较
let byte_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Byte(a), .. }, { value: Byte(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| Byte 比较
let byte_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Byte(a), .. }, { value: Byte(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| Byte 转 Int
let byte_to_int_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Byte(b), .. }, ..] => Int(b.to_int())
  _ => Unit
}

///| Byte 转 UInt
let byte_to_uint_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Byte(b), .. }, ..] => UInt(b.to_uint())
  _ => Unit
}

// ===== Int64 运算函数 =====

///| Int64 加法
let int64_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Int64(a + b)
  _ => Unit
}

///| Int64 减法
let int64_sub_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Int64(a - b)
  _ => Unit
}

///| Int64 乘法
let int64_mul_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Int64(a * b)
  _ => Unit
}

///| Int64 除法
let int64_div_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Int64(a / b)
  _ => Unit
}

///| Int64 取模
let int64_mod_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Int64(a % b)
  _ => Unit
}

///| Int64 相等比较
let int64_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| Int64 比较
let int64_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(a), .. }, { value: Int64(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| Int64 转 Int
let int64_to_int_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(i64), .. }, ..] => Int(i64.to_int())
  _ => Unit
}

///| Int64 转 Double
let int64_to_double_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Int64(i64), .. }, ..] => Double(i64.to_double())
  _ => Unit
}

// ===== UInt64 运算函数 =====

///| UInt64 加法
let uint64_add_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => UInt64(a + b)
  _ => Unit
}

///| UInt64 减法
let uint64_sub_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => UInt64(a - b)
  _ => Unit
}

///| UInt64 乘法
let uint64_mul_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => UInt64(a * b)
  _ => Unit
}

///| UInt64 除法
let uint64_div_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => UInt64(a / b)
  _ => Unit
}

///| UInt64 取模
let uint64_mod_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => UInt64(a % b)
  _ => Unit
}

///| UInt64 相等比较
let uint64_eq_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => Bool(a == b)
  _ => Unit
}

///| UInt64 比较
let uint64_compare_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(a), .. }, { value: UInt64(b), .. }, ..] => Int(a.compare(b))
  _ => Unit
}

///| UInt64 转 UInt
let uint64_to_uint_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(u64), .. }, ..] => UInt(u64.to_uint())
  _ => Unit
}

///| UInt64 转 Int64
let uint64_to_int64_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: UInt64(u64), .. }, ..] => Int64(u64.reinterpret_as_int64())
  _ => Unit
}
