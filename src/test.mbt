///|
test "basic" {
  let vm = MoonBitVM::new()
  // Int 运算测试
  inspect(vm.eval_to_str("1"), content="1")
  inspect(vm.eval_to_str("1+1"), content="2")
  inspect(vm.eval_to_str("2-1"), content="1")
  inspect(vm.eval_to_str("\"hello\""), content="hello")
  inspect(vm.eval_to_str("5 * 3"), content="15")
  inspect(vm.eval_to_str("10 / 2"), content="5")
  inspect(vm.eval_to_str("7 % 3"), content="1")
  inspect(vm.eval_to_str("5 == 5"), content="true")
  inspect(vm.eval_to_str("5 != 3"), content="true")
  inspect(vm.eval_to_str("3 < 5"), content="true")
  inspect(vm.eval_to_str("5 > 3"), content="true")
  inspect(vm.eval_to_str("3 <= 5"), content="true")
  inspect(vm.eval_to_str("5 >= 3"), content="true")
}

///|
test "string" {
  let vm = MoonBitVM::new()
  inspect(vm.eval_to_str("\"hello\""), content="hello")
  inspect(vm.eval_to_str("\"hello\"+\"hello\""), content="hellohello")
}

///|
test "variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval_to_str("let a = 1"), content="Unit")
  inspect(vm.eval_to_str("a"), content="1")
}

///|
test "mutable variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval_to_str("let mut a = 1"), content="Unit")
  inspect(vm.eval_to_str("a = 12"), content="Unit")
  inspect(vm.eval_to_str("a"), content="12")
}

///|
test "function" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval_to_str("fn double(x: Int) -> Int { x * 2 }"),
    content="(x: Int) -> Int",
  )
  inspect(vm.eval_to_str("double(2)"), content="4")
  inspect(
    vm.eval_to_str("fn add(a: Int, b: Int) -> Int { a + b }"),
    content="(a: Int, b: Int) -> Int",
  )
  inspect(vm.eval_to_str("add(1, 2)"), content="3")
  inspect(
    vm.eval_to_str("fn add_named(a~: Int, b~: Int) -> Int { a + b }"),
    content="(a~: Int, b~: Int) -> Int",
  )
  inspect(vm.eval_to_str("add_named(a=1, b=2)"), content="3")
  inspect(
    vm.eval_to_str("fn add_optional(a~: Int, b~: Int=2) -> Int { a + b }"),
    content="(a~: Int, b~: Int = 2) -> Int",
  )
  inspect(vm.eval_to_str("add_optional(a=1)"), content="3")
}

///|
test "str" {
  let vm = MoonBitVM::new()
  inspect(vm.eval_to_str("let str1: String = \"haha\""), content="Unit")
  inspect(vm.eval_to_str("let str2: String = \"hello\""), content="Unit")
  inspect(vm.eval_to_str("str1 + str2"), content="Unit")
}

///|
test "if" {
  let vm = MoonBitVM::new()
  // Test nested if expressions
  inspect(
    vm.eval_to_str("if 1 > 0 { if 2 > 1 { 3 } else { 4 } } else { 5 }"),
    content="3",
  )

  // Test complex conditions
  inspect(vm.eval_to_str("if (5 + 3) * 2 > 15 { 1 } else { 2 }"), content="1")

  // Test boolean expressions in conditions
  inspect(
    vm.eval_to_str("if true && false || true { 1 } else { 2 }"),
    content="1",
  )

  // Test if expression with function calls
  inspect(
    vm.eval_to_str(
      "fn double(x: Int) -> Int { x * 2 }\n if double(5) > 8 { 3 } else { 4 }",
    ),
    content="3",
  )

  // Test if without else
  inspect(vm.eval_to_str("if 3 < 2 { 1 }"), content="Unit")
}

