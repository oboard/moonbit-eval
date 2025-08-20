///|
/// Auto-generated core modules for moonbit-eval interpreter
/// This file contains embedded RuntimeModule definitions for all moonbitlang/core modules

///|
let core_modules : Map[String, RuntimeModule] = {
  "array": array_module,
  "bench": bench_module,
  "bigint": bigint_module,
  "bool": bool_module,
  "buffer": buffer_module,
  "builtin": builtin_module,
  "byte": byte_module,
  "bytes": bytes_module,
  "char": char_module,
  "deque": deque_module,
  "double": double_module,
  "env": env_module,
  "float": float_module,
  "hashset": hashset_module,
  "int": int_module,
  "int16": int16_module,
  "int64": int64_module,
  "json": json_module,
  "math": math_module,
  "random": random_module,
  "rational": rational_module,
  "set": set_module,
  "sorted_map": sorted_map_module,
  "sorted_set": sorted_set_module,
  "strconv": strconv_module,
  "string": string_module,
  "test": test_module,
  "uint": uint_module,
  "uint16": uint16_module,
  "uint64": uint64_module,
  "unit": unit_module,
}

///|
fn dummy_loc() -> @basic.Location {
  {
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
}

///|
let array_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/array",
  fn(_env, build) {
    {
      "join": build(
        (
          #|pub fn join(self : Array[String], separator : @string.View) -> String { self[:].join(separator) }
        ),
      ),
      "collapse": build(
        (
          #|fn collapse(runs : Array[TimSortRun], stop : Int) -> Int? { let n : Int = runs.length()
          #|  if n >= 2 &&
          #|    (
          #|      runs[n - 1].start + runs[n - 1].len == stop ||
          #|      runs[n - 2].len <= runs[n - 1].len ||
          #|      (n >= 3 && runs[n - 3].len <= runs[n - 2].len + runs[n - 1].len) ||
          #|      (n >= 4 && runs[n - 4].len <= runs[n - 3].len + runs[n - 2].len)
          #|    ) {
          #|    if n >= 3 && runs[n - 3].len < runs[n - 1].len {
          #|      Some(n - 3)
          #|    } else {
          #|      Some(n - 2)
          #|    }
          #|  } else {
          #|    None
          #|  } }
        ),
      ),
      "minimum": build(
        (
          #|fn minimum(x : Int, y : Int) -> Int { if x > y {
          #|    y
          #|  } else {
          #|    x
          #|  } }
        ),
      ),
      "join": build(
        (
          #|pub fn View::join(self : ArrayView[String], separator : @string.View) -> String { match self {
          #|    [] => \"\"
          #|    [hd, .. tl] => {
          #|      let mut size_hint = hd.length()
          #|      for s in tl {
          #|        size_hint += s.length() + separator.length()
          #|      }
          #|      size_hint = size_hint << 1
          #|      let buf = StringBuilder::new(size_hint~)
          #|      buf.write_string(hd)
          #|      if separator is \"\" {
          #|        for s in tl {
          #|          buf.write_string(s)
          #|        }
          #|      } else {
          #|        for s in tl {
          #|          buf.write_substring(
          #|            separator.data(),
          #|            separator.start_offset(),
          #|            separator.length(),
          #|          )
          #|          buf.write_string(s)
          #|        }
          #|      }
          #|      buf.to_string()
          #|    }
          #|  } }
        ),
      ),
      "get_limit": build(
        (
          #|fn get_limit(len : Int) -> Int { let mut len = len
          #|  let mut limit = 0
          #|  while len > 0 {
          #|    len = len / 2
          #|    limit += 1
          #|  }
          #|  limit }
        ),
      ),
    }
  },
)

///|
let bench_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bench",
  fn(_env, build) {
    {
      "iter_n_microseconds": build(
        (
          #|fn iter_n_microseconds(inner : () -> Unit, k : Int) -> Double { let ts = monotonic_clock_start()
          #|  for i in 0..<k {
          #|    inner()
          #|  }
          #|  let diff = monotonic_clock_end(ts)
          #|  diff }
        ),
      ),
      "monotonic_clock_end": build(
        (
          #|pub fn monotonic_clock_end(ts : Timestamp) -> Double { let elapsed_secs : Double = instant_elapsed_as_secs_f64(ts)
          #|  elapsed_secs * 1000000.0 }
        ),
      ),
      "new": build(
        (
          #|pub fn new() -> T { let buffer = StringBuilder::new()
          #|  let summaries = Array::new()
          #|  { buffer, summaries, _storage: () } }
        ),
      ),
      "sum": build(
        (
          #|fn sum(data : Array[Double]) -> Double { let mut sum = 0.0
          #|  for i in data {
          #|    sum += i
          #|  }
          #|  sum }
        ),
      ),
    }
  },
)

///|
let bigint_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bigint",
  fn(_env, build) {
    {
      "radix_bit_len": Int(32),
      "decimal_ratio": build("0.302 // log10(2)"),
      "karatsuba_threshold": Int(50),
      "from_int": build(
        (
          #|pub fn BigInt::from_int(n : Int) -> BigInt { BigInt::from_int64(n.to_int64()) }
        ),
      ),
      "zero": build("0N"),
      "from_string": build(
        (
          #|pub fn BigInt::from_string(str : String) -> BigInt { if str.length() == 0 {
          #|    abort(\"empty string\")
          #|  }
          #|  BigInt::js_from_string(str) }
        ),
      ),
      "asr": build(
        (
          #|pub fn BigInt::asr(self : BigInt, n : Int) -> BigInt { self >> n }
        ),
      ),
      "equal_int": build(
        (
          #|pub fn BigInt::equal_int(self : BigInt, other : Int) -> Bool { can_convert_to_int(self) && self.to_int() == other }
        ),
      ),
    }
  },
)

///|
let bool_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/bool", fn(
  _env,
  build,
) {
  {
    "to_int": build(
      (
        #|pub fn to_int(self : Bool) -> Int { if self {
        #|    1
        #|  } else {
        #|    0
        #|  } }
      ),
    ),
  }
})

///|
let buffer_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/buffer",
  fn(_env, build) {
    {
      "grow_if_necessary": build(
        (
          #|fn grow_if_necessary(self : T, required : Int) -> Unit { let start = if self.data.length() <= 0 { 1 } else { self.data.length() }
          #|  let enough_space = for space = start {
          #|    if space >= required {
          #|      break space
          #|    }
          #|    continue space * 2
          #|  }
          #|  if enough_space != self.data.length() {
          #|    let new_data = FixedArray::make(enough_space, Byte::default())
          #|    new_data.unsafe_blit(0, self.data, 0, self.len)
          #|    self.data = new_data
          #|  } }
        ),
      ),
    }
  },
)

///|
let builtin_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/builtin",
  fn(_env, build) {
    {
      "join": build(
        (
          #|pub fn Iter::join(self : Iter[String], sep : String) -> String { let buf = StringBuilder::new()
          #|  let mut first = true
          #|  for str in self {
          #|    if first {
          #|      first = false
          #|    } else {
          #|      buf.write_string(sep)
          #|    }
          #|    buf.write_string(str)
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn Double::to_int64(self : Double) -> Int64 { MyInt64::from_double(self).to_int64() }
        ),
      ),
      "add_hi_lo": build(
        (
          #|fn MyInt64::add_hi_lo(self : MyInt64, bhi : Int, blo : Int) -> MyInt64 { let { hi: ahi, lo: alo } = self
          #|  let lo = alo + blo
          #|  let s = lo >> 31
          #|  let as_ = alo >> 31
          #|  let bs = blo >> 31
          #|  let c = ((as_ & bs) | (s.lnot() & (as_ ^ bs))) & 1
          #|  let hi = ahi + bhi + c
          #|  { hi, lo } }
        ),
      ),
      "to_hex_digit": build(
        (
          #|fn to_hex_digit(i : Int) -> Char { if i < 10 {
          #|    (i + '0').unsafe_to_char()
          #|  } else {
          #|    (i + 'a' - 10).unsafe_to_char()
          #|  } }
        ),
      ),
      "lsr": build(
        (
          #|pub fn Int::lsr(self : Int, other : Int) -> Int { (self.reinterpret_as_uint() >> other).reinterpret_as_int() }
        ),
      ),
      "null": build(
        (
          #|pub fn Json::null() -> Json { return Null }
        ),
      ),
      "to_string": build(
        (
          #|pub fn Int64::to_string(self : Int64, radix~ : Int = 10) -> String { let buf = StringBuilder::new(size_hint=Int64::output_size_hint(radix~))
          #|  self.output(buf, radix~)
          #|  buf.to_string() }
        ),
      ),
      "new": build(
        (
          #|pub fn Hasher::new(seed~ : Int = 0) -> Hasher { { acc: seed.reinterpret_as_uint() + GPRIME5 } }
        ),
      ),
      "upto": build(
        (
          #|pub fn Int::upto(self : Int, end : Int, inclusive~ : Bool = false) -> Iter[Int] { yield_ => {
          #|    let mut i = self
          #|    while i < end || (inclusive && i == end) {
          #|      if yield_(i) == IterEnd {
          #|        break IterEnd
          #|      }
          #|      if i == end {
          #|        break IterContinue
          #|      }
          #|      i += 1
          #|    } else {
          #|      IterContinue
          #|    }
          #|  } }
        ),
      ),
      "calc_grow_threshold": build(
        (
          #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
        ),
      ),
      "new": build(
        (
          #|pub fn StringBuilder::new(size_hint~ : Int = 0) -> StringBuilder { ignore(size_hint)
          #|  { val: \"\" } }
        ),
      ),
      "new": build(
        (
          #|pub fn StringBuilder::new(size_hint~ : Int = 0) -> StringBuilder { let initial = if size_hint < 1 { 1 } else { size_hint }
          #|  let data : FixedArray[Byte] = FixedArray::make(initial, 0)
          #|  { data, len: 0 } }
        ),
      ),
      "make": build(
        (
          #|pub fn String::make(length : Int, value : Char) -> String { guard length >= 0 else { abort(\"invalid length\") }
          #|  if value.to_int() <= 0xFFFF {
          #|    unsafe_make_string(length, value)
          #|  } else {
          #|    let buf = StringBuilder::new(size_hint=2 * length)
          #|    for _ in 0..<length {
          #|      buf.write_char(value)
          #|    }
          #|    buf.to_string()
          #|  } }
        ),
      ),
      "to_int64": build(
        (
          #|pub fn Double::to_int64(self : Double) -> Int64 { if self != self {
          #|    0
          #|  } else if self >= 9223372036854775807 {
          #|    9223372036854775807L
          #|  } else if self <= -9223372036854775808 {
          #|    -9223372036854775808L
          #|  } else {
          #|    self.to_unchecked_int64()
          #|  } }
        ),
      ),
      "to_json": build(
        (
          #|pub fn ArgsLoc::to_json(self : ArgsLoc) -> String { let buf = StringBuilder::new(size_hint=10)
          #|  let ArgsLoc(self) = self
          #|  buf.write_char('[')
          #|  for i in 0..<self.length() {
          #|    if i != 0 {
          #|      buf.write_string(\", \")
          #|    }
          #|    let item = self[i]
          #|    match item {
          #|      None => buf.write_string(\"null\")
          #|      Some(loc) => loc.to_string() |> Show::output(buf)
          #|    }
          #|  }
          #|  buf.write_char(']')
          #|  buf.to_string() }
        ),
      ),
      "output": build(
        (
          #|fn Int64::output(self : Int64, logger : &Logger, radix~ : Int = 10) -> Unit { fn abs(n : Int64) -> Int64 {
          #|    if n < 0L {
          #|      0L - n
          #|    } else {
          #|      n
          #|    }
          #|  }
          #|  if self < 0L {
          #|    logger.write_char('-')
          #|  }
          #|  let radix : Int64 = radix.to_int64()
          #|  fn write_digits(num : Int64) {
          #|    let num2 = num / radix
          #|    if num2 != 0L {
          #|      write_digits(num2)
          #|    }
          #|    logger.write_char(
          #|      ALPHABET.charcode_at(abs(num % radix).to_int()).unsafe_to_char(),
          #|    )
          #|  }
          #|  write_digits(abs(self)) }
        ),
      ),
      "to_int": build(
        (
          #|pub fn Double::to_int(self : Double) -> Int { if self != self {
          #|    0
          #|  } else if self >= 2147483647 {
          #|    2147483647
          #|  } else if self <= -2147483648 {
          #|    -2147483648
          #|  } else {
          #|    self.to_unchecked_int()
          #|  } }
        ),
      ),
      "makei": build(
        (
          #|pub fn Bytes::makei(length : Int, value : (Int) -> Byte raise?) -> Bytes raise? { if length <= 0 {
          #|    return []
          #|  }
          #|  let arr = FixedArray::make(length, value(0))
          #|  for i in 1..<length {
          #|    arr[i] = value(i)
          #|  }
          #|  FixedArray::unsafe_reinterpret_as_bytes(arr) }
        ),
      ),
      "next_power_of_two": build(
        (
          #|pub fn Int::next_power_of_two(self : Int) -> Int { guard self >= 0
          #|  if self <= 1 {
          #|    return 1
          #|  }
          #|  // The largest power of 2 that fits in a 32-bit signed integer is 2^30
          #|  let max_power_of_two = 1073741824 // 2^30
          #|  if self > max_power_of_two {
          #|    return max_power_of_two
          #|  }
          #|  // 2147483647 is the largest value of an integer
          #|  (2147483647 >> ((self - 1).clz() - 1)) + 1 }
        ),
      ),
      "base64_encode": build(
        (
          #|fn base64_encode(data : FixedArray[Byte]) -> String { let base64 = b\"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/\"
          #|  let buf = StringBuilder::new()
          #|  let len = data.length()
          #|  let rem = len % 3
          #|  for i = 0; i < len - rem; i = i + 3 {
          #|    let b0 = data[i].to_int()
          #|    let b1 = data[i + 1].to_int()
          #|    let b2 = data[i + 2].to_int()
          #|    let x0 = base64[(b0 & 0xFC) >> 2]
          #|    let x1 = base64[((b0 & 0x03) << 4) | ((b1 & 0xF0) >> 4)]
          #|    let x2 = base64[((b1 & 0x0F) << 2) | ((b2 & 0xC0) >> 6)]
          #|    let x3 = base64[b2 & 0x3F]
          #|    buf.write_char(x0.to_char())
          #|    buf.write_char(x1.to_char())
          #|    buf.write_char(x2.to_char())
          #|    buf.write_char(x3.to_char())
          #|  }
          #|  if rem == 1 {
          #|    let b0 = data[len - 1].to_int()
          #|    let x0 = base64[(b0 & 0xFC) >> 2]
          #|    let x1 = base64[(b0 & 0x03) << 4]
          #|    buf.write_char(x0.to_char())
          #|    buf.write_char(x1.to_char())
          #|    buf.write_char('=')
          #|    buf.write_char('=')
          #|  } else if rem == 2 {
          #|    let b0 = data[len - 2].to_int()
          #|    let b1 = data[len - 1].to_int()
          #|    let x0 = base64[(b0 & 0xFC) >> 2]
          #|    let x1 = base64[((b0 & 0x03) << 4) | ((b1 & 0xF0) >> 4)]
          #|    let x2 = base64[(b1 & 0x0F) << 2]
          #|    buf.write_char(x0.to_char())
          #|    buf.write_char(x1.to_char())
          #|    buf.write_char(x2.to_char())
          #|    buf.write_char('=')
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "assert_true": build(
        (
          #|pub fn assert_true(x : Bool, msg? : String, loc~ : SourceLoc) -> Unit raise { if !x {
          #|    let fail_msg = match msg {
          #|      Some(msg) => msg
          #|      None => \"`\\{x}` is not true\"
          #|    }
          #|    fail(fail_msg, loc~)
          #|  } }
        ),
      ),
      "alphabet": build(
        (
          #|fn alphabet(x : Int) -> String { match x {
          #|    0 => \"0\"
          #|    1 => \"1\"
          #|    2 => \"2\"
          #|    3 => \"3\"
          #|    4 => \"4\"
          #|    5 => \"5\"
          #|    6 => \"6\"
          #|    7 => \"7\"
          #|    8 => \"8\"
          #|    9 => \"9\"
          #|    10 => \"A\"
          #|    11 => \"B\"
          #|    12 => \"C\"
          #|    13 => \"D\"
          #|    14 => \"E\"
          #|    15 => \"F\"
          #|    _ => abort(\"impossible\")
          #|  } }
        ),
      ),
    }
  },
)

///|
let byte_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/byte", fn(
  _env,
  build,
) {
  {
    "to_uint64": build(
      (
        #|pub fn to_uint64(self : Byte) -> UInt64 { self.to_uint().to_uint64() }
      ),
    ),
  }
})

