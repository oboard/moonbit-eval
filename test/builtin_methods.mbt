// =============================================================================
// BUILT-IN METHODS TESTS
// =============================================================================

///|
test "string_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("let s = \"hello\""), content="()")
  inspect(vm.eval("s.length()"), content="5")
  inspect(vm.eval("s.code_unit_at(0)"), content="104")
  inspect(vm.eval("s.to_string()"), content="hello")
}

///|
test "bool_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("true.compare(false)"), content="1")
  inspect(vm.eval("false.compare(true)"), content="-1")
  inspect(vm.eval("true.compare(true)"), content="0")
  inspect(vm.eval("Bool::default()"), content="false")
}

///|
test "int_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("(5).lnot()"), content="-6")
  inspect(vm.eval("(5).land(3)"), content="1")
  inspect(vm.eval("(5).lor(3)"), content="7")
  inspect(vm.eval("(5).lxor(3)"), content="6")
  inspect(vm.eval("(5).shl(2)"), content="20")
  inspect(vm.eval("(20).shr(2)"), content="5")
  inspect(vm.eval("(5).compare(3)"), content="1")
  inspect(vm.eval("(3).compare(5)"), content="-1")
  inspect(vm.eval("(5).compare(5)"), content="0")
  inspect(vm.eval("(5).is_pos()"), content="true")
  inspect(vm.eval("(-5).is_neg()"), content="true")
  inspect(vm.eval("(0).is_pos()"), content="false")
  inspect(vm.eval("(8).ctz()"), content="3")
  inspect(vm.eval("(8).clz()"), content="28")
  inspect(vm.eval("(7).popcnt()"), content="3")
}

///|
test "double_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("5.5.compare(3.5)"), content="1")
  inspect(vm.eval("3.5.compare(5.5)"), content="-1")
  inspect(vm.eval("3.5.compare(3.5)"), content="0")
  inspect(vm.eval("3.5.to_int64()"), content="3")
}

///|
test "char_methods" {
  let vm = MoonBitVM::new()
  inspect(vm.eval("'b'.compare('a')"), content="1")
  inspect(vm.eval("'a'.compare('b')"), content="-1")
  inspect(vm.eval("'a'.compare('a')"), content="0")
  inspect(vm.eval("'a'.to_int()"), content="97")
}
