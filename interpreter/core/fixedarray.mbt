///|
pub let fixedarray_methods : Map[String, RuntimeFunction] = {
  "length": fixedarray_length_fn,
  "at": fixedarray_at_fn,
  "get": fixedarray_get_fn,
  "set": fixedarray_set_fn,
  "unsafe_get": fixedarray_unsafe_get_fn,
  "unsafe_set": fixedarray_unsafe_set_fn,
  "make": fixedarray_make_fn,
  "fill": fixedarray_fill_fn,
  "blit_to": fixedarray_blit_to_fn,
  "unsafe_blit": fixedarray_unsafe_blit_fn,
  "is_empty": fixedarray_is_empty_fn,
  "all": fixedarray_all_fn,
  "any": fixedarray_any_fn,
  "each": fixedarray_each_fn,
  "eachi": fixedarray_eachi_fn,
  "fold": fixedarray_fold_fn,
  "foldi": fixedarray_foldi_fn,
  "map": fixedarray_map_fn,
  "mapi": fixedarray_mapi_fn,
  "rev": fixedarray_rev_fn,
  "rev_each": fixedarray_rev_each_fn,
  "rev_eachi": fixedarray_rev_eachi_fn,
  "rev_fold": fixedarray_rev_fold_fn,
  "rev_foldi": fixedarray_rev_foldi_fn,
  "rev_in_place": fixedarray_rev_in_place_fn,
  "search": fixedarray_search_fn,
  "contains": fixedarray_contains_fn,
  "starts_with": fixedarray_starts_with_fn,
  "ends_with": fixedarray_ends_with_fn,
  "from_array": fixedarray_from_array_fn,
  "from_iter": fixedarray_from_iter_fn,
  "last": fixedarray_last_fn,
  "join": fixedarray_join_fn,
  "copy": fixedarray_copy_fn,
  "lexical_compare": fixedarray_lexical_compare_fn,
  "makei": fixedarray_makei_fn,
  "view": fixedarray_view_fn,
  "get_view": fixedarray_get_view_fn,
  "mut_view": fixedarray_mut_view_fn,
  "iter": fixedarray_iter_fn,
  "iter2": fixedarray_iter2_fn,
  "binary_search": fixedarray_binary_search_fn,
  "binary_search_by": fixedarray_binary_search_by_fn,
  "is_sorted": fixedarray_is_sorted_fn,
  "sort": fixedarray_sort_fn,
  "sort_by": fixedarray_sort_by_fn,
  "sort_by_key": fixedarray_sort_by_key_fn,
  "stable_sort": fixedarray_stable_sort_fn,
  "swap": fixedarray_swap_fn,
  "unsafe_extract_bit": fixedarray_unsafe_extract_bit_fn,
  "unsafe_extract_byte": fixedarray_unsafe_extract_byte_fn,
  "unsafe_extract_bytesview": fixedarray_unsafe_extract_bytesview_fn,
  "unsafe_extract_uint64_be": fixedarray_unsafe_extract_uint64_be_fn,
  "unsafe_extract_uint64_le": fixedarray_unsafe_extract_uint64_le_fn,
  "unsafe_extract_uint_be": fixedarray_unsafe_extract_uint_be_fn,
  "unsafe_extract_uint_le": fixedarray_unsafe_extract_uint_le_fn,
  "unsafe_reinterpret_as_bytes": fixedarray_unsafe_reinterpret_as_bytes_fn,
  "unsafe_write_uint16_be": fixedarray_unsafe_write_uint16_be_fn,
  "unsafe_write_uint16_le": fixedarray_unsafe_write_uint16_le_fn,
  "unsafe_write_uint32_be": fixedarray_unsafe_write_uint32_be_fn,
  "unsafe_write_uint32_le": fixedarray_unsafe_write_uint32_le_fn,
  "unsafe_write_uint64_be": fixedarray_unsafe_write_uint64_be_fn,
  "unsafe_write_uint64_le": fixedarray_unsafe_write_uint64_le_fn,
  "blit_from_string": fixedarray_blit_from_string_fn,
  "blit_from_bytes": fixedarray_blit_from_bytes_fn,
  "blit_from_bytesview": fixedarray_blit_from_bytesview_fn,
  "set_utf8_char": fixedarray_set_utf8_char_fn,
  "set_utf16le_char": fixedarray_set_utf16le_char_fn,
  "set_utf16be_char": fixedarray_set_utf16be_char_fn,
  "output": fixedarray_output_fn,
}

