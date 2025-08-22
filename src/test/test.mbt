// =============================================================================
// MoonBit Eval Test Suite
// =============================================================================
// Organized by feature categories for better maintainability

// =============================================================================
// 1. BASIC TYPES AND LITERALS
// =============================================================================

///|
test "0. basic_integers" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("1"), content="1")
  inspect(vm.eval("42"), content="42")
  inspect(vm.eval("-5"), content="-5")
}

///|
test "1. basic_booleans" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true"), content="true")
  inspect(vm.eval("false"), content="false")
  inspect(vm.eval("!false"), content="true")
  inspect(vm.eval("!true"), content="false")
  inspect(vm.eval("not(false)"), content="true")
  inspect(vm.eval("not(true)"), content="false")
}

///|
test "2. basic_strings" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("\"hello\""), content="hello")
  inspect(vm.eval("\"hello\"+\"world\""), content="helloworld")
}

///|
test "3. multiline_strings" {
  let vm = MoonBitVM::new()
  // Test multiline string syntax
  assert_eq(vm.eval("#|hello\n#|world").to_string(), "hello\nworld")
  assert_eq(
    vm.eval("#|line1\n#|line2\n#|line3").to_string(),
    "line1\nline2\nline3",
  )
  assert_eq(vm.eval("#|single line").to_string(), "single line")
}

///|
test "4. string_interpolation" {
  let vm = MoonBitVM::new()
  // Test string interpolation
  assert_eq(
    vm.eval("let x = 42; \"The answer is \\{x}\"").to_string(),
    "The answer is 42",
  )
  assert_eq(
    vm.eval("let name = \"World\"; \"Hello, \\{name}!\"").to_string(),
    "Hello, World!",
  )
  assert_eq(
    vm.eval("let a = 5; let b = 3; \"\\{a} + \\{b} = \\{a + b}\"").to_string(),
    "5 + 3 = 8",
  )
}

// =============================================================================
// 2. ARITHMETIC AND COMPARISON OPERATORS
// =============================================================================

///|
test "5.arithmetic_operators" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("1+1"), content="2")
  inspect(vm.eval("2-1"), content="1")
  inspect(vm.eval("5 * 3"), content="15")
  inspect(vm.eval("10 / 2"), content="5")
  inspect(vm.eval("7 % 3"), content="1")
}

// =============================================================================
// ARRAY METHODS TESTS
// =============================================================================

///|
test "6. array_basic_methods" {
  let vm = MoonBitVM::new()
  // Test array creation and basic methods
  inspect(vm.eval("let arr = [1, 2, 3]; arr.length()"), content="3")
  inspect(vm.eval("let arr = []; arr.is_empty()"), content="true")
  inspect(vm.eval("let arr = [1]; arr.is_empty()"), content="false")
}

///|
test "7. array_get_set_methods" {
  let vm = MoonBitVM::new()
  // Test get method
  inspect(vm.eval("let arr = [1, 2, 3]; arr.get(1)"), content="Some(2)")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.get(5)"), content="None")
}

///|
test "8. array_push_pop_methods" {
  let vm = MoonBitVM::new()
  // Test push and pop
  inspect(vm.eval("let arr = [1, 2]; arr.push(3); arr.length()"), content="3")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.pop()"), content="Some(3)")
  inspect(vm.eval("let arr = []; arr.pop()"), content="None")
}

///|
test "9. array_contains_methods" {
  let vm = MoonBitVM::new()
  // Test contains method
  inspect(vm.eval("let arr = [1, 2, 3]; arr.contains(2)"), content="true")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.contains(5)"), content="false")
}

///|
test "10. comparison_operators" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5 == 5"), content="true")
  inspect(vm.eval("5 != 3"), content="true")
  inspect(vm.eval("3 < 5"), content="true")
  inspect(vm.eval("5 > 3"), content="true")
  inspect(vm.eval("3 <= 5"), content="true")
  inspect(vm.eval("5 >= 3"), content="true")
}

// =============================================================================
// 3. VARIABLES AND MUTABILITY
// =============================================================================

///|
test "11. immutable_variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 1"), content="()")
  inspect(vm.eval("a"), content="1")
}

///|
test "12. shadowing" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 0; let a = 1; a"), content="1")
  inspect(vm.eval("let mut a = 0; let a = 1; a"), content="1")
}

///|
test "13. mutable_variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut a = 1"), content="()")
  inspect(vm.eval("a = 12"), content="()")
  inspect(vm.eval("a"), content="12")
}

// =============================================================================
// 4. CONTROL FLOW
// =============================================================================

