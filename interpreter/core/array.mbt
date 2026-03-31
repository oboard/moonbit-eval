///|
pub let array_methods : Map[String, RuntimeFunction] = {
  "new": array_new_fn,
  "length": array_length_fn,
  "at": array_at_fn,
  "unsafe_get": array_unsafe_get_fn,
  "unsafe_set": array_unsafe_set_fn,
  "push": array_push_fn,
  "clear": array_clear_fn,
  "is_empty": array_is_empty_fn,
  "rev": array_rev_fn,
  "copy": array_copy_fn,
  "join": array_join_fn,
  "swap": array_swap_fn,
  "get": array_get_fn,
  "append": array_append_fn,
  "set": array_set_fn,
  "pop": array_pop_fn,
  "unsafe_pop": array_unsafe_pop_fn,
  "unsafe_pop_back": array_unsafe_pop_back_fn,
  "insert": array_insert_fn,
  "remove": array_remove_fn,
  "contains": array_contains_fn,
  "search": array_search_fn,
  "search_by": array_search_by_fn,
  "binary_search": array_binary_search_fn,
  "binary_search_by": array_binary_search_by_fn,
  "capacity": array_capacity_fn,
  "resize": array_resize_fn,
  "truncate": array_truncate_fn,
  "reserve_capacity": array_reserve_capacity_fn,
  "fill": array_fill_fn,
  "view": array_view_fn,
  "get_view": array_get_view_fn,
  "blit_to": array_blit_to_fn,
  "unsafe_blit": array_unsafe_blit_fn,
  "unsafe_blit_fixed": array_unsafe_blit_fixed_fn,
  "split_at": array_split_at_fn,
  "split": array_split_fn,
  "starts_with": array_starts_with_fn,
  "ends_with": array_ends_with_fn,
  "strip_prefix": array_strip_prefix_fn,
  "strip_suffix": array_strip_suffix_fn,
  "suffixes": array_suffixes_fn,
  "all": array_all_fn,
  "any": array_any_fn,
  "each": array_each_fn,
  "eachi": array_eachi_fn,
  "rev_each": array_rev_each_fn,
  "rev_eachi": array_rev_eachi_fn,
  "map": array_map_fn,
  "map_in_place": array_map_in_place_fn,
  "mapi": array_mapi_fn,
  "mapi_in_place": array_mapi_in_place_fn,
  "filter": array_filter_fn,
  "filter_map": array_filter_map_fn,
  "extract_if": array_extract_if_fn,
  "retain": array_retain_fn,
  "retain_map": array_retain_map_fn,
  "fold": array_fold_fn,
  "foldi": array_foldi_fn,
  "rev_fold": array_rev_fold_fn,
  "rev_foldi": array_rev_foldi_fn,
  "make": array_make_fn,
  "makei": array_makei_fn,
  "iter": array_iter_fn,
  "rev_iter": array_rev_iter_fn,
  "iter2": array_iter2_fn,
  "from_fixed_array": array_from_fixed_array_fn,
  "from_iter": array_from_iter_fn,
  "repeat": array_repeat_fn,
  "flatten": array_flatten_fn,
  "last": array_last_fn,
  "zip_to_iter2": array_zip_to_iter2_fn,
  "unzip": array_unzip_fn,
  "push_iter": array_push_iter_fn,
  "chunks": array_chunks_fn,
  "chunk_by": array_chunk_by_fn,
  "windows": array_windows_fn,
  "drain": array_drain_fn,
  "dedup": array_dedup_fn,
  "shuffle": array_shuffle_fn,
  "shuffle_in_place": array_shuffle_in_place_fn,
  "sort_by": array_sort_by_fn,
  "sort_by_key": array_sort_by_key_fn,
  "mut_view": array_mut_view_fn,
  "is_sorted": array_is_sorted_fn,
  "lexical_compare": array_lexical_compare_fn,
  "shrink_to_fit": array_shrink_to_fit_fn,
  "rev_in_place": array_rev_in_place_fn,
  "unsafe_extract_bit": array_unsafe_extract_bit_fn,
  "unsafe_extract_byte": array_unsafe_extract_byte_fn,
  "unsafe_extract_bytesview": array_unsafe_extract_bytesview_fn,
  "unsafe_extract_uint64_be": array_unsafe_extract_uint64_be_fn,
  "unsafe_extract_uint64_le": array_unsafe_extract_uint64_le_fn,
  "unsafe_extract_uint_be": array_unsafe_extract_uint_be_fn,
  "unsafe_extract_uint_le": array_unsafe_extract_uint_le_fn,
  "sort": array_sort_fn,
  "zip": array_zip_fn,
}

