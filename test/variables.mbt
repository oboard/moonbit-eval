// =============================================================================
// VARIABLE AND ASSIGNMENT TESTS
// =============================================================================
// Tests for variable declarations, mutations, and field assignments

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

///|
test "basic_mutable_variables" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let mut x = 0; x = x + 1; x").to_string(), "1")
}

///|
test "sequential_assignments" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval("let mut sum = 0; sum = sum + 1; sum = sum + 2; sum = sum + 3; sum")
    .to_string(),
    "6",
  )
}

///|
test "field_assignment" {
  let vm = MoonBitVM::new()
  // Test field assignment works - separate top and non-top
  assert_eq(
    vm
    .eval(
      (
        #|struct Point { mut x : Int, mut y : Int }
      ),
      top=true,
    )
    .to_string(),
    "()",
  )
  assert_eq(
    vm
    .eval(
      (
        #|let p = { x: 1, y: 2 }
        #|p.x = 10
        #|p.y = 20
        #|(p.x, p.y)
      ),
      top=false,
    )
    .to_string(),
    "(10, 20)",
  )
}

///|
test "nested_struct_reference" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|struct Inner { value : Int }
        #|struct Outer { inner : Inner }
        #|let outer = { inner: { value: 42 } }
        #|outer.inner.value
      ),
    )
    .to_string(),
    "42",
  )
}
