// Iteration-related test cases

///|
test "foreach_loop" {
  let vm = MoonBitVM::new()
  // Test simple for-in loop with array
  inspect(
    vm.eval(
      "let arr = [1, 2, 3]; let sum = 0; for x in arr { sum = sum + x }; sum",
    ),
    content="6",
  )

  // Test for-in loop with range
  inspect(
    vm.eval("let sum = 0; for i in 0..<3 { sum = sum + i }; sum"),
    content="3",
  )
}

///|
test "array_iteration" {
  let vm = MoonBitVM::new()
  // 测试循环变量名不冲突的情况
  assert_eq(
    vm
    .eval("let mut sum = 0; for item in [1, 2, 3] { sum = sum + item }; sum")
    .to_string(),
    "6",
  )
  // 测试循环变量名可能冲突的情况
  assert_eq(
    vm
    .eval("let mut sum = 0; for x in [1, 2, 3] { sum = sum + x }; sum")
    .to_string(),
    "6",
  )
  // 测试循环变量名与外部变量名相同的情况
  assert_eq(
    vm
    .eval("let mut sum = 0; for sum in [1, 2, 3] { println(sum) }; sum")
    .to_string(),
    "0",
  )
}

///|
test "string_iteration" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      "let mut result = \"\"; for c in \"abc\" { result = c + result }; result",
    )
    .to_string(),
    "cba",
  )
}

///|
test "map_iteration" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      "let m = {\"a\": 1, \"b\": 2}; let sum = 0; for pair in m { sum = sum + pair.1 }; sum",
    )
    .to_string(),
    "3",
  )
}

///|
test "range_iteration" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let sum = 0; for i in 0..<3 { sum = sum + i }; sum").to_string(),
    "3",
  )
  assert_eq(
    vm.eval("let sum = 0; for i in 1..=3 { sum = sum + i }; sum").to_string(),
    "6",
  )
}

///|
test "break_continue_iteration" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      "let mut sum = 0; for i in 0..<10 { if i == 3 { break }; sum = sum + i }; sum",
    )
    .to_string(),
    "3", // 0+1+2=3
  )
  assert_eq(
    vm
    .eval(
      "let mut sum = 0; for i in 0..<5 { if i == 2 { continue }; sum = sum + i }; sum",
    )
    .to_string(),
    "8", // 0+1+3+4=8
  )
}

///|
test "iterator_methods" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      "let arr = [1, 2, 3]; let mut sum = 0; for x in arr.iter() { sum = sum + x }; sum",
    )
    .to_string(),
    "6",
  )
  assert_eq(
    vm
    .eval(
      "let str = \"hello\"; let mut count = 0; for c in str.iter() { count = count + 1 }; count",
    )
    .to_string(),
    "5",
  )
  assert_eq(
    vm
    .eval(
      "let map = {\"a\": 1, \"b\": 2}; let mut sum = 0; for pair in map.iter() { sum = sum + pair.1 }; sum",
    )
    .to_string(),
    "3",
  )
}

///|
test "nested_iteration" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      "let arr1 = [1, 2]; let arr2 = [3, 4]; let mut sum = 0; for x in arr1 { for y in arr2 { sum = sum + x * y } }; sum",
    )
    .to_string(),
    "21", // 1*3 + 1*4 + 2*3 + 2*4 = 3+4+6+8 = 21
  )
}

///|
test "iterator_control_flow" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let arr = [1, 2, 3]"), content="()")
  inspect(vm.eval("arr.iter()"), content="<iterator>")
  assert_eq(
    vm
    .eval(
      "let arr = [1, 2, 3, 4, 5]; let mut sum = 0; for x in arr.iter() { if x == 3 { continue }; if x > 4 { break }; sum = sum + x }; sum",
    )
    .to_string(),
    "7",
  )
}