///|
let bytes_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/bytes",
  fn(_env, build) {
    {
      "gPRIME1": build("0x9E3779B1"),
      "gPRIME2": build("0x85EBCA77"),
      "gPRIME3": build("0xC2B2AE3D"),
      "gPRIME4": build("0x27D4EB2F"),
      "gPRIME5": build("0x165667B1"),
      "xxhash32": build(
        (
          #|fn xxhash32(input : Bytes, seed : Int) -> Int { let len = input.length()
          #|  let h = (if len >= 16 {
          #|      h16bytes(input, 0, len, seed)
          #|    } else {
          #|      seed + gPRIME5
          #|    }) +
          #|    len
          #|  finalize(h, input, len & -16, len & 0xF) }
        ),
      ),
      "length": build(
        (
          #|pub fn View::length(self : View) -> Int { self.len() }
        ),
      ),
      "from_array": build(
        (
          #|pub fn Bytes::from_array(arr : Array[Byte]) -> Bytes { Bytes::makei(arr.length(), i => arr[i]) }
        ),
      ),
    }
  },
)

///|
let char_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/char", fn(
  _env,
  build,
) {
  {
    "is_ascii": build(
      (
        #|pub fn Char::is_ascii(self : Self) -> Bool { self is ('\\u{00}'..='\\u{7F}') }
      ),
    ),
  }
})

///|
let deque_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/deque",
  fn(_env, build) {
    {
      "join": build(
        (
          #|pub fn T::join(self : T[String], separator : @string.View) -> String { let str = separator.to_string()
          #|  self.iter().join(str) }
        ),
      ),
    }
  },
)

