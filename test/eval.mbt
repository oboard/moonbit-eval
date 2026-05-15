///|
test "eval_can_be_user_defined" {
  let vm = MoonBitVM()
  ignore(
    vm.eval(
      (
        #|fn eval(value : Int) -> Int {
        #|  value + 1
        #|}
      ),
    ),
  )
  inspect(vm.eval("eval(2)"), content="3")
}
