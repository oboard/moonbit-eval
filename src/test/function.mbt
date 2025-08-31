// =============================================================================
// 5. FUNCTIONS
// =============================================================================

///|
test "basic_functions" {
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
test "named_parameters" {
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
test "lambda_functions" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let f = x => x * 2"), content="()")
  assert_eq(vm.eval("f(3)").to_string(), "6")
  assert_eq(vm.eval("let identity = x => x").to_string(), "()")
  assert_eq(vm.eval("identity(5)").to_string(), "5")
}

///|
test "closure_argument_environment" {
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
test "recursive_functions" {
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
test "mutually_recursive_functions" {
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
test "let_and_bindings" {
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
