///|
test "basic" {
  let vm = MoonBitVM::new()
  // Int 运算测试
  inspect(vm.eval("1"), content="1")
  inspect(vm.eval("1+1"), content="2")
  inspect(vm.eval("2-1"), content="1")
  inspect(vm.eval("\"hello\""), content="hello")
  inspect(vm.eval("5 * 3"), content="15")
  inspect(vm.eval("10 / 2"), content="5")
  inspect(vm.eval("7 % 3"), content="1")
  inspect(vm.eval("5 == 5"), content="true")
  inspect(vm.eval("5 != 3"), content="true")
  inspect(vm.eval("3 < 5"), content="true")
  inspect(vm.eval("5 > 3"), content="true")
  inspect(vm.eval("3 <= 5"), content="true")
  inspect(vm.eval("5 >= 3"), content="true")
}

///|
test "bool" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true"), content="true")
  inspect(vm.eval("false"), content="false")
  inspect(vm.eval("!false"), content="true")
  inspect(vm.eval("!true"), content="false")
  inspect(vm.eval("true && false"), content="false")
  inspect(vm.eval("true || false"), content="true")
}

///|
test "string" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("\"hello\""), content="hello")
  inspect(vm.eval("\"hello\"+\"hello\""), content="hellohello")
}

///|
test "variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 1"), content="()")
  inspect(vm.eval("a"), content="1")
}

///|
test "mutable variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut a = 1"), content="()")
  inspect(vm.eval("a = 12"), content="()")
  inspect(vm.eval("a"), content="12")
}

///|
test "function" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("fn double(x: Int) -> Int { x * 2 }"),
    content="(x: Int) -> Int",
  )
  inspect(vm.eval("double(2)"), content="4")
  inspect(
    vm.eval("fn add(a: Int, b: Int) -> Int { a + b }"),
    content="(a: Int, b: Int) -> Int",
  )
  inspect(vm.eval("add(1, 2)"), content="3")
  inspect(
    vm.eval("fn add_named(a~: Int, b~: Int) -> Int { a + b }"),
    content="(a~: Int, b~: Int) -> Int",
  )
  inspect(vm.eval("add_named(a=1, b=2)"), content="3")
  inspect(
    vm.eval("fn add_optional(a~: Int, b~: Int=2) -> Int { a + b }"),
    content="(a~: Int, b~: Int = 2) -> Int",
  )
  inspect(vm.eval("add_optional(a=1)"), content="3")
}

///|
test "str" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let str1: String = \"haha\""), content="()")
  inspect(vm.eval("let str2: String = \"hello\""), content="()")
  inspect(vm.eval("str1 + str2"), content="()")
}

///|
test "if" {
  let vm = MoonBitVM::new()
  // Test nested if expressions
  inspect(
    vm.eval("if 1 > 0 { if 2 > 1 { 3 } else { 4 } } else { 5 }"),
    content="3",
  )

  // Test complex conditions
  inspect(vm.eval("if (5 + 3) * 2 > 15 { 1 } else { 2 }"), content="1")

  // Test boolean expressions in conditions
  inspect(vm.eval("if true && false || true { 1 } else { 2 }"), content="1")

  // Test if expression with function calls
  inspect(
    vm.eval(
      "fn double(x: Int) -> Int { x * 2 }\n if double(5) > 8 { 3 } else { 4 }",
    ),
    content="3",
  )

  // Test if without else
  inspect(vm.eval("if 3 < 2 { 1 }"), content="()")
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
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut output = 0"), content="()")
  inspect(vm.eval("for i = 0; i < 10; i = i + 1 { output += i }"), content="()")
  inspect(vm.eval("output"), content="45")
  let mut output = 0
  for i = 0; i < 10; i = i + 1 {
    output += i
  }
  inspect(output, content="45")
}

///|
test "while" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut i = 0"), content="()")
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("while i < 5 { sum += i; i += 1 }"), content="()")
  inspect(vm.eval("sum"), content="10")
  inspect(vm.eval("i"), content="5")

  // 测试 while 循环不会执行的情况
  let vm2 = MoonBitVM::new()
  inspect(vm2.eval("let mut count = 0"), content="()")
  inspect(vm2.eval("while false { count += 1 }"), content="()")
  inspect(vm2.eval("count"), content="0")
}

///|
test "lambda" {
  let vm = MoonBitVM::new()
  // 测试基本的 lambda 函数
  inspect(vm.eval("let f = x => x * 2"), content="()")
  inspect(vm.eval("f(3)"), content="6")
  // 测试 lambda 函数作为表达式
  inspect(vm.eval("let g = y => y + 1"), content="()")
  inspect(vm.eval("g(5)"), content="6")

  // 测试 lambda 函数调用
  inspect(vm.eval("let h = z => z * z"), content="()")
  inspect(vm.eval("h(4)"), content="16")
}

