///|
test "v092_struct_constructor_function" {
  let vm = MoonBitVM()
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
    ),
    content="()",
  )
  inspect(vm.eval("Point(1, 2).x + Point(3, 4).y"), content="5")
}

///|
test "v092_array_literal_as_iter" {
  let vm = MoonBitVM()
  inspect(vm.eval("([1, 2, 3] : Iter[Int]).collect()"), content="[1, 2, 3]")
}

///|
test "v092_array_spread_as_iter" {
  let vm = MoonBitVM()
  inspect(
    vm.eval("([0, ..[1, 2].iter(), 3] : Iter[Int]).collect()"),
    content="[0, 1, 2, 3]",
  )
}

///|
test "list_comprehension_array" {
  let vm = MoonBitVM()
  vm.run("import { \"moonbitlang/core/list\" }")
  inspect(vm.eval("[for x in [1, 2, 3] => x * 2]"), content="[2, 4, 6]")
  inspect(
    vm.eval(
      (
        #|[
        #|  for x in [1, 2, 3] => x * 2
        #|]
      ),
    ),
    content="[2, 4, 6]",
  )
  inspect(vm.eval("[for x in 1..=3 => x + 1]"), content="[2, 3, 4]")
  inspect(
    vm.eval("[for x in @list.from_array([1, 2, 3]) => x + 2]"),
    content="[3, 4, 5]",
  )
  inspect(vm.eval("[for x in [1, 2, 3] if x > 1 => x * 2]"), content="[4, 6]")
  inspect(
    vm.eval("[for x in [Some(1), None, Some(3)] if x is Some(y) => y * 2]"),
    content="[2, 6]",
  )
  inspect(
    vm.eval("[for x in [Some(1), None, Some(3)] if x is None => 0]"),
    content="[0]",
  )
  inspect(
    vm.eval("([for c in ['a', 'b', 'c'] if c != 'b' => c] : String)"),
    content="ac",
  )
  inspect(vm.eval("([for b in [65, 66] => b] : Bytes)"), content="b\"AB\"")
}

///|
test "list_comprehension_iter" {
  let vm = MoonBitVM()
  inspect(
    vm.eval(
      (
        #|let fib_numbers : Iter[Int] = [
        #|  for p1 = 1, p2 = 0;; p1 = p1 + p2, p2 = p1 => p1
        #|]
        #|fib_numbers.take(6).collect()
      ),
    ),
    content="[1, 1, 2, 3, 5, 8]",
  )
}

///|
test "v092_extensible_enum_syntax" {
  let vm = MoonBitVM()
  inspect(
    vm.eval(
      (
        #|pub(all) extenum LogEvent[T] {
        #|  Info(T)
        #|  Warning(T)
        #|}
      ),
    ),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|pub(all) extenum @base.LogEvent[T] += {
        #|  Debug(T)
        #|}
      ),
    ),
    content="()",
  )
  inspect(
    vm.eval(
      (
        #|match @base.Debug(3) {
        #|  LogEvent::@base.Debug(n) => n
        #|  _ => 0
        #|}
      ),
    ),
    content="3",
  )
}

///|
test "v092_reverse_pipe_method_call" {
  let vm = MoonBitVM()
  inspect(vm.eval("\"moonbit\".contains() <| \"bit\""), content="true")
  inspect(
    vm.eval("\"moonbit\".replace_all(\"moon\") <| \"sun\""),
    content="sunbit",
  )
}

///|
test "v092_for_update_uses_condition_binding" {
  let vm = MoonBitVM()
  inspect(
    vm.eval(
      (
        #|let queue = [1, 2, 3].iter()
        #|for sum = 0; queue.next() is Some(elem); sum = sum + elem {
        #|}
        #|sum
      ),
    ),
    content="6",
  )
}

///|
test "v092_qualified_package_constructor" {
  let vm = MoonBitVM()
  vm.run("import { \"moonbitlang/core/json\" }")
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