///|
fn fixedarray_runtime_value_to_byte(value : RuntimeValue) -> Byte {
  match value {
    Byte(b) => b
    _ => Byte::default()
  }
}

///|
fn fixedarray_runtime_values_to_bytes(
  values : FixedArray[RuntimeValue],
) -> Array[Byte] {
  values[:].to_array().map(fixedarray_runtime_value_to_byte)
}

///|
fn fixedarray_runtime_values_to_byte_view(
  values : FixedArray[RuntimeValue],
) -> ArrayView[Byte] {
  fixedarray_runtime_values_to_bytes(values)[:]
}

///|
fn fixedarray_runtime_byte_view_to_value(
  view : ArrayView[Byte],
) -> RuntimeValue {
  ArrayView(view.to_array().map(byte => Byte(byte))[:])
}

///|
fn fixedarray_byte_view_extract_bit(
  bs : ArrayView[Byte],
  offset : Int,
  _len : Int,
) -> UInt {
  let byte_index = offset >> 3
  let bit_shift = 7 - (offset & 7)
  let byte_val = bs.unsafe_get(byte_index).to_uint()
  (byte_val >> bit_shift) & 1U
}

///|
fn fixedarray_byte_view_extract_byte(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let byte_index = offset >> 3
  if (offset & 7) == 0 {
    let byte = bs.unsafe_get(byte_index)
    (byte >> (8 - len)).to_uint()
  } else if (offset & 7) + len <= 8 {
    let byte = bs.unsafe_get(byte_index).to_uint()
    let shift = 8 - ((offset & 7) + len)
    let mask = (1U << len) - 1
    (byte >> shift) & mask
  } else {
    let b0 = bs.unsafe_get(byte_index).to_uint()
    let b1 = bs.unsafe_get(byte_index + 1).to_uint()
    let data = (b0 << 8) | b1
    let bit_mask = (1U << (16 - (offset & 7))) - 1
    let data = data & bit_mask
    let shift = 16 - ((offset & 7) + len)
    data >> shift
  }
}

///|
fn fixedarray_byte_view_extract_uint_le(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let bytes_needed = (len + 7) / 8
  let b0 = fixedarray_byte_view_extract_byte(bs, offset, 8)
  match bytes_needed {
    2 => {
      let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, len - 8)
      (b1 << 8) | b0
    }
    3 => {
      let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = fixedarray_byte_view_extract_byte(bs, offset + 16, len - 16)
      (b2 << 16) | (b1 << 8) | b0
    }
    4 => {
      let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = fixedarray_byte_view_extract_byte(bs, offset + 16, 8)
      let b3 = fixedarray_byte_view_extract_byte(bs, offset + 24, len - 24)
      (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    _ => abort("Invalid byte count for int32 extraction")
  }
}

///|
fn fixedarray_byte_view_extract_uint_be(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let bytes_needed = (len + 7) / 8
  let b0 = fixedarray_byte_view_extract_byte(bs, offset, 8)
  match bytes_needed {
    2 => {
      let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, len - 8)
      let shift = 16 - len
      let data = (b0 << 8) | (b1 << shift)
      data >> shift
    }
    3 => {
      let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = fixedarray_byte_view_extract_byte(bs, offset + 16, len - 16)
      let shift = 24 - len
      let data = (b0 << 16) | (b1 << 8) | (b2 << shift)
      data >> shift
    }
    4 => {
      let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = fixedarray_byte_view_extract_byte(bs, offset + 16, 8)
      let b3 = fixedarray_byte_view_extract_byte(bs, offset + 24, len - 24)
      let shift = 32 - len
      let data = (b0 << 24) | (b1 << 16) | (b2 << 8) | (b3 << shift)
      data >> shift
    }
    _ => abort("Invalid byte count for int32 extraction")
  }
}

