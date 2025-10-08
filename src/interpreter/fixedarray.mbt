///|
pub let fixedarray_methods : Map[String, RuntimeFunction] = {
  "new": fixedarray_new_fn,
  "length": fixedarray_length_fn,
  "get": fixedarray_get_fn,
  "set": fixedarray_set_fn,
  "unsafe_get": fixedarray_unsafe_get_fn,
  "unsafe_set": fixedarray_unsafe_set_fn,
  "make": fixedarray_make_fn,
  "fill": fixedarray_fill_fn,
  "blit_to": fixedarray_blit_to_fn,
  "unsafe_blit": fixedarray_unsafe_blit_fn,
  "is_empty": fixedarray_is_empty_fn,
  "iter": fixedarray_iter_fn,
  "iter2": fixedarray_iter2_fn,
  "binary_search": fixedarray_binary_search_fn,
  "binary_search_by": fixedarray_binary_search_by_fn,
  "set_utf16le_char_fn": fixedarray_set_utf16le_char_fn,
  "set_utf16be_char_fn": fixedarray_set_utf16be_char_fn,
}

///|
/// FixedArray::new 操作 - 创建新的固定数组
let fixedarray_new_fn : RuntimeFunction = ctx => match ctx.args {
  [] => FixedArray(FixedArray::make(0, Unit))
  _ => Unit
}

///|
/// FixedArray::length 操作 - 获取数组长度
let fixedarray_length_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }] => Int(arr.length())
  _ => Unit
}

///|
/// FixedArray::get 操作 - 安全获取元素
let fixedarray_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val: Int(i), .. }] =>
    if i >= 0 && i < arr.length() {
      arr[i]
    } else {
      Unit
    }
  _ => Unit
}

///|
/// FixedArray::set 操作 - 设置元素
let fixedarray_set_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val: Int(i), .. }, { val, .. }] => {
    if i >= 0 && i < arr.length() {
      arr[i] = val
    }
    Unit
  }
  _ => Unit
}

///|
/// FixedArray::unsafe_get 操作 - 不安全获取元素
let fixedarray_unsafe_get_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val: Int(i), .. }] => arr[i]
  _ => Unit
}

///|
/// FixedArray::unsafe_set 操作 - 不安全设置元素
let fixedarray_unsafe_set_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val: Int(i), .. }, { val, .. }] => {
    arr[i] = val
    Unit
  }
  _ => Unit
}

///|
/// FixedArray::make 操作 - 创建指定大小和初始值的固定数组
let fixedarray_make_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: Int(len), .. }, { val, .. }] => FixedArray(FixedArray::make(len, val))
  _ => Unit
}

///|
/// FixedArray::fill 操作 - 填充数组
let fixedarray_fill_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val, .. }] => {
    arr.fill(val)
    Unit
  }
  _ => Unit
}

///|
/// FixedArray::blit_to 操作 - 复制数组内容
let fixedarray_blit_to_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: Int(dst_offset), .. },
    { val: FixedArray(src), .. },
    { val: Int(src_offset), .. },
    { val: Int(len), .. },
  ] => {
    src.unsafe_blit(dst_offset, src, src_offset, len)
    Unit
  }
  _ => Unit
}

///|
/// FixedArray::unsafe_blit 操作 - 不安全的数组复制
let fixedarray_unsafe_blit_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: FixedArray(dst), .. },
    { val: Int(dst_offset), .. },
    { val: FixedArray(src), .. },
    { val: Int(src_offset), .. },
    { val: Int(len), .. },
  ] => {
    dst.unsafe_blit(dst_offset, src, src_offset, len)
    Unit
  }
  _ => Unit
}

///|
/// FixedArray::is_empty 操作 - 检查数组是否为空
let fixedarray_is_empty_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }] => Bool(arr.is_empty())
  _ => Unit
}

///|
/// FixedArray::iter 操作 - 获取迭代器
let fixedarray_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }] => Iter(arr.iter())
  _ => Unit
}

///|
/// FixedArray::iter2 操作 - 获取带索引的迭代器
let fixedarray_iter2_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }] => {
    let iter2_impl = Iter2::new(yield_fn => {
      for i in 0..<arr.length() {
        match yield_fn(Int(i), arr[i]) {
          IterEnd => return IterEnd
          IterContinue => ()
        }
      }
      IterEnd
    })
    Iter2(iter2_impl)
  }
  _ => Unit
}

///|
/// FixedArray::binary_search 操作 - 二分查找
let fixedarray_binary_search_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val: target, .. }] =>
    arr.binary_search(target).map(Int(_)).map_err(Int(_))
    |> RuntimeValue::from_result
  _ => Unit
}

///|
/// FixedArray::binary_search_by 操作 - 使用比较函数的二分查找
let fixedarray_binary_search_by_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: FixedArray(arr), .. }, { val: Fn(f, env), .. }] =>
    arr
    .binary_search_by(v => match
      ctx.context.call(
        f,
        ctx.mod,
        env,
        @list.singleton({ val: v, kind: Positional }),
      ) {
      Int(i) => i
      _ => raise Error("binary_search_by closure must return int")
    })
    .map(Int(_))
    .map_err(Int(_))
    |> RuntimeValue::from_result
  _ => Unit
}

///|
/// FixedArray::set_utf16le_char operation - Set UTF-16LE character bytes
let fixedarray_set_utf16le_char_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: FixedArray(self), .. },
    { val: Int(offset), .. },
    { val: Char(value), .. },
  ] => {
    let code = value.to_uint()
    if code < 0x10000 {
      self[offset] = Byte((code & 0xFF).to_byte())
      self[offset + 1] = Byte((code >> 8).to_byte())
      Int(2)
    } else if code < 0x110000 {
      let hi = code - 0x10000
      let lo = (hi >> 10) | 0xD800
      let hi = (hi & 0x3FF) | 0xDC00
      self[offset] = Byte((lo & 0xFF).to_byte())
      self[offset + 1] = Byte((lo >> 8).to_byte())
      self[offset + 2] = Byte((hi & 0xFF).to_byte())
      self[offset + 3] = Byte((hi >> 8).to_byte())
      Int(4)
    } else {
      error("Char out of range")
    }
  }
  _ => Unit
}

///|
/// FixedArray::set_utf16be_char operation - Set UTF-16BE character bytes
let fixedarray_set_utf16be_char_fn : RuntimeFunction = ctx => match ctx.args {
  [
    { val: FixedArray(self), .. },
    { val: Int(offset), .. },
    { val: Char(value), .. },
  ] => {
    let code = value.to_uint()
    if code < 0x10000 {
      self[offset] = Byte((code >> 8).to_byte())
      self[offset + 1] = Byte((code & 0xFF).to_byte())
      Int(2)
    } else if code < 0x110000 {
      let hi = code - 0x10000
      let lo = (hi >> 10) | 0xD800
      let hi = (hi & 0x3FF) | 0xDC00
      self[offset] = Byte((lo >> 8).to_byte())
      self[offset + 1] = Byte((lo & 0xFF).to_byte())
      self[offset + 2] = Byte((hi >> 8).to_byte())
      self[offset + 3] = Byte((hi & 0xFF).to_byte())
      Int(4)
    } else {
      error("Char out of range")
    }
  }
  _ => Unit
}