///|
/// 数组排序
let array_sort_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      arr.sort()
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组zip操作
let array_zip_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr1), .. }, { val: Array(arr2), .. }] =>
      Array(arr1.zip(arr2).map(pair => Tuple([pair.0, pair.1])))
    _ => Unit
  }
}

///|
/// 数组make操作
let array_make_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val, .. }] => Array(Array::make(len, val))
    _ => Unit
  }
}

///|
/// 数组new操作
let array_new_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), kind: LabelledOption("capacity") }] =>
      Array(Array::new(capacity=len))
    _ => Array(Array::new())
  }
}

///|
/// 数组长度
let array_length_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Int(arr.length(), raw=None)
    _ => Unit
  }
}

///|
fn array_runtime_value_to_byte(value : RuntimeValue) -> Byte {
  match value {
    Byte(b) => b
    _ => Byte::default()
  }
}

///|
fn array_runtime_values_to_bytes(values : Array[RuntimeValue]) -> Array[Byte] {
  values.map(array_runtime_value_to_byte)
}

///|
fn array_runtime_values_to_byte_view(
  values : Array[RuntimeValue],
) -> ArrayView[Byte] {
  array_runtime_values_to_bytes(values)[:]
}

///|
fn array_runtime_byte_view_to_value(view : ArrayView[Byte]) -> RuntimeValue {
  ArrayView(view.to_array().map(byte => Byte(byte))[:])
}

