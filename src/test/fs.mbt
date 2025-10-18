///|
test "read_dir" {
  let vm = MoonBitVM::new()
  println(vm.eval("@fs.read_dir(\"./\")"))
}