///|
fn fixedarray_byte_view_extract_uint64_le(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt64 {
  let bytes_needed = (len + 7) / 8
  let b0 = fixedarray_byte_view_extract_byte(bs, offset, 8).to_uint64()
  let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, 8).to_uint64()
  let b2 = fixedarray_byte_view_extract_byte(bs, offset + 16, 8).to_uint64()
  let b3 = fixedarray_byte_view_extract_byte(bs, offset + 24, 8).to_uint64()
  match bytes_needed {
    5 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, len - 32).to_uint64()
      (b4 << 32) | (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    6 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = fixedarray_byte_view_extract_byte(bs, offset + 40, len - 40).to_uint64()
      (b5 << 40) | (b4 << 32) | (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    7 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = fixedarray_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = fixedarray_byte_view_extract_byte(bs, offset + 48, len - 48).to_uint64()
      (b6 << 48) |
      (b5 << 40) |
      (b4 << 32) |
      (b3 << 24) |
      (b2 << 16) |
      (b1 << 8) |
      b0
    }
    8 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = fixedarray_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = fixedarray_byte_view_extract_byte(bs, offset + 48, 8).to_uint64()
      let b7 = fixedarray_byte_view_extract_byte(bs, offset + 56, len - 56).to_uint64()
      (b7 << 56) |
      (b6 << 48) |
      (b5 << 40) |
      (b4 << 32) |
      (b3 << 24) |
      (b2 << 16) |
      (b1 << 8) |
      b0
    }
    _ => abort("Invalid byte count for int64 extraction")
  }
}

///|
fn fixedarray_byte_view_extract_uint64_be(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt64 {
  let bytes_needed = (len + 7) / 8
  let b0 = fixedarray_byte_view_extract_byte(bs, offset, 8).to_uint64()
  let b1 = fixedarray_byte_view_extract_byte(bs, offset + 8, 8).to_uint64()
  let b2 = fixedarray_byte_view_extract_byte(bs, offset + 16, 8).to_uint64()
  let b3 = fixedarray_byte_view_extract_byte(bs, offset + 24, 8).to_uint64()
  match bytes_needed {
    5 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, len - 32).to_uint64()
      let shift = 40 - len
      let data = (b0 << 32) |
        (b1 << 24) |
        (b2 << 16) |
        (b3 << 8) |
        (b4 << shift)
      data >> shift
    }
    6 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = fixedarray_byte_view_extract_byte(bs, offset + 40, len - 40).to_uint64()
      let shift = 48 - len
      let data = (b0 << 40) |
        (b1 << 32) |
        (b2 << 24) |
        (b3 << 16) |
        (b4 << 8) |
        (b5 << shift)
      data >> shift
    }
    7 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = fixedarray_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = fixedarray_byte_view_extract_byte(bs, offset + 48, len - 48).to_uint64()
      let shift = 56 - len
      let data = (b0 << 48) |
        (b1 << 40) |
        (b2 << 32) |
        (b3 << 24) |
        (b4 << 16) |
        (b5 << 8) |
        (b6 << shift)
      data >> shift
    }
    8 => {
      let b4 = fixedarray_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = fixedarray_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = fixedarray_byte_view_extract_byte(bs, offset + 48, 8).to_uint64()
      let b7 = fixedarray_byte_view_extract_byte(bs, offset + 56, len - 56).to_uint64()
      let shift = 64 - len
      let data = (b0 << 56) |
        (b1 << 48) |
        (b2 << 40) |
        (b3 << 32) |
        (b4 << 24) |
        (b5 << 16) |
        (b6 << 8) |
        (b7 << shift)
      data >> shift
    }
    _ => abort("Invalid byte count for int64 extraction")
  }
}

///|
fn fixedarray_byte_view_extract_bytesview(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> ArrayView[Byte] {
  let start = offset >> 3
  let end = start + (len >> 3)
  bs.view(start~, end~)
}

///|
/// FixedArray::length 操作 - 获取数组长度
let fixedarray_length_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => Int(arr.length(), raw=None)
    _ => Unit
  }
}

///|
/// FixedArray::at 操作 - 安全获取元素
let fixedarray_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Int(i, ..), .. }] => arr.at(i)
    _ => Unit
  }
}

///|
/// FixedArray::get 操作 - 安全获取元素
let fixedarray_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(arr.get(i))
    _ => RuntimeValue::from_option(None)
  }
}

///|
/// FixedArray::set 操作 - 设置元素
let fixedarray_set_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Int(i, ..), .. }, { val, .. }] => {
      arr.set(i, val)
      Unit
    }
    _ => Unit
  }
}

///|
/// FixedArray::unsafe_get 操作 - 不安全获取元素
let fixedarray_unsafe_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Int(i, ..), .. }] => arr[i]
    _ => Unit
  }
}