///|
fn array_byte_view_extract_bit(
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
fn array_byte_view_extract_byte(
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
fn array_byte_view_extract_uint_le(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let bytes_needed = (len + 7) / 8
  let b0 = array_byte_view_extract_byte(bs, offset, 8)
  match bytes_needed {
    2 => {
      let b1 = array_byte_view_extract_byte(bs, offset + 8, len - 8)
      (b1 << 8) | b0
    }
    3 => {
      let b1 = array_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_byte_view_extract_byte(bs, offset + 16, len - 16)
      (b2 << 16) | (b1 << 8) | b0
    }
    4 => {
      let b1 = array_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_byte_view_extract_byte(bs, offset + 16, 8)
      let b3 = array_byte_view_extract_byte(bs, offset + 24, len - 24)
      (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    _ => abort("Invalid byte count for int32 extraction")
  }
}

///|
fn array_byte_view_extract_uint_be(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt {
  let bytes_needed = (len + 7) / 8
  let b0 = array_byte_view_extract_byte(bs, offset, 8)
  match bytes_needed {
    2 => {
      let b1 = array_byte_view_extract_byte(bs, offset + 8, len - 8)
      let shift = 16 - len
      let data = (b0 << 8) | (b1 << shift)
      data >> shift
    }
    3 => {
      let b1 = array_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_byte_view_extract_byte(bs, offset + 16, len - 16)
      let shift = 24 - len
      let data = (b0 << 16) | (b1 << 8) | (b2 << shift)
      data >> shift
    }
    4 => {
      let b1 = array_byte_view_extract_byte(bs, offset + 8, 8)
      let b2 = array_byte_view_extract_byte(bs, offset + 16, 8)
      let b3 = array_byte_view_extract_byte(bs, offset + 24, len - 24)
      let shift = 32 - len
      let data = (b0 << 24) | (b1 << 16) | (b2 << 8) | (b3 << shift)
      data >> shift
    }
    _ => abort("Invalid byte count for int32 extraction")
  }
}

///|
fn array_byte_view_extract_uint64_le(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt64 {
  let bytes_needed = (len + 7) / 8
  let b0 = array_byte_view_extract_byte(bs, offset, 8).to_uint64()
  let b1 = array_byte_view_extract_byte(bs, offset + 8, 8).to_uint64()
  let b2 = array_byte_view_extract_byte(bs, offset + 16, 8).to_uint64()
  let b3 = array_byte_view_extract_byte(bs, offset + 24, 8).to_uint64()
  match bytes_needed {
    5 => {
      let b4 = array_byte_view_extract_byte(bs, offset + 32, len - 32).to_uint64()
      (b4 << 32) | (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    6 => {
      let b4 = array_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_byte_view_extract_byte(bs, offset + 40, len - 40).to_uint64()
      (b5 << 40) | (b4 << 32) | (b3 << 24) | (b2 << 16) | (b1 << 8) | b0
    }
    7 => {
      let b4 = array_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_byte_view_extract_byte(bs, offset + 48, len - 48).to_uint64()
      (b6 << 48) |
      (b5 << 40) |
      (b4 << 32) |
      (b3 << 24) |
      (b2 << 16) |
      (b1 << 8) |
      b0
    }
    8 => {
      let b4 = array_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_byte_view_extract_byte(bs, offset + 48, 8).to_uint64()
      let b7 = array_byte_view_extract_byte(bs, offset + 56, len - 56).to_uint64()
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
fn array_byte_view_extract_uint64_be(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> UInt64 {
  let bytes_needed = (len + 7) / 8
  let b0 = array_byte_view_extract_byte(bs, offset, 8).to_uint64()
  let b1 = array_byte_view_extract_byte(bs, offset + 8, 8).to_uint64()
  let b2 = array_byte_view_extract_byte(bs, offset + 16, 8).to_uint64()
  let b3 = array_byte_view_extract_byte(bs, offset + 24, 8).to_uint64()
  match bytes_needed {
    5 => {
      let b4 = array_byte_view_extract_byte(bs, offset + 32, len - 32).to_uint64()
      let shift = 40 - len
      let data = (b0 << 32) |
        (b1 << 24) |
        (b2 << 16) |
        (b3 << 8) |
        (b4 << shift)
      data >> shift
    }
    6 => {
      let b4 = array_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_byte_view_extract_byte(bs, offset + 40, len - 40).to_uint64()
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
      let b4 = array_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_byte_view_extract_byte(bs, offset + 48, len - 48).to_uint64()
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
      let b4 = array_byte_view_extract_byte(bs, offset + 32, 8).to_uint64()
      let b5 = array_byte_view_extract_byte(bs, offset + 40, 8).to_uint64()
      let b6 = array_byte_view_extract_byte(bs, offset + 48, 8).to_uint64()
      let b7 = array_byte_view_extract_byte(bs, offset + 56, len - 56).to_uint64()
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
fn array_byte_view_extract_bytesview(
  bs : ArrayView[Byte],
  offset : Int,
  len : Int,
) -> ArrayView[Byte] {
  let start = offset >> 3
  let end = start + (len >> 3)
  bs.view(start~, end~)
}

///|
fn runtime_option_value(value : RuntimeValue) -> RuntimeValue? {
  match value {
    Constructor({ val: { name: "Some", fields: [{ value: x, .. }] }, .. }) =>
      Some(x)
    Constructor({ val: { name: "None", .. }, .. }) => None
    _ => None
  }
}

///|
/// 数组push操作
let array_push_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val, .. }] => {
      arr.push(val)
      Array(arr)
    }
    _ => Unit
  }
}

///|
let array_push_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Iter(iter), .. }] => {
      arr.push_iter(iter)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组clear操作
let array_clear_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      arr.clear()
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组is_empty操作
let array_is_empty_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Bool(arr.is_empty())
    _ => Unit
  }
}

///|
/// 数组reverse操作
let array_rev_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Array(arr.rev())
    _ => Unit
  }
}

///|
let array_rev_in_place_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      arr.rev_in_place()
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组copy操作
let array_copy_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Array(arr.copy())
    _ => Unit
  }
}

///|
/// 数组join操作
let array_join_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: String(sep), .. }] =>
      String(arr.map(v => v.to_string()).join(sep[:]))
    [{ val: Array(arr), .. }, { val: StringView(sep), .. }] =>
      String(arr.map(v => v.to_string()).join(sep))
    _ => Unit
  }
}

