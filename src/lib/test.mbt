///|
test "basic" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("1"), content="Int(1)")
  inspect(vm.eval("1+1"), content="Int(2)")
  inspect(vm.eval("2-1"), content="Int(1)")
  inspect(
    vm.eval("\"hello\""),
    content=(
      #|String("hello")
    ),
  )
  inspect(vm.eval("println(\"hello\")"), content="Unit")
}

///|
test "string" {
  let vm = MoonBitVM::new(log=true)
  inspect(vm.eval("let str: String = \"hello\""), content="Unit")
  inspect(vm.eval("str"), content="String(\"hello\")")
  inspect(vm.eval("str + \" world\""), content="String(\"hello world\")")
  inspect(
    vm.eval("\"\\{str + str} world\""),
    content="String(\"hellohello world\")",
  )
}

///|
test "variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 1"), content="Unit")
  inspect(vm.eval("a"), content="Int(1)")
}

///|
test "compare" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = -1"), content="Unit")
  inspect(vm.eval("a"), content="Int(-1)")
  inspect(vm.eval("a == 2"), content="Bool(false)")
  inspect(vm.eval("1 > 2"), content="Bool(false)")
  inspect(vm.eval("1 < 2"), content="Bool(true)")
  inspect(vm.eval("1 <= 2"), content="Bool(true)")
  inspect(vm.eval("1 >= 2"), content="Bool(false)")
  inspect(vm.eval("2 >= 2"), content="Bool(true)")
}

///|
test "mutable variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut a = 1"), content="Unit")
  inspect(vm.eval("a = 12"), content="Unit")
  inspect(vm.eval("a"), content="Int(12)")
}

///|
test "function" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("fn double(x: Int) -> Int { x * 2 }"), content="(Int) -> Int")
  inspect(vm.eval("double(2)"), content="Int(4)")
}

///|
test "str" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let str1: String = \"haha\""), content="Unit")
  inspect(vm.eval("let str2: String = \"hello\""), content="Unit")
  inspect(
    vm.eval("str1 + str2"),
    content=(
      #|String("hahahello")
    ),
  )
}

///|
test "if" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("if true { 1 } else { 2 }"), content="Int(1)")
  inspect(vm.eval("if false { 1 } else { 2 }"), content="Int(2)")
}

///|
test "for" {
  let tokens = []
  @lex.lex({
    str: "for i = 0; i < 10; i = i + 1 { output += i }",
    offset: 0,
    array: tokens,
  })
  inspect(
    tokens,
    content=(
      #|[For, Identifier("i"), Assign, Number(0), Semicolon, Identifier("i"), LessThan, Number(10), Semicolon, Identifier("i"), Assign, Identifier("i"), Add, Number(1), LBrace, Identifier("output"), AddEqual, Identifier("i"), RBrace]
    ),
  )
  // let mut output = 0
  // for i = 0; i < 10; i = i + 1 {
  //   output += i
  //   // println(output)
  // }
  // inspect(output, content="45")
  // // test for loop
  // let vm = MoonBitVM::new(log=true)
  // inspect(vm.eval("let mut output = 0"), content="Unit")
  // inspect(
  //   vm.eval("for i = 0; i < 10; i = i + 1 { output += i }"),
  //   content="Unit",
  // )
  // inspect(vm.eval("output"), content="Int(45)")
  // let mut output = 0
  // for i = 0; i < 10; i = i + 1 {
  //   output += i
  // }
  // inspect(output, content="45")
}

///|
test "while" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut i = 0"), content="Unit")
  inspect(vm.eval("let mut sum = 0"), content="Unit")
  inspect(vm.eval("while i < 5 { sum += i; i += 1 }"), content="Unit")
  inspect(vm.eval("sum"), content="Int(10)")
  inspect(vm.eval("i"), content="Int(5)")

  // 测试 while 循环不会执行的情况
  let vm2 = MoonBitVM::new()
  inspect(vm2.eval("let mut count = 0"), content="Unit")
  inspect(vm2.eval("while false { count += 1 }"), content="Unit")
  inspect(vm2.eval("count"), content="Int(0)")
}

///|
test "lambda" {
  let vm = MoonBitVM::new()
  // 测试基本的 lambda 函数
  inspect(vm.eval("let f = x => x * 2"), content="Unit")
  inspect(vm.eval("f(3)"), content="Int(6)")

  // 测试 lambda 函数作为表达式
  inspect(vm.eval("let g = y => y + 1"), content="Unit")
  inspect(vm.eval("g(5)"), content="Int(6)")

  // 测试 lambda 函数调用
  inspect(vm.eval("let h = z => z * z"), content="Unit")
  inspect(vm.eval("h(4)"), content="Int(16)")
}

///|
test "lambda_simple" {
  let vm = MoonBitVM::new(log=true)
  // 测试简单的 lambda 表达式
  inspect(vm.eval("let f = x => x"), content="Unit")
  inspect(vm.eval("f(5)"), content="Int(5)")
}

///|
test "fib" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|fn fib(n : Int) -> Int {
        #|  if n <= 1 {
        #|    1
        #|  } else {
        #|    fib(n - 1) + fib(n - 2)
        #|  }
        #|}
      ),
    ),
    content="(Int) -> Int",
  )
  inspect(vm.eval("fib(10)"), content="Int(89)")
  fn fib(n : Int) -> Int {
    if n <= 1 {
      1
    } else {
      fib(n - 1) + fib(n - 2)
    }
  }

  inspect(fib(10), content="89")
}

///|
test "fn simple" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("fn a() { 1 }"), content="() -> Int")
  inspect(vm.eval("a()"), content="Int(1)")
}

///|
test "fn add" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("fn add(a: Int, b: Int) -> Int { a + b }"),
    content="(Int, Int) -> Int",
  )
  inspect(vm.eval("add(1,2)"), content="Int(3)")
}
