// =============================================================================
// 4. CONTROL FLOW
// =============================================================================

///|
test "if_expressions" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("if 1 > 0 { if 2 > 1 { 3 } else { 4 } } else { 5 }"),
    content="3",
  )
  inspect(vm.eval("if (5 + 3) * 2 > 15 { 1 } else { 2 }"), content="1")
  inspect(vm.eval("if true && false || true { 1 } else { 2 }"), content="1")
  inspect(vm.eval("if 3 < 2 { 1 }"), content="()")
}

///|
test "type_constraints" {
  let vm = MoonBitVM::new()
  // Test type constraint expressions
  assert_eq(vm.eval("(42 : Int)").to_string(), "42")
  assert_eq(vm.eval("(true : Bool)").to_string(), "true")
  assert_eq(vm.eval("(\"hello\" : String)").to_string(), "hello")
  assert_eq(vm.eval("let x = (5 : Int); x + 1").to_string(), "6")
}

///|
test "guard_expressions" {
  let vm = MoonBitVM::new()
  // Test guard expressions
  assert_eq(
    vm
    .eval(
      (
        #|fn guarded_get(array : Array[Int], index : Int) -> Int? {
        #|  guard index >= 0 && index < array.length() else { None }
        #|  Some(array[index])
        #|}
      ),
    )
    .to_string(),
    "(Array[Int], Int) -> Int?",
  )
  assert_eq(vm.eval("guarded_get([1, 2, 3], -1)").to_string(), "None")
}

///|
test "is_expressions" {
  let vm = MoonBitVM::new()
  // Test 'is' pattern matching expressions
  assert_eq(vm.eval("5 is 5").to_string(), "true")
  assert_eq(vm.eval("5 is 3").to_string(), "false")
  assert_eq(vm.eval("Some(2) is Some(_)").to_string(), "true")
  assert_eq(vm.eval("Some(2) is Some(1)").to_string(), "false")
  assert_eq(vm.eval("Some(1) is Some(1)").to_string(), "true")
  assert_eq(vm.eval("None is Some(_)").to_string(), "false")
}

///|
test "defer_expressions" {
  let vm = MoonBitVM::new()
  // Test defer expressions
  assert_eq(
    vm
    .eval(
      (
        #|defer println("First defer")
        #|defer println("Second defer") 
        #|println("Do something")
      ),
    )
    .to_string(),
    "()",
  )
}

///|
test "for_loops" {
  let vm = MoonBitVM::new()
  // 简化测试：只测试最基本的for循环
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("sum"), content="0")
  inspect(vm.eval("sum += 1"), content="()")
  inspect(vm.eval("sum"), content="1")
  inspect(vm.eval("sum += 2"), content="()")
  inspect(vm.eval("sum"), content="3")

  // 测试for循环
  inspect(vm.eval("let mut result = 0"), content="()")
  inspect(vm.eval("for i = 0; i < 3; i = i + 1 { result += i }"), content="()")
  inspect(vm.eval("result"), content="3")
  assert_eq(
    vm
    .eval(
      (
        #|let sum = for i = 1, acc = 0; i <= 6; i = i + 1 {
        #|  if i % 2 == 0 {
        #|    println("even: \{i}")
        #|    continue i + 1, acc + i
        #|  }
        #|} else {
        #|  acc
        #|}
      ),
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("sum").to_string(), "12")
}

///|
test "for_in" {
  let vm = MoonBitVM::new()
  // Test array iteration
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("for x in [1, 2, 3, 4, 5] { sum += x }"), content="()")
  inspect(vm.eval("sum"), content="15")

  // Test range iteration with exclusive upper bound
  inspect(vm.eval("let mut range_sum = 0"), content="()")
  inspect(vm.eval("for i in 0..<5 { range_sum += i }"), content="()")
  inspect(vm.eval("range_sum"), content="10")

  // Test range iteration with inclusive upper bound
  inspect(vm.eval("let mut inclusive_sum = 0"), content="()")
  inspect(vm.eval("for i in 0..=5 { inclusive_sum += i }"), content="()")
  inspect(vm.eval("inclusive_sum"), content="15")

  // Test iteration with index
  inspect(vm.eval("let mut indexed_sum = 0"), content="()")
  inspect(
    vm.eval("for idx, val in [10, 20, 30] { indexed_sum += idx + val }"),
    content="()",
  )
  inspect(vm.eval("indexed_sum"), content="63")
}

///|
test "while_loops" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut i = 0"), content="()")
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("while i < 5 { sum += i; i += 1 }"), content="()")
  inspect(vm.eval("sum"), content="10")
  inspect(vm.eval("i"), content="5")
}

///|
test "loop_control" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|fn sum_with_continue(n : Int, acc : Int) -> Int {
        #|  let mut acc = acc
        #|  for i = 0; i < n; i = i + 1 {
        #|    if i == 2 {
        #|      continue
        #|    }
        #|    acc = acc + i
        #|  }
        #|  acc
        #|}
      ),
    )
    .to_string(),
    "(Int, Int) -> Int",
  )
  assert_eq(vm.eval("sum_with_continue(5, 1)").to_string(), "9")
}

///|
test "return_expressions" {
  let vm = MoonBitVM::new()
  // Test return expressions in functions
  assert_eq(
    vm
    .eval(
      (
        #|fn early_return(x : Int) -> Int {
        #|  if x < 0 { return -1 }
        #|  x * 2
        #|}
        #|early_return(5)
      ),
    )
    .to_string(),
    "10",
  )
  assert_eq(vm.eval("early_return(-3)").to_string(), "-1")
}

///|
test "raise_expressions" {
  let vm = MoonBitVM::new()
  // Test raise expressions for exceptions
  assert_eq(
    vm
    .eval(
      (
        #|fn divide(a : Int, b : Int) -> Int {
        #|  if b == 0 { raise "Division by zero" }
        #|  a / b
        #|}
        #|divide(10, 2)
      ),
    )
    .to_string(),
    "5",
  )
}

///|
test "loop_expressions" {
  let vm = MoonBitVM::new()
  // Test loop expressions
  inspect(
    vm.eval(
      (
        #|fn sum(xs : @list.List[Int]) -> Int {
        #|  loop (xs, 0) {
        #|    (Empty, acc) => break acc // <=> Nil, acc => acc
        #|    (More(x, tail=rest), acc) => continue (rest, x + acc)
        #|  }
        #|}
      ),
    ),
    content="(List[Int]) -> Int",
  )
  inspect(vm.eval("let list = @list.from_array([1, 2, 3])"), content="()")
  inspect(
    vm.eval("list"),
    content="More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )
  inspect(vm.eval("sum(list)"), content="6")
  inspect(vm.eval("@list.to_array(list)"), content="[1, 2, 3]")
}

///|
test "break_continue" {
  let vm = MoonBitVM::new()
  // Test break and continue in loops
  assert_eq(
    vm
    .eval(
      (
        #|let mut result = 0
        #|for i = 0; i < 10; i = i + 1 {
        #|  if i == 3 { continue }
        #|  if i == 7 { break }
        #|  result += i
        #|}
        #|result
      ),
    )
    .to_string(),
    "18",
  )
}
