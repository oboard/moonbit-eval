///|
test {
  let vm = MoonBitVM()
  vm.run(
    (
      #|struct A {
      #|  a: Int
      #|}
      #|impl Show for A with to_string(self : A) -> String {
      #|  "A:\{self.a}"
      #|}
    ),
  )
  assert_eq(vm.eval("let a = {a: 1};a").to_string(), "A::{a: 1}")
  assert_eq(vm.eval("a.to_string()").to_string(), "A:1")
}
