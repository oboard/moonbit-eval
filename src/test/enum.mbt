// Enum-related test cases

///|
test "basic_enum" {
  let vm = MoonBitVM::new(log=true)
  inspect(
    vm.eval(
      (
        #|enum Relation {
        #|  Smaller
        #|  Greater
        #|  Equal
        #|}
        #|fn compare_int(x: Int, y: Int) -> Relation {
        #|  if x < y {
        #|    Smaller
        #|  } else if x > y {
        #|    Relation::Greater
        #|  } else {
        #|    Equal
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("compare_int(0, 1)"), content="Relation::Smaller")
  inspect(vm.eval("compare_int(1, 1)"), content="Relation::Equal")
  inspect(vm.eval("compare_int(2, 1)"), content="Relation::Greater")
}

///|
test "enum_with_data" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum List {
        #|  Nil
        #|  Cons(Int, List)
        #|}
        #|fn is_singleton(l: List) -> Bool {
        #|  match l {
        #|    Cons(_, Nil) => true
        #|    _ => false
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("let l = Cons(1, Cons(2, Nil))"), content="()")
  inspect(vm.eval("is_singleton(l)"), content="false")
  inspect(vm.eval("is_singleton(Cons(1, Nil))"), content="true")
  inspect(vm.eval("is_singleton(Nil)"), content="false")
}

///|
test "enum_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum Maybe {
        #|  Just(Int)
        #|  Nothing
        #|}
        #|fn get_or_default(m: Maybe, default: Int) -> Int {
        #|  match m {
        #|    Just(x) => x
        #|    Nothing => default
        #|  }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("get_or_default(Just(5), 0)"), content="5")
  inspect(vm.eval("get_or_default(Nothing, 0)"), content="0")
}