///|
test "lambda_simple" {
  let vm = MoonBitVM::new()
  // 测试简单的 lambda 表达式
  inspect(vm.eval("let f = x => x"), content="()")
  inspect(vm.eval("f(5)"), content="5")
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
  inspect(vm.eval("println(\"println from external function\")"), content="()")
}

///|
test "embedded_code" {
  let vm = MoonBitVM::new()
  // 注册 embedded_code
  vm.interpreter.add_embedded_fn("%string_length", params => if params
    is @list.More(Constant(c=String(s), loc~), ..) {
    Constant(c=Int(s.length().to_string()), loc~)
  } else {
    unit()
  })
  inspect(
    vm.eval("pub fn String::length(self : String) -> Int = \"%string_length\""),
    content="()",
  )
  inspect(vm.eval("let s = \"hello\""), content="()")
  inspect(vm.eval("s.length()"), content="5")
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
    content="(n: Int) -> Int",
  )
  inspect(vm.eval("fib(10)"), content="89")
}

///|
test "fn simple" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("fn a() { 1 }"), content="()")
  inspect(vm.eval("a()"), content="1")
}

///|
test "fn add" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("fn add(a: Int, b: Int) -> Int { a + b }"),
    content="(a: Int, b: Int) -> Int",
  )
  inspect(vm.eval("add(1,2)"), content="3")
}

///|
test "struct" {
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
test "match" {
  let vm = MoonBitVM::new()
  // 基本常量匹配
  inspect(vm.eval("let s = 10"), content="()")
  inspect(vm.eval("match s { 10 => 100 }"), content="100")

  // 变量模式匹配
  inspect(vm.eval("match 42 { x => x * 2 }"), content="84")

  // 通配符模式匹配
  inspect(vm.eval("match 123 { _ => 999 }"), content="999")

  // Or模式匹配
  inspect(vm.eval("match 5 { 1 | 5 | 10 => 100 }"), content="100")
  inspect(vm.eval("match 3 { 1 | 5 | 10 => 100; _ => 200 }"), content="200")

  // 测试简单变量绑定
  inspect(vm.eval("match 42 { x => x }"), content="42")

  // Tuple模式匹配 - 简化测试
  inspect(vm.eval("match (1, 2) { (a, b) => a }"), content="1")
  inspect(vm.eval("match (1, 2) { (a, b) => b }"), content="2")
  inspect(vm.eval("match (1, 2) { (a, b) => a + b }"), content="3")

  // Array模式匹配
  inspect(vm.eval("match [1, 2, 3] { [a, b, c] => a + b + c }"), content="6")
  inspect(vm.eval("match [5, 10] { [x, y] => x * y }"), content="50")

  // Record模式匹配
  inspect(vm.eval("match { x: 10, y: 20 } { { x, y } => x + y }"), content="30")
  inspect(
    vm.eval("match { name: \"Alice\", age: 25 } { { name, .. } => name }"),
    content="Alice",
  )
  inspect(
    vm.eval("match { name: \"Alice\", age: 25 } { { age, .. } => age }"),
    content="25",
  )
  // 嵌套模式匹配
  inspect(
    vm.eval("match (1, [2, 3]) { (a, [b, c]) => a + b + c }"),
    content="6",
  )

  // 多个case的匹配
  inspect(vm.eval("match 2 { 1 => 10; 2 => 20; _ => 30 }"), content="20")
  inspect(vm.eval("match 5 { 1 => 10; 2 => 20; _ => 30 }"), content="30")
}

///|
test "match range" {
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
test "match constructor" {
  let vm = MoonBitVM::new()
  // 测试常量构造函数匹配
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

///|
test "mutate" {
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
  inspect(
    vm.eval("p"),
    content=(
      #|{
      #|  x: 3,
      #|  y: 4
      #|}
    ),
  )
}

///|
test "tuple" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let t = (1, 2)"), content="()")
  inspect(vm.eval("t.0"), content="1")
  inspect(vm.eval("t.1"), content="2")
  inspect(vm.eval("t"), content="(1, 2)")
  inspect(vm.eval("let (a, b) = t"), content="()")
  inspect(vm.eval("a"), content="1")
  inspect(vm.eval("b"), content="2")
  inspect(vm.eval("let (a, b, c) = (1, 2, 3)"), content="()")
  inspect(vm.eval("a"), content="1")
  inspect(vm.eval("b"), content="2")
  inspect(vm.eval("c"), content="3")
  inspect(vm.eval("let a = 1"), content="()")
  inspect(vm.eval("let a = (a, a)"), content="()")
  inspect(vm.eval("let a = (a, a)"), content="()")
  inspect(vm.eval("a"), content="((1, 1), (1, 1))")
}

///|
test "array" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = [1, 2, 3]"), content="()")
  inspect(vm.eval("a"), content="[1, 2, 3]")
  inspect(vm.eval("a[0]"), content="1")
  inspect(vm.eval("a[1] = 4"), content="()")
  inspect(vm.eval("a"), content="[1, 4, 3]")
}
