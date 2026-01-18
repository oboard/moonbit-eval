// =============================================================================
// SYNTAX FEATURES TESTS
// =============================================================================
// Tests for language syntax features like pipe operator and grouping

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
test "group_expressions" {
  let vm = MoonBitVM::new()
  // Test grouped expressions with parentheses
  assert_eq(vm.eval("(2 + 3) * (4 + 1)").to_string(), "25")
  assert_eq(vm.eval("((1 + 2) * 3) + (4 * (5 + 6))").to_string(), "53")
}

///|
test "lambda_arrays" {
  let a = [x => x + 1, x => x - 1]
  inspect(a[1](10), content="9")
}

///|
test "lambda_arrays_vm" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let a = [x => x + 1, x => x - 1]; a[1](10)"), content="9")
}
