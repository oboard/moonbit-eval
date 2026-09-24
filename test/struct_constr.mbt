///|
test "struct_constr" {
  let vm = MoonBitVM()
  inspect(
    vm.eval(
      (
        #|struct Person {
        #|  name : String
        #|}
        #|fn Person::new(name : String) -> Person {
        #|  { name }
        #|}
      ),
    ),
    content="()",
  )
  inspect(vm.eval("Person::new(\"Alice\").name"), content="Alice")
}
