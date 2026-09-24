///|
test "pattern match" {
  let vm = @eval.MoonBitVM()
  let result = vm.eval(
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
      #|let expr = Mul(Mul(Num(2), Num(3)), Num(4))
      #|eval(expr)  // 24
    ),
  )

  assert_true(result is Success(Int(24, ..), _))
}

///|
test "trait" {
  let vm = @eval.MoonBitVM()
  let result = vm.eval(
    (
      #|// Generic quicksort: works on any type with Compare
      #|fn[T : Compare] qsort(input : Array[T]) -> Array[T] {
      #|  guard input is [p, .. rs] else { [] }
      #|  qsort(rs.filter(x => x <= p)) + [p] + qsort(rs.filter(x => x > p))
      #|}
      #|
      #|qsort([1, 0, 6, 2, 7, 1])
    ),
  )
  assert_true(
    result
    is Success(
      Array(
        [Int(0, ..), Int(1, ..), Int(1, ..), Int(2, ..), Int(6, ..), Int(7, ..)]
      ),
      _
    ),
  )
}

///|
test "first class json" {
  let vm = @eval.MoonBitVM()
  let result = vm.eval( // Pattern match directly on JSON structure
    (
      #|// Pattern match directly on JSON structure
      #|fn extract_name(data : Json) -> String? {
      #|  match data {
      #|    { "user": { "name": String(name), .. }, .. } => Some(name)
      #|    _ => None
      #|  }
      #|}
      #|
      #|let data : Json = { "user": { "name": "Alice", "age": 30 } }
      #|extract_name(data)
    ),
  )
  assert_true(
    result
    is Success(
      Constructor(
        {
          val: { name: "Some", fields: [{ value: String("Alice"), .. }, ..], },
          ..
        }
      ),
      _
    ),
  )
}
