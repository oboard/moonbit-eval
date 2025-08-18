///|
pub let array_methods : Map[String, (Array[RuntimeArgument]) -> RuntimeValue] = {
  "length": array_length_fn,
  "push": array_push_fn,
  "clear": array_clear_fn,
  "is_empty": array_is_empty_fn,
  "rev": array_rev_fn,
  "copy": array_copy_fn,
  "join": array_join_fn,
  "swap": array_swap_fn,
}

///| 数组长度
let array_length_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, ..] => Int(arr.length())
  _ => Unit
}

///| 数组push操作
let array_push_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, { value: val, .. }, ..] => {
    arr.push(val)
    Array(arr)
  }
  _ => Unit
}

///| 数组clear操作
let array_clear_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, ..] => {
    arr.clear()
    Unit
  }
  _ => Unit
}

///| 数组is_empty操作
let array_is_empty_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, ..] => Bool(arr.is_empty())
  _ => Unit
}

///| 数组reverse操作
let array_rev_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, ..] => Array(arr.rev())
  _ => Unit
}

///| 数组copy操作
let array_copy_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, ..] => Array(arr.copy())
  _ => Unit
}

///| 数组join操作
let array_join_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, { value: String(sep), .. }, ..] => {
    let string_arr = arr.map(v => match v {
      String(s) => s
      Int(n) => n.to_string()
      Bool(b) => if b { "true" } else { "false" }
      _ => "[object]"
    })
    String(string_arr.join(sep))
  }
  [{ value: Array(arr), .. }, ..] => {
    // 默认用逗号分隔
    if arr.is_empty() {
      return String("")
    }
    let mut result = ""
    for i = 0; i < arr.length(); i = i + 1 {
      if i > 0 {
        result = result + ","
      }
      match arr[i] {
        String(s) => result = result + s
        Int(n) => result = result + n.to_string()
        Bool(b) => result = result + (if b { "true" } else { "false" })
        _ => result = result + "[object]"
      }
    }
    String(result)
  }
  _ => Unit
}

///| 数组swap操作
let array_swap_fn : (Array[RuntimeArgument]) -> RuntimeValue = params => match
  params {
  [{ value: Array(arr), .. }, { value: Int(i), .. }, { value: Int(j), .. }, ..] => {
    arr.swap(i, j)
    Unit
  }
  _ => Unit
}
