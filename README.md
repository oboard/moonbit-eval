# MoonBit Eval

[![Version](https://img.shields.io/badge/dynamic/json?url=https%3A//mooncakes.io/assets/oboard/eval/resource.json&query=%24.meta_info.version&label=mooncakes&color=yellow)](https://mooncakes.io/docs/oboard/eval)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/oboard/eval/check.yaml)](https://github.com/oboard/eval/actions/workflows/check.yaml)
[![License](https://img.shields.io/github/license/oboard/eval)](https://github.com/oboard/eval/blob/main/LICENSE)

## Demo
🚀 **[REPL Demo](https://github.com/oboard/moonbit-repl/releases/)**

🚀 **[Notebook Demo https://moonbit-notebook.oboard.fun/](https://moonbit-notebook.oboard.fun/)**

## Introduction
MoonBit Eval is an interpreter for the MoonBit language.

Built on top of the [@moonbitlang/parser](https://github.com/moonbitlang/parser) library, it provides comprehensive and accurate MoonBit syntax support, capable of correctly parsing and executing complex MoonBit code structures including functions, structs, lambdas, loops, and more.

## Quick Start

```moonbit
let vm = MoonBitVM()

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

// Using aliases (new parser style)
inspect(vm.eval("using @int {abs}"), content="()")
inspect(vm.eval("abs(-5)"), content="5")
```

## Compile and Run

Use `compile` when the same code needs to run repeatedly. Parsing happens once,
and each `run` executes the compiled code against the VM you pass in.

```moonbit
let vm = MoonBitVM()
let expr = vm.compile("x + y * 2", params=["x", "y"])

inspect(
  expr.run(vm, args=[3, 4]),
  content="11",
)
inspect(
  expr.run(vm, args=[10, 1]),
  content="12",
)
```

Compiled parameters are bound in a temporary scope, so they do not leak into the
VM global environment after execution.

## Imports and Package Loading

`eval` accepts top-level expressions directly, with or without `fn main`.
Import declarations can appear before either form.

```moonbit
let vm = MoonBitVM()

inspect(
  vm.eval(
    (
      #|import {
      #|  "moonbitlang/core/list"
      #|}
      #|@list.from_array([1, 2, 3])
    ),
  ),
  content="More(1, tail=More(2, tail=More(3, tail=Empty)))",
)
```

Core packages are loaded on demand. `moonbitlang/core/builtin` is always
available, but other core packages such as `moonbitlang/core/list` must be
imported explicitly before using their package aliases.

## Runtime Modules

Optional runtime modules can be injected when constructing a VM. They register
packages and embedded runtime functions without loading every package into the
current eval scope.

```moonbit
let vm = MoonBitVM(modules=[@eval/async.module()])
```

The async module makes the root `@async` package available. Subpackages are
lazy-loaded and must be imported explicitly:

```moonbit
inspect(
  vm.test_all(
    (
      #|import { "moonbitlang/async/http" }
      #|async test "https request" {
      #|  let (response, body) = @async.retry(FixedDelay(250), max_retry=3, () => {
      #|    @async.with_timeout(3000, () => @http.get("https://www.moonbitlang.com"))
      #|  })
      #|  assert_true(response.code is (200..<300), msg=response.code.to_string())
      #|  assert_true(body.text().to_lower().has_prefix("<!doctype html>"), msg=body.text())
      #|}
    ),
  ),
  content="TestResult(total=1, passed=1, failed=0)",
)
```

`vm.test_all(code)` runs top-level `test` and `async test` blocks and returns a
`TestResult` summary instead of swallowing assertion failures.

## Parser Notes

- `eval` parses code through a compatibility wrapper around `moonbitlang/parser`.
- Top-level expressions are supported directly, so users do not need to wrap
  snippets in `fn main`.
- Full top-level code with declarations and `fn main` remains supported.
- Diagnostics from parser reports are preserved and returned in `Err(...)` when parse fails.

## ✨ Features

- ✅ **🥮 Mooncakes Loader**: Load Mooncakes packages at runtime
- ✅ **Builtin FileSystem Library**: Provides basic file system operations.
- ✅ **Eval Function**: Allows dynamic evaluation of MoonBit code strings.

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
| Function aliases | ✅ | `using @pkg {name}` alias support |
| Cross-package method calls | ✅ | Method calls across different packages |
| Error handling | ✅ | Result type error handling |
| Group expressions | ✅ | Parenthesized expressions for precedence |
| For-in loops | ✅ | Iterator-based loops |
| Iterator methods | ✅ | iter, map, filter, reduce, for_each |
| Nested iteration | ✅ | Complex nested loop structures |
| Iterator control flow | ✅ | break/continue in iterator contexts |
| **Package System** | | |
| Module imports | ✅ | Explicit `import { "package/path" }` declarations and @package.function syntax |
| Cross-package types | ✅ | Using types from other packages |
| Built-in packages | ✅ | Builtin package is always loaded; other core packages load through explicit imports |
| Package method calling | ✅ | Method calls across package boundaries |
| Runtime modules | ✅ | Optional injected modules such as `@eval/async.module()` |
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
| **Attribute** | | |
| #alias | ✅ | Function alias |
| #external | ❌ | External function binding |
| #callsite | ❌ | Call site information |
| #skip | ❌ | Skipping compilation of a function |
| #cfg | ❌ | Conditional compilation based on configuration |
| **Not Yet Supported** | | |
| Async/await | 🟡 | Async tests and selected `moonbitlang/async` APIs through explicit runtime module injection |

## Contributing

We welcome contributions to the MoonBit Eval project! Whether it's bug fixes, feature additions, or documentation improvements, your contributions are valuable.

## Community

Join our community for discussions and support:
- QQ Group: **949886784**

![QQ 群](qrcode.jpg)
