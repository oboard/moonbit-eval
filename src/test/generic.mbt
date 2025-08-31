// Generic-related test cases

///|
test "generic_list" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum List[T] {
        #|  Nil
        #|  Cons(T, List[T])
        #|}
        #|
        #|fn[T] List::new() -> List[T] {
        #|  Nil
        #|}
        #|
        #|fn[T] List::cons(x: T, xs: List[T]) -> List[T] {
        #|  Cons(x, xs)
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  // 先测试单独的Nil
  inspect(vm.eval("Nil"), content="Nil")
  // 再测试List::new()
  inspect(vm.eval("List::new()"), content="Nil")
  // 测试简单的Cons调用
  inspect(vm.eval("List::cons(1, Nil)"), content="Cons(1, Nil)")
  // 测试嵌套的Cons调用
  assert_eq(vm.eval("List::cons(2, List::new())").to_string(), "Cons(2, Nil)")
  // 测试中间步骤
  inspect(
    vm.eval("let inner = List::cons(2, List::new()); inner"),
    content="Cons(2, Nil)",
  )
  // 测试分步构建
  inspect(
    vm.eval("let step1 = List::new(); let step2 = List::cons(2, step1); step2"),
    content="Cons(2, Nil)",
  )
  // 测试直接嵌套调用
  inspect(vm.eval("List::cons(2, List::new())"), content="Cons(2, Nil)")
  // 测试更深层嵌套
  let result = vm.eval("List::cons(1, List::cons(2, List::new()))")
  inspect(result, content="Cons(1, Cons(2, Nil))")
  inspect(
    vm.eval("let list = List::cons(1, List::cons(2, List::new()))"),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|fn[S, T] map(list: List[S], f: (S) -> T) -> List[T] {
        #|  match list {
        #|    Nil => Nil
        #|    Cons(x, xs) => Cons(f(x), map(xs, f))
        #|  }
        #|}
        #|
        #|fn[T] sum(list: List[T]) -> T {
        #|  match list {
        #|    Nil => 0
        #|    Cons(x, xs) => x + sum(xs)
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(
    vm.eval("let list = List::cons(1, List::cons(2, List::new()))"),
    content="()",
  )
  assert_eq(
    vm.eval("map(list, x => x * 2)").to_string(),
    "Cons(2, Cons(4, Nil))",
  )
  assert_eq(vm.eval("sum(list)").to_string(), "3")
}
