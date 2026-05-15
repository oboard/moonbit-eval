///|
test "example_recursive_enum_expression_eval" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|// Define a recursive enum for expressions
        #|enum Expr { Num(Int); Mul(Expr, Expr) }
        #|
        #|// Evaluate expression with pattern matching
        #|fn eval(expr : Expr) -> Int {
        #|  match expr {
        #|    Num(n) => n
        #|    Mul(a, b) => eval(a) * eval(b)
        #|  }
        #|}
        #|
        #|fn main {
        #|  let expr = Mul(Mul(Num(2), Num(3)), Num(4))
        #|  println(eval(expr)) // 24
        #|}
      ),
    ),
  )
  inspect(vm.eval("eval(Mul(Mul(Num(2), Num(3)), Num(4)))"), content="24")
}

///|
test "example_generic_quicksort" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|// Generic quicksort: works on any type with Compare
        #|fn[T : Compare] qsort(input : Array[T]) -> Array[T] {
        #|  guard input is [p, .. rs] else { [] }
        #|  qsort(rs.filter(x => x <= p)) + [p] + qsort(rs.filter(x => x > p))
        #|}
        #|
        #|fn main {
        #|  println(qsort([1, 0, 6, 2, 7, 1]))
        #|  println(qsort(['e', 'c', 'd', 'b', 'a']))
        #|}
      ),
    ),
  )
  inspect(vm.eval("qsort([1, 0, 6, 2, 7, 1])"), content="[0, 1, 1, 2, 6, 7]")
  inspect(
    vm.eval("qsort(['e', 'c', 'd', 'b', 'a'])"),
    content="[a, b, c, d, e]",
  )
}

///|
test "example_json_pattern_extract_name" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|// Pattern match directly on JSON structure
        #|fn extract_name(data : Json) -> String? {
        #|  match data {
        #|    { "user": { "name": String(name), .. }, .. } => Some(name)
        #|    _ => None
        #|  }
        #|}
        #|
        #|fn main {
        #|  // JSON literals are built-in syntax
        #|  let data : Json = { "user": { "name": "Alice", "age": 30 } }
        #|  println(extract_name(data)) // Some("Alice")
        #|}
      ),
    ),
  )
  inspect(
    vm.eval("extract_name({ \"user\": { \"name\": \"Alice\", \"age\": 30 } })"),
    content="Some(Alice)",
  )
}