///|
let double_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/double",
  fn(_env, build) {
    {
      "sinh": build(
        (
          #|pub fn Double::sinh(self : Double) -> Double { if self.is_nan() || self.is_inf() {
          #|    return self
          #|  }
          #|  let ix = get_high_word(self).reinterpret_as_int() & 0x7fffffff
          #|  let abs_x = self.abs()
          #|  let shuge = 1.0e307
          #|  let h = if self < 0.0 { -0.5 } else { 0.5 }
          #|  if ix < 0x40360000 {
          #|    if ix < 0x3e300000 {
          #|      if shuge + self > 1.0 {
          #|        return self
          #|      }
          #|    }
          #|    let t = abs_x.expm1()
          #|    if ix < 0x3ff00000 {
          #|      return h * (2.0 * t - t * t / (t + 1.0))
          #|    }
          #|    return h * (t + t / (t + 1.0))
          #|  }
          #|  if ix < 0x40862E42 {
          #|    return h * abs_x.exp()
          #|  }
          #|  if abs_x.reinterpret_as_uint64() < 0x408633ce8fb9f87d {
          #|    let w = exp(0.5 * abs_x)
          #|    let t = h * w
          #|    return t * w
          #|  }
          #|  self * shuge }
        ),
      ),
      "set_low_word": build(
        (
          #|fn set_low_word(d : Double, v : UInt) -> Double { let bits : UInt64 = d.reinterpret_as_uint64()
          #|  let bits = bits & 0xFFFF_FFFF_0000_0000
          #|  let bits = bits | v.to_uint64()
          #|  bits.reinterpret_as_double() }
        ),
      ),
      "exp_bias": Int(1023),
      "exp_bits": Int(11),
      "frac_bits": Int(52),
      "trunc": build(
        (
          #|pub fn Double::trunc(self : Double) -> Double { let u64 = self.reinterpret_as_uint64()
          #|  let biased_exp = ((u64 >> frac_bits) & ((0x1UL << exp_bits) - 1)).to_int()
          #|  if biased_exp < exp_bias {
          #|    return (u64 & sign_mask).reinterpret_as_double()
          #|  } else if biased_exp >= exp_bias + frac_bits {
          #|    return self
          #|  }
          #|  let mask_shift = biased_exp - exp_bias + exp_bits
          #|  let trunc_mask = (sign_mask.reinterpret_as_int64() >> mask_shift).reinterpret_as_uint64()
          #|  return (u64 & trunc_mask).reinterpret_as_double() }
        ),
      ),
      "pow": build(
        (
          #|pub fn Double::pow(self : Double, other : Double) -> Double { fn set_low_word(d : Double, v : UInt) -> Double {
          #|    let bits : UInt64 = d.reinterpret_as_uint64()
          #|    let bits = bits & 0xFFFF_FFFF_0000_0000
          #|    let bits = bits | v.to_uint64()
          #|    bits.reinterpret_as_double()
          #|  }
          #|  fn set_high_word(d : Double, v : UInt) -> Double {
          #|    let bits : UInt64 = d.reinterpret_as_uint64()
          #|    let bits = bits & 0x0000_0000_FFFF_FFFF
          #|    let bits = bits | (v.to_uint64() << 32)
          #|    bits.reinterpret_as_double()
          #|  }
          #|  fn get_high_word(x : Double) -> UInt {
          #|    (x.reinterpret_as_uint64() >> 32).to_uint()
          #|  }
          #|  fn get_low_word(x : Double) -> UInt {
          #|    x.reinterpret_as_uint64().to_uint()
          #|  }
          #|  let x = self
          #|  let y = other
          #|  // double z, ax, z_h, z_l, p_h, p_l;
          #|  let mut z : Double = 0.0
          #|  let mut ax : Double = 0.0
          #|  let mut z_h : Double = 0.0
          #|  let mut z_l : Double = 0.0
          #|  let mut p_h : Double = 0.0
          #|  let mut p_l : Double = 0.0
          #|  // double y1, t1, t2, r, s, t, u, v, w
          #|  let mut y1 : Double = 0.0
          #|  let mut t1 : Double = 0.0
          #|  let mut t2 : Double = 0.0
          #|  let mut r : Double = 0.0
          #|  let mut s : Double = 0.0
          #|  let mut t : Double = 0.0
          #|  let mut u : Double = 0.0
          #|  let mut v : Double = 0.0
          #|  let mut w : Double = 0.0
          #|  // int i, j, k, yisint, n
          #|  let mut i : Int = 0
          #|  let mut j : Int = 0
          #|  let mut k : Int = 0
          #|  let mut yisint : Int = 0
          #|  let mut n : Int = 0
          #|  // int hx, hy, ix, iy;
          #|  // unsigned lx, ly;
          #|  //
          #|  // EXTRACT_WORDS(hx, lx, x);
          #|  // EXTRACT_WORDS(hy, ly, y);
          #|  // ix = hx & 0x7fffffff;
          #|  // iy = hy & 0x7fffffff;
          #|  let hx : Int = (x.reinterpret_as_uint64() >> 32).to_int()
          #|  let lx : UInt = (x.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
          #|  let hy : Int = (y.reinterpret_as_uint64() >> 32).to_int()
          #|  let ly : UInt = (y.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
          #|  let mut ix : Int = hx & 0x7FFFFFFF
          #|  let iy : Int = hy & 0x7FFFFFFF
          #|  // y==zero: x**0 = 1
          #|  if (iy.reinterpret_as_uint() | ly) == 0 {
          #|    return ONE
          #|  }
          #|  // +-NaN return x+y
          #|  if ix > 0x7FF00000 ||
          #|    (ix == 0x7FF00000 && lx != 0) ||
          #|    iy > 0x7FF00000 ||
          #|    (iy == 0x7FF00000 && ly != 0) {
          #|    return x + y
          #|  }
          #|  // determine if y is an odd int when x < 0
          #|  // yisint = 0 ... y is not an integer
          #|  // yisint = 1 ... y is an odd int
          #|  // yisint = 2 ... y is an even int
          #|  if hx < 0 {
          #|    if iy >= 0x43400000 {
          #|      yisint = 2 // even integer y
          #|    } else if iy >= 0x3ff00000 {
          #|      k = (iy >> 20) - 0x3ff // exponent
          #|      if k > 20 {
          #|        j = (ly >> (52 - k)).reinterpret_as_int()
          #|        if j << (52 - k) == ly.reinterpret_as_int() {
          #|          yisint = 2 - (j & 1)
          #|        }
          #|      } else if ly == 0 {
          #|        j = iy >> (20 - k)
          #|        if j << (20 - k) == iy {
          #|          yisint = 2 - (j & 1)
          #|        }
          #|      }
          #|    }
          #|  }
          #|  // special value of y
          #|  if ly == 0 {
          #|    if iy == 0x7ff00000 { // y is +-inf
          #|      if ((ix.reinterpret_as_uint() - 0x3ff00000) | lx) == 0 {
          #|        return y - y // inf**+-1 is NaN
          #|      } else if ix >= 0x3ff00000 { // (|x|>1)**+-inf = inf,0
          #|        return if hy >= 0 { y } else { ZERO }
          #|      } else { // (|x|<1)**-,+inf = inf,0
          #|        return if hy < 0 { -y } else { ZERO }
          #|      }
          #|    }
          #|    if iy == 0x3ff00000 { // y is  +-1
          #|      if hy < 0 {
          #|        return ONE / x
          #|      } else {
          #|        return x
          #|      }
          #|    }
          #|    if hy == 0x40000000 { // y is 2
          #|      return x * x
          #|    }
          #|    if hy == 0x3fe00000 { // y is 0.5
          #|      if hx >= 0 { // x >= +0
          #|        return x.sqrt()
          #|      }
          #|    }
          #|  }
          #|  ax = x.abs()
          #|  // special value of x
          #|  if lx == 0 {
          #|    if ix == 0x7ff00000 || ix == 0 || ix == 0x3ff00000 {
          #|      z = ax // x is +-0,+-inf,+-1 */
          #|      if hy < 0 {
          #|        z = ONE / z // z = (1/|x|)
          #|      }
          #|      if hx < 0 {
          #|        if ((ix - 0x3ff00000) | yisint) == 0 {
          #|          // (-1)**non-int is NaN
          #|          z = not_a_number
          #|        } else if yisint == 1 {
          #|          z = -z // (x<0)**odd = -(|x|**odd)
          #|        }
          #|      }
          #|      return z
          #|    }
          #|  }
          #|  n = (hx >> 31) + 1
          #|  // (x<0)**(non-int) is NaN
          #|  if (n | yisint) == 0 {
          #|    return not_a_number
          #|  }
          #|  s = ONE // s (sign of result -ve**odd) = -1 else = 1
          #|  if (n | (yisint - 1)) == 0 {
          #|    s = -ONE // (-ve)**(odd int)
          #|  }
          #|  // |y| is huge
          #|  if iy > 0x41e00000 { // if |y| > 2**31 */
          #|    if iy > 0x43f00000 { // if |y| > 2**64, must o/uflow */
          #|      if ix <= 0x3fefffff {
          #|        return if hy < 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
          #|      }
          #|      if ix >= 0x3ff00000 {
          #|        return if hy > 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
          #|      }
          #|    }
          #|    // over/underflow if x is not close to one */
          #|    if ix < 0x3fefffff {
          #|      return if hy < 0 {
          #|        s * POW_huge * POW_huge
          #|      } else {
          #|        s * POW_tiny * POW_tiny
          #|      }
          #|    }
          #|    if ix > 0x3ff00000 {
          #|      return if hy > 0 {
          #|        s * POW_huge * POW_huge
          #|      } else {
          #|        s * POW_tiny * POW_tiny
          #|      }
          #|    }
          #|    // now |1-x| is tiny <= 2**-20, suffice to compute
          #|    // log(x) by x-x^2/2+x^3/3-x^4/4 */
          #|    t = ax - ONE // t has 20 trailing zeros */
          #|    w = t * t * (0.5 - t * (0.3333333333333333333333 - t * 0.25))
          #|    u = POW_ivln2_h * t // POW_ivln2_h has 21 sig. bits */
          #|    v = t * POW_ivln2_l - w * POW_ivln2
          #|    t1 = u + v
          #|    t1 = set_low_word(t1, 0)
          #|    t2 = v - (t1 - u)
          #|  } else {
          #|    n = 0
          #|    // take care subnormal number
          #|    if ix < 0x00100000 {
          #|      ax *= POW_two53
          #|      n -= 53
          #|      ix = get_high_word(ax).reinterpret_as_int()
          #|    }
          #|    n += (ix >> 20) - 0x3ff
          #|    j = ix & 0x000fffff
          #|    // determine interval
          #|    ix = j | 0x3ff00000 // normalize ix
          #|    if j <= 0x3988E {
          #|      k = 0 // |x|<sqrt(3/2)
          #|    } else if j < 0xBB67A {
          #|      k = 1 // |x|<sqrt(3)
          #|    } else {
          #|      k = 0
          #|      n += 1
          #|      ix -= 0x00100000
          #|    }
          #|    ax = set_high_word(ax, ix.reinterpret_as_uint())
          #|    // compute ss = s_h+s_l = (x-1)/(x+1) or (x-1.5)/(x+1.5)
          #|    u = ax - pow_bp[k] // bp[0]=1.0, bp[1]=1.5
          #|    v = ONE / (ax + pow_bp[k])
          #|    let ss : Double = u * v
          #|    let mut s_h : Double = ss
          #|    s_h = set_low_word(s_h, 0)
          #|    // t_h=ax+bp[k] High
          #|    let mut t_h : Double = ZERO
          #|    t_h = set_high_word(
          #|      t_h,
          #|      ((ix.reinterpret_as_uint() >> 1) | 0x20000000) +
          #|      0x00080000 +
          #|      (k.reinterpret_as_uint() << 18),
          #|    )
          #|    let mut t_l : Double = ax - (t_h - pow_bp[k])
          #|    let s_l : Double = v * (u - s_h * t_h - s_h * t_l)
          #|    // compute log(ax)
          #|    let mut s2 : Double = ss * ss
          #|    r = s2 *
          #|      s2 *
          #|      (
          #|        POW_L1 +
          #|        s2 *
          #|        (POW_L2 + s2 * (POW_L3 + s2 * (POW_L4 + s2 * (POW_L5 + s2 * POW_L6))))
          #|      )
          #|    r += s_l * (s_h + ss)
          #|    s2 = s_h * s_h
          #|    t_h = 3.0 + s2 + r
          #|    t_h = set_low_word(t_h, 0)
          #|    t_l = r - (t_h - 3.0 - s2)
          #|    // u+v = ss*(1+...)
          #|    u = s_h * t_h
          #|    v = s_l * t_h + t_l * ss
          #|    // 2/(3log2)*(ss+...)
          #|    p_h = u + v
          #|    p_h = set_low_word(p_h, 0)
          #|    p_l = v - (p_h - u)
          #|    z_h = POW_cp_h * p_h // cp_h+cp_l = 2/(3*log2)
          #|    z_l = POW_cp_l * p_h + p_l * POW_cp + pow_dp_l[k]
          #|    // log2(ax) = (ss+..)*2/(3*log2) = n + dp_h + z_h + z_l
          #|    t = n.to_double()
          #|    t1 = z_h + z_l + pow_dp_h[k] + t
          #|    t1 = set_low_word(t1, 0)
          #|    t2 = z_l - (t1 - t - pow_dp_h[k] - z_h)
          #|  }
          #|  // split up y into y1+y2 and compute (y1+y2)*(t1+t2)
          #|  y1 = y
          #|  y1 = set_low_word(y1, 0)
          #|  p_l = (y - y1) * t1 + y * t2
          #|  p_h = y1 * t1
          #|  z = p_l + p_h
          #|  j = get_high_word(z).reinterpret_as_int()
          #|  i = get_low_word(z).reinterpret_as_int()
          #|  if j >= 0x40900000 { // z >= 1024
          #|    if ((j - 0x40900000) | i) != 0 { // if z > 1024
          #|      return s * POW_huge * POW_huge // overflow
          #|    } else if p_l + POW_ovt > z - p_h {
          #|      return s * POW_huge * POW_huge // overflow
          #|    }
          #|  } else if (j & 0x7fffffff) >= 0x4090cc00 { // z <= -1075
          #|    if ((j - 0xc090cc00) | i) != 0 { // z < -1075
          #|      return s * POW_tiny * POW_tiny // underflow
          #|    } else if p_l <= z - p_h {
          #|      return s * POW_tiny * POW_tiny // underflow
          #|    }
          #|  }
          #|  //
          #|  // compute 2**(p_h+p_l)
          #|  //
          #|  i = j & 0x7fffffff
          #|  k = (i >> 20) - 0x3ff
          #|  n = 0
          #|  if i > 0x3fe00000 { // if |z| > 0.5, set n = [z+0.5]
          #|    n = j + (0x00100000 >> (k + 1))
          #|    k = ((n & 0x7fffffff) >> 20) - 0x3ff // new k for n
          #|    t = ZERO
          #|    t = set_high_word(t, (n & (0x000fffff >> k).lnot()).reinterpret_as_uint())
          #|    n = ((n & 0x000fffff) | 0x00100000) >> (20 - k)
          #|    if j < 0 {
          #|      n = -n
          #|    }
          #|    p_h -= t
          #|  }
          #|  t = p_l + p_h
          #|  t = set_low_word(t, 0)
          #|  u = t * POW_lg2_h
          #|  v = (p_l - (t - p_h)) * POW_lg2 + t * POW_lg2_l
          #|  z = u + v
          #|  w = v - (z - u)
          #|  t = z * z
          #|  t1 = z -
          #|    t * (POW_P1 + t * (POW_P2 + t * (POW_P3 + t * (POW_P4 + t * POW_P5))))
          #|  r = z * t1 / (t1 - TWO - (w + z * w))
          #|  z = ONE - (r - z)
          #|  j = get_high_word(z).reinterpret_as_int()
          #|  j += (n.reinterpret_as_uint() << 20).reinterpret_as_int()
          #|  if j >> 20 <= 0 {
          #|    z = scalbn(z, n)
          #|  } else { // subnormal output */
          #|    let tmp = get_high_word(z).reinterpret_as_int()
          #|    z = set_high_word(
          #|      z,
          #|      (tmp + (n.reinterpret_as_uint() << 20).reinterpret_as_int()).reinterpret_as_uint(),
          #|    )
          #|  }
          #|  return s * z }
        ),
      ),
      "from_int": build(
        (
          #|pub fn Double::from_int(i : Int) -> Double { i.to_double() }
        ),
      ),
      "hypot": build(
        (
          #|pub fn Double::hypot(self : Double, y : Double) -> Double { if self.is_nan() || y.is_nan() {
          #|    return not_a_number
          #|  }
          #|  if self.is_inf() || y.is_inf() {
          #|    return infinity
          #|  }
          #|  let x = self.abs()
          #|  let y = y.abs()
          #|  let double_epsilon : Double = 0x0.0000000000001P-1022
          #|  let (x, y) = if y > x { (y, x) } else { (x, y) }
          #|  if x * double_epsilon >= y {
          #|    return x
          #|  }
          #|  let r = y / x
          #|  x * (1.0 + r * r).sqrt() }
        ),
      ),
      "nan": build(
        (
          #|pub fn Double::nan() -> Double { not_a_number }
        ),
      ),
      "exp": build(
        (
          #|pub fn Double::exp(self : Double) -> Double { fn get_high_word(x : Double) -> UInt {
          #|    (x.reinterpret_as_uint64() >> 32).to_uint()
          #|  }
          #|  fn get_low_word(x : Double) -> UInt {
          #|    x.reinterpret_as_uint64().to_uint()
          #|  }
          #|  fn insert_words(ix0 : UInt64, ix1 : UInt64) -> Double {
          #|    let mut bits : UInt64 = 0
          #|    bits = bits | (ix0 << 32)
          #|    bits = bits | ix1
          #|    bits.reinterpret_as_double()
          #|  }
          #|  let mut x = self
          #|  let one = 1.0
          #|  let halF = [0.5, -0.5]
          #|  let o_threshold = 7.09782712893383973096e+02
          #|  let u_threshold = -7.45133219101941108420e+02
          #|  let ln2HI = [6.93147180369123816490e-01, -6.93147180369123816490e-01]
          #|  let ln2LO = [1.90821492927058770002e-10, -1.90821492927058770002e-10]
          #|  let invln2 = 1.44269504088896338700e+00
          #|  let p1 = 1.66666666666666019037e-01
          #|  let p2 = -2.77777777770155933842e-03
          #|  let p3 = 6.61375632143793436117e-05
          #|  let p4 = -1.65339022054652515390e-06
          #|  let p5 = 4.13813679705723846039e-08
          #|  let e = 2.718281828459045
          #|  let mut hi = 0.0
          #|  let mut lo = 0.0
          #|  let huge = 1.0e+300
          #|  let twom1000 = 9.33263618503218878990e-302
          #|  let two1023 = 8.988465674311579539e307
          #|  let mut k : Int = 0
          #|  let mut hx : UInt = get_high_word(self)
          #|  let xsb : Int = ((hx >> 31) & 1).reinterpret_as_int()
          #|  hx = hx & 0x7FFFFFFF
          #|  if hx >= 0x40862E42 {
          #|    if hx >= 0x7FF00000 {
          #|      let lx : UInt = get_low_word(self)
          #|      if ((hx & 0xFFFFF) | lx) != 0 {
          #|        return self + self
          #|      } else if xsb == 0 {
          #|        return self
          #|      } else {
          #|        return 0.0
          #|      }
          #|    }
          #|    if self > o_threshold {
          #|      return huge * huge
          #|    }
          #|    if self < u_threshold {
          #|      return twom1000 * twom1000
          #|    }
          #|  }
          #|  if hx > 0x3FD62E42 {
          #|    if hx < 0x3FF0A2B2 {
          #|      if self == 1.0 {
          #|        return e
          #|      }
          #|      hi = self - ln2HI[xsb]
          #|      lo = ln2LO[xsb]
          #|      k = 1 - xsb - xsb
          #|    } else {
          #|      k = (invln2 * self + halF[xsb]).to_int()
          #|      let t = k.to_double()
          #|      hi = self - t * ln2HI[0]
          #|      lo = t * ln2LO[0]
          #|    }
          #|    x = hi - lo
          #|  } else if hx < 0x3E300000 {
          #|    if huge + x > one {
          #|      return one + x
          #|    }
          #|  } else {
          #|    k = 0
          #|  }
          #|  let t = x * x
          #|  let twopk = if k >= -1021 {
          #|    insert_words(
          #|      (0x3FF00000 + (k.reinterpret_as_uint() << 20).reinterpret_as_int())
          #|      .to_int64()
          #|      .reinterpret_as_uint64(),
          #|      0,
          #|    )
          #|  } else {
          #|    insert_words(
          #|      0x3FF00000UL + ((k + 1000).reinterpret_as_uint() << 20).to_uint64(),
          #|      0,
          #|    )
          #|  }
          #|  let c = x - t * (p1 + t * (p2 + t * (p3 + t * (p4 + t * p5))))
          #|  if k == 0 {
          #|    return one - (x * c / (c - 2.0) - x)
          #|  }
          #|  let y = one - (lo - x * c / (2.0 - c) - hi)
          #|  if k >= -1021 {
          #|    if k == 1024 {
          #|      return y * 2.0 * two1023
          #|    } else {
          #|      return y * twopk
          #|    }
          #|  } else {
          #|    return y * twopk * twom1000
          #|  } }
        ),
      ),
      "round": build(
        (
          #|pub fn Double::round(self : Double) -> Double { floor(self + 0.5) }
        ),
      ),
      "to_uint": build(
        (
          #|pub fn to_uint(self : Double) -> UInt { if self != self {
          #|    0
          #|  } else if self >= 4294967295.0 {
          #|    4294967295U
          #|  } else if self <= 0 {
          #|    0
          #|  } else {
          #|    UInt::trunc_double(self)
          #|  } }
        ),
      ),
      "scalbn": build(
        (
          #|fn scalbn(x : Double, exp : Int) -> Double { let mut n = exp
          #|  let mut y : Double = x
          #|  if n > 1023 {
          #|    y *= 0x1.0p1023
          #|    n -= 1023
          #|    if n > 1023 {
          #|      y *= 0x1.0p1023
          #|      n -= 1023
          #|      if n > 1023 {
          #|        n = 1023
          #|      }
          #|    }
          #|  } else if n < -1022 {
          #|    // make sure final n < -53 to avoid double
          #|    // rounding in the subnormal range
          #|    y *= 0x1.0p-1022 * 0x1.0p53
          #|    n += 1022 - 53
          #|    if n < -1022 {
          #|      y *= 0x1.0p-1022 * 0x1.0p53
          #|      n += 1022 - 53
          #|      if n < -1022 {
          #|        n = -1022
          #|      }
          #|    }
          #|  }
          #|  let ui = (0x3ff + n).to_uint64() << 52
          #|  return y * ui.reinterpret_as_double() }
        ),
      ),
      "sqrt2": build(
        "1.41421356237309504880168872420969807856967187537694807317667974",
      ),
      "ln2": build(
        "0.693147180559945309417232121458176568075500134360255254120680009",
      ),
      "ln2_hi": build("6.93147180369123816490e-01 // 3fe62e42 fee00000"),
      "ln2_lo": build("1.90821492927058770002e-10 // 3dea39ef 35793c76"),
      "l1": build("6.666666666666735130e-01 // 3FE55555 55555593"),
      "l2": build("3.999999999940941908e-01 // 3FD99999 9997FA04"),
      "l3": build("2.857142874366239149e-01 // 3FD24924 94229359"),
      "l4": build("2.222219843214978396e-01 // 3FCC71C5 1D8E78AF"),
      "l5": build("1.818357216161805012e-01 // 3FC74664 96CB03DE"),
      "l6": build("1.531383769920937332e-01 // 3FC39A09 D078C69F"),
      "l7": build("1.479819860511658591e-01 // 3FC2F112 DF3E5244"),
      "normalize": build(
        (
          #|fn normalize(f : Double) -> (Double, Int) { if f.abs() < min_positive {
          #|    return (f * (1L << 52).to_double(), -52)
          #|  }
          #|  (f, 0) }
        ),
      ),
      "cbrt": build(
        (
          #|pub fn Double::cbrt(self : Double) -> Double { if self.is_inf() || self.is_nan() || self == 0.0 {
          #|    return self
          #|  }
          #|  let b1 : UInt = 715094163 // B1 = (682-0.03306235651)*2**20
          #|  let b2 : UInt = 696219795 // B2 = (664-0.03306235651)*2**20
          #|  let c = 5.42857142857142815906e-01 // 19/35     = 0x3FE15F15, 0xF15F15F1
          #|  let d = -7.05306122448979611050e-01 // -864/1225 = 0xBFE691DE, 0x2532C834
          #|  let e = 1.41428571428571436819e+00 // 99/70     = 0x3FF6A0EA, 0x0EA0EA0F
          #|  let f = 1.60714285714285720630e+00 // 45/28     = 0x3FF9B6DB, 0x6DB6DB6E
          #|  let g = 3.57142857142857150787e-01 // 5/14      = 0x3FD6DB6D, 0xB6DB6DB7
          #|  let hx = get_high_word(self).reinterpret_as_int()
          #|  let sign = if self < 0.0 { true } else { false }
          #|  let self = abs(self)
          #|  let t = if hx < 0x00100000 {
          #|    let t : UInt64 = 0x43500000_00000000
          #|    let t : Double = t.reinterpret_as_double()
          #|    let t = t * self
          #|    set_high_word(0, get_high_word(t) / 3 + b2)
          #|  } else {
          #|    set_high_word(0, hx.reinterpret_as_uint() / 3 + b1)
          #|  }
          #|  let r = t * t / self
          #|  let s = c + r * t
          #|  let t = t * (g + f / (s + e + d / s))
          #|  let t = set_high_word(0, get_high_word(t) + 0x00000001)
          #|  let s = t * t
          #|  let r = self / s
          #|  let w = t + t
          #|  let r = (r - t) / (w + r)
          #|  let t = t + t * r
          #|  if sign {
          #|    -t
          #|  } else {
          #|    t
          #|  } }
        ),
      ),
    }
  },
)

