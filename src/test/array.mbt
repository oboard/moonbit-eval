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
  inspect(
    vm.eval("let arr = [1, 2, 3]; arr.get(5)"),
    content="@moonbitlang/core/option.Option::None",
  )
}

///|
test "array_push_pop_methods" {
  let vm = MoonBitVM::new()
  // Test push and pop
  inspect(vm.eval("let arr = [1, 2]; arr.push(3); arr.length()"), content="3")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.pop()"), content="Some(3)")
  inspect(
    vm.eval("let arr = []; arr.pop()"),
    content="@moonbitlang/core/option.Option::None",
  )
}

///|
test "array_contains_methods" {
  let vm = MoonBitVM::new()
  // Test contains method
  inspect(vm.eval("let arr = [1, 2, 3]; arr.contains(2)"), content="true")
  inspect(vm.eval("let arr = [1, 2, 3]; arr.contains(5)"), content="false")
}