///|
test "14. if_expressions" {
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
test "15. type_constraints" {
  let vm = MoonBitVM::new()
  // Test type constraint expressions
  assert_eq(vm.eval("(42 : Int)").to_string(), "42")
  assert_eq(vm.eval("(true : Bool)").to_string(), "true")
  assert_eq(vm.eval("(\"hello\" : String)").to_string(), "hello")
  assert_eq(vm.eval("let x = (5 : Int); x + 1").to_string(), "6")
}

///|
test "16. guard_expressions" {
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
    "(array: Array[Int], index: Int) -> Int?",
  )
  assert_eq(vm.eval("guarded_get([1, 2, 3], -1)").to_string(), "None")
}

///|
test "17. is_expressions" {
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
test "18. defer_expressions" {
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
test "19. for_loops" {
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

// ///|
// test "for_in" {
//   let vm = MoonBitVM::new()
//   // Test array iteration
//   inspect(vm.eval("let mut sum = 0"), content="()")
//   inspect(vm.eval("for x in [1, 2, 3, 4, 5] { sum += x }"), content="()")
//   inspect(vm.eval("sum"), content="15")

//   // Test range iteration with exclusive upper bound
//   inspect(vm.eval("let mut range_sum = 0"), content="()")
//   inspect(vm.eval("for i in 0..<5 { range_sum += i }"), content="()")
//   inspect(vm.eval("range_sum"), content="10")

//   // Test range iteration with inclusive upper bound
//   inspect(vm.eval("let mut inclusive_sum = 0"), content="()")
//   inspect(vm.eval("for i in 0..=5 { inclusive_sum += i }"), content="()")
//   inspect(vm.eval("inclusive_sum"), content="15")

//   // Test iteration with index
//   inspect(vm.eval("let mut indexed_sum = 0"), content="()")
//   inspect(
//     vm.eval("for idx, val in [10, 20, 30] { indexed_sum += idx + val }"),
//     content="()",
//   )
//   inspect(vm.eval("indexed_sum"), content="63")
// }

///|
test "20. while_loops" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut i = 0"), content="()")
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("while i < 5 { sum += i; i += 1 }"), content="()")
  inspect(vm.eval("sum"), content="10")
  inspect(vm.eval("i"), content="5")
}

///|
test "21. loop_control" {
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
    "(n: Int, acc: Int) -> Int",
  )
  assert_eq(vm.eval("sum_with_continue(5, 1)").to_string(), "9")
}

// =============================================================================
// 5. FUNCTIONS
// =============================================================================

///|
test "22. basic_functions" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("fn double(x: Int) -> Int { x * 2 }").to_string(),
    "(x: Int) -> Int",
  )
  inspect(vm.eval("double(2)"), content="4")
  assert_eq(
    vm.eval("fn add(a: Int, b: Int) -> Int { a + b }").to_string(),
    "(a: Int, b: Int) -> Int",
  )
  inspect(vm.eval("add(1, 2)"), content="3")
}

///|
test "24. named_parameters" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("fn add_named(a~: Int, b~: Int) -> Int { a + b }").to_string(),
    "(a~: Int, b~: Int) -> Int",
  )
  inspect(vm.eval("add_named(a=1, b=2)"), content="3")
  inspect(
    vm.eval("fn add_optional(a~: Int, b~: Int=2) -> Int { a + b }"),
    content="(a~: Int, b~: Int = 2) -> Int",
  )
  assert_eq(vm.eval("add_optional(a=1)").to_string(), "3")
}

///|
test "25. lambda_functions" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let f = x => x * 2"), content="()")
  assert_eq(vm.eval("f(3)").to_string(), "6")
  assert_eq(vm.eval("let identity = x => x").to_string(), "()")
  assert_eq(vm.eval("identity(5)").to_string(), "5")
}

///|
test "26. closure_argument_environment" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let x = 10"), content="()")
  // 创建闭包，捕获 x = 10
  inspect(vm.eval("let make_adder = y => x + y"), content="()")
  inspect(vm.eval("make_adder(5)"), content="15")
  inspect(vm.eval("let x = 20"), content="()")
  inspect(vm.eval("make_adder(x)"), content="30")
  let x = 10
  let make_adder = y => x + y
  inspect(make_adder(x), content="20")
  // 先测试简单情况：直接传入数字
  inspect(make_adder(5), content="15")
  let x = 20
  inspect(make_adder(x), content="30")
}

///|
test "27. recursive_functions" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|fn fib(n : Int) -> Int {
        #|  if n <= 1 {
        #|    1
        #|  } else {
        #|    fib(n - 1) + fib(n - 2)
        #|  }
        #|}
      ),
    )
    .to_string(),
    "(n: Int) -> Int",
  )
  assert_eq(vm.eval("fib(10)").to_string(), "89")
}