///|
/// FixedArray::unsafe_set 操作 - 不安全设置元素
let fixedarray_unsafe_set_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Int(i, ..), .. }, { val, .. }] => {
      arr[i] = val
      Unit
    }
    _ => Unit
  }
}

///|
/// FixedArray::make 操作 - 创建指定大小和初始值的固定数组
let fixedarray_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val, .. }] =>
      FixedArray(FixedArray::make(len, val))
    _ => Unit
  }
}

///|
/// FixedArray::fill 操作 - 填充数组
let fixedarray_fill_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val, .. }] => {
      let start = match ctx.int_arg("start", 2) {
        Some(i) => i
        None => 0
      }
      let end = match ctx.int_arg("end", 3) {
        Some(i) => i
        None => arr.length()
      }
      arr.fill(val, start~, end~)
      Unit
    }
    _ => Unit
  }
}

///|
/// FixedArray::blit_to 操作 - 复制数组内容
let fixedarray_blit_to_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(src), .. }, { val: FixedArray(dst), .. }] => {
      let len = match ctx.int_arg("len", 2) {
        Some(i) => i
        None => src.length()
      }
      let src_offset = match ctx.int_arg("src_offset", 3) {
        Some(i) => i
        None => 0
      }
      let dst_offset = match ctx.int_arg("dst_offset", 4) {
        Some(i) => i
        None => 0
      }
      src.blit_to(dst, len~, src_offset~, dst_offset~)
      Unit
    }
    _ => Unit
  }
}

///|
/// FixedArray::unsafe_blit 操作 - 不安全的数组复制
let fixedarray_unsafe_blit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(dst), .. },
      { val: Int(dst_offset, ..), .. },
      { val: FixedArray(src), .. },
      { val: Int(src_offset, ..), .. },
      { val: Int(len, ..), .. },
    ] => {
      dst.unsafe_blit(dst_offset, src, src_offset, len)
      Unit
    }
    _ => Unit
  }
}

///|
/// FixedArray::is_empty 操作 - 检查数组是否为空
let fixedarray_is_empty_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => Bool(arr.is_empty())
    _ => Unit
  }
}

///|
/// FixedArray::iter 操作 - 获取迭代器
let fixedarray_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => Iter(arr.iter())
    _ => Unit
  }
}

///|
/// FixedArray::iter2 操作 - 获取带索引的迭代器
let fixedarray_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => {
      let len = arr.length()
      let mut index = 0
      let iterator = Iter2::new(fn() {
        guard index < len else { None }
        let key = Int(index, raw=None)
        let value = arr[index]
        index += 1
        Some((key, value))
      })
      let iter2_impl = iterator.iter2()
      Iter2(iter2_impl)
    }
    _ => Unit
  }
}

///|
/// FixedArray::binary_search 操作 - 二分查找
let fixedarray_binary_search_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: target, .. }] =>
      arr
      .binary_search(target)
      .map(x => Int(x, raw=None))
      .map_err(x => Int(x, raw=None))
      |> RuntimeValue::from_result
    _ => Unit
  }
}

///|
/// FixedArray::binary_search_by 操作 - 使用比较函数的二分查找
let fixedarray_binary_search_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] =>
      arr
      .binary_search_by(v => {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [{ val: v, kind: Positional }])) {
          Int(i, ..) => i
          _ => raise Error("binary_search_by closure must return int")
        }
      })
      .map(x => Int(x, raw=None))
      .map_err(x => Int(x, raw=None))
      |> RuntimeValue::from_result
    _ => Unit
  }
}

///|
/// FixedArray::set_utf16le_char operation - Set UTF-16LE character bytes
let fixedarray_set_utf16le_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(self), .. },
      { val: Int(offset, ..), .. },
      { val: Char(value), .. },
    ] => {
      let code = value.to_uint()
      if code < 0x10000 {
        self[offset] = Byte((code & 0xFF).to_byte())
        self[offset + 1] = Byte((code >> 8).to_byte())
        Int(2, raw=None)
      } else if code < 0x110000 {
        let hi = code - 0x10000
        let lo = (hi >> 10) | 0xD800
        let hi = (hi & 0x3FF) | 0xDC00
        self[offset] = Byte((lo & 0xFF).to_byte())
        self[offset + 1] = Byte((lo >> 8).to_byte())
        self[offset + 2] = Byte((hi & 0xFF).to_byte())
        self[offset + 3] = Byte((hi >> 8).to_byte())
        Int(4, raw=None)
      } else {
        error("Char out of range")
      }
    }
    _ => Unit
  }
}

