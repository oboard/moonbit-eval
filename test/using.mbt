///|
using @eval {type MoonBitVM}

///|
test "function_alias" {
  let vm = MoonBitVM()
  // 测试函数别名定义和使用
  vm.run(
    (
      #|import { "moonbitlang/core/int" }
      #|using @int {abs}
    ),
  )
  inspect(vm.eval("abs"), content="(Int) -> Int")
  inspect(vm.eval("abs(-5)"), content="5")
}