///|
test "28. mutually_recursive_functions" {
  let vm = MoonBitVM::new()
  // Test LetRec for mutually recursive functions
  assert_eq(
    vm
    .eval(
      (
        #|fn is_even(n : Int) -> Bool {
        #|  if n == 0 { true } else { is_odd(n - 1) }
        #|}
        #|fn is_odd(n : Int) -> Bool {
        #|  if n == 0 { false } else { is_even(n - 1) }
        #|}
        #|is_even(4)
      ),
    )
    .to_string(),
    "true",
  )
  assert_eq(vm.eval("is_odd(5)").to_string(), "true")
  assert_eq(vm.eval("is_even(3)").to_string(), "false")
}

///|
test "29. let_and_bindings" {
  let vm = MoonBitVM::new()
  // Test LetAnd for simultaneous function definitions
  assert_eq(
    vm
    .eval(
      (
        #|letrec even = x => x == 0 || odd(x - 1)
        #|and odd = x => x != 0 && even(x - 1)
        #|even(4)
      ),
    )
    .to_string(),
    "true",
  )
}

// =============================================================================
// 6. DATA STRUCTURES
// =============================================================================

///|
test "30. tuples" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let t = (1, 2)"), content="()")
  inspect(vm.eval("t.0"), content="1")
  inspect(vm.eval("t.1"), content="2")
  inspect(vm.eval("t"), content="(1, 2)")
  inspect(vm.eval("let (a, b) = t"), content="()")
  inspect(vm.eval("a"), content="1")
  inspect(vm.eval("b"), content="2")
}

///|
test "30. arrays" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let arr = [1, 2, 3]; arr.length()"), content="3")
  inspect(vm.eval("let arr = []; arr.is_empty()"), content="true")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.is_empty()"), content="false")
  inspect(
    vm.eval("let arr = [\"1\", \"2\", \"3\"]; arr.join(\"-\")"),
    content="1-2-3",
  )
}

///|
test "31. array_spread" {
  let vm = MoonBitVM::new()
  // Test array spread syntax
  assert_eq(
    vm
    .eval("let arr1 = [1, 2]; let arr2 = [3, 4]; [..arr1, ..arr2]")
    .to_string(),
    "[1, 2, 3, 4]",
  )
  assert_eq(
    vm.eval("let arr = [2, 3]; [1, ..arr, 4]").to_string(),
    "[1, 2, 3, 4]",
  )
  assert_eq(vm.eval("let arr = [1, 2, 3]; [..arr]").to_string(), "[1, 2, 3]")
}

///|
test "32. array_slice_operations" {
  let vm = MoonBitVM::new()
  // Test array slice get operations
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[1:3]").to_string(),
    "[2, 3]",
  )
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[2:]").to_string(),
    "[3, 4, 5]",
  )
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[:3]").to_string(),
    "[1, 2, 3]",
  )
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[:]").to_string(),
    "[1, 2, 3, 4, 5]",
  )
}

///|
test "33. array_set_operations" {
  let vm = MoonBitVM::new()
  // Test array set operations
  assert_eq(
    vm.eval("let mut arr = [1, 2, 3]; arr[1] = 5; arr").to_string(),
    "[1, 5, 3]",
  )
  assert_eq(
    vm.eval("let mut arr = [1, 2, 3]; arr[0] = 10; arr[0]").to_string(),
    "10",
  )
}

///|
test "34. array_augmented_set" {
  let vm = MoonBitVM::new()
  // Test array augmented assignment operations
  assert_eq(
    vm.eval("let mut arr = [1, 2, 3]; arr[1] += 5; arr").to_string(),
    "[1, 7, 3]",
  )
  assert_eq(
    vm.eval("let mut arr = [10, 20, 30]; arr[0] -= 5; arr[0]").to_string(),
    "5",
  )
  assert_eq(
    vm.eval("let mut arr = [2, 4, 6]; arr[1] *= 3; arr[1]").to_string(),
    "12",
  )
}

///|
test "35. structs" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct S { 
        #|  a: Int
        #|  b: Int
        #|}
        #|fn S::sum(self: S) -> Int {
        #|  self.a + self.b
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let s = { a: 23, b: 32 }"), content="()")
  inspect(vm.eval("s.sum()"), content="55")
}

