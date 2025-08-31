// =============================================================================
// PACKAGE SYSTEM TESTS
// =============================================================================
// Tests for module system, package imports, and cross-package method calls

///|
test "module" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let max_value = 1").to_string(), "()")
  assert_eq(vm.eval("max_value").to_string(), "1")
  assert_eq(vm.eval("@int.max_value").to_string(), "2147483647")
  assert_eq(vm.eval("@int.abs(-1)").to_string(), "1")
}

///|
test "math" {
  let vm = MoonBitVM::new()
  // vm.interpreter.env.deps["math"].unwrap().env.values["abs"]
  assert_eq(vm.eval("@math.abs(-1.0)").to_string(), "1")
  assert_eq(vm.eval("@math.abs").to_string(), "(x: Double) -> Double")
}

///|
test "bigint" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@bigint.zero").to_string(), "0")
  assert_eq(vm.eval("@bigint.radix_bit_len").to_string(), "32")
}

///|
test "cmp" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@cmp.maximum").to_string(), "(x: T, y: T) -> T")
  assert_eq(vm.eval("@cmp.minimum").to_string(), "(x: T, y: T) -> T")
  assert_eq(vm.eval("@cmp.maximum(1, 2)").to_string(), "2")
  assert_eq(vm.eval("@cmp.minimum(1, 2)").to_string(), "1")
}

///|
test "cross_package_method_calling" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let list = @list.of([1,2,3]); list").to_string(),
    "More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )
  assert_eq(vm.eval("list.to_array()").to_string(), "[1, 2, 3]")
  assert_eq(
    vm.eval("let arr1 : Array[Int] = [1, 2, 3, 4, 5]").to_string(),
    "()",
  )
  assert_eq(vm.eval("arr1.length()").to_string(), "5")
}
