# MoonBit Eval

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
- [X] Struct
- [ ] Match
- [ ] Trait


## Examples

### Basic Operations
```moonbit
test "basic" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("1 + 1"), content="2")
  inspect(vm.eval("5 * 3"), content="15")
  inspect(vm.eval("10 / 2"), content="5")
  inspect(vm.eval("5 == 5"), content="true")
  inspect(vm.eval("\"hello\" + \"world\""), content="helloworld")
}
```

### Variables and Functions
```moonbit
test "variables and functions" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 1"), content="()")
  inspect(vm.eval("a"), content="1")
  
  inspect(vm.eval("fn add(a: Int, b: Int) -> Int { a + b }"), content="(a: Int, b: Int) -> Int")
  inspect(vm.eval("add(1, 2)"), content="3")
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
test "control flow" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("if 1 > 0 { 3 } else { 4 }"), content="3")
  
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("for i = 0; i < 5; i = i + 1 { sum += i }"), content="()")
  inspect(vm.eval("sum"), content="10")
}
```

### Lambda Functions
```moonbit
test "lambda" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let f = x => x * 2"), content="()")
  inspect(vm.eval("f(3)"), content="6")
  
  inspect(vm.eval("let h = z => z * z"), content="()")
  inspect(vm.eval("h(4)"), content="16")
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

### Fibonacci Recursion
```moonbit
test "fibonacci" {
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
    if params is More(Constant(c=String(s), ..), ..) {
      println(s)
    }
    unit()
  })
  inspect(vm.eval("println(\"Hello from external function\")"), content="()")
}
```


## Features

- ✅ **Complete Expression Support**: Arithmetic, logical, and comparison operations
- ✅ **Variable Management**: Immutable and mutable variable declarations
- ✅ **Control Flow**: If-else statements, for loops, while loops
- ✅ **Function Definitions**: Named functions with parameters and return types
- ✅ **Lambda Expressions**: Anonymous functions with closure support
- ✅ **Struct Definitions**: Custom data types with methods
- ✅ **External Functions**: Integration with external function calls
- ✅ **Type System**: Basic type checking and inference

## Contributing

We welcome contributions to the MoonBit Eval project! Whether it's bug fixes, feature additions, or documentation improvements, your contributions are valuable.

## Community

Join our community for discussions and support:
- QQ Group: **949886784**

![QQ群](qrcode.jpg)
