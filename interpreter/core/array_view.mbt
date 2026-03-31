///|
pub let array_view_methods : Map[String, RuntimeFunction] = {
  "at": array_view_at_fn,
  "length": array_view_length_fn,
  "is_empty": array_view_is_empty_fn,
  "all": array_view_all_fn,
  "any": array_view_any_fn,
  "search": array_view_search_fn,
  "contains": array_view_contains_fn,
  "starts_with": array_view_starts_with_fn,
  "ends_with": array_view_ends_with_fn,
  "binary_search": array_view_binary_search_fn,
  "binary_search_by": array_view_binary_search_by_fn,
  "lexical_compare": array_view_lexical_compare_fn,
  "is_sorted": array_view_is_sorted_fn,
  "each": array_view_each_fn,
  "eachi": array_view_eachi_fn,
  "filter": array_view_filter_fn,
  "fold": array_view_fold_fn,
  "foldi": array_view_foldi_fn,
  "iter": array_view_iter_fn,
  "rev_iter": array_view_rev_iter_fn,
  "iter2": array_view_iter2_fn,
  "join": array_view_join_fn,
  "map": array_view_map_fn,
  "mapi": array_view_mapi_fn,
  "rev_fold": array_view_rev_fold_fn,
  "rev_foldi": array_view_rev_foldi_fn,
  "last": array_view_last_fn,
  "get": array_view_get_fn,
  "get_view": array_view_get_view_fn,
  "start_offset": array_view_start_offset_fn,
  "to_array": array_view_to_array_fn,
  "view": array_view_view_fn,
  "blit_to": array_view_blit_to_fn,
  "suffixes": array_view_suffixes_fn,
  "unsafe_get": array_view_unsafe_get_fn,
  "unsafe_extract_bit": array_view_unsafe_extract_bit_fn,
  "unsafe_extract_bit_signed": array_view_unsafe_extract_bit_signed_fn,
  "unsafe_extract_byte": array_view_unsafe_extract_byte_fn,
  "unsafe_extract_byte_signed": array_view_unsafe_extract_byte_signed_fn,
  "unsafe_extract_bytesview": array_view_unsafe_extract_bytesview_fn,
  "unsafe_extract_uint64_be": array_view_unsafe_extract_uint64_be_fn,
  "unsafe_extract_uint64_le": array_view_unsafe_extract_uint64_le_fn,
  "unsafe_extract_uint_be": array_view_unsafe_extract_uint_be_fn,
  "unsafe_extract_uint_le": array_view_unsafe_extract_uint_le_fn,
  "unsafe_extract_int_be": array_view_unsafe_extract_int_be_fn,
  "unsafe_extract_int_le": array_view_unsafe_extract_int_le_fn,
  "unsafe_extract_int64_be": array_view_unsafe_extract_int64_be_fn,
  "unsafe_extract_int64_le": array_view_unsafe_extract_int64_le_fn,
}

///|
fn RuntimeFunctionContext::int_arg(
  self : RuntimeFunctionContext,
  name : String,
  index : Int,
) -> Int? {
  match self.named(name) {
    Some(Int(i, ..)) => Some(i)
    _ =>
      if index >= 0 && index < self.args.length() {
        match self.args[index].val {
          Int(i, ..) => Some(i)
          _ => None
        }
      } else {
        None
      }
  }
}

///|
fn runtime_value_to_byte(value : RuntimeValue) -> Byte {
  match value {
    Byte(b) => b
    _ => Byte::default()
  }
}

///|
fn runtime_value_view_to_bytes(values : ArrayView[RuntimeValue]) -> Array[Byte] {
  values.to_array().map(runtime_value_to_byte)
}

///|
fn runtime_byte_view_to_value(view : ArrayView[Byte]) -> RuntimeValue {
  ArrayView(view.to_array().map(byte => Byte(byte))[:])
}

///|
fn array_view_extend_sign(value : UInt, len : Int) -> Int {
  let b = 32 - len
  value.reinterpret_as_int() << b >> b
}

///|
fn array_view_extend_sign64(value : UInt64, len : Int) -> Int64 {
  let b = 64 - len
  value.reinterpret_as_int64() << b >> b
}

