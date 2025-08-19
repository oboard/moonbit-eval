// =============================================================================
// MoonBit Eval Test Suite
// =============================================================================
// Organized by feature categories for better maintainability

// =============================================================================
// 1. BASIC TYPES AND LITERALS
// =============================================================================

///|
test "basic_integers" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("1"), content="1")
  inspect(vm.eval("42"), content="42")
  inspect(vm.eval("-5"), content="-5")
}

///|
test "basic_booleans" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true"), content="true")
  inspect(vm.eval("false"), content="false")
  inspect(vm.eval("!false"), content="true")
  inspect(vm.eval("!true"), content="false")
  inspect(vm.eval("not(false)"), content="true")
  inspect(vm.eval("not(true)"), content="false")
}

///|
test "basic_strings" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("\"hello\""), content="hello")
  inspect(vm.eval("\"hello\"+\"world\""), content="helloworld")
}

// =============================================================================
// 2. ARITHMETIC AND COMPARISON OPERATORS
// =============================================================================

///|
test "arithmetic_operators" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("1+1"), content="2")
  inspect(vm.eval("2-1"), content="1")
  inspect(vm.eval("5 * 3"), content="15")
  inspect(vm.eval("10 / 2"), content="5")
  inspect(vm.eval("7 % 3"), content="1")
}

// =============================================================================
// ARRAY METHODS TESTS
// =============================================================================

///|
test "array_basic_methods" {
  let vm = MoonBitVM::new()
  // Test array creation and basic methods
  inspect(vm.eval("let arr = [1, 2, 3]; arr.length()"), content="3")
  inspect(vm.eval("let arr = []; arr.is_empty()"), content="true")
  inspect(vm.eval("let arr = [1]; arr.is_empty()"), content="false")
}

///|
test "array_get_set_methods" {
  let vm = MoonBitVM::new()
  // Test get method
  inspect(vm.eval("let arr = [1, 2, 3]; arr.get(1)"), content="Some(2)")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.get(5)"), content="None")
}

///|
test "array_push_pop_methods" {
  let vm = MoonBitVM::new()
  // Test push and pop
  inspect(vm.eval("let arr = [1, 2]; arr.push(3); arr.length()"), content="3")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.pop()"), content="Some(3)")
  inspect(vm.eval("let arr = []; arr.pop()"), content="None")
}

///|
test "array_contains_methods" {
  let vm = MoonBitVM::new()
  // Test contains method
  inspect(vm.eval("let arr = [1, 2, 3]; arr.contains(2)"), content="true")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.contains(5)"), content="false")
}

///|
test "array_index_methods" {
  let vm = MoonBitVM::new()
  // Test index_of and last_index_of
  inspect(vm.eval("let arr = [1, 2, 3, 2]; arr.index_of(2)"), content="Some(1)")
  inspect(
    vm.eval("let arr = [1, 2, 3, 2]; arr.last_index_of(2)"),
    content="Some(3)",
  )
  inspect(vm.eval("let arr = [1, 2, 3]; arr.index_of(5)"), content="None")
}

///|
test "array_slice_methods" {
  let vm = MoonBitVM::new()
  // Test slice method
  inspect(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr.slice(1, 3).length()"),
    content="2",
  )
  inspect(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr.slice(2).length()"),
    content="3",
  )
}

///|
test "array_concat_methods" {
  let vm = MoonBitVM::new()
  // Test concat method
  inspect(
    vm.eval("let arr1 = [1, 2]; let arr2 = [3, 4]; arr1.concat(arr2).length()"),
    content="4",
  )
}

///|
test "array_boolean_methods" {
  let vm = MoonBitVM::new()
  // Test any and all methods
  inspect(vm.eval("let arr = [true, false, true]; arr.any()"), content="true")
  inspect(vm.eval("let arr = [false, false]; arr.any()"), content="false")
  inspect(vm.eval("let arr = [true, true]; arr.all()"), content="true")
  inspect(vm.eval("let arr = [true, false]; arr.all()"), content="false")
}

///|
test "comparison_operators" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5 == 5"), content="true")
  inspect(vm.eval("5 != 3"), content="true")
  inspect(vm.eval("3 < 5"), content="true")
  inspect(vm.eval("5 > 3"), content="true")
  inspect(vm.eval("3 <= 5"), content="true")
  inspect(vm.eval("5 >= 3"), content="true")
}