///|
/// 数组swap操作
let array_swap_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }, { val: Int(j, ..), .. }] => {
      arr.swap(i, j)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组get操作
let array_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }] =>
      RuntimeValue::from_option(arr.get(i))
    _ => Unit
  }
}

///|
/// 数组append操作
let array_append_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(arr2), .. }] => {
      arr.append(arr2)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组set操作
let array_set_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }, { val, .. }] => {
      arr[i] = val
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组pop操作
let array_pop_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => RuntimeValue::from_option(arr.pop())
    _ => Unit
  }
}

///|
/// 数组insert操作
let array_insert_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }, { val, .. }] => {
      arr.insert(i, val)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组remove操作
let array_remove_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }] => arr.remove(i)
    _ => Unit
  }
}

///|
/// 数组contains操作
let array_contains_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val, .. }] => Bool(arr.contains(val))
    _ => Unit
  }
}

///|
/// 数组search操作
let array_search_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val, .. }] =>
      RuntimeValue::from_option(arr.search(val).map(fn(i) { Int(i, raw=None) }))
    _ => Unit
  }
}

///|
/// 数组capacity操作
let array_capacity_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Int(arr.capacity(), raw=None)
    _ => Unit
  }
}

///|
/// 数组resize操作
let array_resize_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(new_size, ..), .. },
      { val: fill_val, .. },
      ..,
    ] => {
      arr.resize(new_size, fill_val)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组truncate操作
let array_truncate_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(len, ..), .. }] => {
      arr.truncate(len)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组reserve_capacity操作
let array_reserve_capacity_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(additional, ..), .. }] => {
      arr.reserve_capacity(additional)
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组each操作
let array_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.each(fn(val) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组eachi操作
let array_eachi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.eachi(fn(i, val) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组map操作
let array_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let new_arr = arr.map(fn(val) {
        try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])
      })
      Array(new_arr)
    }
    _ => Unit
  }
}

///|
/// 数组mapi操作
let array_mapi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let new_arr = arr.mapi(fn(i, val) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val, kind: Positional },
        ])
      })
      Array(new_arr)
    }
    _ => Unit
  }
}

///|
/// 数组filter操作
let array_filter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let new_arr = arr.filter(fn(val) {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])) {
          Bool(b) => b
          _ => false
        }
      })
      Array(new_arr)
    }
    _ => Unit
  }
}

///|
/// 数组fold操作
let array_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }, ..] =>
      arr.fold(init=init_val, fn(acc, val) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
/// 数组index_of操作
let array_search_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let index = arr.search_by(val => {
        (try? ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }]))
        is Ok(Bool(true))
      })
      RuntimeValue::from_option(index.map(x => Int(x, raw=None)))
    }
    _ => Unit
  }
}

///|
let array_shrink_to_fit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      arr.shrink_to_fit()
      Unit
    }
    _ => Unit
  }
}

///|
/// 数组iter操作
let array_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Iter(arr.iter())
    _ => Unit
  }
}

///|
let array_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
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
let array_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }] => arr.at(i)
    _ => Unit
  }
}

///|
let array_unsafe_get_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }] => arr.unsafe_get(i)
    _ => Unit
  }
}

///|
let array_unsafe_set_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(i, ..), .. }, { val, .. }] => {
      arr.unsafe_set(i, val)
      Unit
    }
    _ => Unit
  }
}

///|
let array_unsafe_pop_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => arr.unsafe_pop()
    _ => Unit
  }
}

///|
let array_unsafe_pop_back_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      arr.unsafe_pop_back()
      Unit
    }
    _ => Unit
  }
}

///|
let array_all_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let result = arr.all(fn(val) {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])) {
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
let array_any_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let result = arr.any(fn(val) {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])) {
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
let array_binary_search_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val, .. }] =>
      RuntimeValue::from_result(
        arr[:]
        .binary_search(val)
        .map(x => Int(x, raw=None))
        .map_err(x => Int(x, raw=None)),
      )
    _ => Unit
  }
}