///|
let env_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/env", fn(
  _env,
  build,
) {
  {
    "args": build(
      (
        #|pub fn args() -> Array[String] { get_cli_args_internal() }
      ),
    ),
    "string_from_extern": build(
      (
        #|fn string_from_extern(e : XExternString) -> String { let buf = StringBuilder::new()
        #|  let handle = begin_read_string(e)
        #|  while true {
        #|    let ch = string_read_char(handle)
        #|    if ch == -1 {
        #|      break
        #|    } else {
        #|      buf.write_char(ch.unsafe_to_char())
        #|    }
        #|  }
        #|  finish_read_string(handle)
        #|  buf.to_string() }
      ),
    ),
    "get_cli_args_internal": build(
      (
        #|fn get_cli_args_internal() -> Array[String] { let tmp = get_cli_args_ffi()
        #|  let res = Array::new(capacity=tmp.length())
        #|  for i in 0..<tmp.length() {
        #|    res.push(utf8_bytes_to_mbt_string(tmp[i]))
        #|  }
        #|  res }
      ),
    ),
  }
})

///|
let float_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/float",
  fn(_env, build) {
    {
      "exp_bias": Int(127),
      "exp_bits": Int(8),
      "frac_bits": Int(23),
      "trunc": build(
        (
          #|pub fn Float::trunc(self : Float) -> Float { let u32 = self.reinterpret_as_uint()
          #|  let biased_exp = ((u32 >> frac_bits) & ((0x1U << exp_bits) - 1)).reinterpret_as_int()
          #|  if biased_exp < exp_bias {
          #|    return (u32 & sign_mask).reinterpret_as_float()
          #|  } else if biased_exp >= exp_bias + frac_bits {
          #|    return self
          #|  }
          #|  let mask_shift = biased_exp - exp_bias + exp_bits
          #|  let trunc_mask = (sign_mask.reinterpret_as_int() >> mask_shift).reinterpret_as_uint()
          #|  return (u32 & trunc_mask).reinterpret_as_float() }
        ),
      ),
      "default": build(
        (
          #|pub fn default() -> Float { 0.0 }
        ),
      ),
      "cbrt": build(
        (
          #|pub fn Float::cbrt(self : Float) -> Float { let b1 : UInt = 709958130 // B1 = (127-127.0/3-0.03306235651)*2**23 */
          #|  let b2 : UInt = 642849266 // B2 = (127-127.0/3-24/3-0.03306235651)*2**23 */
          #|  let mut ui : UInt = self.reinterpret_as_uint()
          #|  let mut hx : UInt = ui & 0x7fffffff
          #|  if hx >= 0x7f800000 {
          #|    // cbrt(NaN,INF) is itx
          #|    return self + self
          #|  }
          #|  // rough cbrt to 5 bits
          #|  if hx < 0x00800000 {
          #|    // zero or subnormal?
          #|    if hx == 0 {
          #|      return self
          #|    } // cbrt(+-0) is itx
          #|    ui = (self * (0x1.0p24 : Float)).reinterpret_as_uint()
          #|    hx = ui & 0x7fffffff
          #|    hx = hx / 3 + b2
          #|  } else {
          #|    hx = hx / 3 + b1
          #|  }
          #|  ui = ui & 0x80000000
          #|  ui = ui | hx
          #|  //
          #|  // First step Newton iteration (solving t*t-x/t == 0) to 16 bits.  In
          #|  // double precision so that its terms can be arranged for efficiency
          #|  // without causing overflow or underflow.
          #|  //
          #|  let dx = self.to_double()
          #|  let t = ui.reinterpret_as_float().to_double()
          #|  let r = t * t * t
          #|  let t = t * (dx + dx + r) / (dx + r + r)
          #|  //
          #|  // Second step Newton iteration to 47 bits.  In double precision for
          #|  // efficiency and accuracy.
          #|  //
          #|  let r = t * t * t
          #|  let t = t * (dx + dx + r) / (dx + r + r)
          #|  // rounding to 24 bits is perfect in round-to-nearest mode
          #|  t.to_float() }
        ),
      ),
      "logf_off": UInt(0x3f330000U),
      "logf_table_bits": Int(4),
      "k_expo2f": build(
        (
          #|fn k_expo2f(x : Float) -> Float { let k = 235
          #|  let k_ln2 = (0x4322e3bc).reinterpret_as_float()
          #|  // note that k is odd and scale*scale overflows */
          #|  let scale = ((0x7f + k / 2) << 23).reinterpret_as_float()
          #|  // exp(x - k ln2) * 2**(k-1) */
          #|  (x - k_ln2).exp() * scale * scale }
        ),
      ),
      "round": build(
        (
          #|pub fn Float::round(self : Float) -> Float { floor(self + 0.5) }
        ),
      ),
      "mulh": build(
        (
          #|fn mulh(a : UInt, b : UInt) -> UInt { let a = a.to_uint64()
          #|  let b = b.to_uint64()
          #|  let res = a * b
          #|  (res >> 32).to_uint() }
        ),
      ),
      "top12": build(
        (
          #|fn top12(x : Float) -> UInt { x.reinterpret_as_uint() >> 20 }
        ),
      ),
      "pow": build(
        (
          #|pub fn Float::pow(self : Float, other : Float) -> Float { self.to_double().pow(other.to_double()).to_float() }
        ),
      ),
      "to_int": build(
        (
          #|pub fn to_int(self : Float) -> Int { if self != self {
          #|    0
          #|  } else if self >= 2147483647 {
          #|    2147483647
          #|  } else if self <= -2147483648 {
          #|    -2147483648
          #|  } else {
          #|    self.to_unchecked_int()
          #|  } }
        ),
      ),
    }
  },
)

///|
let hashset_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/hashset",
  fn(_env, build) {
    {
      "default_init_capacity": Int(8),
      "abs": build(
        (
          #|fn abs(n : Int) -> Int { if n < 0 {
          #|    -n
          #|  } else {
          #|    n
          #|  } }
        ),
      ),
    }
  },
)

///|
let int_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/int", fn(
  _env,
  build,
) {
  {
    "max_value": Int(2147483647),
    "min_value": Int(-2147483648),
    "abs": build(
      (
        #|pub fn Int::abs(self : Int) -> Int { if self < 0 {
        #|    -self
        #|  } else {
        #|    self
        #|  } }
      ),
    ),
  }
})

///|
let int16_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int16",
  fn(_env, build) {
    {
      "abs": build(
        (
          #|pub fn Int16::abs(self : Int16) -> Int16 { if self < 0 {
          #|    -self
          #|  } else {
          #|    self
          #|  } }
        ),
      ),
    }
  },
)

///|
let int64_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/int64",
  fn(_env, build) {
    {
      "max_value": Int64(9223372036854775807L),
      "min_value": Int64(-9223372036854775808L),
      "from_int": build(
        (
          #|pub fn Int64::from_int(i : Int) -> Int64 { i.to_int64() }
        ),
      ),
      "gPRIME2": UInt(0x85EBCA77U),
      "gPRIME3": UInt(0xC2B2AE3DU),
      "gPRIME4": UInt(0x27D4EB2FU),
      "gPRIME5": UInt(0x165667B1U),
      "slow_hash": build(
        (
          #|fn slow_hash(self : Int64) -> Int { let self = self.reinterpret_as_uint64()
          #|  let b : Bytes = [
          #|    (self & 0xFF).to_byte(),
          #|    ((self >> 8) & 0xFF).to_byte(),
          #|    ((self >> 16) & 0xFF).to_byte(),
          #|    ((self >> 24) & 0xFF).to_byte(),
          #|    ((self >> 32) & 0xFF).to_byte(),
          #|    ((self >> 40) & 0xFF).to_byte(),
          #|    ((self >> 48) & 0xFF).to_byte(),
          #|    ((self >> 56) & 0xFF).to_byte(),
          #|  ]
          #|  b.hash() }
        ),
      ),
    }
  },
)

