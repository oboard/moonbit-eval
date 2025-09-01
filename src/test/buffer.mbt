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
  inspect(vm.eval("StringBuilder::new()"), content="{val: }")

  // inspect(
  //   vm.eval("typeof(StringBuilder::new())"), //   content="@moonbitlang/core/builtin.StringBuilder",
  // )
}
