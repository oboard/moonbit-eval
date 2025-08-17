# MoonBit Eval

🚀 **[Demo https://moonrepl.oboard.eu.org/](https://moonrepl.oboard.eu.org/)**

## Introduction
MoonBit Eval is an interpreter for the MoonBit language.

Built on top of the [@moonbitlang/parser](https://github.com/moonbitlang/parser) library, it provides comprehensive and accurate MoonBit syntax support, capable of correctly parsing and executing complex MoonBit code structures including functions, structs, lambdas, loops, and more.


## Progress
- [x] Expression
- [x] Variable
- [x] Basic Types
- [x] If
- [x] Let (Mut)
- [x] Assign
- [x] For
- [x] While
- [x] Lambda Fn
- [x] Struct
- [x] Match
- [x] Array
- [x] Tuple
- [x] Embedded Functions
- [x] External Functions
- [x] Mutable Struct Fields
- [x] Range Patterns
- [x] Constructor Patterns
- [ ] Trait
- [ ] Packages


## Examples

### Basic Operations
```moonbit
test "basic" {
  let vm = MoonBitVM::new()
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
```

### Boolean Operations
```moonbit
test "bool" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true"), content="true")
  inspect(vm.eval("false"), content="false")
  inspect(vm.eval("!false"), content="true")
  inspect(vm.eval("!true"), content="false")
  inspect(vm.eval("not(false)"), content="true")
  inspect(vm.eval("not(true)"), content="false")
  inspect(not(false), content="true")
  inspect(not(true), content="false")
  inspect(vm.eval("true && false"), content="false")
  inspect(vm.eval("true || false"), content="true")
}
```

### String Operations
```moonbit
test "string" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("\"hello\""), content="hello")
  inspect(vm.eval("\"hello\"+\"hello\""), content="hellohello")
}
```

### Variables and Functions
```moonbit
test "variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 1"), content="()")
  inspect(vm.eval("a"), content="1")
}

test "function" {
  let vm = MoonBitVM::new()
  let result = vm.eval("fn double(x: Int) -> Int { x * 2 }")
  inspect(result, content="(x: Int) -> Int")
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
```

### Mutable Variables
```moonbit
test "mutable variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut a = 1"), content="()")
  inspect(vm.eval("a = 12"), content="()")
  inspect(vm.eval("a"), content="12")
}
```

### Control Flow
```moonbit
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

  // Test if without else
  inspect(vm.eval("if 3 < 2 { 1 }"), content="()")
}

test "for" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut output = 0"), content="()")
  inspect(vm.eval("for i = 0; i < 10; i = i + 1 { output += i }"), content="()")
  inspect(vm.eval("output"), content="45")
}

test "while" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut i = 0"), content="()")
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("while i < 5 { sum += i; i += 1 }"), content="()")
  inspect(vm.eval("sum"), content="10")
  inspect(vm.eval("i"), content="5")
}
```

### Lambda Functions
```moonbit
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

test "lambda_simple" {
  let vm = MoonBitVM::new()
  // 测试简单的 lambda 表达式
  inspect(vm.eval("let f = x => x"), content="()")
  inspect(vm.eval("f(5)"), content="5")
}
```

### Structs and Methods
```moonbit
test "struct" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      #|struct S { 
      #|  a: Int
      #|  b: Int
      #|}
      #|fn S::sum(self: S) -> Int {
      #|  self.a + self.b
      #|}
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let s = { a: 23, b: 32 }"), content="()")
  inspect(vm.eval("s.sum()"), content="55")
}
```

### Tuples
```moonbit
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
```

### Mutable Struct Fields
```moonbit
test "mutate" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      #|struct Point {
      #|  mut x : Int
      #|  mut y : Int
      #|}
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let p = { x: 1, y: 2 }"), content="()")
  inspect(vm.eval("p.x = 3"), content="()")
  inspect(vm.eval("p.y = 4"), content="()")
  inspect(vm.eval("p.x"), content="3")
}
```

### Fibonacci Recursion
```moonbit
test "fib" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      #|fn fib(n : Int) -> Int {
      #|  if n <= 1 {
      #|    1
      #|  } else {
      #|    fib(n - 1) + fib(n - 2)
      #|  }
      #|}
    ),
    content="(n: Int) -> Int",
  )
  inspect(vm.eval("fib(10)"), content="89")
}
```

### External Functions
```moonbit
test "extern" {
  let vm = MoonBitVM::new()
  vm.interpreter.add_extern_fn("println", params => {
    if params is [{ value: String(s), .. }, ..] {
      println(s)
    }
    Unit
  })
  inspect(vm.eval("println(\"println from external function\")"), content="()")
}
```

### Embedded Functions
```moonbit
test "embedded_code" {
  let vm = MoonBitVM::new()
  // 注册 embedded_code
  vm.interpreter.add_embedded_fn("%string_length2", params => if params
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
```

### Match Expressions
```moonbit
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
```

### Embedded Methods

#### Boolean Methods
```moonbit
test "bool embedded methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true.eq(true)"), content="true")
  inspect(vm.eval("true.eq(false)"), content="false")
  inspect(vm.eval("true.compare(false)"), content="1")
  inspect(vm.eval("false.compare(true)"), content="-1")
  inspect(vm.eval("true.compare(true)"), content="0")
  inspect(vm.eval("Bool::default()"), content="false")
}
```

#### Integer Methods
```moonbit
test "int embedded methods" {
  let vm = MoonBitVM::new()
  // 位运算
  inspect(vm.eval("(5).lnot()"), content="-6")
  inspect(vm.eval("(5).land(3)"), content="1")
  inspect(vm.eval("(5).lor(3)"), content="7")
  inspect(vm.eval("(5).lxor(3)"), content="6")
  inspect(vm.eval("(5).shl(2)"), content="20")
  inspect(vm.eval("(20).shr(2)"), content="5")

  // 比较和状态
  inspect(vm.eval("(5).eq(5)"), content="true")
  inspect(vm.eval("(5).eq(3)"), content="false")
  inspect(vm.eval("(5).compare(3)"), content="1")
  inspect(vm.eval("(3).compare(5)"), content="-1")
  inspect(vm.eval("(5).compare(5)"), content="0")
  inspect(vm.eval("(5).is_pos()"), content="true")
  inspect(vm.eval("(-5).is_neg()"), content="true")
  inspect(vm.eval("(0).is_pos()"), content="false")

  // 位操作
  inspect(vm.eval("(8).ctz()"), content="3")
  inspect(vm.eval("(8).clz()"), content="28")
  inspect(vm.eval("(7).popcnt()"), content="3")
}
```

#### String Methods
```moonbit
test "string embedded methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let s = \"hello\""), content="()")
  inspect(vm.eval("s.length()"), content="5")
  inspect(vm.eval("s.get(0)"), content="104") // 返回字符的 ASCII 码
  inspect(vm.eval("s.unsafe_get(1)"), content="101") // 返回字符的 ASCII 码
  inspect(vm.eval("s.add(\" world\")"), content="hello world")
  inspect(vm.eval("s.eq(\"hello\")"), content="true")
  inspect(vm.eval("s.eq(\"world\")"), content="false")
  inspect(vm.eval("s.to_string()"), content="hello")
}
```

#### Other Type Methods
```moonbit
test "other embedded methods" {
  let vm = MoonBitVM::new()
  // Double methods
  inspect(vm.eval("3.5.add(1.5)"), content="5")
  inspect(vm.eval("5.5.sub(2.5)"), content="3")
  inspect(vm.eval("2.5.mul(4.0)"), content="10")
  inspect(vm.eval("10.0.div(2.0)"), content="5")
  inspect(vm.eval("3.5.eq(3.5)"), content="true")
  inspect(vm.eval("3.5.to_int64()"), content="3")
  
  // Char methods
  inspect(vm.eval("'a'.eq('a')"), content="true")
  inspect(vm.eval("'a'.to_int()"), content="97")
  
  // Other numeric types
  inspect(vm.eval("5U.add(3U)"), content="8")
  inspect(vm.eval("3.5F.add(1.5F)"), content="5")
  inspect(vm.eval("5L.add(3L)"), content="8")
  inspect(vm.eval("5UL.add(3UL)"), content="8")
}
```


## Features

- ✅ **Complete Expression Support**: Arithmetic, logical, and comparison operations
- ✅ **Variable Management**: Immutable and mutable variable declarations
- ✅ **Control Flow**: If-else statements, for loops, while loops
- ✅ **Function Definitions**: Named functions with parameters and return types
- ✅ **Lambda Expressions**: Anonymous functions with closure support
- ✅ **Struct Definitions**: Custom data types with methods and mutable fields
- ✅ **Match Expressions**: Pattern matching with constant, variable, tuple, array, and record patterns
- ✅ **Range Patterns**: Pattern matching with range expressions (e.g., `_..<Zero`, `'a'..='z'`)
- ✅ **Constructor Patterns**: Pattern matching with constant constructors
- ✅ **Array Operations**: Array creation, indexing, and element assignment
- ✅ **Tuple Operations**: Tuple creation, field access, and destructuring
- ✅ **External Functions**: Integration with external function calls
- ✅ **Embedded Functions**: Native function integration with custom implementations
- ✅ **Embedded Methods**: Built-in methods for primitive types (Bool, Int, String, Double, Char, etc.)
- ✅ **Static Method Calls**: Support for static method syntax like `Bool::default()`
- ✅ **Function Aliases**: Support for function aliases like `not` for `%bool_not`
- ✅ **Type System**: Basic type checking and inference

## Contributing

We welcome contributions to the MoonBit Eval project! Whether it's bug fixes, feature additions, or documentation improvements, your contributions are valuable.

## Community

Join our community for discussions and support:
- QQ Group: **949886784**

![QQ群](qrcode.jpg)