///|
let json_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/json", fn(
  _env,
  build,
) {
  {
    "read_char": build(
      (
        #|fn ParseContext::read_char(ctx : ParseContext) -> Char? { if ctx.offset < ctx.end_offset {
        #|    let c1 = ctx.input.unsafe_charcode_at(ctx.offset)
        #|    ctx.offset += 1
        #|    if c1 >= 0xD800 && c1 <= 0xDBFF {
        #|      if ctx.offset < ctx.end_offset {
        #|        let c2 = ctx.input.unsafe_charcode_at(ctx.offset)
        #|        if c2 >= 0xDC00 && c2 <= 0xDFFF {
        #|          ctx.offset += 1
        #|          let c3 = (c1 << 10) + c2 - 0x35fdc00
        #|          return Some(c3.unsafe_to_char())
        #|        }
        #|      }
        #|    }
        #|    Some(c1.unsafe_to_char())
        #|  } else {
        #|    None
        #|  } }
      ),
    ),
    "as_null": build(
      (
        #|pub fn as_null(self : JsonValue) -> Unit? { guard self is Null else { return None }
        #|  Some(()) }
      ),
    ),
    "add_index": build(
      (
        #|pub fn add_index(self : JsonPath, index : Int) -> JsonPath { Index(self, index~) }
      ),
    ),
    "lex_string": build(
      (
        #|fn ParseContext::lex_string(ctx : ParseContext) -> String raise ParseError { let buf = StringBuilder::new()
        #|  let mut start = ctx.offset
        #|  fn flush(end : Int) {
        #|    if start > 0 && end > start {
        #|      buf.write_substring(ctx.input, start, end - start)
        #|    }
        #|  }
        #|  for {
        #|    match ctx.read_char() {
        #|      Some('\"') => {
        #|        flush(ctx.offset - 1)
        #|        break
        #|      }
        #|      Some('\\n' | '\\r') => ctx.invalid_char(shift=-1)
        #|      Some('\\\\') => {
        #|        flush(ctx.offset - 1)
        #|        match ctx.read_char() {
        #|          Some('b') => buf.write_char('\\b')
        #|          Some('f') => buf.write_char('\\u{0C}')
        #|          Some('n') => buf.write_char('\\n')
        #|          Some('r') => buf.write_char('\\r')
        #|          Some('t') => buf.write_char('\\t')
        #|          Some('\"') => buf.write_char('\"')
        #|          Some('\\\\') => buf.write_char('\\\\')
        #|          Some('/') => buf.write_char('/')
        #|          Some('u') => {
        #|            let c = ctx.lex_hex_digits(4)
        #|            buf.write_char(c.unsafe_to_char())
        #|          }
        #|          Some(_) => ctx.invalid_char(shift=-1)
        #|          None => raise InvalidEof
        #|        }
        #|        start = ctx.offset
        #|      }
        #|      Some(ch) =>
        #|        if ch.to_int() < 32 {
        #|          ctx.invalid_char(shift=-1)
        #|        } else {
        #|          continue
        #|        }
        #|      None => raise InvalidEof
        #|    }
        #|  }
        #|  buf.to_string() }
      ),
    ),
    "valid": build(
      (
        #|pub fn valid(input : String) -> Bool { try {
        #|    parse(input) |> ignore
        #|    true
        #|  } catch {
        #|    _ => return false
        #|  } }
      ),
    ),
    "offset_to_position": build(
      (
        #|fn offset_to_position(input : String, offset : Int) -> Position { let mut line = 1
        #|  let mut column = 0
        #|  for i in 0..<offset {
        #|    if input.unsafe_charcode_at(i) == '\\n' {
        #|      line += 1
        #|      column = 0
        #|    } else {
        #|      column += 1
        #|    }
        #|  }
        #|  return Position::{ line, column } }
      ),
    ),
    "make": build(
      (
        #|fn ParseContext::make(input : String) -> ParseContext { { offset: 0, input, end_offset: input.length() } }
      ),
    ),
  }
})

