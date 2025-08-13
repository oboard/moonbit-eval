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
  let vm = MoonBitVM::new(log=true)
  inspect(vm.eval_to_str("\"hello\""), content="hello")
  inspect(vm.eval_to_str("\"hello\"+\"hello\""), content="hellohello")
}

///|
test "variables" {
  let vm = MoonBitVM::new(log=true)
  inspect(vm.eval_to_str("let a = 1"), content="Unit")
  inspect(vm.eval_to_str("a"), content="Int(1)")
}

// ///|
// test "compare" {
//   let vm = MoonBitVM::new()
//   @json.inspect(vm.eval_to_str("let a = -1"), content="Unit")
//   @json.inspect(vm.eval_to_str("a"), content="Int(-1)")
//   @json.inspect(vm.eval_to_str("a == 2"), content="Bool(false)")
//   @json.inspect(vm.eval_to_str("1 > 2"), content="Bool(false)")
//   @json.inspect(vm.eval_to_str("1 < 2"), content="Bool(true)")
//   @json.inspect(vm.eval_to_str("1 <= 2"), content="Bool(true)")
//   @json.inspect(vm.eval_to_str("1 >= 2"), content="Bool(false)")
//   @json.inspect(vm.eval_to_str("2 >= 2"), content="Bool(true)")
// }

// ///|
// test "mutable variables" {
//   let vm = MoonBitVM::new()
//   @json.inspect(vm.eval_to_str("let mut a = 1"), content="Unit")
//   @json.inspect(vm.eval_to_str("a = 12"), content="Unit")
//   @json.inspect(vm.eval_to_str("a"), content="Int(12)")
// }

// ///|
// test "function" {
//   let vm = MoonBitVM::new()
//   @json.inspect(
//     vm.eval_to_str("fn double(x: Int) -> Int { x * 2 }"),
//     content="(Int) -> Int",
//   )
//   @json.inspect(vm.eval_to_str("double(2)"), content="Int(4)")
// }

// ///|
// test "str" {
//   let vm = MoonBitVM::new()
//   @json.inspect(vm.eval_to_str("let str1: String = \"haha\""), content="Unit")
//   @json.inspect(vm.eval_to_str("let str2: String = \"hello\""), content="Unit")
//   @json.inspect(
//     vm.eval_to_str("str1 + str2"),
//     content=(
//       #|String("hahahello")
//     ),
//   )
// }

// ///|
// test "if" {
//   let vm = MoonBitVM::new()
//   @json.inspect(vm.eval_to_str("if true { 1 } else { 2 }"), content="Int(1)")
//   @json.inspect(vm.eval_to_str("if false { 1 } else { 2 }"), content="Int(2)")
// }

// ///|
// test "for" {
//   let tokens = []
//   @json.inspect(
//     tokens,
//     content=(
//       #|[For, Identifier("i"), Assign, Number(0), Semicolon, Identifier("i"), LessThan, Number(10), Semicolon, Identifier("i"), Assign, Identifier("i"), Add, Number(1), LBrace, Identifier("output"), AddEqual, Identifier("i"), RBrace]
//     ),
//   )
//   // let mut output = 0
//   // for i = 0; i < 10; i = i + 1 {
//   //   output += i
//   //   // println(output)
//   // }
//   //  @json.inspect(output, content="45")
//   // // test for loop
//   // let vm = MoonBitVM::new(log=true)
//   //  @json.inspect(vm.eval_to_str("let mut output = 0"), content="Unit")
//   //  @json.inspect(
//   //   vm.eval_to_str("for i = 0; i < 10; i = i + 1 { output += i }"),
//   //   content="Unit",
//   // )
//   //  @json.inspect(vm.eval_to_str("output"), content="Int(45)")
//   // let mut output = 0
//   // for i = 0; i < 10; i = i + 1 {
//   //   output += i
//   // }
//   //  @json.inspect(output, content="45")
// }

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

// ///|
// test "lambda_simple" {
//   let vm = MoonBitVM::new(log=true)
//   // 测试简单的 lambda 表达式
//   @json.inspect(vm.eval_to_str("let f = x => x"), content="Unit")
//   @json.inspect(vm.eval_to_str("f(5)"), content="Int(5)")
// }

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

// ///|
// test "fn simple" {
//   let vm = MoonBitVM::new()
//   @json.inspect(vm.eval_to_str("fn a() { 1 }"), content="() -> Int")
//   @json.inspect(vm.eval_to_str("a()"), content="Int(1)")
// }

// ///|
// test "fn add" {
//   let vm = MoonBitVM::new()
//   @json.inspect(
//     vm.eval_to_str("fn add(a: Int, b: Int) -> Int { a + b }"),
//     content="(Int, Int) -> Int",
//   )
//   @json.inspect(vm.eval_to_str("add(1,2)"), content="Int(3)")
// }