///|
fn array_view_byte_view_extract_bit(
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
fn array_view_byte_view_extract_bit_signed(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> Int {
  let unsigned = array_view_byte_view_extract_bit(bs, offset, len)
  array_view_extend_sign(unsigned, len)
}

///|
fn array_view_byte_view_extract_byte(
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
fn array_view_byte_view_extract_byte_signed(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> Int {
  array_view_extend_sign(
    array_view_byte_view_extract_byte(bs, offset, len),
    len,
  )
}

///|
fn array_view_byte_view_extract_uint_le(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let bytes_needed = (len + 7) / 8
  let b0 = array_view_byte_view_extract_byte(bs, offset, 8)
  match bytes_needed {
    2 => {
      let b1 = array_view_byte_view_extract_byte(bs, offset + 8, len - 8)
      (b1 << 8) | b0
    }
    3 => {
      let b1 = array_view_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_view_byte_view_extract_byte(bs, offset + 16, len - 16)
      (b2 << 16) | (b1 << 8) | b0
    }
    4 => {
      let b1 = array_view_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_view_byte_view_extract_byte(bs, offset + 16, 8)
      let b3 = array_view_byte_view_extract_byte(bs, offset + 24, len - 24)
      (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    _ => abort("Invalid byte count for int32 extraction")
  }
}

///|
fn array_view_byte_view_extract_uint_be(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let bytes_needed = (len + 7) / 8
  let b0 = array_view_byte_view_extract_byte(bs, offset, 8)
  match bytes_needed {
    2 => {
      let b1 = array_view_byte_view_extract_byte(bs, offset + 8, len - 8)
      let shift = 16 - len
      let data = (b0 << 8) | (b1 << shift)
      data >> shift
    }
    3 => {
      let b1 = array_view_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_view_byte_view_extract_byte(bs, offset + 16, len - 16)
      let shift = 24 - len
      let data = (b0 << 16) | (b1 << 8) | (b2 << shift)
      data >> shift
    }
    4 => {
      let b1 = array_view_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_view_byte_view_extract_byte(bs, offset + 16, 8)
      let b3 = array_view_byte_view_extract_byte(bs, offset + 24, len - 24)
      let shift = 32 - len
      let data = (b0 << 24) | (b1 << 16) | (b2 << 8) | (b3 << shift)
      data >> shift
    }
    _ => abort("Invalid byte count for int32 extraction")
  }
}

///|
fn array_view_byte_view_extract_uint64_le(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt64 {
  let bytes_needed = (len + 7) / 8
  let b0 = array_view_byte_view_extract_byte(bs, offset, 8).to_uint64()
  let b1 = array_view_byte_view_extract_byte(bs, offset + 8, 8).to_uint64()
  let b2 = array_view_byte_view_extract_byte(bs, offset + 16, 8).to_uint64()
  let b3 = array_view_byte_view_extract_byte(bs, offset + 24, 8).to_uint64()
  match bytes_needed {
    5 => {
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, len - 32).to_uint64()
      (b4 << 32) | (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    6 => {
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_view_byte_view_extract_byte(bs, offset + 40, len - 40).to_uint64()
      (b5 << 40) | (b4 << 32) | (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    7 => {
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_view_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_view_byte_view_extract_byte(bs, offset + 48, len - 48).to_uint64()
      (b6 << 48) |
      (b5 << 40) |
      (b4 << 32) |
      (b3 << 24) |
      (b2 << 16) |
      (b1 << 8) |
      b0
    }
    8 => {
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_view_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_view_byte_view_extract_byte(bs, offset + 48, 8).to_uint64()
      let b7 = array_view_byte_view_extract_byte(bs, offset + 56, len - 56).to_uint64()
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
fn array_view_byte_view_extract_uint64_be(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt64 {
  let bytes_needed = (len + 7) / 8
  let b0 = array_view_byte_view_extract_byte(bs, offset, 8).to_uint64()
  let b1 = array_view_byte_view_extract_byte(bs, offset + 8, 8).to_uint64()
  let b2 = array_view_byte_view_extract_byte(bs, offset + 16, 8).to_uint64()
  let b3 = array_view_byte_view_extract_byte(bs, offset + 24, 8).to_uint64()
  match bytes_needed {
    5 => {
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, len - 32).to_uint64()
      let shift = 40 - len
      let data = (b0 << 32) |
        (b1 << 24) |
        (b2 << 16) |
        (b3 << 8) |
        (b4 << shift)
      data >> shift
    }
    6 => {
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_view_byte_view_extract_byte(bs, offset + 40, len - 40).to_uint64()
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
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_view_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_view_byte_view_extract_byte(bs, offset + 48, len - 48).to_uint64()
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
      let b4 = array_view_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_view_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_view_byte_view_extract_byte(bs, offset + 48, 8).to_uint64()
      let b7 = array_view_byte_view_extract_byte(bs, offset + 56, len - 56).to_uint64()
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
fn array_view_byte_view_extract_bytesview(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> ArrayView[Byte] {
  let start = offset >> 3
  let end = start + (len >> 3)
  bs.view(start~, end~)
}

///|
/// 数组长度
let array_view_length_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Int(arr.length(), raw=None)
    _ => Unit
  }
}

///|
let array_view_is_empty_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Bool(arr.is_empty())
    _ => Unit
  }
}

///|
let array_view_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Int(i, ..), .. }] => arr.at(i)
    _ => Unit
  }
}

///|
fn[T] ArrayView::buf(self : ArrayView[T]) -> UninitializedArray[T] = "%arrayview.buf"

///|
fn[T] ArrayView::start(self : ArrayView[T]) -> Int = "%arrayview.start"

///|
fn[T] ArrayView::len(self : ArrayView[T]) -> Int = "%arrayview.len"

///|
/// ArrayView start 方法 - 返回起始索引
let array_view_buf_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => UninitializedArray(arr.buf())
    _ => Unit
  }
}

///|
/// ArrayView start 方法 - 返回起始索引
let array_view_start_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Int(arr.start(), raw=None)
    _ => Unit
  }
}

///|
/// ArrayView len 方法
let array_view_len_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Int(arr.len(), raw=None)
    _ => Unit
  }
}

///|
let array_view_start_offset_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Int(arr.start_offset(), raw=None)
    _ => Unit
  }
}

///|
let array_view_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(arr.get(i))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let array_view_last_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => RuntimeValue::from_option(arr.last())
    _ => RuntimeValue::from_option(None)
  }
}