///|
test "for" {
  let mut output = 0
  for i = 0; i < 10; i = i + 1 {
    output += i
    // println(output)
  }
  inspect(output, content="45")
  // test for loop
  let vm = MoonBitVM::new(log=true)
  inspect(vm.eval_to_str("let mut output = 0"), content="Unit")
  inspect(
    vm.eval_to_str("for i = 0; i < 10; i = i + 1 { output += i }"),
    content="Unit",
  )
  inspect(vm.eval_to_str("output"), content="45")
  let mut output = 0
  for i = 0; i < 10; i = i + 1 {
    output += i
  }
  inspect(output, content="45")
}

// ///|
// test "while" {
//   let vm = MoonBitVM::new()
//   @json.inspect(vm.eval_to_str("let mut i = 0"), content="Unit")
//   @json.inspect(vm.eval_to_str("let mut sum = 0"), content="Unit")
//   @json.inspect(vm.eval_to_str("while i < 5 { sum += i; i += 1 }"), content="Unit")
//   @json.inspect(vm.eval_to_str("sum"), content="Int(10)")
//   @json.inspect(vm.eval_to_str("i"), content="Int(5)")

//   // 测试 while 循环不会执行的情况
//   let vm2 = MoonBitVM::new()
//   @json.inspect(vm2.eval("let mut count = 0"), content="Unit")
//   @json.inspect(vm2.eval("while false { count += 1 }"), content="Unit")
//   @json.inspect(vm2.eval("count"), content="Int(0)")
// }

// ///|
// test "lambda" {
//   let vm = MoonBitVM::new()
//   // 测试基本的 lambda 函数
//   @json.inspect(vm.eval_to_str("let f = x => x * 2"), content="Unit")
//   @json.inspect(vm.eval_to_str("f(3)"), content="Int(6)")

//   // 测试 lambda 函数作为表达式
//   @json.inspect(vm.eval_to_str("let g = y => y + 1"), content="Unit")
//   @json.inspect(vm.eval_to_str("g(5)"), content="Int(6)")

//   // 测试 lambda 函数调用
//   @json.inspect(vm.eval_to_str("let h = z => z * z"), content="Unit")
//   @json.inspect(vm.eval_to_str("h(4)"), content="Int(16)")
// }

///|
test "lambda_simple" {
  let vm = MoonBitVM::new()
  // 测试简单的 lambda 表达式
  inspect(vm.eval_to_str("let f = x => x"), content="Unit")
  inspect(vm.eval_to_str("f(5)"), content="5")
}

///|
test "extern" {
  let vm = MoonBitVM::new()
  vm.interpreter.add_extern_fn("println", params => {
    if params is More(Constant(c=String(s), ..), ..) {
      println(s)
    }
    unit()
  })
  inspect(vm.eval_to_str("println(\"hello\")"), content="Unit")
}
// ///|
// test "fib" {
//   let vm = MoonBitVM::new()
//   @json.inspect(
//     vm.eval_to_str(
//       (
//         #|fn fib(n : Int) -> Int {
//         #|  if n <= 1 {
//         #|    1
//         #|  } else {
//         #|    fib(n - 1) + fib(n - 2)
//         #|  }
//         #|}
//       ),
//     ),
//     content="(Int) -> Int",
//   )
//   @json.inspect(vm.eval_to_str("fib(10)"), content="Int(89)")
//   fn fib(n : Int) -> Int {
//     if n <= 1 {
//       1
//     } else {
//       fib(n - 1) + fib(n - 2)
//     }
//   }

//   @json.inspect(fib(10), content="89")
// }

///|
test "fn simple" {
  let vm = MoonBitVM::new()
  @json.inspect(vm.eval_to_str("fn a() { 1 }"), content="()")
  @json.inspect(vm.eval_to_str("a()"), content="1")
}

///|
test "fn add" {
  let vm = MoonBitVM::new()
  @json.inspect(
    vm.eval_to_str("fn add(a: Int, b: Int) -> Int { a + b }"),
    content="(a: Int, b: Int) -> Int",
  )
  @json.inspect(vm.eval_to_str("add(1,2)"), content="3")
}