///|
let math_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/math", fn(
  _env,
  build,
) {
  {
    "ln": build(
      (
        #|pub fn ln(x : Double) -> Double { let l1 = 6.666666666666735130e-01 // 3FE55555 55555593
        #|  let l2 = 3.999999999940941908e-01 // 3FD99999 9997FA04
        #|  let l3 = 2.857142874366239149e-01 // 3FD24924 94229359
        #|  let l4 = 2.222219843214978396e-01 // 3FCC71C5 1D8E78AF
        #|  let l5 = 1.818357216161805012e-01 // 3FC74664 96CB03DE
        #|  let l6 = 1.531383769920937332e-01 // 3FC39A09 D078C69F
        #|  let l7 = 1.479819860511658591e-01 // 3FC2F112 DF3E5244
        #|  if x < 0.0 {
        #|    return @double.not_a_number
        #|  } else if x.is_nan() || x.is_inf() {
        #|    return x
        #|  } else if x == 0.0 {
        #|    return @double.neg_infinity
        #|  }
        #|  let (f1, ki) = frexp(x)
        #|  let (f, k) = if f1 < SQRT2 / 2.0 {
        #|    (f1 * 2.0 - 1.0, (ki - 1).to_double())
        #|  } else {
        #|    (f1 - 1.0, ki.to_double())
        #|  }
        #|  let s = f / (2.0 + f)
        #|  let s2 = s * s
        #|  let s4 = s2 * s2
        #|  let t1 = s2 * (l1 + s4 * (l3 + s4 * (l5 + s4 * l7)))
        #|  let t2 = s4 * (l2 + s4 * (l4 + s4 * l6))
        #|  let r = t1 + t2
        #|  let hfsq = 0.5 * f * f
        #|  k * LN2_HI - (hfsq - (s * (hfsq + r) + k * LN2_LO) - f) }
      ),
    ),
    "sin": build(
      (
        #|pub fn sin(x : Double) -> Double { if x.is_inf() || x.is_nan() {
        #|    return @double.not_a_number
        #|  }
        #|  let y = [0.0, 0.0]
        #|  let z = 0.0
        #|  if x.abs() <= PI_OVER_4 {
        #|    return __kernel_sin(x, z, 0)
        #|  } else {
        #|    let n = rem_pio2(x, y)
        #|    match n & 3 {
        #|      0 => __kernel_sin(y[0], y[1], 1)
        #|      1 => __kernel_cos(y[0], y[1])
        #|      2 => -__kernel_sin(y[0], y[1], 1)
        #|      _ => -__kernel_cos(y[0], y[1])
        #|    }
        #|  } }
      ),
    ),
    "probable_prime": build(
      (
        #|pub fn probable_prime(bits : Int, rand : @random.Rand) -> @bigint.BigInt { for {
        #|    let b = rand.bigint(bits)
        #|    if is_probable_prime(b, rand) {
        #|      break b
        #|    }
        #|  } }
      ),
    ),
    "sinh": build(
      (
        #|pub fn sinh(x : Double) -> Double { if x.is_nan() || x.is_inf() {
        #|    return x
        #|  }
        #|  let ix = get_high_word(x).reinterpret_as_int() & 0x7fffffff
        #|  let abs_x = x.abs()
        #|  let shuge = 1.0e307
        #|  let h = if x < 0.0 { -0.5 } else { 0.5 }
        #|  if ix < 0x40360000 {
        #|    if ix < 0x3e300000 {
        #|      if shuge + x > 1.0 {
        #|        return x
        #|      }
        #|    }
        #|    let t = expm1(abs_x)
        #|    if ix < 0x3ff00000 {
        #|      return h * (2.0 * t - t * t / (t + 1.0))
        #|    }
        #|    return h * (t + t / (t + 1.0))
        #|  }
        #|  if ix < 0x40862E42 {
        #|    return h * exp(abs_x)
        #|  }
        #|  if abs_x.reinterpret_as_uint64() < 0x408633ce8fb9f87d {
        #|    let w = exp(0.5 * abs_x)
        #|    let t = h * w
        #|    return t * w
        #|  }
        #|  x * shuge }
      ),
    ),
    "cbrt": build(
      (
        #|pub fn cbrt(x : Double) -> Double { if x.is_inf() || x.is_nan() || x == 0.0 {
        #|    return x
        #|  }
        #|  let b1 : UInt = 715094163 // B1 = (682-0.03306235651)*2**20
        #|  let b2 : UInt = 696219795 // B2 = (664-0.03306235651)*2**20
        #|  let c = 5.42857142857142815906e-01 // 19/35     = 0x3FE15F15, 0xF15F15F1
        #|  let d = -7.05306122448979611050e-01 // -864/1225 = 0xBFE691DE, 0x2532C834
        #|  let e = 1.41428571428571436819e+00 // 99/70     = 0x3FF6A0EA, 0x0EA0EA0F
        #|  let f = 1.60714285714285720630e+00 // 45/28     = 0x3FF9B6DB, 0x6DB6DB6E
        #|  let g = 3.57142857142857150787e-01 // 5/14      = 0x3FD6DB6D, 0xB6DB6DB7
        #|  let hx = get_high_word(x).reinterpret_as_int()
        #|  let sign = if x < 0.0 { true } else { false }
        #|  let x = abs(x)
        #|  let t = if hx < 0x00100000 {
        #|    let t : UInt64 = 0x43500000_00000000
        #|    let t : Double = t.reinterpret_as_double()
        #|    let t = t * x
        #|    set_high_word(0, get_high_word(t) / 3 + b2)
        #|  } else {
        #|    set_high_word(0, hx.reinterpret_as_uint() / 3 + b1)
        #|  }
        #|  let r = t * t / x
        #|  let s = c + r * t
        #|  let t = t * (g + f / (s + e + d / s))
        #|  let t = set_high_word(0, get_high_word(t) + 0x00000001)
        #|  let s = t * t
        #|  let r = x / s
        #|  let w = t + t
        #|  let r = (r - t) / (w + r)
        #|  let t = t + t * r
        #|  if sign {
        #|    -t
        #|  } else {
        #|    t
        #|  } }
      ),
    ),
    "pow": build(
      (
        #|pub fn pow(x : Double, y : Double) -> Double { fn set_low_word(d : Double, v : UInt) -> Double {
        #|    let bits : UInt64 = d.reinterpret_as_uint64()
        #|    let bits = bits & 0xFFFF_FFFF_0000_0000
        #|    let bits = bits | v.to_uint64()
        #|    bits.reinterpret_as_double()
        #|  }
        #|  fn set_high_word(d : Double, v : UInt) -> Double {
        #|    let bits : UInt64 = d.reinterpret_as_uint64()
        #|    let bits = bits & 0x0000_0000_FFFF_FFFF
        #|    let bits = bits | (v.to_uint64() << 32)
        #|    bits.reinterpret_as_double()
        #|  }
        #|  fn get_high_word(x : Double) -> UInt {
        #|    (x.reinterpret_as_uint64() >> 32).to_uint()
        #|  }
        #|  fn get_low_word(x : Double) -> UInt {
        #|    x.reinterpret_as_uint64().to_uint()
        #|  }
        #|  // double z, ax, z_h, z_l, p_h, p_l;
        #|  let mut z : Double = 0.0
        #|  let mut ax : Double = 0.0
        #|  let mut z_h : Double = 0.0
        #|  let mut z_l : Double = 0.0
        #|  let mut p_h : Double = 0.0
        #|  let mut p_l : Double = 0.0
        #|  // double y1, t1, t2, r, s, t, u, v, w
        #|  let mut y1 : Double = 0.0
        #|  let mut t1 : Double = 0.0
        #|  let mut t2 : Double = 0.0
        #|  let mut r : Double = 0.0
        #|  let mut s : Double = 0.0
        #|  let mut t : Double = 0.0
        #|  let mut u : Double = 0.0
        #|  let mut v : Double = 0.0
        #|  let mut w : Double = 0.0
        #|  // int i, j, k, yisint, n
        #|  let mut i : Int = 0
        #|  let mut j : Int = 0
        #|  let mut k : Int = 0
        #|  let mut yisint : Int = 0
        #|  let mut n : Int = 0
        #|  // int hx, hy, ix, iy;
        #|  // unsigned lx, ly;
        #|  //
        #|  // EXTRACT_WORDS(hx, lx, x);
        #|  // EXTRACT_WORDS(hy, ly, y);
        #|  // ix = hx & 0x7fffffff;
        #|  // iy = hy & 0x7fffffff;
        #|  let hx : Int = (x.reinterpret_as_uint64() >> 32).to_int()
        #|  let lx : UInt = (x.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
        #|  let hy : Int = (y.reinterpret_as_uint64() >> 32).to_int()
        #|  let ly : UInt = (y.reinterpret_as_uint64() & 0xFFFFFFFF).to_uint()
        #|  let mut ix : Int = hx & 0x7FFFFFFF
        #|  let iy : Int = hy & 0x7FFFFFFF
        #|  // y==zero: x**0 = 1
        #|  if (iy.reinterpret_as_uint() | ly) == 0 {
        #|    return ONE
        #|  }
        #|  // +-NaN return x+y
        #|  if ix > 0x7FF00000 ||
        #|    (ix == 0x7FF00000 && lx != 0) ||
        #|    iy > 0x7FF00000 ||
        #|    (iy == 0x7FF00000 && ly != 0) {
        #|    return x + y
        #|  }
        #|  // determine if y is an odd int when x < 0
        #|  // yisint = 0 ... y is not an integer
        #|  // yisint = 1 ... y is an odd int
        #|  // yisint = 2 ... y is an even int
        #|  if hx < 0 {
        #|    if iy >= 0x43400000 {
        #|      yisint = 2 // even integer y
        #|    } else if iy >= 0x3ff00000 {
        #|      k = (iy >> 20) - 0x3ff // exponent
        #|      if k > 20 {
        #|        j = (ly >> (52 - k)).reinterpret_as_int()
        #|        if j << (52 - k) == ly.reinterpret_as_int() {
        #|          yisint = 2 - (j & 1)
        #|        }
        #|      } else if ly == 0 {
        #|        j = iy >> (20 - k)
        #|        if j << (20 - k) == iy {
        #|          yisint = 2 - (j & 1)
        #|        }
        #|      }
        #|    }
        #|  }
        #|  // special value of y
        #|  if ly == 0 {
        #|    if iy == 0x7ff00000 { // y is +-inf
        #|      if ((ix.reinterpret_as_uint() - 0x3ff00000) | lx) == 0 {
        #|        return y - y // inf**+-1 is NaN
        #|      } else if ix >= 0x3ff00000 { // (|x|>1)**+-inf = inf,0
        #|        return if hy >= 0 { y } else { ZERO }
        #|      } else { // (|x|<1)**-,+inf = inf,0
        #|        return if hy < 0 { -y } else { ZERO }
        #|      }
        #|    }
        #|    if iy == 0x3ff00000 { // y is  +-1
        #|      if hy < 0 {
        #|        return ONE / x
        #|      } else {
        #|        return x
        #|      }
        #|    }
        #|    if hy == 0x40000000 { // y is 2
        #|      return x * x
        #|    }
        #|    if hy == 0x3fe00000 { // y is 0.5
        #|      if hx >= 0 { // x >= +0
        #|        return x.sqrt()
        #|      }
        #|    }
        #|  }
        #|  ax = x.abs()
        #|  // special value of x
        #|  if lx == 0 {
        #|    if ix == 0x7ff00000 || ix == 0 || ix == 0x3ff00000 {
        #|      z = ax // x is +-0,+-inf,+-1 */
        #|      if hy < 0 {
        #|        z = ONE / z // z = (1/|x|)
        #|      }
        #|      if hx < 0 {
        #|        if ((ix - 0x3ff00000) | yisint) == 0 {
        #|          // (-1)**non-int is NaN
        #|          z = @double.not_a_number
        #|        } else if yisint == 1 {
        #|          z = -z // (x<0)**odd = -(|x|**odd)
        #|        }
        #|      }
        #|      return z
        #|    }
        #|  }
        #|  n = (hx >> 31) + 1
        #|  // (x<0)**(non-int) is NaN
        #|  if (n | yisint) == 0 {
        #|    return @double.not_a_number
        #|  }
        #|  s = ONE // s (sign of result -ve**odd) = -1 else = 1
        #|  if (n | (yisint - 1)) == 0 {
        #|    s = -ONE // (-ve)**(odd int)
        #|  }
        #|  // |y| is huge
        #|  if iy > 0x41e00000 { // if |y| > 2**31 */
        #|    if iy > 0x43f00000 { // if |y| > 2**64, must o/uflow */
        #|      if ix <= 0x3fefffff {
        #|        return if hy < 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
        #|      }
        #|      if ix >= 0x3ff00000 {
        #|        return if hy > 0 { POW_huge * POW_huge } else { POW_tiny * POW_tiny }
        #|      }
        #|    }
        #|    // over/underflow if x is not close to one */
        #|    if ix < 0x3fefffff {
        #|      return if hy < 0 {
        #|        s * POW_huge * POW_huge
        #|      } else {
        #|        s * POW_tiny * POW_tiny
        #|      }
        #|    }
        #|    if ix > 0x3ff00000 {
        #|      return if hy > 0 {
        #|        s * POW_huge * POW_huge
        #|      } else {
        #|        s * POW_tiny * POW_tiny
        #|      }
        #|    }
        #|    // now |1-x| is tiny <= 2**-20, suffice to compute
        #|    // log(x) by x-x^2/2+x^3/3-x^4/4 */
        #|    t = ax - ONE // t has 20 trailing zeros */
        #|    w = t * t * (0.5 - t * (0.3333333333333333333333 - t * 0.25))
        #|    u = POW_ivln2_h * t // POW_ivln2_h has 21 sig. bits */
        #|    v = t * POW_ivln2_l - w * POW_ivln2
        #|    t1 = u + v
        #|    t1 = set_low_word(t1, 0)
        #|    t2 = v - (t1 - u)
        #|  } else {
        #|    n = 0
        #|    // take care subnormal number
        #|    if ix < 0x00100000 {
        #|      ax *= POW_two53
        #|      n -= 53
        #|      ix = get_high_word(ax).reinterpret_as_int()
        #|    }
        #|    n += (ix >> 20) - 0x3ff
        #|    j = ix & 0x000fffff
        #|    // determine interval
        #|    ix = j | 0x3ff00000 // normalize ix
        #|    if j <= 0x3988E {
        #|      k = 0 // |x|<sqrt(3/2)
        #|    } else if j < 0xBB67A {
        #|      k = 1 // |x|<sqrt(3)
        #|    } else {
        #|      k = 0
        #|      n += 1
        #|      ix -= 0x00100000
        #|    }
        #|    ax = set_high_word(ax, ix.reinterpret_as_uint())
        #|    // compute ss = s_h+s_l = (x-1)/(x+1) or (x-1.5)/(x+1.5)
        #|    u = ax - pow_bp[k] // bp[0]=1.0, bp[1]=1.5
        #|    v = ONE / (ax + pow_bp[k])
        #|    let ss : Double = u * v
        #|    let mut s_h : Double = ss
        #|    s_h = set_low_word(s_h, 0)
        #|    // t_h=ax+bp[k] High
        #|    let mut t_h : Double = ZERO
        #|    t_h = set_high_word(
        #|      t_h,
        #|      ((ix.reinterpret_as_uint() >> 1) | 0x20000000) +
        #|      0x00080000 +
        #|      (k.reinterpret_as_uint() << 18),
        #|    )
        #|    let mut t_l : Double = ax - (t_h - pow_bp[k])
        #|    let s_l : Double = v * (u - s_h * t_h - s_h * t_l)
        #|    // compute log(ax)
        #|    let mut s2 : Double = ss * ss
        #|    r = s2 *
        #|      s2 *
        #|      (
        #|        POW_L1 +
        #|        s2 *
        #|        (POW_L2 + s2 * (POW_L3 + s2 * (POW_L4 + s2 * (POW_L5 + s2 * POW_L6))))
        #|      )
        #|    r += s_l * (s_h + ss)
        #|    s2 = s_h * s_h
        #|    t_h = 3.0 + s2 + r
        #|    t_h = set_low_word(t_h, 0)
        #|    t_l = r - (t_h - 3.0 - s2)
        #|    // u+v = ss*(1+...)
        #|    u = s_h * t_h
        #|    v = s_l * t_h + t_l * ss
        #|    // 2/(3log2)*(ss+...)
        #|    p_h = u + v
        #|    p_h = set_low_word(p_h, 0)
        #|    p_l = v - (p_h - u)
        #|    z_h = POW_cp_h * p_h // cp_h+cp_l = 2/(3*log2)
        #|    z_l = POW_cp_l * p_h + p_l * POW_cp + pow_dp_l[k]
        #|    // log2(ax) = (ss+..)*2/(3*log2) = n + dp_h + z_h + z_l
        #|    t = n.to_double()
        #|    t1 = z_h + z_l + pow_dp_h[k] + t
        #|    t1 = set_low_word(t1, 0)
        #|    t2 = z_l - (t1 - t - pow_dp_h[k] - z_h)
        #|  }
        #|  // split up y into y1+y2 and compute (y1+y2)*(t1+t2)
        #|  y1 = y
        #|  y1 = set_low_word(y1, 0)
        #|  p_l = (y - y1) * t1 + y * t2
        #|  p_h = y1 * t1
        #|  z = p_l + p_h
        #|  j = get_high_word(z).reinterpret_as_int()
        #|  i = get_low_word(z).reinterpret_as_int()
        #|  if j >= 0x40900000 { // z >= 1024
        #|    if ((j - 0x40900000) | i) != 0 { // if z > 1024
        #|      return s * POW_huge * POW_huge // overflow
        #|    } else if p_l + POW_ovt > z - p_h {
        #|      return s * POW_huge * POW_huge // overflow
        #|    }
        #|  } else if (j & 0x7fffffff) >= 0x4090cc00 { // z <= -1075
        #|    if ((j - 0xc090cc00) | i) != 0 { // z < -1075
        #|      return s * POW_tiny * POW_tiny // underflow
        #|    } else if p_l <= z - p_h {
        #|      return s * POW_tiny * POW_tiny // underflow
        #|    }
        #|  }
        #|  //
        #|  // compute 2**(p_h+p_l)
        #|  //
        #|  i = j & 0x7fffffff
        #|  k = (i >> 20) - 0x3ff
        #|  n = 0
        #|  if i > 0x3fe00000 { // if |z| > 0.5, set n = [z+0.5]
        #|    n = j + (0x00100000 >> (k + 1))
        #|    k = ((n & 0x7fffffff) >> 20) - 0x3ff // new k for n
        #|    t = ZERO
        #|    t = set_high_word(t, (n & (0x000fffff >> k).lnot()).reinterpret_as_uint())
        #|    n = ((n & 0x000fffff) | 0x00100000) >> (20 - k)
        #|    if j < 0 {
        #|      n = -n
        #|    }
        #|    p_h -= t
        #|  }
        #|  t = p_l + p_h
        #|  t = set_low_word(t, 0)
        #|  u = t * POW_lg2_h
        #|  v = (p_l - (t - p_h)) * POW_lg2 + t * POW_lg2_l
        #|  z = u + v
        #|  w = v - (z - u)
        #|  t = z * z
        #|  t1 = z -
        #|    t * (POW_P1 + t * (POW_P2 + t * (POW_P3 + t * (POW_P4 + t * POW_P5))))
        #|  r = z * t1 / (t1 - TWO - (w + z * w))
        #|  z = ONE - (r - z)
        #|  j = get_high_word(z).reinterpret_as_int()
        #|  j += (n.reinterpret_as_uint() << 20).reinterpret_as_int()
        #|  if j >> 20 <= 0 {
        #|    z = scalbn(z, n)
        #|  } else { // subnormal output */
        #|    let tmp = get_high_word(z).reinterpret_as_int()
        #|    z = set_high_word(
        #|      z,
        #|      (tmp + (n.reinterpret_as_uint() << 20).reinterpret_as_int()).reinterpret_as_uint(),
        #|    )
        #|  }
        #|  return s * z }
      ),
    ),
    "cbrtf": build(
      (
        #|pub fn cbrtf(x : Float) -> Float { let b1 : UInt = 709958130 // B1 = (127-127.0/3-0.03306235651)*2**23 */
        #|  let b2 : UInt = 642849266 // B2 = (127-127.0/3-24/3-0.03306235651)*2**23 */
        #|  let mut ui : UInt = x.reinterpret_as_uint()
        #|  let mut hx : UInt = ui & 0x7fffffff
        #|  if hx >= 0x7f800000 {
        #|    // cbrt(NaN,INF) is itx
        #|    return x + x
        #|  }
        #|  // rough cbrt to 5 bits
        #|  if hx < 0x00800000 {
        #|    // zero or subnormal?
        #|    if hx == 0 {
        #|      return x
        #|    } // cbrt(+-0) is itx
        #|    ui = (x * (0x1.0p24 : Float)).reinterpret_as_uint()
        #|    hx = ui & 0x7fffffff
        #|    hx = hx / 3 + b2
        #|  } else {
        #|    hx = hx / 3 + b1
        #|  }
        #|  ui = ui & 0x80000000
        #|  ui = ui | hx
        #|  //
        #|  // First step Newton iteration (solving t*t-x/t == 0) to 16 bits.  In
        #|  // double precision so that its terms can be arranged for efficiency
        #|  // without causing overflow or underflow.
        #|  //
        #|  let dx = x.to_double()
        #|  let t = ui.reinterpret_as_float().to_double()
        #|  let r = t * t * t
        #|  let t = t * (dx + dx + r) / (dx + r + r)
        #|  //
        #|  // Second step Newton iteration to 47 bits.  In double precision for
        #|  // efficiency and accuracy.
        #|  //
        #|  let r = t * t * t
        #|  let t = t * (dx + dx + r) / (dx + r + r)
        #|  // rounding to 24 bits is perfect in round-to-nearest mode
        #|  t.to_float() }
      ),
    ),
    "pi": build("0x3.243F6A8885A308CA8A54"),
    "exp": build(
      (
        #|pub fn exp(x : Double) -> Double { fn get_high_word(x : Double) -> UInt {
        #|    (x.reinterpret_as_uint64() >> 32).to_uint()
        #|  }
        #|  fn get_low_word(x : Double) -> UInt {
        #|    x.reinterpret_as_uint64().to_uint()
        #|  }
        #|  fn insert_words(ix0 : UInt64, ix1 : UInt64) -> Double {
        #|    let mut bits : UInt64 = 0
        #|    bits = bits | (ix0 << 32)
        #|    bits = bits | ix1
        #|    bits.reinterpret_as_double()
        #|  }
        #|  let ori_x = x
        #|  let mut x = x
        #|  let one = 1.0
        #|  let halF = [0.5, -0.5]
        #|  let o_threshold = 7.09782712893383973096e+02
        #|  let u_threshold = -7.45133219101941108420e+02
        #|  let ln2HI = [6.93147180369123816490e-01, -6.93147180369123816490e-01]
        #|  let ln2LO = [1.90821492927058770002e-10, -1.90821492927058770002e-10]
        #|  let invln2 = 1.44269504088896338700e+00
        #|  let p1 = 1.66666666666666019037e-01
        #|  let p2 = -2.77777777770155933842e-03
        #|  let p3 = 6.61375632143793436117e-05
        #|  let p4 = -1.65339022054652515390e-06
        #|  let p5 = 4.13813679705723846039e-08
        #|  let e = 2.718281828459045
        #|  let mut hi = 0.0
        #|  let mut lo = 0.0
        #|  let huge = 1.0e+300
        #|  let twom1000 = 9.33263618503218878990e-302
        #|  let two1023 = 8.988465674311579539e307
        #|  let mut k : Int = 0
        #|  let mut hx : UInt = get_high_word(ori_x)
        #|  let xsb : Int = ((hx >> 31) & 1).reinterpret_as_int()
        #|  hx = hx & 0x7FFFFFFF
        #|  if hx >= 0x40862E42 {
        #|    if hx >= 0x7FF00000 {
        #|      let lx : UInt = get_low_word(ori_x)
        #|      if ((hx & 0xFFFFF) | lx) != 0 {
        #|        return ori_x + ori_x
        #|      } else if xsb == 0 {
        #|        return ori_x
        #|      } else {
        #|        return 0.0
        #|      }
        #|    }
        #|    if ori_x > o_threshold {
        #|      return huge * huge
        #|    }
        #|    if ori_x < u_threshold {
        #|      return twom1000 * twom1000
        #|    }
        #|  }
        #|  if hx > 0x3FD62E42 {
        #|    if hx < 0x3FF0A2B2 {
        #|      if ori_x == 1.0 {
        #|        return e
        #|      }
        #|      hi = ori_x - ln2HI[xsb]
        #|      lo = ln2LO[xsb]
        #|      k = 1 - xsb - xsb
        #|    } else {
        #|      k = (invln2 * ori_x + halF[xsb]).to_int()
        #|      let t = k.to_double()
        #|      hi = ori_x - t * ln2HI[0]
        #|      lo = t * ln2LO[0]
        #|    }
        #|    x = hi - lo
        #|  } else if hx < 0x3E300000 {
        #|    if huge + x > one {
        #|      return one + x
        #|    }
        #|  } else {
        #|    k = 0
        #|  }
        #|  let t = x * x
        #|  let twopk = if k >= -1021 {
        #|    insert_words(
        #|      (0x3FF00000 + (k.reinterpret_as_uint() << 20).reinterpret_as_int())
        #|      .to_int64()
        #|      .reinterpret_as_uint64(),
        #|      0,
        #|    )
        #|  } else {
        #|    insert_words(
        #|      0x3FF00000UL + ((k + 1000).reinterpret_as_uint() << 20).to_uint64(),
        #|      0,
        #|    )
        #|  }
        #|  let c = x - t * (p1 + t * (p2 + t * (p3 + t * (p4 + t * p5))))
        #|  if k == 0 {
        #|    return one - (x * c / (c - 2.0) - x)
        #|  }
        #|  let y = one - (lo - x * c / (2.0 - c) - hi)
        #|  if k >= -1021 {
        #|    if k == 1024 {
        #|      return y * 2.0 * two1023
        #|    } else {
        #|      return y * twopk
        #|    }
        #|  } else {
        #|    return y * twopk * twom1000
        #|  } }
      ),
    ),
    "abs": build(
      (
        #|fn abs(x : Double) -> Double { if x < 0.0 {
        #|    -x
        #|  } else {
        #|    x
        #|  } }
      ),
    ),
    "logf_off": UInt(0x3f330000U),
    "logf_table_bits": Int(4),
    "lnf": build(
      (
        #|pub fn lnf(x : Float) -> Float { let mut ix : UInt = x.reinterpret_as_uint()
        #|  if ix == 0x3f800000U {
        #|    return 0.0
        #|  }
        #|  if ix - 0x00800000U >= 0x7f800000U - 0x00800000U {
        #|    if ix * 2 == 0 {
        #|      return @float.neg_infinity
        #|    }
        #|    if ix == 0x7f800000U {
        #|      return x
        #|    }
        #|    if (ix & 0x80000000U) != 0 || ix * 2 >= 0xff000000U {
        #|      return @float.not_a_number
        #|    }
        #|    ix = (x * 0x1.0p23).reinterpret_as_uint()
        #|    ix -= (23 << 23).reinterpret_as_uint()
        #|  }
        #|  let tmp = ix - logf_off
        #|  let i = ((tmp >> (23 - logf_table_bits)) % logf_n).reinterpret_as_int()
        #|  let k = tmp.reinterpret_as_int() >> 23
        #|  let iz = ix - (tmp & 0xff800000U)
        #|  let invc = logf_data.invc[i]
        #|  let logc = logf_data.logc[i]
        #|  let z = iz.reinterpret_as_float().to_double()
        #|  let r = z * invc - 1
        #|  let y0 = logc + k.to_double() * logf_data.ln2
        #|  let r2 = r * r
        #|  let y = logf_data.poly[1] * r + logf_data.poly[2]
        #|  let y = logf_data.poly[0] * r2 + y
        #|  let y = y * r2 + (y0 + r)
        #|  y.to_float() }
      ),
    ),
    "k_expo2f": build(
      (
        #|fn k_expo2f(x : Float) -> Float { let k = 235
        #|  let k_ln2 = (0x4322e3bc).reinterpret_as_float()
        #|  // note that k is odd and scale*scale overflows */
        #|  let scale = ((0x7f + k / 2) << 23).reinterpret_as_float()
        #|  // exp(x - k ln2) * 2**(k-1) */
        #|  expf(x - k_ln2) * scale * scale }
      ),
    ),
    "mulh": build(
      (
        #|fn mulh(a : UInt, b : UInt) -> UInt { let a = a.to_uint64()
        #|  let b = b.to_uint64()
        #|  let res = a * b
        #|  (res >> 32).to_uint() }
      ),
    ),
    "scalbn": build(
      (
        #|pub fn scalbn(x : Double, exp : Int) -> Double { let mut n = exp
        #|  let mut y : Double = x
        #|  if n > 1023 {
        #|    y *= 0x1.0p1023
        #|    n -= 1023
        #|    if n > 1023 {
        #|      y *= 0x1.0p1023
        #|      n -= 1023
        #|      if n > 1023 {
        #|        n = 1023
        #|      }
        #|    }
        #|  } else if n < -1022 {
        #|    // make sure final n < -53 to avoid double
        #|    // rounding in the subnormal range
        #|    y *= 0x1.0p-1022 * 0x1.0p53
        #|    n += 1022 - 53
        #|    if n < -1022 {
        #|      y *= 0x1.0p-1022 * 0x1.0p53
        #|      n += 1022 - 53
        #|      if n < -1022 {
        #|        n = -1022
        #|      }
        #|    }
        #|  }
        #|  let ui = (0x3ff + n).to_uint64() << 52
        #|  return y * ui.reinterpret_as_double() }
      ),
    ),
    "top12": build(
      (
        #|fn top12(x : Float) -> UInt { x.reinterpret_as_uint() >> 20 }
      ),
    ),
    "powf": build(
      (
        #|pub fn powf(base : Float, exponent : Float) -> Float { let huge : Float = 1.0e30
        #|  let tiny : Float = 1.0e-30
        #|  let cp : Float = 9.6179670095e-01 // 0x3f76384f =2/(3ln2) */
        #|  let cp_h : Float = 9.6191406250e-01 // 0x3f764000 =12b cp */
        #|  let cp_l : Float = -1.1736857402e-04 // 0xb8f623c6 =tail of cp_h */
        #|  let lg2 : Float = 6.9314718246e-01 // 0x3f317218 */
        #|  let lg2_h : Float = 6.93145752e-01 // 0x3f317200 */
        #|  let lg2_l : Float = 1.4286067653e-06 // 0x35bfbe8c */
        #|  let ovt : Float = 8.0085662595e-08 // -(2**-28)/(log(2)**2) */
        #|  let ivln2 : Float = 1.4426950216e+00 // 0x3f317218 */
        #|  let ivln2_h : Float = 1.4426879883e+00 // 0x3f317218 */
        #|  let ivln2_l : Float = 7.0526075433e-06 // 0x35bfbe8c */
        #|  let l1 : Float = 6.0000002384e-01 // 0x3f19999a */
        #|  let l2 : Float = 4.2857143283e-01 // 0x3edb6db7 */
        #|  let l3 : Float = 3.3333334327e-01 // 0x3eaaaaab */
        #|  let l4 : Float = 2.7272811532e-01 // 0x3e8ba305 */
        #|  let l5 : Float = 2.3066075146e-01 // 0x3e6c3255 */
        #|  let l6 : Float = 2.0697501302e-01 // 0x3e53f142 */
        #|  let p1 : Float = 1.6666667163e-01 // 0x3e2aaaab */
        #|  let p2 : Float = -2.7777778450e-03 // 0xbb360b61 */
        #|  let p3 : Float = 6.6137559770e-05 // 0x388ab355 */
        #|  let p4 : Float = -1.6533901999e-06 // 0xb5ddea0e */
        #|  let p5 : Float = 4.1381369442e-08 // 0x3331bb4c */
        #|  let mut z : Float = 0
        #|  let mut ax : Float = 0
        #|  let mut z_h : Float = 0
        #|  let mut z_l : Float = 0
        #|  let mut p_h : Float = 0
        #|  let mut p_l : Float = 0
        #|  let mut y1 : Float = 0
        #|  let mut t1 : Float = 0
        #|  let mut t2 : Float = 0
        #|  let mut r : Float = 0
        #|  let mut s : Float = 0
        #|  let mut sn : Float = 0
        #|  let mut t : Float = 0
        #|  let mut u : Float = 0
        #|  let mut v : Float = 0
        #|  let mut w : Float = 0
        #|  let mut i : Int = 0
        #|  let mut j : Int = 0
        #|  let mut k : Int = 0
        #|  let mut yisint : Int = 0
        #|  let mut n : Int = 0
        #|  let mut hx : Int = 0
        #|  let mut hy : Int = 0
        #|  let mut ix : Int = 0
        #|  let mut iy : Int = 0
        #|  let mut i_s : Int = 0
        #|  let (x, y) = (base, exponent)
        #|  let bp : Array[Float] = [1.0, 1.5]
        #|  let dp_h : Array[Float] = [0.0, 5.84960938e-01] // 0x3f15c000 */
        #|  let dp_l : Array[Float] = [0.0, 1.56322085e-06] // 0x35d1cfdc */
        #|  let two24 : Float = 16777216.0
        #|  hx = x.reinterpret_as_int()
        #|  hy = y.reinterpret_as_int()
        #|  ix = hx & 0x7fffffff
        #|  iy = hy & 0x7fffffff
        #|  // x**0 = 1, even if x is NaN
        #|  if iy == 0 {
        #|    return 1.0
        #|  }
        #|  // 1**y = 1, even if y is NaN
        #|  if hx == 0x3f800000 {
        #|    return 1.0
        #|  }
        #|  // NaN if either arg is NaN
        #|  if ix > 0x7f800000 || iy > 0x7f800000 {
        #|    return x + y
        #|  }
        #|  // determine if y is an odd int when x < 0
        #|  // yisint = 0       ... y is not an integer
        #|  // yisint = 1       ... y is an odd int
        #|  // yisint = 2       ... y is an even int
        #|  //
        #|  yisint = 0
        #|  if hx < 0 {
        #|    if iy >= 0x4b800000 {
        #|      yisint = 2 // even integer y
        #|    } else if iy >= 0x3f800000 {
        #|      k = (iy >> 23) - 0x7f // exponent
        #|      j = iy >> (23 - k)
        #|      if j << (23 - k) == iy {
        #|        yisint = 2 - (j & 1)
        #|      }
        #|    }
        #|  }
        #|  // special value of y
        #|  if iy == 0x7f800000 {
        #|    if ix == 0x3f800000 {
        #|      // (-1)**+-inf is 1
        #|      return 1.0
        #|    } else if ix > 0x3f800000 {
        #|      // (|x|>1)**+-inf = inf,0
        #|      return if hy >= 0 { y } else { 0.0 }
        #|    } else {
        #|      // (|x|<1)**+-inf = 0,inf
        #|      return if hy >= 0 { 0.0 } else { -y }
        #|    }
        #|  }
        #|  if iy == 0x3f800000 {
        #|    // y is +-1
        #|    return if hy >= 0 { x } else { (1.0 : Float) / x }
        #|  }
        #|  if hy == 0x40000000 {
        #|    // y is 2
        #|    return x * x
        #|  }
        #|  // y is  0.5
        #|  if hy == 0x3f000000 && hx >= 0 {
        #|    // x >= +0
        #|    return x.sqrt()
        #|  }
        #|  ax = x.abs()
        #|  // special value of x
        #|  if ix == 0x7f800000 || ix == 0 || ix == 0x3f800000 {
        #|    // x is +-0,+-inf,+-1
        #|    z = ax
        #|    if hy < 0 {
        #|      // z = (1/|x|)
        #|      z = (1.0 : Float) / z
        #|    }
        #|    if hx < 0 {
        #|      if ((ix - 0x3f800000) | yisint) == 0 {
        #|        z = (z - z) / (z - z) // (-1)**non-int is NaN
        #|      } else if yisint == 1 {
        #|        z = -z
        #|      }
        #|    } // (x<0)**odd = -(|x|**odd)
        #|    return z
        #|  }
        #|  sn = 1.0 // sign of result
        #|  if hx < 0 {
        #|    if yisint == 0 {
        #|      // (x<0)**(non-int) is NaN
        #|      return @float.not_a_number
        #|    }
        #|    if yisint == 1 {
        #|      // (x<0)**(odd int)
        #|      sn = -1.0
        #|    }
        #|  }
        #|  // |y| is huge
        #|  if iy > 0x4d000000 {
        #|    // if |y| > 2**27
        #|    // over/underflow if x is not close to one
        #|    if ix < 0x3f7ffff8 {
        #|      return if hy < 0 { sn * huge * huge } else { sn * tiny * tiny }
        #|    }
        #|    if ix > 0x3f800007 {
        #|      return if hy > 0 { sn * huge * huge } else { sn * tiny * tiny }
        #|    }
        #|    // now |1-x| is tiny <= 2**-20, suffice to compute
        #|    // log(x) by x-x^2/2+x^3/3-x^4/4
        #|    t = ax - 1.0 // t has 20 trailing zeros
        #|    w = t * t * ((0.5 : Float) - t * ((0.333333333333 : Float) - t * 0.25))
        #|    u = ivln2_h * t // IVLN2_H has 16 sig. bits
        #|    v = t * ivln2_l - w * ivln2
        #|    t1 = u + v
        #|    i_s = t1.reinterpret_as_int()
        #|    t1 = (i_s & 0xfffff000).reinterpret_as_float()
        #|    t2 = v - (t1 - u)
        #|  } else {
        #|    let mut s2 : Float = 0
        #|    let mut s_h : Float = 0
        #|    let mut s_l : Float = 0
        #|    let mut t_h : Float = 0
        #|    let mut t_l : Float = 0
        #|    n = 0
        #|    // take care subnormal number
        #|    if ix < 0x00800000 {
        #|      ax *= two24
        #|      n -= 24
        #|      ix = ax.reinterpret_as_int()
        #|    }
        #|    n += (ix >> 23) - 0x7f
        #|    j = ix & 0x007fffff
        #|    // determine interval
        #|    ix = j | 0x3f800000 // normalize ix
        #|    if j <= 0x1cc471 {
        #|      // |x|<sqrt(3/2)
        #|      k = 0
        #|    } else if j < 0x5db3d7 {
        #|      // |x|<sqrt(3)
        #|      k = 1
        #|    } else {
        #|      k = 0
        #|      n += 1
        #|      ix -= 0x00800000
        #|    }
        #|    ax = ix.reinterpret_as_float()
        #|    // compute s = s_h+s_l = (x-1)/(x+1) or (x-1.5)/(x+1.5)
        #|    u = ax - bp[k]
        #|    v = (1.0 : Float) / (ax + bp[k])
        #|    s = u * v
        #|    s_h = s
        #|    i_s = s_h.reinterpret_as_int()
        #|    s_h = (i_s & 0xfffff000).reinterpret_as_float()
        #|    // t_h=ax+bp[k] High
        #|    i_s = (((ix.reinterpret_as_uint() >> 1) & 0xfffff000) | 0x20000000).reinterpret_as_int()
        #|    t_h = (i_s.reinterpret_as_uint() +
        #|    0x00400000 +
        #|    (k.reinterpret_as_uint() << 21)).reinterpret_as_float()
        #|    t_l = ax - (t_h - bp[k])
        #|    s_l = v * (u - s_h * t_h - s_h * t_l)
        #|    // compute log(ax) */
        #|    s2 = s * s
        #|    r = s2 * s2 * (l1 + s2 * (l2 + s2 * (l3 + s2 * (l4 + s2 * (l5 + s2 * l6)))))
        #|    r += s_l * (s_h + s)
        #|    s2 = s_h * s_h
        #|    t_h = (3.0 : Float) + s2 + r
        #|    i_s = t_h.reinterpret_as_int()
        #|    t_h = (i_s & 0xfffff000).reinterpret_as_float()
        #|    t_l = r - (t_h - 3.0 - s2)
        #|    // u+v = s*(1+...)
        #|    u = s_h * t_h
        #|    v = s_l * t_h + t_l * s
        #|    // 2/(3log2)*(s+...)
        #|    p_h = u + v
        #|    i_s = p_h.reinterpret_as_int()
        #|    p_h = (i_s & 0xfffff000).reinterpret_as_float()
        #|    p_l = v - (p_h - u)
        #|    z_h = cp_h * p_h // cp_h+cp_l = 2/(3*log2)
        #|    z_l = cp_l * p_h + p_l * cp + dp_l[k]
        #|    // log2(ax) = (s+..)*2/(3*log2) = n + dp_h + z_h + z_l
        #|    t = n.to_float()
        #|    t1 = z_h + z_l + dp_h[k] + t
        #|    i_s = t1.reinterpret_as_int()
        #|    t1 = (i_s & 0xfffff000).reinterpret_as_float()
        #|    t2 = z_l - (t1 - t - dp_h[k] - z_h)
        #|  }
        #|  // split up y into y1+y2 and compute (y1+y2)*(t1+t2)
        #|  i_s = y.reinterpret_as_int()
        #|  y1 = (i_s & 0xfffff000).reinterpret_as_float()
        #|  p_l = (y - y1) * t1 + y * t2
        #|  p_h = y1 * t1
        #|  z = p_l + p_h
        #|  j = z.reinterpret_as_int()
        #|  if j > 0x43000000 {
        #|    // if z > 128
        #|    return sn * huge * huge // overflow
        #|  } else if j == 0x43000000 {
        #|    // if z == 128
        #|    if p_l + ovt > z - p_h {
        #|      return sn * huge * huge
        #|    }
        #|  } else if ( // overflow
        #|      j & 0x7fffffff
        #|    ) >
        #|    0x43160000 {
        #|    // z < -150
        #|    return sn * tiny * tiny // underflow
        #|    // z == -150
        #|  } else if j.reinterpret_as_uint() == 0xc3160000 && p_l <= z - p_h {
        #|    return sn * tiny * tiny
        #|  } // underflow
        #|  //
        #|  // compute 2**(p_h+p_l)
        #|  //
        #|  i = j & 0x7fffffff
        #|  k = (i >> 23) - 0x7f
        #|  n = 0
        #|  if i > 0x3f000000 {
        #|    // if |z| > 0.5, set n = [z+0.5]
        #|    n = j + (0x00800000 >> (k + 1))
        #|    k = ((n & 0x7fffffff) >> 23) - 0x7f // new k for n
        #|    t = (n & (0x007fffff >> k).lnot()).reinterpret_as_float()
        #|    n = ((n & 0x007fffff) | 0x00800000) >> (23 - k)
        #|    if j < 0 {
        #|      n = -n
        #|    }
        #|    p_h -= t
        #|  }
        #|  t = p_l + p_h
        #|  i_s = t.reinterpret_as_int()
        #|  t = (i_s & 0xffff8000).reinterpret_as_float()
        #|  u = t * lg2_h
        #|  v = (p_l - (t - p_h)) * lg2 + t * lg2_l
        #|  z = u + v
        #|  w = v - (z - u)
        #|  t = z * z
        #|  t1 = z - t * (p1 + t * (p2 + t * (p3 + t * (p4 + t * p5))))
        #|  r = z * t1 / (t1 - 2.0) - (w + z * w)
        #|  z = (1.0 : Float) - (r - z)
        #|  j = z.reinterpret_as_int()
        #|  j += n << 23
        #|  if j >> 23 <= 0 {
        #|    // subnormal output
        #|    z = scalbnf(z, n)
        #|  } else {
        #|    z = j.reinterpret_as_float()
        #|  }
        #|  sn * z }
      ),
    ),
  }
})

