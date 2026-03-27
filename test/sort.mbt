///|
test "sort" {
  let vm = MoonBitVM::new()
  let unsorted = @list.from_array([3, 1, 4, 1, 5, 9, 2, 6])
  inspect(unsorted.sort().to_array(), content="[1, 1, 2, 3, 4, 5, 6, 9]")
  assert_eq(
    vm.eval("let unsorted = [3, 1, 4, 1, 5, 9, 2, 6]").to_string(),
    "()",
  )
  assert_eq(vm.eval("unsorted.sort()").to_string(), "()")
  assert_eq(vm.eval("unsorted").to_string(), "[1, 1, 2, 3, 4, 5, 6, 9]")
}
