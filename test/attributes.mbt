///|
test "alias" {
  let vm = MoonBitVM()
  vm.run(
    (
      #|#alias(number_one)
      #|fn one() -> Int { 
      #|  1 
      #|}
    ),
  )
  inspect(vm.eval("one()"), content="1")
  inspect(vm.eval("number_one()"), content="1")
}