///|
let array_binary_search_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] =>
      RuntimeValue::from_result(
        arr[:]
        .binary_search_by(v => {
          match
            (try! ctx.context.call(f.val, ctx.pkg, [
              { val: v, kind: Positional },
            ])) {
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
let array_fill_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val, .. }] => {
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
let array_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => ArrayView(arr[:])
    [{ val: Array(arr), .. }, { val: Int(start, ..), .. }] => {
      let end = match ctx.int_arg("end", 2) {
        Some(i) => i
        None => arr.length()
      }
      ArrayView(arr.view(start~, end~))
    }
    [
      { val: Array(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end, ..), .. },
    ] => ArrayView(arr.view(start~, end~))
    _ => Unit
  }
}

///|
let array_get_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] =>
      RuntimeValue::from_option(arr.get_view().map(v => ArrayView(v)))
    [{ val: Array(arr), .. }, { val: Int(start, ..), .. }] => {
      let end = match ctx.int_arg("end", 2) {
        Some(i) => i
        None => arr.length()
      }
      RuntimeValue::from_option(
        arr.get_view(start~, end~).map(v => ArrayView(v)),
      )
    }
    [
      { val: Array(arr), .. },
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
let array_blit_to_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(src), .. }, { val: Array(dst), .. }] => {
      src[:].blit_to(dst)
      Unit
    }
    [
      { val: Array(src), .. },
      { val: Array(dst), .. },
      { val: Int(len, ..), .. },
    ] => {
      src[:len].blit_to(dst)
      Unit
    }
    [
      { val: Array(src), .. },
      { val: Array(dst), .. },
      { val: Int(len, ..), .. },
      { val: Int(src_offset, ..), .. },
    ] => {
      src[src_offset:src_offset + len].blit_to(dst)
      Unit
    }
    [
      { val: Array(src), .. },
      { val: Array(dst), .. },
      { val: Int(len, ..), .. },
      { val: Int(src_offset, ..), .. },
      { val: Int(dst_offset, ..), .. },
    ] => {
      src[src_offset:src_offset + len].blit_to(dst, dst_offset~)
      Unit
    }
    _ => Unit
  }
}

///|
let array_unsafe_blit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(dst), .. },
      { val: Int(dst_offset, ..), .. },
      { val: Array(src), .. },
      { val: Int(src_offset, ..), .. },
      { val: Int(len, ..), .. },
    ] => {
      Array::unsafe_blit(dst, dst_offset, src, src_offset, len)
      Unit
    }
    _ => Unit
  }
}

///|
let array_unsafe_blit_fixed_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(dst), .. },
      { val: Int(dst_offset, ..), .. },
      { val: FixedArray(src), .. },
      { val: Int(src_offset, ..), .. },
      { val: Int(len, ..), .. },
    ] => {
      Array::unsafe_blit_fixed(dst, dst_offset, src, src_offset, len)
      Unit
    }
    _ => Unit
  }
}

///|
let array_split_at_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(index, ..), .. }] => {
      let left = arr[:index].to_array()
      let right = arr[index:].to_array()
      Tuple([Array(left), Array(right)])
    }
    _ => Unit
  }
}

///|
let array_split_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(pred), .. }] => {
      let chunks = arr.split(fn(v) {
        match
          (try! ctx.context.call(pred.val, ctx.pkg, [
            { val: v, kind: Positional },
          ])) {
          Bool(b) => b
          _ => false
        }
      })
      Array(chunks.map(chunk => Array(chunk)))
    }
    _ => Unit
  }
}

///|
let array_starts_with_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(prefix), .. }] =>
      Bool(arr.starts_with(prefix))
    _ => Bool(false)
  }
}

///|
let array_ends_with_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(suffix), .. }] =>
      Bool(arr.ends_with(suffix))
    _ => Bool(false)
  }
}