///|
test "36. mutable_structs" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct Point {
        #|  mut x : Int
        #|  mut y : Int
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let p = { x: 1, y: 2 }"), content="()")
  inspect(vm.eval("p.x"), content="1")
  inspect(vm.eval("p.y"), content="2")
  inspect(vm.eval("p.x = 3"), content="()")
  inspect(vm.eval("p.y = 4"), content="()")
  inspect(vm.eval("p.x"), content="3")
  inspect(vm.eval("p.y"), content="4")
  inspect(vm.eval("p"), content="{ x: 3, y: 4 }")
}

///|
test "36. record_update" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Person {
        #|  name : String
        #|  age : Int
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let p1 = { name: \"Alice\", age: 25 }").to_string(), "()")
  assert_eq(vm.eval("let p2 = { ..p1, age: 26 }").to_string(), "()")
  assert_eq(vm.eval("p2.name").to_string(), "Alice")
  assert_eq(vm.eval("p2.age").to_string(), "26")
  assert_eq(vm.eval("p1.age").to_string(), "25")
}

///|
test "37. method_calls" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Calculator {
        #|  value : Int
        #|}
        #|fn Calculator::add(self : Calculator, x : Int) -> Int {
        #|  self.value + x
        #|}
        #|fn Calculator::multiply(self : Calculator, x : Int) -> Int {
        #|  self.value * x
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let calc = { value: 10 }").to_string(), "()")
  assert_eq(vm.eval("calc.add(5)").to_string(), "15")
  assert_eq(vm.eval("calc.multiply(3)").to_string(), "30")
  assert_eq(
    vm.eval("Calculator::add").to_string(),
    "(self: Calculator, x: Int) -> Int",
  )
}

///|
test "40. trait_as_expressions" {
  let vm = MoonBitVM::new()
  // Test basic string operations first
  assert_eq(vm.eval("1.to_string()").to_string(), "1")
  assert_eq(vm.eval("\"hello\" + \" world\"").to_string(), "hello world")

  // Test 'as' expressions for trait casting
  assert_eq(
    vm
    .eval(
      (
        #|trait Show {
        #|  show(Self) -> String
        #|}
        #|struct Point {
        #|  x : Int
        #|  y : Int
        #|}
        #|fn Point::show(self : Point) -> String {
        #|  "(" + self.x.to_string() + ", " + self.y.to_string() + ")"
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let p = { x: 1, y: 2 }").to_string(), "()")
  assert_eq(vm.eval("(p as Show).show()").to_string(), "(1, 2)")
}

///|
test "40. field_mutation" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Counter {
        #|  mut count : Int
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let c = { count: 0 }").to_string(), "()")
  assert_eq(vm.eval("c.count = 5").to_string(), "()")
  assert_eq(vm.eval("c.count").to_string(), "5")

  // 测试简单赋值对比
  assert_eq(vm.eval("c.count = 5").to_string(), "()")
  // 测试 += 是否被解析为 =
  assert_eq(vm.eval("c.count = 3").to_string(), "()")
  assert_eq(vm.eval("c.count += 3").to_string(), "()")
  assert_eq(vm.eval("c.count").to_string(), "6")
  assert_eq(vm.eval("c.count *= 2").to_string(), "()")
  assert_eq(vm.eval("c.count").to_string(), "12")
}

///|
test "41. references" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct RefInt {
        #|  mut value: Int
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|let a = { value: 1 }
        #|let b = a
        #|b.value = 2
      ),
    ),
    content="()",
  )
  inspect(vm.eval("a"), content="{ value: 2 }")
  inspect(vm.eval("a.value"), content="2")
}

// =============================================================================
// 6.5. ADVANCED CONTROL FLOW
// =============================================================================

