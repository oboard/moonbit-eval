// =============================================================================
// Exception Handling Tests
// =============================================================================
// Tests for try-catch expressions and exception handling

///|
test "try_catch_expressions" {
  let vm = MoonBitVM::new()
  // Test try-catch expressions
  assert_eq(
    vm
    .eval(
      (
        #|try {
        #|  let x = 10 / 2
        #|  x
        #|} catch {
        #|  e => -1
        #|}
      ),
    )
    .to_string(),
    "5",
  )
  assert_eq(
    vm
    .eval(
      (
        #|try {
        #|  raise "error"
        #|  42
        #|} catch {
        #|  e => 0
        #|}
      ),
    )
    .to_string(),
    "0",
  )
}
