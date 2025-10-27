///|
test "import" {
  let vm = MoonBitVM::new()
  vm.eval(
    (
      #|require("hello", "./src/test/hello")
    ),
  )
  |> ignore
  inspect(vm.eval("@hello.hello()"), content="Hello, World!")
}