///|
test "42. return_expressions" {
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
test "43. raise_expressions" {
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
test "44. loop_expressions" {
  let vm = MoonBitVM::new()
  // Test loop expressions
  assert_eq(
    vm
    .eval(
      (
        #|fn sum(xs : @list.List[Int]) -> Int {
        #|  loop (xs, 0) {
        #|    (Empty, acc) => break acc // <=> Nil, acc => acc
        #|    (More(x, tail=rest), acc) => continue (rest, x + acc)
        #|  }
        #|}
      ),
    )
    .to_string(),
    "(xs: @list.List[Int]) -> Int",
  )
  assert_eq(vm.eval("let list = @list.from_array([1, 2, 3])").to_string(), "()")
  assert_eq(vm.eval("list").to_string(), "More(1, More(2, More(3, Empty)))")
  assert_eq(vm.eval("sum(list)").to_string(), "6")
  assert_eq(vm.eval("@list.to_array(list)").to_string(), "[1, 2, 3]")
}

///|
test "45. break_continue" {
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

// =============================================================================
// 6.6. EXCEPTION HANDLING
// =============================================================================

///|
test "46. try_catch_expressions" {
  let vm = MoonBitVM::new()
  // Test try-catch expressions
  assert_eq(
    vm
    .eval(
      (
        #|try {
        #|  let x = 10 / 2
        #|  x
        #|} catch {
        #|  e => -1
        #|}
      ),
    )
    .to_string(),
    "5",
  )
  assert_eq(
    vm
    .eval(
      (
        #|try {
        #|  raise "error"
        #|  42
        #|} catch {
        #|  e => 0
        #|}
      ),
    )
    .to_string(),
    "0",
  )
}

///|
test "47. option_type" {
  let vm = MoonBitVM::new()
  // Test try operator (?)
  assert_eq(
    vm
    .eval(
      (
        #|fn safe_divide(a : Int, b : Int) -> Int? {
        #|  if b == 0 { None } else { Some(a / b) }
        #|}
        #|let result = safe_divide(10, 2)
        #|result
      ),
    )
    .to_string(),
    "Some(5)",
  )
  assert_eq(
    vm
    .eval(
      (
        #|let result = safe_divide(10, 0)
        #|result
      ),
    )
    .to_string(),
    "None",
  )
}

// =============================================================================
// 6.7. MISCELLANEOUS SYNTAX
// =============================================================================

///|
test "48. map_expressions" {
  let vm = MoonBitVM::new()
  // Test map literal expressions
  assert_eq(
    vm
    .eval(
      (
        #|let m = { "a": 1, "b": 2, "c": 3 }
        #|m["b"]
      ),
    )
    .to_string(),
    "2",
  )
}

///|
test "49. group_expressions" {
  let vm = MoonBitVM::new()
  // Test grouped expressions with parentheses
  assert_eq(vm.eval("(2 + 3) * (4 + 1)").to_string(), "25")
  assert_eq(vm.eval("((1 + 2) * 3) + (4 * (5 + 6))").to_string(), "53")
}

// =============================================================================
// 7. PATTERN MATCHING
// =============================================================================

///|
test "50. basic_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let s = 10"), content="()")
  inspect(vm.eval("match s { 10 => 100 }"), content="100")
  inspect(vm.eval("match 42 { x => x * 2 }"), content="84")
  inspect(vm.eval("match 123 { _ => 999 }"), content="999")
}

///|
test "51. or_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match 5 { 1 | 5 | 10 => 100 }"), content="100")
  inspect(vm.eval("match 3 { 1 | 5 | 10 => 100; _ => 200 }"), content="200")
}

///|
test "52. tuple_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match (1, 2) { (a, b) => a }"), content="1")
  inspect(vm.eval("match (1, 2) { (a, b) => b }"), content="2")
  inspect(vm.eval("match (1, 2) { (a, b) => a + b }"), content="3")
}

///|
test "53. array_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match [1, 2, 3] { [a, b, c] => a }"), content="1")
  inspect(vm.eval("match [1, 2, 3] { [a, b, c] => a + b + c }"), content="6")
  inspect(vm.eval("match [5, 10] { [x, y] => x * y }"), content="50")
}

///|
test "54. record_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match { x: 10, y: 20 } { { x, y } => x + y }"), content="30")
  inspect(
    vm.eval("match { name: \"Alice\", age: 25 } { { name, .. } => name }"),
    content="Alice",
  )
  inspect(
    vm.eval("match { name: \"Alice\", age: 25 } { { age, .. } => age }"),
    content="25",
  )
}

///|
test "55. nested_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("match (1, [2, 3]) { (a, [b, c]) => a + b + c }"),
    content="6",
  )
  inspect(vm.eval("match 2 { 1 => 10; 2 => 20; _ => 30 }"), content="20")
  inspect(vm.eval("match 5 { 1 => 10; 2 => 20; _ => 30 }"), content="30")
}

///|
test "56. range_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|const Zero = 0
        #|fn sign(x : Int) -> Int {
        #|  match x {
        #|    _..<Zero => -1
        #|    Zero => 0
        #|    1..<_ => 1
        #|  }
        #|}
        #|
        #|fn classify_char(c : Char) -> String {
        #|  match c {
        #|    'a'..='z' => "lowercase"
        #|    'A'..='Z' => "uppercase"
        #|    '0'..='9' => "digit"
        #|    _ => "other"
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("sign(10)"), content="1")
  inspect(vm.eval("sign(-10)"), content="-1")
  inspect(vm.eval("sign(0)"), content="0")
  inspect(vm.eval("classify_char('a')"), content="lowercase")
  inspect(vm.eval("classify_char('A')"), content="uppercase")
  inspect(vm.eval("classify_char('0')"), content="digit")
  inspect(vm.eval("classify_char('!')"), content="other")
}