///|
/// FixedArray::set_utf16be_char operation - Set UTF-16BE character bytes
let fixedarray_set_utf16be_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(self), .. },
      { val: Int(offset, ..), .. },
      { val: Char(value), .. },
    ] => {
      let code = value.to_uint()
      if code < 0x10000 {
        self[offset] = Byte((code >> 8).to_byte())
        self[offset + 1] = Byte((code & 0xFF).to_byte())
        Int(2, raw=None)
      } else if code < 0x110000 {
        let hi = code - 0x10000
        let lo = (hi >> 10) | 0xD800
        let hi = (hi & 0x3FF) | 0xDC00
        self[offset] = Byte((lo >> 8).to_byte())
        self[offset + 1] = Byte((lo & 0xFF).to_byte())
        self[offset + 2] = Byte((hi >> 8).to_byte())
        self[offset + 3] = Byte((hi & 0xFF).to_byte())
        Int(4, raw=None)
      } else {
        error("Char out of range")
      }
    }
    _ => Unit
  }
}

///|
let fixedarray_all_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] => {
      let result = arr.all(fn(elem) {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [
            { val: elem, kind: Positional },
          ])) {
          Bool(b) => b
          _ => false
        }
      })
      Bool(result)
    }
    _ => Unit
  }
}

///|
let fixedarray_any_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] => {
      let result = arr.any(fn(elem) {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [
            { val: elem, kind: Positional },
          ])) {
          Bool(true) => true
          _ => false
        }
      })
      Bool(result)
    }
    _ => Unit
  }
}

///|
let fixedarray_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] => {
      arr.each(fn(elem) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val: elem, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_eachi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] => {
      arr.eachi(fn(i, elem) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.fold(init=init_val, fn(acc, elem) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let fixedarray_foldi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.foldi(init=init_val, fn(i, acc, elem) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let fixedarray_from_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => FixedArray(FixedArray::from_array(arr))
    _ => Unit
  }
}

///|
let fixedarray_from_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => FixedArray(FixedArray::from_iter(iter))
    _ => Unit
  }
}

///|
let fixedarray_get_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] =>
      RuntimeValue::from_option(arr.get_view().map(v => ArrayView(v)))
    [{ val: FixedArray(arr), .. }, { val: Int(start, ..), .. }] => {
      let end = match ctx.int_arg("end", 2) {
        Some(i) => i
        None => arr.length()
      }
      RuntimeValue::from_option(
        arr.get_view(start~, end~).map(v => ArrayView(v)),
      )
    }
    [
      { val: FixedArray(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end, ..), .. },
    ] =>
      RuntimeValue::from_option(
        arr.get_view(start~, end~).map(v => ArrayView(v)),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let fixedarray_is_sorted_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => Bool(arr.is_sorted())
    _ => Bool(false)
  }
}

///|
let fixedarray_join_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: String(sep), .. }] =>
      String(arr.map(v => v.to_string()).join(sep[:]))
    [{ val: FixedArray(arr), .. }, { val: StringView(sep), .. }] =>
      String(arr.map(v => v.to_string()).join(sep))
    _ => Unit
  }
}

///|
let fixedarray_copy_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => FixedArray(arr.copy())
    _ => Unit
  }
}

///|
let fixedarray_last_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => RuntimeValue::from_option(arr.last())
    _ => RuntimeValue::from_option(None)
  }
}

///|
let fixedarray_lexical_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: FixedArray(other), .. }] =>
      Int(arr[:].lexical_compare(other[:]), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let fixedarray_makei_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val: Fn(f), .. }] =>
      FixedArray(
        FixedArray::makei(len, fn(i) {
          try! ctx.context.call(f.val, ctx.pkg, [
            { val: Int(i, raw=None), kind: Positional },
          ])
        }),
      )
    _ => Unit
  }
}

///|
let fixedarray_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] =>
      FixedArray(
        arr.map(fn(elem) {
          try! ctx.context.call(f.val, ctx.pkg, [
            { val: elem, kind: Positional },
          ])
        }),
      )
    _ => Unit
  }
}

///|
let fixedarray_mapi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] =>
      FixedArray(
        arr.mapi(fn(i, elem) {
          try! ctx.context.call(f.val, ctx.pkg, [
            { val: Int(i, raw=None), kind: Positional },
            { val: elem, kind: Positional },
          ])
        }),
      )
    _ => Unit
  }
}

