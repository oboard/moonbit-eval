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

///|
test "list_comprehension_array" {
  let vm = MoonBitVM::new()
  ignore(vm.eval("import { \"moonbitlang/core/list\" }"))
  inspect(vm.eval("[for x in [1, 2, 3] { x * 2 }]"), content="[2, 4, 6]")
  inspect(
    vm.eval(
      (
        #|[
        #|  for x in [1, 2, 3] { x * 2 }
        #|]
      ),
    ),
    content="[2, 4, 6]",
  )
  inspect(vm.eval("[for x in 1..=3 { x + 1 }]"), content="[2, 3, 4]")
  inspect(
    vm.eval("[for x in @list.from_array([1, 2, 3]) { x + 2 }]"),
    content="[3, 4, 5]",
  )
  inspect(
    vm.eval("[for x in [1, 2, 3] { guard x > 1 else { continue }; x * 2 }]"),
    content="[4, 6]",
  )
  inspect(
    vm.eval(
      "[for x in [Some(1), None, Some(3)] { guard x is Some(y) else { continue }; y * 2 }]",
    ),
    content="[2, 6]",
  )
  inspect(
    vm.eval(
      "[for x in [Some(1), None, Some(3)] { guard x is None else { continue }; 0 }]",
    ),
    content="[0]",
  )
}

///|
test "v092_qualified_package_constructor" {
  let vm = MoonBitVM::new()
  ignore(vm.eval("import { \"moonbitlang/core/json\" }"))
  inspect(vm.eval("@json.Null"), content="Null")
  inspect(vm.eval("@json.Json::True"), content="True")
  inspect(
    vm.eval(
      (
        #|match @json.True {
        #|  @json.Json::False => 0
        #|  @json.Json::True => 1
        #|  _ => 2
        #|}
      ),
    ),
    content="1",
  )
}
