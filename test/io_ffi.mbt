// =============================================================================
// IO AND FFI TESTS
// =============================================================================
// Tests for input/output operations and foreign function interface

///|
test "println" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("println(\"hello\")"), content="()")
}

///|
test "embedded_code" {
  let vm = MoonBitVM::new()
  vm.interpreter.add_embedded_fn("%string_length2", ctx => {
    if ctx.args is [{ val: String(s), .. }] {
      Int(s.length(), raw=None)
    } else {
      Unit
    }
  })
  inspect(
    vm.eval(
      "pub fn String::length2(self : String) -> Int = \"%string_length2\"",
    ),
    content="()",
  )
  inspect(vm.eval("\"hello\".length2()"), content="5")
}