// =============================================================================
// 3. VARIABLES AND MUTABILITY
// =============================================================================

///|
test "immutable_variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 1"), content="()")
  inspect(vm.eval("a"), content="1")
}

///|
test "shadowing" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = 0; let a = 1; a"), content="1")
  inspect(vm.eval("let mut a = 0; let a = 1; a"), content="1")
}

///|
test "mutable_variables" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut a = 1"), content="()")
  inspect(vm.eval("a = 12"), content="()")
  inspect(vm.eval("a"), content="12")
}

// =============================================================================
// 4. CONTROL FLOW
// =============================================================================

///|
test "if_expressions" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("if 1 > 0 { if 2 > 1 { 3 } else { 4 } } else { 5 }"),
    content="3",
  )
  inspect(vm.eval("if (5 + 3) * 2 > 15 { 1 } else { 2 }"), content="1")
  inspect(vm.eval("if true && false || true { 1 } else { 2 }"), content="1")
  inspect(vm.eval("if 3 < 2 { 1 }"), content="()")
}

///|
test "for_loops" {
  let vm = MoonBitVM::new()
  // 简化测试：只测试最基本的for循环
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("sum"), content="0")
  inspect(vm.eval("sum += 1"), content="()")
  inspect(vm.eval("sum"), content="1")
  inspect(vm.eval("sum += 2"), content="()")
  inspect(vm.eval("sum"), content="3")

  // 测试for循环
  inspect(vm.eval("let mut result = 0"), content="()")
  inspect(vm.eval("for i = 0; i < 3; i = i + 1 { result += i }"), content="()")
  inspect(vm.eval("result"), content="3")
}

// ///|
// test "for_in" {
//   let vm = MoonBitVM::new(log=true)
//   // Test array iteration
//   inspect(vm.eval("let mut sum = 0"), content="()")
//   inspect(vm.eval("for x in [1, 2, 3, 4, 5] { sum += x }"), content="()")
//   inspect(vm.eval("sum"), content="15")

//   // Test range iteration with exclusive upper bound
//   inspect(vm.eval("let mut range_sum = 0"), content="()")
//   inspect(vm.eval("for i in 0..<5 { range_sum += i }"), content="()")
//   inspect(vm.eval("range_sum"), content="10")

//   // Test range iteration with inclusive upper bound
//   inspect(vm.eval("let mut inclusive_sum = 0"), content="()")
//   inspect(vm.eval("for i in 0..=5 { inclusive_sum += i }"), content="()")
//   inspect(vm.eval("inclusive_sum"), content="15")

//   // Test iteration with index
//   inspect(vm.eval("let mut indexed_sum = 0"), content="()")
//   inspect(
//     vm.eval("for idx, val in [10, 20, 30] { indexed_sum += idx + val }"),
//     content="()",
//   )
//   inspect(vm.eval("indexed_sum"), content="63")
// }

///|
test "while_loops" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let mut i = 0"), content="()")
  inspect(vm.eval("let mut sum = 0"), content="()")
  inspect(vm.eval("while i < 5 { sum += i; i += 1 }"), content="()")
  inspect(vm.eval("sum"), content="10")
  inspect(vm.eval("i"), content="5")
}

///|
test "loop_control" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|fn sum_with_continue(n : Int, acc : Int) -> Int {
        #|  let mut acc = acc
        #|  for i = 0; i < n; i = i + 1 {
        #|    if i == 2 {
        #|      continue
        #|    }
        #|    acc = acc + i
        #|  }
        #|  acc
        #|}
      ),
    ),
    content="(n: Int, acc: Int) -> Int",
  )
  inspect(vm.eval("sum_with_continue(5, 1)"), content="9")
  inspect(
    vm.eval(
      (
        #|let mut i = 10
        #|while i > 0 {
        #|  i = i - 1
        #|  if i % 2 == 0 {
        #|    break 5
        #|  }
        #|} else {
        #|  7
        #|}
      ),
    ),
    content="5",
  )
}

// =============================================================================
// 5. FUNCTIONS
// =============================================================================

///|
test "basic_functions" {
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
}

///|
test "named_parameters" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("fn add_named(a~: Int, b~: Int) -> Int { a + b }"),
    content="(a~: Int, b~: Int) -> Int",
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

