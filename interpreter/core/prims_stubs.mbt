///| Extra embedded stub handlers for new core extern primitives.

///|
/// The map `extra_embedded_code` is merged into `core_embedded_code` in builtin.mbt.

// Double
let f64_abs_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Double(d.abs())
    _ => Unit
  }
}

///|
let f64_neg_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Double(-d)
    _ => Unit
  }
}

///|
let f64_sqrt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Double(d.sqrt())
    _ => Unit
  }
}

///|
let f64_lt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(a), .. }, { val: Double(b), .. }] => Bool(a < b)
    _ => Unit
  }
}

///|
let f64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(a), .. }, { val: Double(b), .. }] => Bool(a <= b)
    _ => Unit
  }
}

///|
let f64_gt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(a), .. }, { val: Double(b), .. }] => Bool(a > b)
    _ => Unit
  }
}

///|
let f64_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(a), .. }, { val: Double(b), .. }] => Bool(a >= b)
    _ => Unit
  }
}

///|
let f64_ne_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(a), .. }, { val: Double(b), .. }] => Bool(a != b)
    _ => Unit
  }
}

///|
let f64_to_f32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Float(Float::from_double(d))
    _ => Unit
  }
}

///|
let f64_to_u32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => UInt(UInt::trunc_double(d))
    _ => Unit
  }
}

///|
let f64_to_u32_sat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => UInt(d.to_uint())
    _ => Unit
  }
}

///|
let f64_to_u64_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => UInt64(UInt64::trunc_double(d))
    _ => Unit
  }
}

///|
let f64_to_u64_sat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => UInt64(d.to_uint64())
    _ => Unit
  }
}

///|
let f64_to_i32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Int(d.to_int(), raw=None)
    _ => Unit
  }
}

///|
let f64_to_i32_sat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Int(d.to_int(), raw=None)
    _ => Unit
  }
}

///|
let f64_to_i64_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Int64(d.to_int().to_int64())
    _ => Unit
  }
}

///|
let f64_to_i64_reinterpret_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Double(d), .. }] => Int64(d.reinterpret_as_int64())
    _ => Unit
  }
}

///|
let f64_default_fn : RuntimeFunction = _ctx => Double(0.0)

// Float

///|
let f32_abs_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(f), .. }] => Float(f.abs())
    _ => Unit
  }
}

///|
let f32_neg_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(f), .. }] => Float(-f)
    _ => Unit
  }
}

///|
let f32_sqrt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(f), .. }] => Float(f.sqrt())
    _ => Unit
  }
}

///|
let f32_lt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(a), .. }, { val: Float(b), .. }] => Bool(a < b)
    _ => Unit
  }
}

///|
let f32_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(a), .. }, { val: Float(b), .. }] => Bool(a <= b)
    _ => Unit
  }
}

///|
let f32_gt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(a), .. }, { val: Float(b), .. }] => Bool(a > b)
    _ => Unit
  }
}

///|
let f32_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(a), .. }, { val: Float(b), .. }] => Bool(a >= b)
    _ => Unit
  }
}

///|
let f32_ne_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(a), .. }, { val: Float(b), .. }] => Bool(a != b)
    _ => Unit
  }
}

///|
let f32_to_i32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(f), .. }] => Int(f.to_int(), raw=None)
    _ => Unit
  }
}

///|
let f32_to_i32_reinterpret_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(f), .. }] => UInt(f.reinterpret_as_uint())
    _ => Unit
  }
}

///|
let f32_to_i32_sat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Float(f), .. }] => Int(f.to_int(), raw=None)
    _ => Unit
  }
}

// Int compare / default

///|
let i32_lt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Bool(a < b)
    _ => Unit
  }
}

///|
let i32_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Bool(a <= b)
    _ => Unit
  }
}

///|
let i32_gt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Bool(a > b)
    _ => Unit
  }
}

///|
let i32_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Bool(a >= b)
    _ => Unit
  }
}

///|
let i32_ne_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(a, ..), .. }, { val: Int(b, ..), .. }] => Bool(a != b)
    _ => Unit
  }
}

///|
let i32_default_fn : RuntimeFunction = _ctx => Int(0, raw=None)

// Int64

///|
let i64_lt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Bool(a < b)
    _ => Unit
  }
}

///|
let i64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Bool(a <= b)
    _ => Unit
  }
}

///|
let i64_gt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Bool(a > b)
    _ => Unit
  }
}

///|
let i64_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Bool(a >= b)
    _ => Unit
  }
}

///|
let i64_ne_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Bool(a != b)
    _ => Unit
  }
}

