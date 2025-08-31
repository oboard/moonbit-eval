// =============================================================================
// PATTERN MATCHING TESTS
// =============================================================================

///|
test "basic_pattern_matching" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match 5 {
        #|  1 => "one"
        #|  2 => "two"
        #|  x => "other: " + x.to_string()
        #|}
      ),
    ),
    content="other: 5",
  )
  inspect(
    vm.eval(
      (
        #|match 2 {
        #|  1 => "one"
        #|  2 => "two"
        #|  x => "other: " + x.to_string()
        #|}
      ),
    ),
    content="two",
  )
}

///|
test "or_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match 3 {
        #|  1 | 2 | 3 => "small"
        #|  _ => "large"
        #|}
      ),
    ),
    content="small",
  )
  inspect(
    vm.eval(
      (
        #|match 5 {
        #|  1 | 2 | 3 => "small"
        #|  _ => "large"
        #|}
      ),
    ),
    content="large",
  )
}

///|
test "tuple_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match (1, 2) {
        #|  (0, y) => "first is zero, second is " + y.to_string()
        #|  (x, 0) => "first is " + x.to_string() + ", second is zero"
        #|  (x, y) => "first is " + x.to_string() + ", second is " + y.to_string()
        #|}
      ),
    ),
    content="first is 1, second is 2",
  )
}

///|
test "array_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match [1, 2, 3] {
        #|  [] => "empty"
        #|  [x] => "single: " + x.to_string()
        #|  [x, y] => "pair: " + x.to_string() + ", " + y.to_string()
        #|  [x, y, z] => "triple: " + x.to_string() + ", " + y.to_string() + ", " + z.to_string()
        #|  _ => "other"
        #|}
      ),
    ),
    content="triple: 1, 2, 3",
  )
}

///|
test "record_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|struct Point { x : Int; y : Int }
        #|let p = { x: 1, y: 2 }
        #|match p {
        #|  { x: 0, y } => "x is zero, y is " + y.to_string()
        #|  { x, y: 0 } => "x is " + x.to_string() + ", y is zero"
        #|  { x, y } => "x is " + x.to_string() + ", y is " + y.to_string()
        #|}
      ),
    ),
    content="x is 1, y is 2",
  )
}

///|
test "nested_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match (Some(1), Some(2)) {
        #|  (Some(x), Some(y)) => "both some: " + x.to_string() + ", " + y.to_string()
        #|  (Some(x), None) => "first some: " + x.to_string()
        #|  (None, Some(y)) => "second some: " + y.to_string()
        #|  (None, None) => "both none"
        #|}
      ),
    ),
    content="both some: 1, 2",
  )
}

///|
test "range_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match 5 {
        #|  1..=3 => "low"
        #|  4..=6 => "medium"
        #|  7..=9 => "high"
        #|  _ => "other"
        #|}
      ),
    ),
    content="medium",
  )
}

///|
test "constructor_patterns" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|enum Color {
        #|  Red
        #|  Green
        #|  Blue
        #|  RGB(Int, Int, Int)
        #|}
        #|let color = RGB(255, 0, 0)
        #|match color {
        #|  Red => "red"
        #|  Green => "green"
        #|  Blue => "blue"
        #|  RGB(r, g, b) => "rgb(" + r.to_string() + ", " + g.to_string() + ", " + b.to_string() + ")"
        #|}
      ),
    ),
    content="rgb(255, 0, 0)",
  )
}

///|
test "match_as_pattern" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|match Some(42) {
        #|  Some(x) as opt => "value: " + x.to_string()
        #|  None => "none"
        #|}
      ),
    ),
    content="value: 42",
  )
}
