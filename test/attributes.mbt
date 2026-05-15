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
  )
  |> ignore
  inspect(vm.eval("one()"), content="1")
  inspect(vm.eval("number_one()"), content="1")
}
