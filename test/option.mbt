// =============================================================================
// Option Type Tests
// =============================================================================
// Tests for Option type functionality, pattern matching, and methods

///|
test "option_type" {
  let vm = MoonBitVM()
  // Test try operator (?)
  inspect(
    vm.eval(
      (
        #|fn safe_divide(a : Int, b : Int) -> Int? {
        #|  if b == 0 { None } else { Some(a / b) }
        #|}
        #|let result = safe_divide(10, 2)
        #|result
      ),
    ),
    content="Some(5)",
  )
  inspect(
    vm.eval(
      (
        #|let result = safe_divide(10, 0)
        #|result
      ),
    ),
    content="None",
  )
}

///|
test "option_basics" {
  let vm = MoonBitVM()
  inspect(vm.eval("@option.Some(5)"), content="Some(5)")
  inspect(vm.eval("Some(5)"), content="Some(5)")
  inspect(vm.eval("None"), content="None")
  inspect(vm.eval("Some(5).unwrap()"), content="5")
}

///|
test "option_pattern_matching" {
  let vm = MoonBitVM()
  inspect(vm.eval("match Some(5) { Some(x) => x, None => 0 }"), content="5")
  inspect(
    vm.eval("match Some(5) { Option::Some(x) => x, None => 0 }"),
    content="5",
  )
  inspect(vm.eval("match None { Some(x) => x, None => 0 }"), content="0")
}

///|
test {
  let opt = Some(5)
  assert_eq(@debug.to_string(opt.map(fn(x) { x * 2 })), "Some(10)")
}

///|
test "option_methods" {
  let vm = MoonBitVM()
  inspect(vm.eval("let opt = Some(42); opt.unwrap()"), content="42")
  inspect(vm.eval("let opt = Some(42); opt.unwrap_or(0)"), content="42")
  inspect(vm.eval("let opt = None; opt.unwrap_or(0)"), content="0")
  inspect(vm.eval("let opt = Some(42); opt.is_empty()"), content="false")
  inspect(vm.eval("let opt = None; opt.is_empty()"), content="true")
  inspect(
    vm.eval("let opt = Some(5); opt.map(fn(x) { x * 2 })"),
    content="Some(10)",
  )
  inspect(vm.eval("let opt = None; opt.map(fn(x) { x * 2 })"), content="None")
  inspect(
    vm.eval("let opt = Some(5); opt.filter(fn(x) { x > 3 })"),
    content="Some(5)",
  )
  inspect(
    vm.eval("let opt = Some(2); opt.filter(fn(x) { x > 3 })"),
    content="None",
  )
}
