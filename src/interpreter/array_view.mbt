///|
pub let array_view_methods : Map[String, RuntimeFunction] = {
  "length": array_view_length_fn,
  "swap": array_view_swap_fn,
}

///| 数组长度
let array_view_length_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ val: ArrayView(arr), .. }, ..] => Int(arr.length())
  _ => Unit
}

///| 数组交换
let array_view_swap_fn : RuntimeFunction = ctx => match ctx.arguments {
  [{ val: ArrayView(arr), .. }, { val: Int(i), .. }, { val: Int(j), .. }, ..] => {
    arr.swap(i, j)
    Unit
  }
  _ => Unit
}
