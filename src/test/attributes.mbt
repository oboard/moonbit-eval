///|
test "alias" {
  let vm = MoonBitVM::new()
  vm.eval(
    (
      #|#alias(number_one)
      #|fn one() -> Int { 
      #|  1 
      #|}
    ),
    top=true,
  )
  |> ignore
  assert_true(vm.eval("one()") is Ok(Int(1)))
  assert_true(vm.eval("number_one()") is Ok(Int(1)))
}
