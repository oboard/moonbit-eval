///|
test "sort" {
  let vm = MoonBitVM::new()
  let unsorted = @list.from_array([3, 1, 4, 1, 5, 9, 2, 6])
  assert_eq(
    @debug.to_string(unsorted.sort().to_array()),
    "[1, 1, 2, 3, 4, 5, 6, 9]",
  )
  inspect(vm.eval("let unsorted = [3, 1, 4, 1, 5, 9, 2, 6]"), content="()")
  inspect(vm.eval("unsorted.sort()"), content="()")
  inspect(vm.eval("unsorted"), content="[1, 1, 2, 3, 4, 5, 6, 9]")
}