///|
let array_view_search_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val, .. }] =>
      RuntimeValue::from_option(arr.search(val).map(i => Int(i, raw=None)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
/// ArrayView all 方法
let array_view_all_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
      Bool(
        arr.all(elem => {
          ctx.context.call(f.val, ctx.pkg, [{ val: elem, kind: Positional }])
          is Bool(true)
        }),
      )
    _ => Unit
  }
}

///|
/// ArrayView any 方法
let array_view_any_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
      Bool(
        arr.any(elem => {
          ctx.context.call(f.val, ctx.pkg, [{ val: elem, kind: Positional }])
          is Bool(true)
        }),
      )
    _ => Unit
  }
}

///|
/// ArrayView contains 方法
let array_view_contains_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: x, .. }] => Bool(arr.contains(x))
    _ => Unit
  }
}

///|
let array_view_starts_with_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: ArrayView(prefix), .. }] =>
      Bool(arr.starts_with(prefix))
    _ => Bool(false)
  }
}

///|
let array_view_ends_with_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: ArrayView(suffix), .. }] =>
      Bool(arr.ends_with(suffix))
    _ => Bool(false)
  }
}

///|
let array_view_binary_search_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val, .. }] =>
      RuntimeValue::from_result(
        arr
        .binary_search(val)
        .map(x => Int(x, raw=None))
        .map_err(x => Int(x, raw=None)),
      )
    _ => Unit
  }
}

///|
let array_view_binary_search_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
      RuntimeValue::from_result(
        arr
        .binary_search_by(v => {
          match
            ctx.context.call(f.val, ctx.pkg, [{ val: v, kind: Positional }]) {
            Int(i, ..) => i
            _ => raise Error("binary_search_by closure must return int")
          }
        })
        .map(x => Int(x, raw=None))
        .map_err(x => Int(x, raw=None)),
      )
    _ => Unit
  }
}

