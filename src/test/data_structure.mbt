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
test "array_spread" {
  let vm = MoonBitVM::new()
  // Test array spread syntax
  assert_eq(
    vm
    .eval("let arr1 = [1, 2]; let arr2 = [3, 4]; [..arr1, ..arr2]")
    .to_string(),
    "[1, 2, 3, 4]",
  )
  assert_eq(
    vm.eval("let arr = [2, 3]; [1, ..arr, 4]").to_string(),
    "[1, 2, 3, 4]",
  )
  assert_eq(vm.eval("let arr = [1, 2, 3]; [..arr]").to_string(), "[1, 2, 3]")
}

///|
test "array_slice_operations" {
  let vm = MoonBitVM::new()
  // Test array slice get operations
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[1:3]").to_string(),
    "[2, 3]",
  )
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[2:]").to_string(),
    "[3, 4, 5]",
  )
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[:3]").to_string(),
    "[1, 2, 3]",
  )
  assert_eq(
    vm.eval("let arr = [1, 2, 3, 4, 5]; arr[:]").to_string(),
    "[1, 2, 3, 4, 5]",
  )
}

///|
test "array_set_operations" {
  let vm = MoonBitVM::new()
  // Test array set operations
  assert_eq(
    vm.eval("let mut arr = [1, 2, 3]; arr[1] = 5; arr").to_string(),
    "[1, 5, 3]",
  )
  assert_eq(
    vm.eval("let mut arr = [1, 2, 3]; arr[0] = 10; arr[0]").to_string(),
    "10",
  )
}

///|
test "array_augmented_set" {
  let vm = MoonBitVM::new()
  // Test array augmented assignment operations
  assert_eq(
    vm.eval("let mut arr = [1, 2, 3]; arr[1] += 5; arr").to_string(),
    "[1, 7, 3]",
  )
  assert_eq(
    vm.eval("let mut arr = [10, 20, 30]; arr[0] -= 5; arr[0]").to_string(),
    "5",
  )
  assert_eq(
    vm.eval("let mut arr = [2, 4, 6]; arr[1] *= 3; arr[1]").to_string(),
    "12",
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
  inspect(vm.eval("p"), content="Point::{x: 3, y: 4}")
}

///|
test "record_update" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Person {
        #|  name : String
        #|  age : Int
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let p1 = { name: \"Alice\", age: 25 }").to_string(), "()")
  assert_eq(vm.eval("let p2 = { ..p1, age: 26 }").to_string(), "()")
  assert_eq(vm.eval("p2.name").to_string(), "Alice")
  assert_eq(vm.eval("p2.age").to_string(), "26")
  assert_eq(vm.eval("p1.age").to_string(), "25")
}

///|
test "method_calls" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Calculator {
        #|  value : Int
        #|}
        #|fn Calculator::add(self : Calculator, x : Int) -> Int {
        #|  self.value + x
        #|}
        #|fn Calculator::multiply(self : Calculator, x : Int) -> Int {
        #|  self.value * x
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let calc = { value: 10 }").to_string(), "()")
  assert_eq(vm.eval("calc.add(5)").to_string(), "15")
  assert_eq(vm.eval("calc.multiply(3)").to_string(), "30")
  assert_eq(
    vm.eval("Calculator::add").to_string(),
    "(self: Calculator, x: Int) -> Int",
  )
}

///|
test "trait_as_expressions" {
  let vm = MoonBitVM::new()
  // Test basic string operations first
  assert_eq(vm.eval("1.to_string()").to_string(), "1")
  assert_eq(vm.eval("\"hello\" + \" world\"").to_string(), "hello world")

  // Test 'as' expressions for trait casting
  assert_eq(
    vm
    .eval(
      (
        #|trait Show {
        #|  show(Self) -> String
        #|}
        #|struct Point {
        #|  x : Int
        #|  y : Int
        #|}
        #|fn Point::show(self : Point) -> String {
        #|  "(" + self.x.to_string() + ", " + self.y.to_string() + ")"
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let p = { x: 1, y: 2 }").to_string(), "()")
  assert_eq(vm.eval("(p as Show).show()").to_string(), "(1, 2)")
}

///|
test "field_mutation" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Counter {
        #|  mut count : Int
        #|}
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("let c = { count: 0 }").to_string(), "()")
  assert_eq(vm.eval("c.count = 5").to_string(), "()")
  assert_eq(vm.eval("c.count").to_string(), "5")

  // 测试简单赋值对比
  assert_eq(vm.eval("c.count = 5").to_string(), "()")
  // 测试 += 是否被解析为 =
  assert_eq(vm.eval("c.count = 3").to_string(), "()")
  assert_eq(vm.eval("c.count += 3").to_string(), "()")
  assert_eq(vm.eval("c.count").to_string(), "6")
  assert_eq(vm.eval("c.count *= 2").to_string(), "()")
  assert_eq(vm.eval("c.count").to_string(), "12")
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
  inspect(vm.eval("a"), content="RefInt::{value: 2}")
  inspect(vm.eval("a.value"), content="2")
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
  inspect(vm.eval("a"), content="T::{a: 2}")
}
