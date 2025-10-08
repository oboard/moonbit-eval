///|
pub let array_view_methods : Map[String, RuntimeFunction] = {
  "length": array_view_length_fn,
}

///|
/// 数组长度
let array_view_length_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Int(arr.length())
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
  [{ val: ArrayView(arr), .. }] => Int(arr.start())
  _ => Unit
}

///|
/// ArrayView len 方法
let array_view_len_fn : RuntimeFunction = ctx => match ctx.args {
  [{ val: ArrayView(arr), .. }] => Int(arr.len())
  _ => Unit
}