///|
let random_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/random",
  fn(_env, build) {
    {
      "new": build(
        (
          #|pub fn new(seed~ : Bytes = b\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\") -> Rand { if seed.length() != 32 {
          #|    abort(\"seed must be 32 bytes long\")
          #|  }
          #|  @random_source.ChaCha8::new(seed) as &Source }
        ),
      ),
      "chacha8": build(
        (
          #|pub fn chacha8(seed~ : Bytes = b\"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456\") -> &Source { @random_source.ChaCha8::new(seed) }
        ),
      ),
    }
  },
)

///|
let rational_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/rational",
  fn(_env, build) {
    {
      "gcd": build(
        (
          #|fn gcd(a : Int64, b : Int64) -> Int64 { for a = a, b = b {
          #|    if b == 0L {
          #|      break a
          #|    }
          #|    continue b, a % b
          #|  } }
        ),
      ),
    }
  },
)

///|
let set_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/set", fn(
  _env,
  build,
) {
  {
    "calc_grow_threshold": build(
      (
        #|fn calc_grow_threshold(capacity : Int) -> Int { capacity * 13 / 16 }
      ),
    ),
  }
})

///|
let sorted_map_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/sorted_map",
  fn(_env, build) {
    {
      "max": build(
        (
          #|fn max(x : Int, y : Int) -> Int { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
    }
  },
)

///|
let sorted_set_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/sorted_set",
  fn(_env, build) {
    {
      "max": build(
        (
          #|fn max(x : Int, y : Int) -> Int { if x > y {
          #|    x
          #|  } else {
          #|    y
          #|  } }
        ),
      ),
    }
  },
)

