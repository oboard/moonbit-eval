test "basic" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("1"), content="Int(1)")
  inspect!(vm.eval("1+1"), content="Int(2)")
  inspect!(vm.eval("2-1"), content="Int(1)")
  inspect!(
    vm.eval("\"hello\""),
    content=
      #|String("hello")
    ,
  )
  // inspect!(vm.eval("println(\"hello\")"), content="Unit")
}

test "variables" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("let a = 1"), content="Unit")
  inspect!(vm.eval("a"), content="Int(1)")
}

test "mutable variables" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("let mut a = 1"), content="Unit")
  inspect!(vm.eval("a = 12"), content="Unit")
  inspect!(vm.eval("a"), content="Int(12)")
}

test "function" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("fn double(x: Int) -> Int { x*2 }"), content="Unit")
  inspect!(vm.eval("double(2)"), content="Int(4)")
}

test "str" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("let str1: String = \"haha\""), content="Unit")
  inspect!(vm.eval("let str2: String = \"hello\""), content="Unit")
  inspect!(
    vm.eval("str1 + str2"),
    content=
      #|String("hahahello")
    ,
  )
}

test "if" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("if true { 1 } else { 2 }"), content="Int(1)")
  inspect!(vm.eval("if false { 1 } else { 2 }"), content="Int(2)")
}

test "for" {
  let vm = MoonBitVM::new()
  inspect!(vm.eval("let mut output = \"\""), content="Unit")
  // inspect!(
  //   vm.eval("for i = 0; i < 10; i = i + 1 {  output = output + i.to_string() }"),
  //   content="Int(0)\nInt(1)\nInt(2)",
  // )
}
