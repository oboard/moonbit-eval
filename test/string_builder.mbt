///|
test {
  let vm = MoonBitVM::new()
  assert_eq(
    vm
    .eval(
      (
        #|let result = StringBuilder::new()
        #|  ..write_char('a')
        #|  ..write_object(1001)
        #|  ..write_string("abcdef")
        #|  .to_string()
      ),
    )
    .to_string(),
    "()",
  )
  assert_eq(vm.eval("result").to_string(), "a1001abcdef")
}
