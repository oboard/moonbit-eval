// =============================================================================
// 2. ARITHMETIC AND COMPARISON OPERATORS
// =============================================================================

///|
test "arithmetic_operators" {
  let vm = MoonBitVM::new()
  assert_true(vm.eval("1+1") is Ok(Int(2)))
  assert_true(vm.eval("2-1") is Ok(Int(1)))
  assert_true(vm.eval("5 * 3") is Ok(Int(15)))
  assert_true(vm.eval("10 / 2") is Ok(Int(5)))
  assert_true(vm.eval("7 % 3") is Ok(Int(1)))
}

///|
test "group_expressions" {
  let vm = MoonBitVM::new()
  // Test grouped expressions with parentheses
  assert_true(vm.eval("(2 + 3) * (4 + 1)") is Ok(Int(25)))
  assert_true(vm.eval("((1 + 2) * 3) + (4 * (5 + 6))") is Ok(Int(53)))
}