///|
let i64_neg_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Int64(-a)
    _ => Unit
  }
}

///|
let i64_land_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a & b)
    _ => Unit
  }
}

///|
let i64_lor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a | b)
    _ => Unit
  }
}

///|
let i64_lxor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int64(b), .. }] => Int64(a ^ b)
    _ => Unit
  }
}

///|
let i64_lnot_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Int64(a.lnot())
    _ => Unit
  }
}

///|
let i64_shl_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int(b, ..), .. }] => Int64(a << b)
    _ => Unit
  }
}

///|
let i64_shr_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }, { val: Int(b, ..), .. }] => Int64(a >> b)
    _ => Unit
  }
}

///|
let i64_clz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Int(a.clz(), raw=None)
    _ => Unit
  }
}

///|
let i64_ctz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Int(a.ctz(), raw=None)
    _ => Unit
  }
}

///|
let i64_popcnt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Int(a.popcnt(), raw=None)
    _ => Unit
  }
}

///|
let i64_default_fn : RuntimeFunction = _ctx => Int64(0L)

///|
let i64_to_f32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Float(Float::from_double(a.to_double()))
    _ => Unit
  }
}

///|
let i64_to_u64_reinterpret_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => UInt64(a.reinterpret_as_uint64())
    _ => Unit
  }
}

///|
let i64_to_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Byte(a.to_byte())
    _ => Unit
  }
}

///|
let i64_to_f64_reinterpret_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Double(a.reinterpret_as_double())
    _ => Unit
  }
}

///|
let i64_to_i16_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] => Int(a.to_int() & 0xFFFF, raw=None)
    _ => Unit
  }
}

///|
let i64_to_u16_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int64(a), .. }] =>
      UInt16(a.reinterpret_as_uint64().to_uint().to_uint16())
    _ => UInt16(0U.to_uint16())
  }
}

// UInt

///|
let u32_lt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Bool(a < b)
    _ => Unit
  }
}

///|
let u32_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Bool(a <= b)
    _ => Unit
  }
}

///|
let u32_gt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Bool(a > b)
    _ => Unit
  }
}

///|
let u32_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Bool(a >= b)
    _ => Unit
  }
}

///|
let u32_ne_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => Bool(a != b)
    _ => Unit
  }
}

///|
let u32_bitand_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a & b)
    _ => Unit
  }
}

///|
let u32_bitor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a | b)
    _ => Unit
  }
}

///|
let u32_bitxor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: UInt(b), .. }] => UInt(a ^ b)
    _ => Unit
  }
}

///|
let u32_bitnot_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }] => UInt(a.lnot())
    _ => Unit
  }
}

///|
let u32_clz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }] => Int(a.clz(), raw=None)
    _ => Unit
  }
}

///|
let u32_ctz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }] => Int(a.ctz(), raw=None)
    _ => Unit
  }
}

///|
let u32_popcnt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }] => Int(a.popcnt(), raw=None)
    _ => Unit
  }
}

///|
let u32_shl_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: Int(b, ..), .. }] => UInt(a << b)
    _ => Unit
  }
}

///|
let u32_shr_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }, { val: Int(b, ..), .. }] => UInt(a >> b)
    _ => Unit
  }
}

///|
let u32_to_f32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt(a), .. }] => Float(Float::from_double(a.to_double()))
    _ => Unit
  }
}

// UInt64

///|
let u64_lt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Bool(a < b)
    _ => Unit
  }
}

///|
let u64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Bool(a <= b)
    _ => Unit
  }
}

///|
let u64_gt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Bool(a > b)
    _ => Unit
  }
}

///|
let u64_ge_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Bool(a >= b)
    _ => Unit
  }
}

///|
let u64_ne_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => Bool(a != b)
    _ => Unit
  }
}

///|
let u64_bitand_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a & b)
    _ => Unit
  }
}

///|
let u64_bitor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a | b)
    _ => Unit
  }
}

///|
let u64_bitxor_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: UInt64(b), .. }] => UInt64(a ^ b)
    _ => Unit
  }
}

///|
let u64_bitnot_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => UInt64(a.lnot())
    _ => Unit
  }
}

///|
let u64_clz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => Int(a.clz(), raw=None)
    _ => Unit
  }
}

///|
let u64_ctz_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => Int(a.ctz(), raw=None)
    _ => Unit
  }
}

///|
let u64_popcnt_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => Int(a.popcnt(), raw=None)
    _ => Unit
  }
}

///|
let u64_shl_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: Int(b, ..), .. }] => UInt64(a << b)
    _ => Unit
  }
}