///|
test "constructor_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|const Zero = 0
        #|const One = 1
        #|const Two = 2
        #|fn test_constr(x : Int) -> String {
        #|  match x {
        #|    Zero => "zero"
        #|    One => "one" 
        #|    Two => "two"
        #|    _ => "other"
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("test_constr(0)"), content="zero")
  inspect(vm.eval("test_constr(1)"), content="one")
  inspect(vm.eval("test_constr(2)"), content="two")
  inspect(vm.eval("test_constr(5)"), content="other")
}

// ///|
// test "constructor_named_patterns" {
//   let vm = MoonBitVM::new()
//   inspect(
//     vm.eval(
//       (
//         #|fn t(x : @list.List) -> Int {
//         #|  match x {
//         #|    More(x, tail=xs) => (x, xs)
//         #|    Empty => 0
//         #|  }
//         #|}
//       ),
//       top=true,
//     ),
//     content="()",
//   )
//   inspect(vm.eval("t(@list.of([1, 2]))"), content="1")
// }
// =============================================================================
// 8. OPTION TYPE
// =============================================================================

///|
test "option_basics" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@option.Some(5)").to_string(), "Some(5)")
  assert_eq(vm.eval("Some(5)").to_string(), "Some(5)")
  assert_eq(vm.eval("None").to_string(), "None")
  assert_eq(vm.eval("Some(5).unwrap()").to_string(), "5")
}

///|
test "option_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match Some(5) { Some(x) => x, None => 0 }"), content="5")
  inspect(
    vm.eval("match Some(5) { Option::Some(x) => x, None => 0 }"),
    content="5",
  )
  inspect(vm.eval("match None { Some(x) => x, None => 0 }"), content="0")
}

///|
test {
  inspect(
    {
      let opt = Some(5)
      opt.map(fn(x) { x * 2 })
    },
    content="Some(10)",
  )
}

///|
test "option_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let opt = Some(42); opt.unwrap()"), content="42")
  inspect(vm.eval("let opt = Some(42); opt.unwrap_or(0)"), content="42")
  inspect(vm.eval("let opt = None; opt.unwrap_or(0)"), content="0")
  inspect(vm.eval("let opt = Some(42); opt.is_empty()"), content="false")
  inspect(vm.eval("let opt = None; opt.is_empty()"), content="true")
  assert_eq(
    vm.eval("let opt = Some(5); opt.map(fn(x) { x * 2 })").to_string(),
    "Some(10)",
  )
  inspect(vm.eval("let opt = None; opt.map(fn(x) { x * 2 })"), content="None")
  inspect(
    vm.eval("let opt = Some(5); opt.filter(fn(x) { x > 3 })"),
    content="Some(5)",
  )
  inspect(
    vm.eval("let opt = Some(2); opt.filter(fn(x) { x > 3 })"),
    content="None",
  )
}

// =============================================================================
// 9. BUILT-IN METHODS
// =============================================================================

///|
test "string_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let s = \"hello\""), content="()")
  inspect(vm.eval("s.length()"), content="5")
  inspect(vm.eval("s.get(0)"), content="104")
  inspect(vm.eval("s.unsafe_get(1)"), content="101")
  inspect(vm.eval("s.to_string()"), content="hello")
}

///|
test "bool_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true.compare(false)"), content="1")
  inspect(vm.eval("false.compare(true)"), content="-1")
  inspect(vm.eval("true.compare(true)"), content="0")
  inspect(vm.eval("Bool::default()"), content="false")
}

///|
test "int_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("(5).lnot()"), content="-6")
  inspect(vm.eval("(5).land(3)"), content="1")
  inspect(vm.eval("(5).lor(3)"), content="7")
  inspect(vm.eval("(5).lxor(3)"), content="6")
  inspect(vm.eval("(5).shl(2)"), content="20")
  inspect(vm.eval("(20).shr(2)"), content="5")
  inspect(vm.eval("(5).compare(3)"), content="1")
  inspect(vm.eval("(3).compare(5)"), content="-1")
  inspect(vm.eval("(5).compare(5)"), content="0")
  inspect(vm.eval("(5).is_pos()"), content="true")
  inspect(vm.eval("(-5).is_neg()"), content="true")
  inspect(vm.eval("(0).is_pos()"), content="false")
  inspect(vm.eval("(8).ctz()"), content="3")
  inspect(vm.eval("(8).clz()"), content="28")
  inspect(vm.eval("(7).popcnt()"), content="3")
}