// =============================================================================
// 6. DATA STRUCTURES
// =============================================================================

///|
test "tuples" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let t = (1, 2)"), content="()")
  inspect(vm.eval("t.0"), content="1")
  inspect(vm.eval("t.1"), content="2")
  inspect(vm.eval("t"), content="(1, 2)")
  inspect(vm.eval("let (a, b) = t"), content="()")
  inspect(vm.eval("a"), content="1")
  inspect(vm.eval("b"), content="2")
}

///|
test "arrays" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let arr = [1, 2, 3]; arr.length()"), content="3")
  inspect(vm.eval("let arr = []; arr.is_empty()"), content="true")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.is_empty()"), content="false")
  inspect(
    vm.eval("let arr = [\"1\", \"2\", \"3\"]; arr.join(\"-\")"),
    content="1-2-3",
  )
}

///|
test "structs" {
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
test "mutable_structs" {
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
  inspect(vm.eval("p"), content="{ x: 3, y: 4 }")
}

///|
test "references" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct RefInt {
        #|  mut value: Int
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|let a = { value: 1 }
        #|let b = a
        #|b.value = 2
      ),
    ),
    content="()",
  )
  inspect(vm.eval("a"), content="{ value: 2 }")
  inspect(vm.eval("a.value"), content="2")
}

// =============================================================================
// 7. PATTERN MATCHING
// =============================================================================

///|
test "basic_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let s = 10"), content="()")
  inspect(vm.eval("match s { 10 => 100 }"), content="100")
  inspect(vm.eval("match 42 { x => x * 2 }"), content="84")
  inspect(vm.eval("match 123 { _ => 999 }"), content="999")
}

///|
test "or_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match 5 { 1 | 5 | 10 => 100 }"), content="100")
  inspect(vm.eval("match 3 { 1 | 5 | 10 => 100; _ => 200 }"), content="200")
}

///|
test "tuple_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match (1, 2) { (a, b) => a }"), content="1")
  inspect(vm.eval("match (1, 2) { (a, b) => b }"), content="2")
  inspect(vm.eval("match (1, 2) { (a, b) => a + b }"), content="3")
}

///|
test "array_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match [1, 2, 3] { [a, b, c] => a }"), content="1")
  inspect(vm.eval("match [1, 2, 3] { [a, b, c] => a + b + c }"), content="6")
  inspect(vm.eval("match [5, 10] { [x, y] => x * y }"), content="50")
}

///|
test "record_patterns" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("match { x: 10, y: 20 } { { x, y } => x + y }"), content="30")
  inspect(
    vm.eval("match { name: \"Alice\", age: 25 } { { name, .. } => name }"),
    content="Alice",
  )
  inspect(
    vm.eval("match { name: \"Alice\", age: 25 } { { age, .. } => age }"),
    content="25",
  )
}

///|
test "nested_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("match (1, [2, 3]) { (a, [b, c]) => a + b + c }"),
    content="6",
  )
  inspect(vm.eval("match 2 { 1 => 10; 2 => 20; _ => 30 }"), content="20")
  inspect(vm.eval("match 5 { 1 => 10; 2 => 20; _ => 30 }"), content="30")
}

///|
test "range_patterns" {
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
test "constructor_patterns" {
  let vm = MoonBitVM::new()
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

// =============================================================================
// 8. OPTION TYPE
// =============================================================================

///|
test "option_basics" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("Some(5)"), content="Some(5)")
  inspect(vm.eval("Option::Some(5)"), content="Some(5)")
  inspect(vm.eval("None"), content="None")
  inspect(vm.eval("Some(5).unwrap()"), content="5")
}

///|
test "option_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("match Option::Some(5) { Some(x) => x, Option::None => 0 }"),
    content="5",
  )
  inspect(
    vm.eval("match Some(5) { Option::Some(x) => x, None => 0 }"),
    content="5",
  )
  inspect(vm.eval("match None { Some(x) => x, None => 0 }"), content="0")
}

///|
test {
  inspect(
    {
      let opt = Some(5)
      opt.map(fn(x) { x * 2 })
    },
    content="Some(10)",
  )
}