///|
let u64_shr_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }, { val: Int(b, ..), .. }] => UInt64(a >> b)
    _ => Unit
  }
}

///|
let u64_to_f32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => Float(Float::from_double(a.to_double()))
    _ => Unit
  }
}

///|
let u64_to_f64_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => Double(a.to_double())
    _ => Unit
  }
}

///|
let u64_to_i32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(a), .. }] => Int(a.to_int(), raw=None)
    _ => Unit
  }
}

// Byte / Int16 / UInt16

///|
let byte_to_f32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Byte(b), .. }] => Float(Float::from_int(b.to_int()))
    _ => Unit
  }
}

///|
let byte_to_i16_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Byte(b), .. }] => Int(b.to_int(), raw=None)
    _ => Unit
  }
}

///|
let byte_to_u16_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Byte(b), .. }] => UInt16(b.to_uint16())
    _ => UInt16(0U.to_uint16())
  }
}

///|
let i16_to_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Byte(i.to_byte())
    _ => Unit
  }
}

///|
let i16_to_i32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int(i, raw=None)
    _ => Unit
  }
}

///|
let i16_to_i64_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(i, ..), .. }] => Int64(i.to_int64())
    _ => Unit
  }
}

///|
let u16_to_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt16(u), .. }] => Byte(u.to_int().to_byte())
    _ => Unit
  }
}

///|
let u16_to_i32_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt16(u), .. }] => Int(u.to_int(), raw=None)
    _ => Unit
  }
}

///|
let u16_to_i64_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt16(u), .. }] => Int64(u.to_int().to_int64())
    _ => Unit
  }
}

///|
let char_default_fn : RuntimeFunction = _ctx => Char('\u{0}')

// FixedArray / UninitializedArray unified handlers

///|
let fixedarray_make_uninit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }] =>
      UninitializedArray(@builtin.UninitializedArray::make(len))
    _ => Unit
  }
}

///|
let fixedarray_length_unified_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => Int(arr.length(), raw=None)
    [{ val: Array(arr), .. }] => Int(arr.length(), raw=None)
    [{ val: UninitializedArray(arr), .. }] => Int(arr.length(), raw=None)
    _ => Unit
  }
}

///|
let fixedarray_get_unified_fn : RuntimeFunction = ctx => {
  match ctx.args[0].val {
    FixedArray(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => -1
      }
      match arr.get(i) {
        Some(v) => v
        None => Unit
      }
    }
    Array(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => -1
      }
      match arr.get(i) {
        Some(v) => v
        None => Unit
      }
    }
    UninitializedArray(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => -1
      }
      arr.at(i)
    }
    _ => Unit
  }
}

///|
let fixedarray_unsafe_get_unified_fn : RuntimeFunction = ctx => {
  match ctx.args[0].val {
    FixedArray(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => 0
      }
      arr[i]
    }
    Array(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => 0
      }
      arr[i]
    }
    UninitializedArray(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => 0
      }
      arr[i]
    }
    _ => Unit
  }
}

///|
let fixedarray_set_unified_fn : RuntimeFunction = ctx => {
  match ctx.args[0].val {
    FixedArray(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => 0
      }
      let val = ctx.args[2].val
      arr.set(i, val)
      Unit
    }
    Array(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => 0
      }
      let val = ctx.args[2].val
      arr.set(i, val)
      Unit
    }
    UninitializedArray(arr) => {
      let i = match ctx.args[1].val {
        Int(n, ..) => n
        _ => 0
      }
      let val = ctx.args[2].val
      arr.set(i, val)
      Unit
    }
    _ => Unit
  }
}

// ArrayView

///|
let arrayview_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: UninitializedArray(buf), .. },
      { val: Int(start, ..), .. },
      { val: Int(len, ..), .. },
    ] => ArrayView(buf.exact_view(start~, end=start + len))
    [
      { val: Array(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(len, ..), .. },
    ] => ArrayView(arr.exact_view(start~, end=start + len))
    _ => Unit
  }
}

// BytesView (minimal — store as Bytes)

///|
let bytesview_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }, ..] => Bytes(b)
    _ => Unit
  }
}

///|
let bytesview_bytes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Bytes(b)
    _ => Unit
  }
}

///|
let bytesview_len_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Bytes(b), .. }] => Int(b.length(), raw=None)
    _ => Unit
  }
}

///|
let bytesview_start_fn : RuntimeFunction = _ctx => Int(0, raw=None)

// String (string_unsafe_get_fn and string_get_fn already defined in string.mbt)

