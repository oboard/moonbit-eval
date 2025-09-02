///|
test {
  let vm = MoonBitVM::new(log=true)
  vm.eval(
    (
      #|struct A {
      #|  a: Int
      #|}
      #|impl Show for A with to_string(self : A) -> String {
      #|  "A:\{self.a}"
      #|}
    ),
    top=true,
  )
  |> ignore
  assert_eq(vm.eval("let a = {a: 1};a").to_string(), "A::{a: 1}")
  assert_eq(vm.eval("a.to_string()").to_string(), "A:1")
}
