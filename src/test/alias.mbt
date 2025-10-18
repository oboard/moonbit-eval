///|
typealias @eval.MoonBitVM

///|
test "function_alias" {
  let vm = MoonBitVM::new()
  // 测试函数别名定义和使用
  vm.eval(
    (
      #|fnalias @int.abs
    ),
    top=true,
  )
  |> ignore
  inspect(vm.eval("abs"), content="(Int) -> Int")
  inspect(vm.eval("abs(-5)"), content="5")
}