///|
test "double_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5.5.compare(3.5)"), content="1")
  inspect(vm.eval("3.5.compare(5.5)"), content="-1")
  inspect(vm.eval("3.5.compare(3.5)"), content="0")
  inspect(vm.eval("3.5.to_int64()"), content="3")
}

///|
test "char_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("'b'.compare('a')"), content="1")
  inspect(vm.eval("'a'.compare('b')"), content="-1")
  inspect(vm.eval("'a'.compare('a')"), content="0")
  inspect(vm.eval("'a'.to_int()"), content="97")
}

// =============================================================================
// 10. ADVANCED FEATURES
// =============================================================================

///|
test "pipe_operator" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5 |> ignore"), content="()")
  inspect(vm.eval("[] |> Array::push(5)"), content="[5]")
  inspect(
    vm.eval("fn add(x: Int, y: Int) -> Int { x + y }\n1 |> add(5)"),
    content="6",
  )
}

///|
test "println" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("println(\"hello\")"), content="()")
}

///|
test "embedded_code" {
  let vm = MoonBitVM::new()
  vm.interpreter.add_embedded_fn("%string_length2", ctx => if ctx.arguments
    is [{ value: String(s), .. }, ..] {
    Int(s.length())
  } else {
    Unit
  })
  inspect(
    vm.eval(
      "pub fn String::length2(self : String) -> Int = \"%string_length2\"",
    ),
    content="()",
  )
  inspect(vm.eval("let s = \"hello\""), content="()")
  inspect(vm.eval("s.length2()"), content="5")
}

// =============================================================================
// 11. ENUM
// =============================================================================

///|
test "basic_enum" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum Relation {
        #|  Smaller
        #|  Greater
        #|  Equal
        #|}
        #|fn compare_int(x: Int, y: Int) -> Relation {
        #|  if x < y {
        #|    Smaller
        #|  } else if x > y {
        #|    Relation::Greater
        #|  } else {
        #|    Equal
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("compare_int(0, 1)"), content="Smaller")
  inspect(vm.eval("compare_int(1, 1)"), content="Equal")
  inspect(vm.eval("compare_int(2, 1)"), content="Greater")
}

///|
test "enum_with_data" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum List {
        #|  Nil
        #|  Cons(Int, List)
        #|}
        #|fn is_singleton(l: List) -> Bool {
        #|  match l {
        #|    Cons(_, Nil) => true
        #|    _ => false
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let l = Cons(1, Cons(2, Nil))"), content="()")
  inspect(vm.eval("is_singleton(l)"), content="false")
  inspect(vm.eval("is_singleton(Cons(1, Nil))"), content="true")
  inspect(vm.eval("is_singleton(Nil)"), content="false")
}

///|
test "enum_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum Maybe {
        #|  Just(Int)
        #|  Nothing
        #|}
        #|fn get_or_default(m: Maybe, default: Int) -> Int {
        #|  match m {
        #|    Just(x) => x
        #|    Nothing => default
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("get_or_default(Just(5), 0)"), content="5")
  inspect(vm.eval("get_or_default(Nothing, 0)"), content="0")
}

// =============================================================================
// 12. GENERIC
// =============================================================================

