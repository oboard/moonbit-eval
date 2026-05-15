///|
test "import_core_package_for_expression_eval" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|import {
        #|  "moonbitlang/core/list"
        #|}
        #|@list.from_array([1, 2, 3])
      ),
    ),
    content="More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )
}

///|
test "import_core_package_with_alias" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|import { "moonbitlang/core/list" @linked }
        #|@linked.from_array([1, 2]).to_array()
      ),
    ),
    content="[1, 2]",
  )
}

///|
test "import_core_package_with_main_function" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval(
      (
        #|import {
        #|  "moonbitlang/core/list"
        #|}
        #|fn main {
        #|  @list.from_array([1, 2, 3]).to_array()
        #|}
      ),
    ),
    content="[1, 2, 3]",
  )
}

///|
test "core_packages_are_not_loaded_by_default" {
  let vm = MoonBitVM::new()
  inspect(
    vm.eval("@list.from_array([1, 2, 3])"),
    content="Error: execute_function_by_name method @main.from_array not found",
  )
}