///|
let array_view_lexical_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: ArrayView(other), .. }] =>
      Int(arr.lexical_compare(other), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let array_view_is_sorted_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Bool(arr.is_sorted())
    _ => Bool(false)
  }
}

///|
/// ArrayView each 方法
let array_view_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] => {
      arr.each(elem => {
        ctx.context.call(f.val, ctx.pkg, [{ val: elem, kind: Positional }])
        |> ignore
      })
      Unit
    }
    _ => Unit
  }
}

///|
/// ArrayView eachi 方法
let array_view_eachi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] => {
      arr.eachi((i, elem) => {
        ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: elem, kind: Positional },
        ])
        |> ignore
      })
      Unit
    }
    _ => Unit
  }
}

///|
/// ArrayView filter 方法
let array_view_filter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
      Array(
        arr.filter(elem => {
          ctx.context.call(f.val, ctx.pkg, [{ val: elem, kind: Positional }])
          is Bool(true)
        }),
      )
    _ => Unit
  }
}

///|
/// ArrayView fold 方法
let array_view_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
      arr.fold(init~, (acc, elem) => {
        ctx.context.call(f.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
/// ArrayView foldi 方法
let array_view_foldi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
      arr.foldi(init~, (i, acc, elem) => {
        ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
/// ArrayView iter 方法
let array_view_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Iter(arr.iter())
    _ => Unit
  }
}

///|
let array_view_rev_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Iter(arr.rev_iter())
    _ => Unit
  }
}

///|
/// ArrayView iter2 方法
let array_view_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(self), .. }] => {
      let len = self.length()
      let mut index = 0
      let iterator = Iter2::new(fn() {
        guard index < len else { None }
        let key = Int(index, raw=None)
        let value = self[index]
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
/// ArrayView join 方法
let array_view_join_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: String(separator), .. }] =>
      String(arr.map(elem => elem.to_string()).join(separator[:]))
    [{ val: ArrayView(arr), .. }, { val: StringView(separator), .. }] =>
      String(arr.map(elem => elem.to_string()).join(separator))
    _ => Unit
  }
}

///|
/// ArrayView map 方法
let array_view_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
      Array(
        arr.map(elem => {
          ctx.context.call(f.val, ctx.pkg, [{ val: elem, kind: Positional }])
        }),
      )
    _ => Unit
  }
}

///|
/// ArrayView mapi 方法
let array_view_mapi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
      Array(
        arr.mapi((i, elem) => {
          ctx.context.call(f.val, ctx.pkg, [
            { val: Int(i, raw=None), kind: Positional },
            { val: elem, kind: Positional },
          ])
        }),
      )
    _ => Unit
  }
}

///|
/// ArrayView rev_fold 方法
let array_view_rev_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
      arr.rev_fold(init~, (acc, elem) => {
        ctx.context.call(f.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
/// ArrayView rev_foldi 方法
let array_view_rev_foldi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
      arr.rev_foldi(init~, (i, acc, elem) => {
        ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: acc, kind: Positional },
          { val: elem, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
/// ArrayView to_array 方法
let array_view_to_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Array(arr.to_array())
    _ => Unit
  }
}

///|
let array_view_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => ArrayView(arr.view())
    [{ val: ArrayView(arr), .. }, { val: Int(start, ..), .. }] =>
      ArrayView(arr.view(start~))
    [
      { val: ArrayView(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] => ArrayView(arr.view(start~, end=end_))
    _ => Unit
  }
}

///|
let array_view_get_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] =>
      RuntimeValue::from_option(arr.get_view().map(v => ArrayView(v)))
    [{ val: ArrayView(arr), .. }, { val: Int(start, ..), .. }] =>
      RuntimeValue::from_option(arr.get_view(start~).map(v => ArrayView(v)))
    [
      { val: ArrayView(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end_, ..), .. },
    ] =>
      RuntimeValue::from_option(
        arr.get_view(start~, end=end_).map(v => ArrayView(v)),
      )
    _ => RuntimeValue::from_option(None)
  }
}

