///|
test "eval" {
  let vm = MoonBitVM::new()
  let result = vm.eval("eval(\"1 + 2\")")
  inspect(result, content="3")
}

///|
test "eval eval" {
  let vm = MoonBitVM::new()
  let result = vm.eval("eval(\"eval(\\\"1 + 2\\\")\")")
  inspect(result, content="3")
}

///|
test "typeof eval" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|typeof(eval("(1+2).to_string()"))
      ),
    ),
    content="@moonbitlang/core/string.String",
  )
  inspect(
    vm.eval(
      (
        #|typeof(eval("1+2"))
      ),
    ),
    content="@moonbitlang/core/int.Int",
  )
  inspect(
    vm.eval(
      (
        #|eval("1+2") is 3
      ),
    ),
    content="true",
  )
}
