// =============================================================================
// FUNCTIONAL PROGRAMMING TESTS
// =============================================================================
// Tests for functional programming features like currying and higher-order functions

///|
test "currying" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let add = x => y => x + y").to_string(), "()")
  assert_eq(vm.eval("let f = add(10)").to_string(), "()")
  assert_eq(vm.eval("f").to_string(), "(Any) -> Any")
  assert_eq(vm.eval("f(1)").to_string(), "11")
  assert_eq(vm.eval("add(5)(3)").to_string(), "8")
}

// Lambda array tests moved to syntax.mbt

///|
test "closure_environment" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|let mut x = 0
        #|fn f1() { x += 1; x }
        #|let mut x = 0
        #|fn f2() { x += 1; x }
      ),
    ),
    content="() -> Any",
  )
  assert_eq(vm.eval("f1()").to_string(), "1")
  assert_eq(vm.eval("f1()").to_string(), "2")
  assert_eq(vm.eval("f2()").to_string(), "1")
  assert_eq(vm.eval("f2()").to_string(), "2")
}
