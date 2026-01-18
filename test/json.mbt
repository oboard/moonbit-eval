///|
test "json_value" {
  let vm = MoonBitVM::new()
  let _ = vm.eval("let simple_json : Json = 42")
  assert_eq(
    vm.eval("typeof(simple_json)").to_string(),
    "@moonbitlang/core/builtin.Json",
  )
}

///|
test "json_array" {
  let vm = MoonBitVM::new()
  vm.eval("let json_array : Json = [1, 2, 3]") |> ignore
  inspect(
    vm.eval("json_array"),
    content="Array([Number(1), Number(2), Number(3)])",
  )
  assert_eq(
    vm.eval("typeof(json_array)").to_string(),
    "@moonbitlang/core/builtin.Json",
  )
}

///|
test "json_type" {
  let vm = MoonBitVM::new()
  vm.eval("let json : Json = { \"a\": [\"1\", \"2\"], \"b\": [\"3\", \"4\"] }")
  |> ignore
  assert_eq(
    vm.eval("typeof(json)").to_string(),
    "@moonbitlang/core/builtin.Json",
  )
  assert_eq(
    vm.eval("json").to_string(),
    (
      #|Object({"a": Array([String("1"), String("2")]), "b": Array([String("3"), String("4")])})
    ),
  )
}