///|
let array_strip_prefix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(prefix), .. }] =>
      RuntimeValue::from_option(arr.strip_prefix(prefix).map(v => Array(v)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let array_strip_suffix_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(suffix), .. }] =>
      RuntimeValue::from_option(arr.strip_suffix(suffix).map(v => Array(v)))
    _ => RuntimeValue::from_option(None)
  }
}

///|
let array_suffixes_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Iter(arr.suffixes().map(v => ArrayView(v)))
    [{ val: Array(arr), .. }, { val: Bool(include_empty), .. }] =>
      Iter(arr.suffixes(include_empty~).map(v => ArrayView(v)))
    _ => Unit
  }
}

///|
let array_foldi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.foldi(init=init_val, fn(i, acc, val) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: acc, kind: Positional },
          { val, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let array_rev_fold_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.rev_fold(init=init_val, fn(acc, val) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: acc, kind: Positional },
          { val, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let array_rev_foldi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: init_val, .. }, { val: Fn(f), .. }] =>
      arr.rev_foldi(init=init_val, fn(i, acc, val) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val: acc, kind: Positional },
          { val, kind: Positional },
        ])
      })
    _ => Unit
  }
}

///|
let array_rev_each_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.rev_each(fn(val) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_rev_eachi_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.rev_eachi(fn(i, val) {
        let _ = try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_map_in_place_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.map_in_place(fn(val) {
        try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_mapi_in_place_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.mapi_in_place(fn(i, val) {
        try! ctx.context.call(f.val, ctx.pkg, [
          { val: Int(i, raw=None), kind: Positional },
          { val, kind: Positional },
        ])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_filter_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      let new_arr = arr.filter_map(fn(val) {
        runtime_option_value(
          try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }]),
        )
      })
      Array(new_arr)
    }
    _ => Unit
  }
}

///|
let array_extract_if_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] =>
      Array(
        arr.extract_if(fn(val) {
          match
            (try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])) {
            Bool(b) => b
            _ => false
          }
        }),
      )
    _ => Unit
  }
}

///|
let array_retain_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.retain(fn(val) {
        match
          (try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }])) {
          Bool(b) => b
          _ => false
        }
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_retain_map_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] => {
      arr.retain_map(fn(val) {
        runtime_option_value(
          try! ctx.context.call(f.val, ctx.pkg, [{ val, kind: Positional }]),
        )
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_makei_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Int(len, ..), .. }, { val: Fn(f), .. }] =>
      Array(
        Array::makei(len, fn(i) {
          try! ctx.context.call(f.val, ctx.pkg, [
            { val: Int(i, raw=None), kind: Positional },
          ])
        }),
      )
    _ => Unit
  }
}

///|
let array_rev_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Iter(arr.rev_iter())
    _ => Unit
  }
}

///|
let array_from_fixed_array_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: FixedArray(arr), .. }] => Array(arr[:].to_array())
    _ => Unit
  }
}

///|
let array_from_iter_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Iter(iter), .. }] => Array(iter.collect())
    _ => Unit
  }
}

///|
let array_repeat_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(times, ..), .. }] =>
      Array(arr.repeat(times))
    _ => Unit
  }
}

///|
let array_flatten_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      let nested = arr.map(v => {
        match v {
          Array(xs) => xs
          _ => []
        }
      })
      Array(nested.flatten())
    }
    _ => Unit
  }
}

///|
let array_last_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => RuntimeValue::from_option(arr.last())
    _ => RuntimeValue::from_option(None)
  }
}

///|
let array_unzip_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      let left = Array::new(capacity=arr.length())
      let right = Array::new(capacity=arr.length())
      for pair in arr {
        match pair {
          Tuple([x, y]) => {
            left.push(x)
            right.push(y)
          }
          _ => abort("Array::unzip expects tuples")
        }
      }
      Tuple([Array(left), Array(right)])
    }
    _ => Unit
  }
}

///|
let array_zip_to_iter2_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(other), .. }] =>
      Iter2(arr.zip_to_iter2(other))
    _ => Unit
  }
}

///|
let array_chunks_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(size, ..), .. }] =>
      Array(arr.chunks(size).map(v => ArrayView(v)))
    _ => Unit
  }
}