///|
let array_view_blit_to_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Array(dst), .. }] => {
      arr.blit_to(dst)
      Unit
    }
    [
      { val: ArrayView(arr), .. },
      { val: Array(dst), .. },
      { val: Int(offset, ..), .. },
    ] => {
      arr.blit_to(dst, dst_offset=offset)
      Unit
    }
    _ => Unit
  }
}

///|
let array_view_suffixes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }] => Iter(arr.suffixes().map(v => ArrayView(v)))
    [{ val: ArrayView(arr), .. }, { val: Bool(include_empty), .. }] =>
      Iter(arr.suffixes(include_empty~).map(v => ArrayView(v)))
    _ => Unit
  }
}

///|
let array_view_unsafe_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: ArrayView(arr), .. }, { val: Int(i, ..), .. }] => arr.unsafe_get(i)
    _ => Unit
  }
}

///|
let array_view_unsafe_extract_bit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_view_byte_view_extract_bit(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_view_unsafe_extract_bit_signed_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      Int(
        array_view_byte_view_extract_bit_signed(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
        raw=None,
      )
    _ => Int(0, raw=None)
  }
}

///|
let array_view_unsafe_extract_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_view_byte_view_extract_byte(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_view_unsafe_extract_byte_signed_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      Int(
        array_view_byte_view_extract_byte_signed(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
        raw=None,
      )
    _ => Int(0, raw=None)
  }
}

///|
let array_view_unsafe_extract_bytesview_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      runtime_byte_view_to_value(
        array_view_byte_view_extract_bytesview(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => Unit
  }
}

///|
let array_view_unsafe_extract_uint_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_view_byte_view_extract_uint_le(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_view_unsafe_extract_uint_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_view_byte_view_extract_uint_be(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_view_unsafe_extract_uint64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt64(
        array_view_byte_view_extract_uint64_le(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => UInt64(0UL)
  }
}

///|
let array_view_unsafe_extract_uint64_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt64(
        array_view_byte_view_extract_uint64_be(
          runtime_value_view_to_bytes(arr)[:],
          offset,
          len,
        ),
      )
    _ => UInt64(0UL)
  }
}

///|
let array_view_unsafe_extract_int_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      Int(
        array_view_extend_sign(
          array_view_byte_view_extract_uint_le(
            runtime_value_view_to_bytes(arr)[:],
            offset,
            len,
          ),
          len,
        ),
        raw=None,
      )
    _ => Int(0, raw=None)
  }
}

///|
let array_view_unsafe_extract_int_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      Int(
        array_view_extend_sign(
          array_view_byte_view_extract_uint_be(
            runtime_value_view_to_bytes(arr)[:],
            offset,
            len,
          ),
          len,
        ),
        raw=None,
      )
    _ => Int(0, raw=None)
  }
}

///|
let array_view_unsafe_extract_int64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      Int64(
        array_view_extend_sign64(
          array_view_byte_view_extract_uint64_le(
            runtime_value_view_to_bytes(arr)[:],
            offset,
            len,
          ),
          len,
        ),
      )
    _ => Int64(0L)
  }
}

///|
let array_view_unsafe_extract_int64_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: ArrayView(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      Int64(
        array_view_extend_sign64(
          array_view_byte_view_extract_uint64_be(
            runtime_value_view_to_bytes(arr)[:],
            offset,
            len,
          ),
          len,
        ),
      )
    _ => Int64(0L)
  }
}

// ///|
// /// ArrayView unsafe_extract_bit 方法
// let array_view_unsafe_extract_bit_fn : RuntimeFunction = ctx => match ctx.args {
//   [{ val: ArrayView(bs), .. }, { val: Int(offset, ..), .. }, { val: Int(_len, ..), .. }] =>
//     UInt(
//       bs
//       .map(i => match i {
//         Byte(b) => b
//         _ => raise Error("ArrayView::unsafe_extract_bit: non-byte element")
//       })
//       .unsafe_extract_bit(offset, _len),
//     )
//   _ => Unit
// }