///|
let string_unsafe_from_uint16_fixedarray_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(fa), .. }] => {
      let chars = @builtin.Array(capacity=fa.length())
      for i = 0; i < fa.length(); i = i + 1 {
        match fa[i] {
          UInt16(u) => chars.push(Int::unsafe_to_char(u.to_int()))
          _ => chars.push('\u{0}')
        }
      }
      String(String::from_array(chars))
    }
    _ => Unit
  }
}

// StringView

///|
let stringview_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: String(s), .. },
      { val: Int(start, ..), .. },
      { val: Int(end, ..), .. },
    ] => StringView(s[start:end].to_string_view())
    _ => Unit
  }
}

///|
let stringview_start_fn : RuntimeFunction = _ctx => Int(0, raw=None)

///|
let stringview_end_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(sv), .. }] => Int(sv.to_owned().length(), raw=None)
    _ => Unit
  }
}

///|
let stringview_str_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: StringView(sv), .. }] => String(sv.to_owned())
    _ => Unit
  }
}

// Error

///|
let error_to_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Exception(msg), .. }] => String(msg)
    _ => String("")
  }
}

///|
let error_to_json_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Exception(msg), .. }] => Json(@json.to_json(msg))
    _ => Json(@json.to_json(""))
  }
}

///|
let error_to_repr_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Exception(msg), .. }] => String("Error(" + msg + ")")
    _ => String("Error()")
  }
}

// Misc

///|
let eprintln_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: String(s), .. }] => {
      println(s)
      Unit
    }
    _ => Unit
  }
}

///|
let loc_to_string_fn : RuntimeFunction = _ctx => String("<loc>")

// V128 (minimal)

///|
let v128_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(lo), .. }, { val: UInt64(_hi), .. }] => UInt64(lo)
    _ => Unit
  }
}

///|
let v128_lo_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: UInt64(u), .. }] => UInt64(u)
    _ => Unit
  }
}

///|
let v128_hi_fn : RuntimeFunction = _ctx => UInt64(0UL)

// ===========================================================================