///|
test "option_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let opt = Some(42); opt.unwrap()"), content="42")
  inspect(vm.eval("let opt = Some(42); opt.unwrap_or(0)"), content="42")
  inspect(vm.eval("let opt = None; opt.unwrap_or(0)"), content="0")
  inspect(vm.eval("let opt = Some(42); opt.is_empty()"), content="false")
  inspect(vm.eval("let opt = None; opt.is_empty()"), content="true")
  assert_eq(
    vm.eval("let opt = Some(5); opt.map(fn(x) { x * 2 })").to_string(),
    "Some(10)",
  )
  inspect(vm.eval("let opt = None; opt.map(fn(x) { x * 2 })"), content="None")
  inspect(
    vm.eval("let opt = Some(5); opt.filter(fn(x) { x > 3 })"),
    content="Some(5)",
  )
  inspect(
    vm.eval("let opt = Some(2); opt.filter(fn(x) { x > 3 })"),
    content="None",
  )
}

// =============================================================================
// 9. BUILT-IN METHODS
// =============================================================================

///|
test "string_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let s = \"hello\""), content="()")
  inspect(vm.eval("s.length()"), content="5")
  inspect(vm.eval("s.get(0)"), content="104")
  inspect(vm.eval("s.unsafe_get(1)"), content="101")
  inspect(vm.eval("s.to_string()"), content="hello")
}

///|
test "bool_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true.compare(false)"), content="1")
  inspect(vm.eval("false.compare(true)"), content="-1")
  inspect(vm.eval("true.compare(true)"), content="0")
  inspect(vm.eval("Bool::default()"), content="false")
}

///|
test "int_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("(5).lnot()"), content="-6")
  inspect(vm.eval("(5).land(3)"), content="1")
  inspect(vm.eval("(5).lor(3)"), content="7")
  inspect(vm.eval("(5).lxor(3)"), content="6")
  inspect(vm.eval("(5).shl(2)"), content="20")
  inspect(vm.eval("(20).shr(2)"), content="5")
  inspect(vm.eval("(5).compare(3)"), content="1")
  inspect(vm.eval("(3).compare(5)"), content="-1")
  inspect(vm.eval("(5).compare(5)"), content="0")
  inspect(vm.eval("(5).is_pos()"), content="true")
  inspect(vm.eval("(-5).is_neg()"), content="true")
  inspect(vm.eval("(0).is_pos()"), content="false")
  inspect(vm.eval("(8).ctz()"), content="3")
  inspect(vm.eval("(8).clz()"), content="28")
  inspect(vm.eval("(7).popcnt()"), content="3")
}

///|
test "double_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5.5.compare(3.5)"), content="1")
  inspect(vm.eval("3.5.compare(5.5)"), content="-1")
  inspect(vm.eval("3.5.compare(3.5)"), content="0")
  inspect(vm.eval("3.5.to_int64()"), content="3")
}

///|
test "char_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("'b'.compare('a')"), content="1")
  inspect(vm.eval("'a'.compare('b')"), content="-1")
  inspect(vm.eval("'a'.compare('a')"), content="0")
  inspect(vm.eval("'a'.to_int()"), content="97")
}

// =============================================================================
// 10. ADVANCED FEATURES
// =============================================================================

///|
test "pipe_operator" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5 |> ignore"), content="()")
  inspect(vm.eval("[] |> Array::push(5)"), content="[5]")
  inspect(
    vm.eval("fn add(x: Int, y: Int) -> Int { x + y }\n1 |> add(5)"),
    content="6",
  )
}

///|
test "external_functions" {
  let vm = MoonBitVM::new()
  vm.interpreter.add_extern_fn("println", ctx => {
    if ctx.arguments is [{ value: String(s), .. }, ..] {
      println(s)
    }
    Unit
  })
  inspect(vm.eval("println(\"println from external function\")"), content="()")
}

