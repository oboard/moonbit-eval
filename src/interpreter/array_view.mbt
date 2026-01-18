///|
pub let array_view_methods : Map[String, RuntimeFunction] = {
  "length": array_view_length_fn,
  "all": array_view_all_fn,
  "any": array_view_any_fn,
  "contains": array_view_contains_fn,
  "each": array_view_each_fn,
  "eachi": array_view_eachi_fn,
  "filter": array_view_filter_fn,
  "fold": array_view_fold_fn,
  "foldi": array_view_foldi_fn,
  "iter": array_view_iter_fn,
  "iter2": array_view_iter2_fn,
  "join": array_view_join_fn,
  "map": array_view_map_fn,
  "mapi": array_view_mapi_fn,
  "rev_fold": array_view_rev_fold_fn,
  "rev_foldi": array_view_rev_foldi_fn,
  "to_array": array_view_to_array_fn,
  // "unsafe_extract_bit": array_view_unsafe_extract_bit_fn,
  // "unsafe_extract_byte": array_view_unsafe_extract_byte_fn,
  // "unsafe_extract_bytesview": array_view_unsafe_extract_bytesview_fn,
  // "unsafe_extract_uint64_be": array_view_unsafe_extract_uint64_be_fn,
  // "unsafe_extract_uint64_le": array_view_unsafe_extract_uint64_le_fn,
  // "unsafe_extract_uint_be": array_view_unsafe_extract_uint_be_fn,
  // "unsafe_extract_uint_le": array_view_unsafe_extract_uint_le_fn,
}

///|
/// 数组长度
let array_view_length_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Int(arr.length(), raw=None)
  _ => Unit
}

///|
fn[T] ArrayView::buf(self : ArrayView[T]) -> UninitializedArray[T] = "%arrayview.buf"

///|
fn[T] ArrayView::start(self : ArrayView[T]) -> Int = "%arrayview.start"

///|
fn[T] ArrayView::len(self : ArrayView[T]) -> Int = "%arrayview.len"

///|
/// ArrayView start 方法 - 返回起始索引
let array_view_buf_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => UninitializedArray(arr.buf())
  _ => Unit
}

///|
/// ArrayView start 方法 - 返回起始索引
let array_view_start_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Int(arr.start(), raw=None)
  _ => Unit
}

///|
/// ArrayView len 方法
let array_view_len_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Int(arr.len(), raw=None)
  _ => Unit
}

///|
/// ArrayView all 方法
let array_view_all_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
    Bool(
      arr.all(elem => ctx.context.call(f.val, ctx.pkg, [
          { val: elem, kind: Positional },
        ])
        is Bool(true)),
    )
  _ => Unit
}

///|
/// ArrayView any 方法
let array_view_any_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
    Bool(
      arr.any(elem => ctx.context.call(f.val, ctx.pkg, [
          { val: elem, kind: Positional },
        ])
        is Bool(true)),
    )
  _ => Unit
}

///|
/// ArrayView contains 方法
let array_view_contains_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: x, .. }] => Bool(arr.contains(x))
  _ => Unit
}

///|
/// ArrayView each 方法
let array_view_each_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] => {
    arr.each(elem => ctx.context.call(f.val, ctx.pkg, [
        { val: elem, kind: Positional },
      ])
      |> ignore)
    Unit
  }
  _ => Unit
}

///|
/// ArrayView eachi 方法
let array_view_eachi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] => {
    arr.eachi((i, elem) => ctx.context.call(f.val, ctx.pkg, [
        { val: Int(i, raw=None), kind: Positional },
        { val: elem, kind: Positional },
      ])
      |> ignore)
    Unit
  }
  _ => Unit
}

///|
/// ArrayView filter 方法
let array_view_filter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
    Array(
      arr.filter(elem => ctx.context.call(f.val, ctx.pkg, [
          { val: elem, kind: Positional },
        ])
        is Bool(true)),
    )
  _ => Unit
}

///|
/// ArrayView fold 方法
let array_view_fold_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
    arr.fold(init~, fn(acc, elem) {
      ctx.context.call(f.val, ctx.pkg, [
        { val: acc, kind: Positional },
        { val: elem, kind: Positional },
      ])
    })
  _ => Unit
}

///|
/// ArrayView foldi 方法
let array_view_foldi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
    arr.foldi(init~, fn(i, acc, elem) {
      ctx.context.call(f.val, ctx.pkg, [
        { val: Int(i, raw=None), kind: Positional },
        { val: acc, kind: Positional },
        { val: elem, kind: Positional },
      ])
    })
  _ => Unit
}

///|
/// ArrayView iter 方法
let array_view_iter_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Array(arr.iter().collect())
  _ => Unit
}

///|
/// ArrayView iter2 方法
let array_view_iter2_fn : RuntimeFunction = ctx => match ctx.args {
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

///|
/// ArrayView join 方法
let array_view_join_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: String(separator), .. }] =>
    String(arr.map(elem => elem.to_string()).join(separator))
  _ => Unit
}

///|
/// ArrayView map 方法
let array_view_map_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
    Array(
      arr.map(elem => ctx.context.call(f.val, ctx.pkg, [
        { val: elem, kind: Positional },
      ])),
    )
  _ => Unit
}

///|
/// ArrayView mapi 方法
let array_view_mapi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: Fn(f), .. }] =>
    Array(
      arr.mapi((i, elem) => ctx.context.call(f.val, ctx.pkg, [
        { val: Int(i, raw=None), kind: Positional },
        { val: elem, kind: Positional },
      ])),
    )
  _ => Unit
}

///|
/// ArrayView rev_fold 方法
let array_view_rev_fold_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
    arr.rev_fold(init~, fn(acc, elem) {
      ctx.context.call(f.val, ctx.pkg, [
        { val: acc, kind: Positional },
        { val: elem, kind: Positional },
      ])
    })
  _ => Unit
}

///|
/// ArrayView rev_foldi 方法
let array_view_rev_foldi_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }, { val: init, .. }, { val: Fn(f), .. }] =>
    arr.rev_foldi(init~, fn(i, acc, elem) {
      ctx.context.call(f.val, ctx.pkg, [
        { val: Int(i, raw=None), kind: Positional },
        { val: acc, kind: Positional },
        { val: elem, kind: Positional },
      ])
    })
  _ => Unit
}

///|
/// ArrayView to_array 方法
let array_view_to_array_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Array(arr.to_array())
  _ => Unit
}

// ///|
// /// ArrayView unsafe_extract_bit 方法
// let array_view_unsafe_extract_bit_fn : RuntimeFunction = ctx => match ctx.args {
//   [{ val: ArrayView(bs), .. }, { val: Int(offset), .. }, { val: Int(_len), .. }] =>
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
