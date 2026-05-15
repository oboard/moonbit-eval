///|
test "read_dir" {
  let vm = MoonBitVM()
  println(vm.eval("@fs.read_dir(\"./\")"))
}
