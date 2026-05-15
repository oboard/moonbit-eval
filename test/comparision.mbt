///|
test "comparison_operators" {
  let vm = MoonBitVM()
  inspect(vm.eval("5 == 5"), content="true")
  inspect(vm.eval("5 != 3"), content="true")
  inspect(vm.eval("3 < 5"), content="true")
  inspect(vm.eval("5 > 3"), content="true")
  inspect(vm.eval("3 <= 5"), content="true")
  inspect(vm.eval("5 >= 3"), content="true")
}
