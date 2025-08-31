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

///|
test "multiline_strings" {
  let vm = MoonBitVM::new()
  // Test multiline string syntax
  assert_eq(vm.eval("#|hello\n#|world").to_string(), "hello\nworld")
  assert_eq(
    vm.eval("#|line1\n#|line2\n#|line3").to_string(),
    "line1\nline2\nline3",
  )
  assert_eq(vm.eval("#|single line").to_string(), "single line")
}

///|
test "string_interpolation" {
  let vm = MoonBitVM::new()
  // Test string interpolation
  assert_eq(
    vm.eval("let x = 42; \"The answer is \\{x}\"").to_string(),
    "The answer is 42",
  )
  assert_eq(
    vm.eval("let name = \"World\"; \"Hello, \\{name}!\"").to_string(),
    "Hello, World!",
  )
  assert_eq(
    vm.eval("let a = 5; let b = 3; \"\\{a} + \\{b} = \\{a + b}\"").to_string(),
    "5 + 3 = 8",
  )
}