///|
test "embedded_code" {
  let vm = MoonBitVM::new()
  vm.interpreter.add_embedded_fn("%string_length2", ctx => if ctx.arguments
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

// =============================================================================
// 11. ENUM
// =============================================================================

///|
test "basic_enum" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum Relation {
        #|  Smaller
        #|  Greater
        #|  Equal
        #|}
        #|fn compare_int(x: Int, y: Int) -> Relation {
        #|  if x < y {
        #|    Smaller
        #|  } else if x > y {
        #|    Relation::Greater
        #|  } else {
        #|    Equal
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("compare_int(0, 1)"), content="Smaller")
  inspect(vm.eval("compare_int(1, 1)"), content="Equal")
  inspect(vm.eval("compare_int(2, 1)"), content="Greater")
}

///|
test "enum_with_data" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum List {
        #|  Nil
        #|  Cons(Int, List)
        #|}
        #|fn is_singleton(l: List) -> Bool {
        #|  match l {
        #|    Cons(_, Nil) => true
        #|    _ => false
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let l = Cons(1, Cons(2, Nil))"), content="()")
  inspect(vm.eval("is_singleton(l)"), content="false")
  inspect(vm.eval("is_singleton(Cons(1, Nil))"), content="true")
  inspect(vm.eval("is_singleton(Nil)"), content="false")
}

///|
test "enum_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum Maybe {
        #|  Just(Int)
        #|  Nothing
        #|}
        #|fn get_or_default(m: Maybe, default: Int) -> Int {
        #|  match m {
        #|    Just(x) => x
        #|    Nothing => default
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("get_or_default(Just(5), 0)"), content="5")
  inspect(vm.eval("get_or_default(Nothing, 0)"), content="0")
}

// =============================================================================
// 12. GENERIC
// =============================================================================

///|
test "generic_list" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum List[T] {
        #|  Nil
        #|  Cons(T, List[T])
        #|}
        #|
        #|fn[T] List::new() -> List[T] {
        #|  Nil
        #|}
        #|
        #|fn[T] List::cons(x: T, xs: List[T]) -> List[T] {
        #|  Cons(x, xs)
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  // 先测试单独的Nil
  inspect(vm.eval("Nil"), content="Nil")
  // 再测试List::new()
  inspect(vm.eval("List::new()"), content="Nil")
  // 测试简单的Cons调用
  inspect(vm.eval("List::cons(1, Nil)"), content="Cons(1, Nil)")
  // 测试嵌套的Cons调用
  inspect(vm.eval("List::cons(2, List::new())"), content="Cons(2, Nil)")
  // 测试中间步骤
  inspect(
    vm.eval("let inner = List::cons(2, List::new()); inner"),
    content="Cons(2, Nil)",
  )
  // 测试分步构建
  inspect(
    vm.eval("let step1 = List::new(); let step2 = List::cons(2, step1); step2"),
    content="Cons(2, Nil)",
  )
  // 测试直接嵌套调用
  inspect(vm.eval("List::cons(2, List::new())"), content="Cons(2, Nil)")
  // 测试更深层嵌套
  let result = vm.eval("List::cons(1, List::cons(2, List::new()))")
  inspect(result, content="Cons(1, Cons(2, Nil))")
  inspect(
    vm.eval("let list = List::cons(1, List::cons(2, List::new()))"),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|fn[S, T] map(list: List[S], f: (S) -> T) -> List[T] {
        #|  match list {
        #|    Nil => Nil
        #|    Cons(x, xs) => Cons(f(x), map(xs, f))
        #|  }
        #|}
        #|
        #|fn[T] sum(list: List[T]) -> T {
        #|  match list {
        #|    Nil => 0
        #|    Cons(x, xs) => x + sum(xs)
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(
    vm.eval("let list = List::cons(1, List::cons(2, List::new()))"),
    content="()",
  )
  assert_eq(
    vm.eval("map(list, x => x * 2)").to_string(),
    "Cons(2, Cons(4, Nil))",
  )
  assert_eq(vm.eval("sum(list)").to_string(), "3")
}

///|
test {
  let a = [x => x + 1, x => x - 1]
  inspect(a[1](10), content="9")
}

///|
test {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = [x => x + 1, x => x - 1]; a[1](10)"), content="9")
}

///|
test "nested_struct_reference" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct S {
        #|  mut a: Int
        #|}
        #|
        #|struct T {
        #|  a: S
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let a = { a: 1 }"), content="()")
  inspect(vm.eval("let b = { a: a }"), content="()")
  inspect(vm.eval("b.a.a = 2"), content="()")
  inspect(vm.eval("a"), content="{ a: 2 }")
}

///|
test "currying" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let add = x => y => x + y").to_string(), "()")
  assert_eq(vm.eval("let f = add(10)").to_string(), "()")
  assert_eq(vm.eval("f").to_string(), "(y) -> Any")
  assert_eq(vm.eval("f(1)").to_string(), "11")
  assert_eq(vm.eval("add(5)(3)").to_string(), "8")
}
