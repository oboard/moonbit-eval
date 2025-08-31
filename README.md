# MoonBit Eval

[![Version](https://img.shields.io/badge/dynamic/json?url=https%3A//mooncakes.io/assets/oboard/moonbit-eval/resource.json&query=%24.meta_info.version&label=mooncakes&color=yellow)](https://mooncakes.io/docs/oboard/moonbit-eval)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/oboard/moonbit-eval/check.yaml)](https://github.com/oboard/moonbit-eval/actions/workflows/check.yaml)
[![License](https://img.shields.io/github/license/oboard/moonbit-eval)](https://github.com/oboard/moonbit-eval/blob/main/LICENSE)

## Demo
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
| Multiline strings | ✅ | #\|syntax for multiline string literals |
| String interpolation | ✅ | \{variable} syntax in string literals |
| Type constraints | ✅ | (value : Type) syntax for explicit typing |
| **Control Flow** | | |
| If-else | ✅ | Conditional expressions |
| For loops | ✅ | C-style for loops with continue/break |
| While loops | ✅ | While loop constructs with else clause |
| Loop control | ✅ | Continue and break statements |
| Guard expressions | ✅ | guard condition else { action } syntax |
| Is expressions | ✅ | Pattern matching with 'is' operator |
| Defer expressions | ✅ | defer statement for cleanup code |
| Return expressions | ✅ | Early return from functions |
| Raise expressions | ✅ | Exception throwing with raise |
| Try-catch expressions | ✅ | Exception handling with try-catch |
| Loop expressions | ✅ | loop pattern matching with break/continue |
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
| Array spread syntax | ✅ | [..array1, ..array2] syntax |
| Array slice operations | ✅ | arr[start:end], arr[start:], arr[:end] syntax |
| Array augmented assignment | ✅ | arr[i] += value, arr[i] *= value syntax |
| Tuples | ✅ | Tuple creation, access, destructuring |
| Structs | ✅ | Custom data types with methods |
| Mutable struct fields | ✅ | Field mutation support |
| Nested struct references | ✅ | Reference semantics for nested structures |
| Record update syntax | ✅ | { ..record, field: new_value } syntax |
| Map literals | ✅ | { "key": value } syntax for map creation |
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
| Pipe operator | ✅ | \|> operator for function chaining |
| Function aliases | ✅ | Alias support (e.g., not for %bool_not) |
| Cross-package method calls | ✅ | Method calls across different packages |
| Error handling | ✅ | Result type error handling |
| Group expressions | ✅ | Parenthesized expressions for precedence |
| For-in loops | ✅ | Iterator-based loops |
| Iterator methods | ✅ | iter, map, filter, reduce, for_each |
| Nested iteration | ✅ | Complex nested loop structures |
| Iterator control flow | ✅ | break/continue in iterator contexts |
| **Package System** | | |
| Module imports | ✅ | @package.function syntax |
| Cross-package types | ✅ | Using types from other packages |
| Built-in packages | ✅ | @int, @math, @bigint, @cmp, @list support |
| Package method calling | ✅ | Method calls across package boundaries |
| **IO and FFI** | | |
| Print functions | ✅ | println and print support |
| Embedded functions | ✅ | Native function integration via FFI |
| External function binding | ✅ | Custom function registration |
| **Sorting and Collections** | | |
| List sorting | ✅ | Built-in sort methods for collections |
| Array sorting | ✅ | Sorting operations on arrays |
| Collection methods | ✅ | Comprehensive collection manipulation |
| **Comparison Operations** | | |
| Equality operators | ✅ | == and != operators |
| Relational operators | ✅ | <, >, <=, >= operators |
| Type-aware comparison | ✅ | Proper type checking in comparisons |
| **Constructor Patterns** | | |
| Single argument matching | ✅ | Constructor pattern with single args |
| Named field matching | ✅ | Constructor patterns with named fields |
| Wildcard patterns | ✅ | _ patterns in constructor matching |
| **Functional Programming** | | |
| Higher-order functions | ✅ | Functions as first-class values |
| Function composition | ✅ | Combining functions effectively |
| Closure environments | ✅ | Proper variable capture in closures |
| **Literal Overloading** | | |
| Numeric literal overloading | ✅ | Automatic conversion between numeric types |
| Character literal overloading | ✅ | Char to Int conversion in pattern matching |
| String literal overloading | ✅ | String to Bytes conversion |
| Array literal overloading | ✅ | Array to various types (Bytes, String) conversion |
| Double literal overloading | ✅ | Double to Float precision conversion |
| Map literal overloading | ✅ | Map to Json object conversion |
| Complex overloading scenarios | ✅ | Multi-step type conversions |
| Traits | 🟡 | Interface definitions |
| Trait as expressions | 🟡 | (value as Trait) syntax for trait casting |
| Packages | 🟡 | Module system with @package.function syntax (no trait, trait derive, operator overloading) |
| **Not Yet Supported** | | |
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