///|
let extra_embedded_code : Map[String, RuntimeFunction] = {
  "%f64.abs": f64_abs_fn,
  "%f64_neg": f64_neg_fn,
  "%f64_sqrt": f64_sqrt_fn,
  "%f64.lt": f64_lt_fn,
  "%f64.le": f64_le_fn,
  "%f64.gt": f64_gt_fn,
  "%f64.ge": f64_ge_fn,
  "%f64_ne": f64_ne_fn,
  "%f64.to_f32": f64_to_f32_fn,
  "%f64.to_u32": f64_to_u32_fn,
  "%f64.to_u32_saturate": f64_to_u32_sat_fn,
  "%f64.to_u64": f64_to_u64_fn,
  "%f64.to_u64_saturate": f64_to_u64_sat_fn,
  "%f64_to_i32": f64_to_i32_fn,
  "%f64_to_i32_saturate": f64_to_i32_sat_fn,
  "%f64_to_i64": f64_to_i64_fn,
  "%f64_to_i64_reinterpret": f64_to_i64_reinterpret_fn,
  "%f64_default": f64_default_fn,
  "%f32.abs": f32_abs_fn,
  "%f32.neg": f32_neg_fn,
  "%f32.sqrt": f32_sqrt_fn,
  "%f32.lt": f32_lt_fn,
  "%f32.le": f32_le_fn,
  "%f32.gt": f32_gt_fn,
  "%f32.ge": f32_ge_fn,
  "%f32.ne": f32_ne_fn,
  "%f32.to_i32": f32_to_i32_fn,
  "%f32.to_i32_reinterpret": f32_to_i32_reinterpret_fn,
  "%f32.to_i32_saturate": f32_to_i32_sat_fn,
  "%i32.lt": i32_lt_fn,
  "%i32.le": i32_le_fn,
  "%i32.gt": i32_gt_fn,
  "%i32.ge": i32_ge_fn,
  "%i32_ne": i32_ne_fn,
  "%i32_default": i32_default_fn,
  "%i64.lt": i64_lt_fn,
  "%i64.le": i64_le_fn,
  "%i64.gt": i64_gt_fn,
  "%i64.ge": i64_ge_fn,
  "%i64_ne": i64_ne_fn,
  "%i64_neg": i64_neg_fn,
  "%i64_land": i64_land_fn,
  "%i64_lor": i64_lor_fn,
  "%i64_lxor": i64_lxor_fn,
  "%i64_lnot": i64_lnot_fn,
  "%i64_shl": i64_shl_fn,
  "%i64_shr": i64_shr_fn,
  "%i64_clz": i64_clz_fn,
  "%i64_ctz": i64_ctz_fn,
  "%i64_popcnt": i64_popcnt_fn,
  "%i64_default": i64_default_fn,
  "%i64.to_f32": i64_to_f32_fn,
  "%i64.to_u64_reinterpret": i64_to_u64_reinterpret_fn,
  "%i64_to_byte": i64_to_byte_fn,
  "%i64_to_f64_reinterpret": i64_to_f64_reinterpret_fn,
  "%i64_to_i16": i64_to_i16_fn,
  "%i64_to_u16": i64_to_u16_fn,
  "%u32.lt": u32_lt_fn,
  "%u32.le": u32_le_fn,
  "%u32.gt": u32_gt_fn,
  "%u32.ge": u32_ge_fn,
  "%u32.ne": u32_ne_fn,
  "%u32.bitand": u32_bitand_fn,
  "%u32.bitor": u32_bitor_fn,
  "%u32.bitxor": u32_bitxor_fn,
  "%u32.bitnot": u32_bitnot_fn,
  "%u32.clz": u32_clz_fn,
  "%u32.ctz": u32_ctz_fn,
  "%u32.popcnt": u32_popcnt_fn,
  "%u32.shl": u32_shl_fn,
  "%u32.shr": u32_shr_fn,
  "%u32.to_f32": u32_to_f32_fn,
  "%u64.lt": u64_lt_fn,
  "%u64.le": u64_le_fn,
  "%u64.gt": u64_gt_fn,
  "%u64.ge": u64_ge_fn,
  "%u64.ne": u64_ne_fn,
  "%u64.bitand": u64_bitand_fn,
  "%u64.bitor": u64_bitor_fn,
  "%u64.bitxor": u64_bitxor_fn,
  "%u64.bitnot": u64_bitnot_fn,
  "%u64.clz": u64_clz_fn,
  "%u64.ctz": u64_ctz_fn,
  "%u64.popcnt": u64_popcnt_fn,
  "%u64.shl": u64_shl_fn,
  "%u64.shr": u64_shr_fn,
  "%u64.to_f32": u64_to_f32_fn,
  "%u64.to_f64": u64_to_f64_fn,
  "%u64.to_i32": u64_to_i32_fn,
  "%byte.to_f32": byte_to_f32_fn,
  "%byte_to_i16": byte_to_i16_fn,
  "%byte_to_u16": byte_to_u16_fn,
  "%i16_to_byte": i16_to_byte_fn,
  "%i16_to_i32": i16_to_i32_fn,
  "%i16_to_i64": i16_to_i64_fn,
  "%u16_to_byte": u16_to_byte_fn,
  "%u16_to_i32": u16_to_i32_fn,
  "%u16_to_i64": u16_to_i64_fn,
  "%char_default": char_default_fn,
  "%fixedarray.make": fixedarray_make_fn,
  "%fixedarray.make_uninit": fixedarray_make_uninit_fn,
  "%fixedarray.length": fixedarray_length_unified_fn,
  "%fixedarray.get": fixedarray_get_unified_fn,
  "%fixedarray.unsafe_get": fixedarray_unsafe_get_unified_fn,
  "%fixedarray.set": fixedarray_set_unified_fn,
  "%fixedarray.unsafe_set": fixedarray_set_unified_fn,
  "%arrayview.make": arrayview_make_fn,
  "%bytes.equal": bytes_equal_fn,
  "%bytes.unsafe_get": bytes_unsafe_get_fn,
  "%bytes_get": bytes_at_fn,
  "%bytes_length": bytes_length_fn,
  "%bytes_make": bytes_make_fn,
  "%bytesview.make": bytesview_make_fn,
  "%bytesview.bytes": bytesview_bytes_fn,
  "%bytesview.len": bytesview_len_fn,
  "%bytesview.start": bytesview_start_fn,
  "%string.unsafe_get": string_unsafe_get_fn,
  "%string_get": string_get_fn,
  "%string.unsafe_from_uint16_fixedarray": string_unsafe_from_uint16_fixedarray_fn,
  "%stringview.make": stringview_make_fn,
  "%stringview.start": stringview_start_fn,
  "%stringview.end": stringview_end_fn,
  "%stringview.str": stringview_str_fn,
  "%error.to_string": error_to_string_fn,
  "%error.to_json": error_to_json_fn,
  "%error.to_repr": error_to_repr_fn,
  "%eprintln": eprintln_fn,
  "%loc_to_string": loc_to_string_fn,
  "%v128.make": v128_make_fn,
  "%v128.lo": v128_lo_fn,
  "%v128.hi": v128_hi_fn,
}