///|
test "generic_list" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum List[T] {
        #|  Nil
        #|  Cons(T, List[T])
        #|}
        #|
        #|fn[T] List::new() -> List[T] {
        #|  Nil
        #|}
        #|
        #|fn[T] List::cons(x: T, xs: List[T]) -> List[T] {
        #|  Cons(x, xs)
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  // 先测试单独的Nil
  inspect(vm.eval("Nil"), content="Nil")
  // 再测试List::new()
  inspect(vm.eval("List::new()"), content="Nil")
  // 测试简单的Cons调用
  inspect(vm.eval("List::cons(1, Nil)"), content="Cons(1, Nil)")
  // 测试嵌套的Cons调用
  assert_eq(vm.eval("List::cons(2, List::new())").to_string(), "Cons(2, Nil)")
  // 测试中间步骤
  inspect(
    vm.eval("let inner = List::cons(2, List::new()); inner"),
    content="Cons(2, Nil)",
  )
  // 测试分步构建
  inspect(
    vm.eval("let step1 = List::new(); let step2 = List::cons(2, step1); step2"),
    content="Cons(2, Nil)",
  )
  // 测试直接嵌套调用
  inspect(vm.eval("List::cons(2, List::new())"), content="Cons(2, Nil)")
  // 测试更深层嵌套
  let result = vm.eval("List::cons(1, List::cons(2, List::new()))")
  inspect(result, content="Cons(1, Cons(2, Nil))")
  inspect(
    vm.eval("let list = List::cons(1, List::cons(2, List::new()))"),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|fn[S, T] map(list: List[S], f: (S) -> T) -> List[T] {
        #|  match list {
        #|    Nil => Nil
        #|    Cons(x, xs) => Cons(f(x), map(xs, f))
        #|  }
        #|}
        #|
        #|fn[T] sum(list: List[T]) -> T {
        #|  match list {
        #|    Nil => 0
        #|    Cons(x, xs) => x + sum(xs)
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(
    vm.eval("let list = List::cons(1, List::cons(2, List::new()))"),
    content="()",
  )
  assert_eq(
    vm.eval("map(list, x => x * 2)").to_string(),
    "Cons(2, Cons(4, Nil))",
  )
  assert_eq(vm.eval("sum(list)").to_string(), "3")
}

///|
test {
  let a = [x => x + 1, x => x - 1]
  inspect(a[1](10), content="9")
}

///|
test {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = [x => x + 1, x => x - 1]; a[1](10)"), content="9")
}

///|
test "nested_struct_reference" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct S {
        #|  mut a: Int
        #|}
        #|
        #|struct T {
        #|  a: S
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let a = { a: 1 }"), content="()")
  inspect(vm.eval("let b = { a: a }"), content="()")
  inspect(vm.eval("b.a.a = 2"), content="()")
  inspect(vm.eval("a"), content="{ a: 2 }")
}

///|
test "currying" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let add = x => y => x + y").to_string(), "()")
  assert_eq(vm.eval("let f = add(10)").to_string(), "()")
  assert_eq(vm.eval("f").to_string(), "(y) -> Any")
  assert_eq(vm.eval("f(1)").to_string(), "11")
  assert_eq(vm.eval("add(5)(3)").to_string(), "8")
}

///|
test "module" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let max_value = 1").to_string(), "()")
  assert_eq(vm.eval("max_value").to_string(), "1")
  assert_eq(vm.eval("@int.max_value").to_string(), "2147483647")
  assert_eq(vm.eval("@int.abs(-1)").to_string(), "1")
}

///|
test "math" {
  let vm = MoonBitVM::new()
  // vm.interpreter.env.deps["math"].unwrap().env.values["abs"]
  assert_eq(vm.eval("@math.abs(-1.0)").to_string(), "1")
  assert_eq(vm.eval("@math.abs").to_string(), "(x: Double) -> Double")
}

///|
test "bigint" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@bigint.zero").to_string(), "0")
  assert_eq(vm.eval("@bigint.radix_bit_len").to_string(), "32")
}

///|
test "cmp" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@cmp.maximum").to_string(), "(x: T, y: T) -> T")
  assert_eq(vm.eval("@cmp.minimum").to_string(), "(x: T, y: T) -> T")
  assert_eq(vm.eval("@cmp.maximum(1, 2)").to_string(), "2")
  assert_eq(vm.eval("@cmp.minimum(1, 2)").to_string(), "1")
}

///|
test "cross_package_method_calling" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let list = @list.of([1,2,3]); list").to_string(),
    "More(1, More(2, More(3, Empty)))",
  )
  assert_eq(vm.eval("list.to_array()").to_string(), "[1, 2, 3]")
  assert_eq(
    vm.eval("let arr1 : Array[Int] = [1, 2, 3, 4, 5]").to_string(),
    "()",
  )
  assert_eq(vm.eval("arr1.length()").to_string(), "5")
}

///|
test "45. map_operations" {
  let vm = MoonBitVM::new()
  // Test simple Map::of creation first
  inspect(vm.eval("Map::of([])"), content="{}")

  // Test map literal creation
  inspect(
    vm.eval("let map1 = { \"key1\": 1, \"key2\": 2, \"key3\": 3 }"),
    content="()",
  )
  inspect(vm.eval("map1"), content="{\"key1\": 1, \"key2\": 2, \"key3\": 3}")
  // Test map length

  // Test map access
  inspect(vm.eval("map1[\"key1\"]"), content="1")

  // Test Map::of creation
  inspect(
    vm.eval("let map2 = Map::of([(\"key1\", 1), (\"key2\", 2), (\"key3\", 3)])"),
    content="()",
  )
  // inspect(vm.eval("map1 == map2"), content="true")

  // Test map update
  inspect(vm.eval("map1[\"key1\"] = 10", log=true), content="()")
  inspect(vm.eval("map1"), content="{\"key1\": 10, \"key2\": 2, \"key3\": 3}")
}

///|
test "46. foreach_loop" {
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
