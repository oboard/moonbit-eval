// =============================================================================
// CONSTRUCTOR AND ADVANCED PATTERN TESTS
// =============================================================================
// Tests for constructor patterns and advanced pattern matching scenarios

///|
test "constructor_single_argument_any_match" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let l = @list.of([1, 2]); l").to_string(),
    "More(1, tail=More(2, tail=Empty))",
  )
  assert_eq(
    vm
    .eval(
      (
        #|match l {
        #|  More(_, tail~) => tail
        #|  Empty => "empty"
        #|}
        #|
      ),
    )
    .to_string(),
    "More(2, tail=Empty)",
  )
}
