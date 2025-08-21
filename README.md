# MoonBit Eval

🚀 **[REPL Demo https://moonrepl.oboard.eu.org/](https://moonrepl.oboard.eu.org/)**
🚀 **[Notebook Demo https://moonbit-notebook.oboard.fun/](https://moonbit-notebook.oboard.fun/)**

## Introduction
MoonBit Eval is an interpreter for the MoonBit language.

Built on top of the [@moonbitlang/parser](https://github.com/moonbitlang/parser) library, it provides comprehensive and accurate MoonBit syntax support, capable of correctly parsing and executing complex MoonBit code structures including functions, structs, lambdas, loops, and more.

## Quick Start

```moonbit
let vm = MoonBitVM::new()

// Basic expressions
inspect(vm.eval("1 + 2 * 3"), content="7")
inspect(vm.eval("\"hello\" + \" world\""), content="hello world")

// Variables and functions
inspect(vm.eval("let x = 42"), content="()")
inspect(vm.eval("fn double(n: Int) -> Int { n * 2 }"), content="(n: Int) -> Int")
inspect(vm.eval("double(x)"), content="84")

// Control flow
inspect(vm.eval("if x > 40 { \"big\" } else { \"small\" }"), content="big")

// Pattern matching
inspect(vm.eval("match (1, 2) { (a, b) => a + b }"), content="3")
```

## MoonBit Language Support

| Feature | Status | Description |
|---------|--------|-------------|
| **Core Language** | | |
| Basic Types (Int, Bool, String, Double, Char) | ✅ | Full support for primitive types |
| Expressions (arithmetic, logical, comparison) | ✅ | Complete expression evaluation |
| Variables (let, let mut) | ✅ | Immutable and mutable variables |
| Assignment | ✅ | Variable reassignment and shadowing |
| **Control Flow** | | |
| If-else | ✅ | Conditional expressions |
| For loops | ✅ | C-style for loops with continue/break |
| While loops | ✅ | While loop constructs with else clause |
| Loop control | ✅ | Continue and break statements |
| **Functions** | | |
| Function definitions | ✅ | Named functions with parameters |
| Named parameters | ✅ | Named and optional parameters |
| Lambda expressions | ✅ | Anonymous functions (x => x * 2) |
| Closures | ✅ | Proper closure environment capture |
| Recursive functions | ✅ | Self-referencing function calls |
| Currying | ✅ | Higher-order function composition |
| External functions | ✅ | Integration with external calls |
| Embedded functions | ✅ | Native function integration |
| **Data Structures** | | |
| Arrays | ✅ | Array creation, indexing, assignment |
| Array methods | ✅ | length, get, push, pop, contains, slice, concat, join |
| Array boolean methods | ✅ | any, all operations |
| Tuples | ✅ | Tuple creation, access, destructuring |
| Structs | ✅ | Custom data types with methods |
| Mutable struct fields | ✅ | Field mutation support |
| Nested struct references | ✅ | Reference semantics for nested structures |
| **Pattern Matching** | | |
| Basic patterns | ✅ | Constants, variables, wildcards |
| Tuple patterns | ✅ | Destructuring tuples |
| Array patterns | ✅ | Array destructuring |
| Record patterns | ✅ | Struct field matching |
| Range patterns | ✅ | Range expressions (_..<x, 'a'..='z') |
| Constructor patterns | ✅ | Constant constructor matching |
| Or patterns | ✅ | Multiple pattern alternatives |
| Nested patterns | ✅ | Complex nested pattern matching |
| **Enums and Generics** | | |
| Basic enums | ✅ | Simple enumeration types |
| Enums with data | ✅ | Algebraic data types |
| Enum pattern matching | ✅ | Pattern matching on enum variants |
| Generic types | ✅ | Generic enums and functions |
| Generic functions | ✅ | Polymorphic function definitions |
| **Option Type** | | |
| Option basics | ✅ | Some/None construction |
| Option pattern matching | ✅ | Pattern matching on Option |
| Option methods | ✅ | unwrap, unwrap_or, is_empty, map, filter |
| **Built-in Methods** | | |
| Bool methods | ✅ | compare, default |
| Int methods | ✅ | Bitwise ops, comparisons, bit manipulation |
| String methods | ✅ | length, get, unsafe_get, to_string |
| Double methods | ✅ | compare, to_int64 |
| Char methods | ✅ | compare, to_int |
| **Advanced Features** | | |
| Type system | ✅ | Basic type checking and inference |
| Static method calls | ✅ | Class::method() syntax |
| Pipe operator | ✅ | |> operator for function chaining |
| Function aliases | ✅ | Alias support (e.g., not for %bool_not) |
| Traits | ✅ | Interface definitions |
| Packages | ✅ | Module system |
| Error handling | ✅ | Result type error handling |
| **Not Yet Supported** | | |
| For-in loops | ❌ | Iterator-based loops (commented out in tests) |
| Async/await | ❌ | Asynchronous programming |

## Features

- ✅ **Complete Expression Support**: Arithmetic, logical, and comparison operations
- ✅ **Variable Management**: Immutable and mutable variable declarations
- ✅ **Control Flow**: If-else statements, for loops, while loops
- ✅ **Function Definitions**: Named functions with parameters and return types
- ✅ **Lambda Expressions**: Anonymous functions with closure support
- ✅ **Struct Definitions**: Custom data types with methods and mutable fields
- ✅ **Pattern Matching**: Comprehensive pattern matching with multiple pattern types
- ✅ **Array & Tuple Operations**: Creation, indexing, and destructuring
- ✅ **External Integration**: External and embedded function support
- ✅ **Built-in Methods**: Native methods for all primitive types
- ✅ **Type System**: Basic type checking and inference

## Contributing

We welcome contributions to the MoonBit Eval project! Whether it's bug fixes, feature additions, or documentation improvements, your contributions are valuable.

## Community

Join our community for discussions and support:
- QQ Group: **949886784**

![QQ群](qrcode.jpg)