///|
let fixedarray_mut_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => ArrayView(arr.mut_view().view())
    [{ val: FixedArray(arr), .. }, { val: Int(start, ..), .. }] => {
      let end = match ctx.int_arg("end", 2) {
        Some(i) => i
        None => arr.length()
      }
      ArrayView(arr.mut_view(start~, end~).view())
    }
    [
      { val: FixedArray(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end, ..), .. },
    ] => ArrayView(arr.mut_view(start~, end~).view())
    _ => Unit
  }
}

///|
let fixedarray_rev_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => FixedArray(arr.rev())
    _ => Unit
  }
}

///|
let fixedarray_rev_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] => {
      arr.rev_each(fn(elem) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val: elem, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_rev_eachi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(f), .. }] => {
      arr.rev_eachi(fn(i, elem) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_rev_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.rev_fold(init=init_val, fn(acc, elem) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let fixedarray_rev_foldi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.rev_foldi(init=init_val, fn(i, acc, elem) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let fixedarray_rev_in_place_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => {
      arr.rev_in_place()
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_search_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: value, .. }] =>
      RuntimeValue::from_option(arr.search(value).map(i => Int(i, raw=None)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let fixedarray_contains_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: value, .. }] =>
      Bool(arr.contains(value))
    _ => Bool(false)
  }
}

///|
let fixedarray_starts_with_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: FixedArray(prefix), .. }] =>
      Bool(arr.starts_with(prefix))
    _ => Bool(false)
  }
}

///|
let fixedarray_ends_with_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: FixedArray(suffix), .. }] =>
      Bool(arr.ends_with(suffix))
    _ => Bool(false)
  }
}

