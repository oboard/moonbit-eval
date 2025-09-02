///|
test "list_methods" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let list = @list.of([1, 2, 3]); list").to_string(),
    "More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )
  assert_eq(vm.eval("typeof(list)").to_string(), "@moonbitlang/core/list.List")
  assert_eq(
    vm.eval("list.rev()").to_string(),
    "More(3, tail=More(2, tail=More(1, tail=Empty)))",
  )
  assert_eq(
    vm.eval("list").to_string(),
    "More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )

  // Test basic list operations
  assert_eq(vm.eval("let l = @list.empty()").to_string(), "()")
  assert_eq(vm.eval("l.is_empty()").to_string(), "true")
  assert_eq(vm.eval("l = l.add(1)").to_string(), "()")
  assert_eq(vm.eval("l.is_empty()").to_string(), "false")
  assert_eq(vm.eval("l.length()").to_string(), "1")

  // Test list mapping and filtering
  assert_eq(vm.eval("let l2 = @list.of([1, 2, 3, 4, 5])").to_string(), "()")
  assert_eq(
    vm.eval("l2.map(x => x * 2).to_array()").to_string(),
    "[2, 4, 6, 8, 10]",
  )
  assert_eq(
    vm.eval("l2.filter(x => x % 2 == 0).to_array()").to_string(),
    "[2, 4]",
  )

  // Test list folding
  assert_eq(vm.eval("l2.fold(init=0, (acc, x) => acc + x)").to_string(), "15")

  // Test list concatenation and reversal
  assert_eq(
    vm.eval("let l3 = @list.of([6, 7, 8]); l3.to_array()").to_string(),
    "[6, 7, 8]",
  )
  assert_eq(vm.eval("l3.to_array()").to_string(), "[6, 7, 8]")
  assert_eq(
    vm.eval("l2.concat(l3).to_array()").to_string(),
    "[1, 2, 3, 4, 5, 6, 7, 8]",
  )
  assert_eq(vm.eval("l2.rev().to_array()").to_string(), "[5, 4, 3, 2, 1]")

  // Test list searching
  assert_eq(vm.eval("l2.contains(3)").to_string(), "true")
  assert_eq(vm.eval("l2.find(x => x > 4)").to_string(), "Some(5)")

  // Test list slicing
  assert_eq(vm.eval("l2.take(3).to_array()").to_string(), "[1, 2, 3]")
  assert_eq(vm.eval("l2.drop(2).to_array()").to_string(), "[3, 4, 5]")

  // zip
  assert_eq(
    vm
    .eval(
      "let l4 = @list.of([1, 2, 3]); let l5 = @list.of([4, 5, 6]); l4.zip(l5).to_array()",
    )
    .to_string(),
    "[(1, 4), (2, 5), (3, 6)]",
  )
}
