///|
test "map_expressions" {
  let vm = MoonBitVM::new()
  // Test map literal expressions
  assert_eq(
    vm
    .eval(
      (
        #|let m = { "a": 1, "b": 2, "c": 3 }
        #|m["b"]
      ),
    )
    .to_string(),
    "2",
  )
}

///|
test "map_operations" {
  let vm = MoonBitVM::new()
  // Test simple Map::of creation first
  inspect(vm.eval("Map::of([])"), content="{}")

  // Test map literal creation
  inspect(
    vm.eval("let map1 = { \"key1\": 1, \"key2\": 2, \"key3\": 3 }"),
    content="()",
  )
  inspect(vm.eval("map1"), content="{\"key1\": 1, \"key2\": 2, \"key3\": 3}")
  // Test map length

  // Test map access
  inspect(vm.eval("map1[\"key1\"]"), content="1")

  // Test Map::of creation
  inspect(
    vm.eval("let map2 = Map::of([(\"key1\", 1), (\"key2\", 2), (\"key3\", 3)])"),
    content="()",
  )
  // inspect(vm.eval("map1 == map2"), content="true")

  // Test map update
  inspect(vm.eval("map1[\"key1\"] = 10"), content="()")
  inspect(vm.eval("map1"), content="{\"key1\": 10, \"key2\": 2, \"key3\": 3}")
}