///|
let strconv_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/strconv",
  fn(_env, build) {
    {
      "parse_bool": build(
        (
          #|pub fn parse_bool(str : @string.View) -> Bool raise StrConvError { match str {
          #|    \"1\" | \"t\" | \"T\" | \"true\" | \"TRUE\" | \"True\" => true
          #|    \"0\" | \"f\" | \"F\" | \"false\" | \"FALSE\" | \"False\" => false
          #|    _ => syntax_err()
          #|  } }
        ),
      ),
      "mantissa_explicit_bits": Int(52),
      "parse_double": build(
        (
          #|pub fn parse_double(str : @string.View) -> Double raise StrConvError { if str.length() == 0 {
          #|    syntax_err()
          #|  }
          #|  if !check_underscore(str) {
          #|    syntax_err()
          #|  }
          #|  // validate its a number
          #|  let (num, consumed) = match parse_number(str) {
          #|    Some(r) => r
          #|    None =>
          #|      match parse_inf_nan(str) {
          #|        Some((num, consumed)) =>
          #|          if str.length() != consumed {
          #|            syntax_err()
          #|          } else {
          #|            return num
          #|          }
          #|        None => syntax_err()
          #|      }
          #|  }
          #|  if str.length() != consumed {
          #|    syntax_err()
          #|  }
          #|  // Clinger's fast path (How to read floating point numbers accurately)[https://doi.org/10.1145/989393.989430]
          #|  match num.try_fast_path() {
          #|    Some(value) => value
          #|    None => {
          #|      // fallback to slow path
          #|      let ret = parse_decimal_priv(str)
          #|      ret.to_double_priv()
          #|    }
          #|  } }
        ),
      ),
      "parse_digits": build(
        (
          #|fn parse_digits(s : @string.View, x : UInt64) -> (@string.View, UInt64, Int) { s.fold_digits(x, (digit, acc : UInt64) => acc * 10UL +
          #|    UInt64::extend_uint(digit.reinterpret_as_uint())) }
        ),
      ),
      "range_err_str": String("value out of range"),
      "syntax_err_str": String("invalid syntax"),
      "base_err_str": String("invalid base"),
      "max_shift": Int(59),
      "powtab": build("["),
      "new_priv": build(
        (
          #|fn Decimal::new_priv() -> Decimal { {
          #|    digits: FixedArray::make(800, Byte::default()),
          #|    digits_num: 0,
          #|    decimal_point: 0,
          #|    negative: false,
          #|    truncated: false,
          #|  } }
        ),
      ),
      "new": build(
        (
          #|pub fn Decimal::new() -> Decimal { Decimal::new_priv() }
        ),
      ),
      "parse_int": build(
        (
          #|pub fn parse_int(str : @string.View, base~ : Int = 0) -> Int raise StrConvError { let n = parse_int64(str, base~)
          #|  if n < INT_MIN.to_int64() || n > INT_MAX.to_int64() {
          #|    range_err()
          #|  }
          #|  n.to_int() }
        ),
      ),
    }
  },
)

///|
let string_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/string",
  fn(_env, build) {
    {
      "concat": build(
        (
          #|pub fn String::concat(self : Array[String], separator~ : String = \"\") -> String { concat(self, separator~) }
        ),
      ),
      "code_point_of_surrogate_pair": build(
        (
          #|fn code_point_of_surrogate_pair(leading : Int, trailing : Int) -> Char { ((leading - 0xD800) * 0x400 + trailing - 0xDC00 + 0x10000).unsafe_to_char() }
        ),
      ),
      "find": build(
        (
          #|pub fn View::find(self : View, str : View) -> Int? { if str.length() <= 4 {
          #|    brute_force_find(self, str)
          #|  } else {
          #|    boyer_moore_horspool_find(self, str)
          #|  }
          #|  // TODO: When the pattern string is long (>= 256),
          #|  // consider using Two-Way algorithm to ensure linear time complexity. }
        ),
      ),
      "from_array": build(
        (
          #|pub fn String::from_array(chars : Array[Char]) -> String { let buf = StringBuilder::new(size_hint=chars.length() * 4)
          #|  for c in chars {
          #|    buf.write_char(c)
          #|  }
          #|  buf.to_string() }
        ),
      ),
      "op_get": build(
        (
          #|pub fn View::op_get(self : View, index : Int) -> Int { guard index >= 0 && index < self.length() else {
          #|    abort(\"Index out of bounds\")
          #|  }
          #|  self.str().unsafe_charcode_at(self.start() + index) }
        ),
      ),
    }
  },
)

///|
let test_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/test", fn(
  _env,
  build,
) {
  {
    "is_true": build(
      (
        #|pub fn is_true(x : Bool, loc~ : SourceLoc) -> Unit raise { if !x {
        #|    let x = debug_string(x)
        #|    fail(\"`\\{x}` is not true\", loc~)
        #|  } }
      ),
    ),
    "new": build(
      (
        #|pub fn new(name : String) -> T { { name, buffer: StringBuilder::new() } }
      ),
    ),
    "write": build(
      (
        #|pub fn write(self : T, obj : &Show) -> Unit { self.buffer.write_string(obj.to_string()) }
      ),
    ),
  }
})

///|
let uint_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/uint", fn(
  _env,
  build,
) {
  {
    "to_int64": build(
      (
        #|pub fn to_int64(self : UInt) -> Int64 { self.to_uint64().reinterpret_as_int64() }
      ),
    ),
  }
})

///|
let uint16_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint16",
  fn(_env, build) {
    {
      "to_uint": build(
        (
          #|pub fn UInt16::to_uint(self : UInt16) -> UInt { self.to_int().reinterpret_as_uint() }
        ),
      ),
    }
  },
)

///|
let uint64_module : RuntimeModule = RuntimeModule::new(
  "moonbitlang/core/uint64",
  fn(_env, build) {
    {
      "to_be_bytes": build(
        (
          #|pub fn to_be_bytes(self : UInt64) -> Bytes { [
          #|    (self >> 56).to_byte(),
          #|    (self >> 48).to_byte(),
          #|    (self >> 40).to_byte(),
          #|    (self >> 32).to_byte(),
          #|    (self >> 24).to_byte(),
          #|    (self >> 16).to_byte(),
          #|    (self >> 8).to_byte(),
          #|    self.to_byte(),
          #|  ] }
        ),
      ),
    }
  },
)

///|
let unit_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/unit", fn(
  _env,
  build,
) {
  {
    "to_string": build(
      (
        #|pub fn to_string(self : Unit) -> String { let _ = self
        #|  \"()\" }
      ),
    ),
  }
})
