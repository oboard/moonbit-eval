// =============================================================================
// COMPILED CODE TESTS
// =============================================================================

///|
test "compiled expression can run repeatedly" {
  let vm = MoonBitVM()
  let compiled = vm.compile("1 + 2 * 3")
  inspect(compiled.run(vm), content="7")
  inspect(compiled.run(vm), content="7")
}

///|
test "compiled expression accepts parameters" {
  let vm = MoonBitVM()
  let compiled = vm.compile("x + y * 2", params=["x", "y"])
  inspect(compiled.run(vm, args=[3, 4]), content="11")
  inspect(compiled.run(vm, args=[10, 1]), content="12")
}

///|
test "compiled parameters do not leak" {
  let vm = MoonBitVM()
  let compiled = vm.compile("x + 1", params=["x"])
  inspect(compiled.run(vm, args=[41]), content="42")
  inspect(vm.eval("x"), content="Error: variable @main.x not found")
}

///|
test "compiled argument count is checked" {
  let vm = MoonBitVM()
  let compiled = vm.compile("x + y", params=["x", "y"])
  inspect(
    compiled.run(vm, args=[1]),
    content="Error: compiled code expects 2 arguments, got 1",
  )
}

///|
test "compiled expression accepts mixed runtime values" {
  let vm = MoonBitVM()
  let compiled = vm.compile(
    "if ok { name + \"=\" + score.to_string() } else { \"skip\" }",
    params=["ok", "name", "score"],
  )
  inspect(compiled.run(vm, args=[true, "score", 99]), content="score=99")
}

///|
test "compiled top declarations can run later" {
  let vm = MoonBitVM()
  let compiled = vm.compile("fn double(n : Int) -> Int { n * 2 }")
  inspect(compiled.run(vm), content="(Int) -> Int")
  inspect(vm.eval("double(21)"), content="42")
}
