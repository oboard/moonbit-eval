///|
test {
  let result = StringBuilder::new()
    ..write_char('a')
    ..write_char('a')
    ..write_object(1001)
    ..write_string("abcdef")
    .to_string()
  inspect(result, content="aa1001abcdef")
}

///|
test {
  let vm = MoonBitVM::new()
  vm.eval(
    (
      #|let result = StringBuilder::new()
      #|  ..write_char('a')
      #|  ..write_char('a')
      #|  ..write_object(1001)
      #|  ..write_string("abcdef")
      #|  .to_string()
    ),
  )
  |> ignore
  inspect(vm.eval("result"), content="aa1001abcdef")
}

///|
test {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("StringBuilder::new"),
    content="(size_hint~: Int = 0) -> StringBuilder",
  )
  inspect(
    vm.eval("StringBuilder::new()"),
    content=(
      #|Error: @main.new(size_hint~: Int = 0) -> StringBuilder => visit: unimplemented {"type":"Expr::Hole","loc":null,"kind":{"type":"Hole::Synthesized"}} /Users/oboard/Development/moonbit-packages/moonbit-eval/src/interpreter/interpreter.mbt:267:3-267:51
    ),
  )
  // inspect(
  //   vm.eval("typeof(StringBuilder::new())"), //   content="@moonbitlang/core/builtin.StringBuilder",
  // )
}

///|
test {
  let l = FixedArray::make(1, 1)
  inspect(l, content="[1]")
}
