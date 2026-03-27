///|
test "struct_constr" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct Person {
        #|  name: String,
        #|  fn new(name : String) -> Person
        #|}
        #|fn Person::new(name: String) -> Person {
        #|  { name }
        #|}
      ),
      top=true,
    ),
    content="()",
  )
  inspect(vm.eval("Person(\"Alice\").name"), content="Alice")
}