///|
let array_chunk_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(f), .. }] =>
      Array(
        arr
        .chunk_by(fn(left, right) {
          match
            (try! ctx.context.call(f.val, ctx.pkg, [
              { val: left, kind: Positional },
              { val: right, kind: Positional },
            ])) {
            Bool(b) => b
            _ => false
          }
        })
        .map(v => ArrayView(v)),
      )
    _ => Unit
  }
}

///|
let array_windows_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Int(size, ..), .. }] =>
      Array(arr.windows(size).map(v => ArrayView(v)))
    _ => Unit
  }
}

///|
let array_drain_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(begin, ..), .. },
      { val: Int(end, ..), .. },
    ] => Array(arr.drain(begin, end))
    _ => Unit
  }
}

///|
let array_dedup_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => {
      arr.dedup()
      Unit
    }
    _ => Unit
  }
}

///|
let array_shuffle_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(rand), .. }] => {
      let rand0 = rand
      let rand = fn(upper) {
        match
          (try! ctx.context.call(rand0.val, ctx.pkg, [
            { val: Int(upper, raw=None), kind: Positional },
          ])) {
          Int(i, ..) => i
          _ => 0
        }
      }
      Array(arr.shuffle(rand~))
    }
    _ => Unit
  }
}

///|
let array_shuffle_in_place_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(rand), .. }] => {
      let rand0 = rand
      let rand = fn(upper) {
        match
          (try! ctx.context.call(rand0.val, ctx.pkg, [
            { val: Int(upper, raw=None), kind: Positional },
          ])) {
          Int(i, ..) => i
          _ => 0
        }
      }
      arr.shuffle_in_place(rand~)
      Unit
    }
    _ => Unit
  }
}

///|
let array_sort_by_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(cmp), .. }] => {
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
let array_sort_by_key_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Fn(map), .. }] => {
      arr.sort_by_key(fn(val) {
        try! ctx.context.call(map.val, ctx.pkg, [{ val, kind: Positional }])
      })
      Unit
    }
    _ => Unit
  }
}

///|
let array_mut_view_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => ArrayView(arr.mut_view().view())
    [{ val: Array(arr), .. }, { val: Int(start, ..), .. }] => {
      let end = match ctx.int_arg("end", 2) {
        Some(i) => i
        None => arr.length()
      }
      ArrayView(arr.mut_view(start~, end~).view())
    }
    [
      { val: Array(arr), .. },
      { val: Int(start, ..), .. },
      { val: Int(end, ..), .. },
    ] => ArrayView(arr.mut_view(start~, end~).view())
    _ => Unit
  }
}

///|
let array_is_sorted_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }] => Bool(arr.is_sorted())
    _ => Bool(false)
  }
}

///|
let array_lexical_compare_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [{ val: Array(arr), .. }, { val: Array(other), .. }] =>
      Int(arr[:].lexical_compare(other[:]), raw=None)
    _ => Int(0, raw=None)
  }
}

///|
let array_unsafe_extract_bit_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_byte_view_extract_bit(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_unsafe_extract_byte_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_byte_view_extract_byte(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_unsafe_extract_bytesview_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      array_runtime_byte_view_to_value(
        array_byte_view_extract_bytesview(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => Unit
  }
}

///|
let array_unsafe_extract_uint_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_byte_view_extract_uint_le(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_unsafe_extract_uint_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt(
        array_byte_view_extract_uint_be(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt(0)
  }
}

///|
let array_unsafe_extract_uint64_le_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt64(
        array_byte_view_extract_uint64_le(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt64(0UL)
  }
}

///|
let array_unsafe_extract_uint64_be_fn : RuntimeFunction = ctx => {
  match ctx.args {
    [
      { val: Array(arr), .. },
      { val: Int(offset, ..), .. },
      { val: Int(len, ..), .. },
    ] =>
      UInt64(
        array_byte_view_extract_uint64_be(
          array_runtime_values_to_byte_view(arr),
          offset,
          len,
        ),
      )
    _ => UInt64(0UL)
  }
}
