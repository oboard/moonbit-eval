///|
typealias @eval.MoonBitVM

///|
test "function_alias" {
  let vm = MoonBitVM::new(log=true)
  // 测试函数别名定义和使用
  vm.eval(
    (
      #|fnalias @int.abs
    ),
    top=true,
  )
  |> ignore
  assert_eq(vm.eval("abs").to_string(), "(x: Int) -> Int")
  assert_eq(vm.eval("abs(-5)").to_string(), "5")
}