///|
let fixedarray_sort_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => {
      arr.sort()
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_sort_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(cmp), .. }] => {
      arr.sort_by(fn(left, right) {
        match
          (try! ctx.context.call(cmp.val, ctx.pkg, [
            { val: left, kind: Positional },
            { val: right, kind: Positional },
          ])) {
          Int(i, ..) => i
          _ => 0
        }
      })
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_sort_by_key_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: Fn(map), .. }] => {
      arr.sort_by_key(fn(val) {
        try! ctx.context.call(map.val, ctx.pkg, [{ val, kind: Positional }])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_stable_sort_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => {
      arr.stable_sort()
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_swap_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(i, ..), .. },
      { val: Int(j, ..), .. },
    ] => {
      arr.swap(i, j)
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => ArrayView(arr.view())
    [{ val: FixedArray(arr), .. }, { val: Int(start, ..), .. }] => {
      let end = match ctx.int_arg("end", 2) {
        Some(i) => i
        None => arr.length()
      }
      ArrayView(arr.view(start~, end~))
    }
    [
      { val: FixedArray(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end, ..), .. },
    ] => ArrayView(arr.view(start~, end~))
    _ => Unit
  }
}

///|
let fixedarray_unsafe_extract_bit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        fixedarray_byte_view_extract_bit(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let fixedarray_unsafe_extract_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        fixedarray_byte_view_extract_byte(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let fixedarray_unsafe_extract_bytesview_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      fixedarray_runtime_byte_view_to_value(
        fixedarray_byte_view_extract_bytesview(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => Unit
  }
}

///|
let fixedarray_unsafe_extract_uint_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        fixedarray_byte_view_extract_uint_le(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let fixedarray_unsafe_extract_uint_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        fixedarray_byte_view_extract_uint_be(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let fixedarray_unsafe_extract_uint64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt64(
        fixedarray_byte_view_extract_uint64_le(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt64(0UL)
  }
}

///|
let fixedarray_unsafe_extract_uint64_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt64(
        fixedarray_byte_view_extract_uint64_be(
          fixedarray_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt64(0UL)
  }
}

///|
let fixedarray_unsafe_reinterpret_as_bytes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] =>
      Bytes(Bytes::from_array(fixedarray_runtime_values_to_bytes(arr)))
    _ => Bytes(b"")
  }
}

///|
let fixedarray_unsafe_write_uint16_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(index, ..), .. },
      { val: UInt16(value), .. },
    ] => {
      arr[index] = Byte((value & 0xFF).to_byte())
      arr[index + 1] = Byte((value >> 8).to_byte())
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_unsafe_write_uint16_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(index, ..), .. },
      { val: UInt16(value), .. },
    ] => {
      arr[index] = Byte((value >> 8).to_byte())
      arr[index + 1] = Byte((value & 0xFF).to_byte())
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_unsafe_write_uint32_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(index, ..), .. },
      { val: UInt(value), .. },
    ] => {
      for i in 0..<=3 {
        arr[index + i] = Byte((value >> (8 * i)).to_byte())
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_unsafe_write_uint32_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(index, ..), .. },
      { val: UInt(value), .. },
    ] => {
      for i in 0..<=3 {
        arr[index + i] = Byte((value >> (8 * (3 - i))).to_byte())
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_unsafe_write_uint64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(index, ..), .. },
      { val: UInt64(value), .. },
    ] => {
      for i in 0..<=7 {
        arr[index + i] = Byte((value >> (8 * i)).to_byte())
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_unsafe_write_uint64_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(index, ..), .. },
      { val: UInt64(value), .. },
    ] => {
      for i in 0..<=7 {
        arr[index + i] = Byte((value >> (8 * (7 - i))).to_byte())
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_blit_from_string_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(bytes_offset, ..), .. },
      { val: String(str), .. },
      { val: Int(str_offset, ..), .. },
      { val: Int(length, ..), .. },
    ] => {
      guard bytes_offset >= 0 &&
        str_offset >= 0 &&
        length >= 0 &&
        bytes_offset + length * 2 <= arr.length() &&
        str_offset + length <= str.length() else {
        abort("bounds check failed")
      }
      let end_str_offset = str_offset + length
      for i = str_offset, j = bytes_offset
          i < end_str_offset
          i = i + 1, j = j + 2 {
        let code = str.unsafe_get(i).to_uint()
        arr[j] = Byte((code & 0xFF).to_byte())
        arr[j + 1] = Byte((code >> 8).to_byte())
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_blit_from_bytes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(bytes_offset, ..), .. },
      { val: Bytes(src), .. },
      { val: Int(src_offset, ..), .. },
      { val: Int(length, ..), .. },
    ] => {
      guard bytes_offset >= 0 &&
        src_offset >= 0 &&
        length >= 0 &&
        bytes_offset + length <= arr.length() &&
        src_offset + length <= src.length() else {
        abort("bounds check failed")
      }
      for i in 0..<length {
        arr[bytes_offset + i] = Byte(src.unsafe_get(src_offset + i))
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_blit_from_bytesview_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(bytes_offset, ..), .. },
      { val: ArrayView(src), .. },
    ] => {
      let len = src.length()
      guard bytes_offset >= 0 && bytes_offset + len <= arr.length() else {
        abort("bounds check failed")
      }
      for i in 0..<len {
        arr[bytes_offset + i] = src[i]
      }
      Unit
    }
    _ => Unit
  }
}

///|
let fixedarray_set_utf8_char_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: FixedArray(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Char(value), .. },
    ] => {
      let code = value.to_uint()
      match code {
        _..<0x80 => {
          arr[offset] = Byte((code & 0x7F).to_byte())
          Int(1, raw=None)
        }
        _..<0x0800 => {
          arr[offset] = Byte((((code >> 6) & 0x1F) | 0xC0).to_byte())
          arr[offset + 1] = Byte(((code & 0x3F) | 0x80).to_byte())
          Int(2, raw=None)
        }
        _..<0x010000 => {
          arr[offset] = Byte((((code >> 12) & 0x0F) | 0xE0).to_byte())
          arr[offset + 1] = Byte((((code >> 6) & 0x3F) | 0x80).to_byte())
          arr[offset + 2] = Byte(((code & 0x3F) | 0x80).to_byte())
          Int(3, raw=None)
        }
        _..<0x110000 => {
          arr[offset] = Byte((((code >> 18) & 0x07) | 0xF0).to_byte())
          arr[offset + 1] = Byte((((code >> 12) & 0x3F) | 0x80).to_byte())
          arr[offset + 2] = Byte((((code >> 6) & 0x3F) | 0x80).to_byte())
          arr[offset + 3] = Byte(((code & 0x3F) | 0x80).to_byte())
          Int(4, raw=None)
        }
        _ => abort("Char out of range")
      }
    }
    _ => Unit
  }
}

///|
let fixedarray_output_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }, { val: StringBuilder(logger), .. }] => {
      arr.output(logger)
      Unit
    }
    _ => Unit
  }
}
