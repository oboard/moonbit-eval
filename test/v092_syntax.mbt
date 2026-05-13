///|
test "v092_struct_constructor_function" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct Point {
        #|  x : Int
        #|  y : Int
        #|}
        #|fn Point::Point(x : Int, y : Int) -> Point {
        #|  { x, y }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("Point(1, 2).x + Point(3, 4).y"), content="5")
}

///|
test "v092_array_literal_as_iter" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("([1, 2, 3] : Iter[Int]).collect()"), content="[1, 2, 3]")
}

///|
test "v092_array_spread_as_iter" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("([0, ..[1, 2].iter(), 3] : Iter[Int]).collect()"),
    content="[0, 1, 2, 3]",
  )
}
