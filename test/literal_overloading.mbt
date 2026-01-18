// Literal overloading test cases

///|
test "char_literals" {
  let vm = MoonBitVM::new()
  // Test character literals and conversions
  inspect(vm.eval("let c : Char = '1'"), content="()")
  assert_eq(vm.eval("c").to_string(), "1")
  inspect(vm.eval("let i : Int = '1'"), content="()")
  assert_eq(vm.eval("i").to_string(), "49")
}

///|
test "numeric_literal_overloading" {
  let vm = MoonBitVM::new()

  // Int -> UInt conversion
  inspect(vm.eval("let u : UInt = 42"), content="()")
  assert_eq(vm.eval("typeof(u)").to_string(), "@moonbitlang/core/uint.UInt")
  assert_eq(vm.eval("u").to_string(), "42")

  // Int -> Int64 conversion
  inspect(vm.eval("let i64 : Int64 = 123"), content="()")
  assert_eq(vm.eval("typeof(i64)").to_string(), "@moonbitlang/core/int64.Int64")
  assert_eq(vm.eval("i64").to_string(), "123")

  // Int -> UInt64 conversion
  inspect(vm.eval("let u64 : UInt64 = 456"), content="()")
  assert_eq(
    vm.eval("typeof(u64)").to_string(),
    "@moonbitlang/core/uint64.UInt64",
  )
  assert_eq(vm.eval("u64").to_string(), "456")

  // Int -> UInt16 conversion
  assert_eq(vm.eval("let u16 : UInt16 = 789").to_string(), "()")
  assert_eq(vm.eval("u16").to_string(), "789")
  assert_eq(
    vm.eval("typeof(u16)").to_string(),
    "@moonbitlang/core/uint16.UInt16",
  )

  // Int -> Byte conversion
  inspect(vm.eval("let b : Byte = 255"), content="()")
  assert_eq(vm.eval("typeof(b)").to_string(), "@moonbitlang/core/byte.Byte")
  assert_eq(vm.eval("b").to_string(), "255")

  // Int -> Double conversion
  inspect(vm.eval("let d : Double = 42"), content="()")
  assert_eq(vm.eval("typeof(d)").to_string(), "@moonbitlang/core/double.Double")
  assert_eq(vm.eval("d").to_string(), "42")

  // Int -> Float conversion
  inspect(vm.eval("let f : Float = 42"), content="()")
  assert_eq(vm.eval("typeof(f)").to_string(), "@moonbitlang/core/float.Float")
  assert_eq(vm.eval("f").to_string(), "42")
}

///|
test "char_literal_overloading" {
  let vm = MoonBitVM::new()

  // Char -> Int conversion (ASCII value)
  inspect(vm.eval("let i : Int = 'A'"), content="()")
  assert_eq(vm.eval("i").to_string(), "65")

  // Char -> Byte conversion
  inspect(vm.eval("let b : Byte = 'Z'"), content="()")
  assert_eq(vm.eval("b").to_string(), "90")

  // Multiple char conversions
  inspect(vm.eval("let zero : Int = '0'"), content="()")
  assert_eq(vm.eval("zero").to_string(), "48")
  inspect(vm.eval("let nine : Int = '9'"), content="()")
  assert_eq(vm.eval("nine").to_string(), "57")
}

///|
test "string_literal_overloading" {
  let vm = MoonBitVM::new()

  // simple string to bytes conversion
  assert_eq(vm.eval("(\"hello\" as Bytes)").to_string(), "b\"hello\"")

  // String -> Bytes conversion - test in single eval call
  // Verify the type is correctly converted to Bytes
  assert_eq(vm.eval("let b : Bytes = \"hello\"; b.length()").to_string(), "5")
  inspect(vm.eval("typeof(b)"), content="@moonbitlang/core/bytes.Bytes")
}

///|
test "array_literal_overloading" {
  let vm = MoonBitVM::new()

  // Array of Ints -> Bytes conversion
  assert_eq(
    vm.eval("let bytes : Bytes = [72, 101, 108, 108, 111]").to_string(),
    "()",
  )
  assert_eq(
    vm.eval("typeof(bytes)").to_string(),
    "@moonbitlang/core/bytes.Bytes",
  )
  // Verify it's converted to Bytes type
  assert_eq(
    vm.eval("bytes.length()").to_string(),
    (
      #|5
    ),
  )

  // Array of Chars -> String conversion
  inspect(vm.eval("let str : String = ['H', 'i']"), content="()")
  assert_eq(vm.eval("str").to_string(), "Hi")

  // Array -> ArrayView conversion
  inspect(vm.eval("let view : ArrayView[Int] = [1, 2, 3, 4, 5]"), content="()")
  inspect(vm.eval("typeof(view)"), content="@moonbitlang/core/array.ArrayView")
  // Verify it's converted to ArrayView type
  inspect(vm.eval("view"), content="[1, 2, 3, 4, 5]")
}

///|
test "double_literal_overloading" {
  let vm = MoonBitVM::new()

  // Double -> Float conversion (precision may vary)
  let float_result = vm.eval("(3.14 : Float)").to_string()
  assert_true(float_result.contains("3.14"))

  // Large double -> Float (precision test)
  inspect(vm.eval("let big_f : Float = 123.456789"), content="()")
  inspect(vm.eval("typeof(big_f)"), content="@moonbitlang/core/float.Float")
  let result = vm.eval("big_f").to_string()
  // Float should have the value (precision may differ)
  assert_true(result.contains("123"))
}

///|
test "complex_overloading_scenarios" {
  let vm = MoonBitVM::new()

  // Mixed type array with overloading
  inspect(vm.eval("let mixed_bytes : Bytes = [65, 66, 67]"), content="()")
  let mixed_result = vm.eval("mixed_bytes")
  assert_eq(mixed_result.to_string() == "[65, 66, 67]", false)

  // Nested overloading in expressions (test direct evaluation)
  assert_eq(vm.eval("((10 + 20) as UInt)").to_string(), "30")

  // Function parameter overloading
  inspect(
    vm.eval("fn test_param(x : UInt64) -> UInt64 { x }"),
    content="(UInt64) -> UInt64",
  )
  inspect(vm.eval("test_param(42)"), content="42")
}

///|
test "overloading_edge_cases" {
  let vm = MoonBitVM::new()

  // Zero values
  inspect(vm.eval("let zero_uint : UInt = 0"), content="()")
  assert_eq(vm.eval("zero_uint").to_string(), "0")

  // Negative to unsigned (should handle gracefully)
  // Note: This might fail or wrap around depending on implementation
  // inspect(vm.eval("let neg_uint : UInt = -1"), content="()")

  // Maximum values for small types
  inspect(vm.eval("let max_byte : Byte = 255"), content="()")
  assert_eq(vm.eval("max_byte").to_string(), "255")

  // Empty array overloading
  inspect(vm.eval("let empty_bytes : Bytes = []"), content="()")
  let empty_result = vm.eval("empty_bytes")
  assert_eq(empty_result.to_string() == "[]", false)
}
