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

///|
test "group_expressions" {
  let vm = MoonBitVM::new()
  // Test grouped expressions with parentheses
  assert_eq(vm.eval("(2 + 3) * (4 + 1)").to_string(), "25")
  assert_eq(vm.eval("((1 + 2) * 3) + (4 * (5 + 6))").to_string(), "53")
}
