///|
test "struct_constr" {
  let vm = MoonBitVM()
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
    ),
    content="()",
  )
  inspect(vm.eval("Person(\"Alice\").name"), content="Alice")
}
