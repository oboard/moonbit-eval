// =============================================================================
// PACKAGE SYSTEM TESTS
// =============================================================================
// Tests for module system, package imports, and cross-package method calls

///|
test "module" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("let max_value = 1").to_string(), "()")
  assert_eq(vm.eval("max_value").to_string(), "1")
  assert_eq(vm.eval("@int.max_value").to_string(), "2147483647")
  // println(vm.interpreter.current_module.deps["int"].env.values["max_value"])
  // println(vm.interpreter.current_module.deps["int"].env.struct_methods)
  // println(vm.interpreter.current_module.deps["int"].env.struct_methods["Int"])
  // println(vm.interpreter.current_module.deps["int"].env.struct_methods["Int"]["abs"])
  assert_eq(vm.eval("@int.abs(-1)").to_string(), "1")
}

///|
test "math" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@math.abs(-1.0)").to_string(), "1")
  assert_eq(vm.eval("@math.abs").to_string(), "(x: Double) -> Double")
}

///|
test "bigint" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@bigint.zero").to_string(), "0")
  assert_eq(vm.eval("@bigint.radix_bit_len").to_string(), "32")
}

///|
test "cmp" {
  let vm = MoonBitVM::new()
  assert_eq(vm.eval("@cmp.maximum").to_string(), "(x: T, y: T) -> T")
  assert_eq(vm.eval("@cmp.minimum").to_string(), "(x: T, y: T) -> T")
  assert_eq(vm.eval("@cmp.maximum(1, 2)").to_string(), "2")
  assert_eq(vm.eval("@cmp.minimum(1, 2)").to_string(), "1")
}

///|
test "cross_package_method_calling" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let list = @list.of([1,2,3]); list").to_string(),
    "More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )
  assert_eq(vm.eval("list.to_array()").to_string(), "[1, 2, 3]")
  assert_eq(
    vm.eval("let arr1 : Array[Int] = [1, 2, 3, 4, 5]").to_string(),
    "()",
  )
  assert_eq(vm.eval("arr1.length()").to_string(), "5")
}

// waiting for package `zipc`
// ///|
// test "online_package" {
//   let vm = MoonBitVM::new()
//   @mio.run(() => {
//     let modules = try? @mooncakes.load_module("oboard/mimetype")
//     if modules is Ok(modules) {
//       vm.interpreter.main.deps.set(
//         "mimetype",
//         modules.get("oboard/mimetype").unwrap().pkgs["lib"],
//       )
//       println(
//         vm.eval("@minetype.new().get_type(\"txt\")") catch {
//           _ => Error("Failed to get type", vm.interpreter)
//         },
//       )
//     }
//   })
// }

// ///|
// test {
//   @mio.run(fn() {
//     async fn load(mod_name) noraise {
//       let url = "https://mooncakes.io/assets/\{mod_name}/resource.json"
//       let info = try? @mio.get(url).unwrap_json()
//       if info is Ok(a) {
//         let json = a
//         println(json)
//       } else {
//         abort("Failed to get resource.json")
//       }
//     }

//     load("oboard/mimetype")
//   })
// }

// ///|
// test {
//   @mio.run(fn() {
//     if (try? @mooncakes.load_meta("oboard/mimetype")) is Ok(a) {
//       println(a.get_zip_url())
//       let res = try? @mio.get(a.get_zip_url())
//       if res is Ok(res) {
//         if @zipc.of_bytes(res.data) is Ok(zip) {
//           println(zip.members.keys())
//         }
//       }
//     }
//   })
// }

// ///|
// test "request" {
//   @mio.run(fn() {
//     if (try? @mio.get(
//         "https://moonbitlang-mooncakes.s3.us-west-2.amazonaws.com/user/oboard/mimetype/0.1.8.zip",
//       ))
//       is Ok(res) {
//       println(res.data.length())
//       match @zipc.of_bytes(res.data) {
//         Ok(zip) => println(zip.members.size())
//         Err(e) => println(e.to_string())
//       }
//     }
//   })
// }

// ///|
// test {
//   @mio.run(fn() {
//     async fn load(mod_name) noraise {
//       let url = "https://mooncakes.io/assets/\{mod_name}/resource.json"
//       let info = try? @mio.get(url).unwrap_json()
//       if info is Ok(a) {
//         let json = a
//         println(json)
//       } else {
//         abort("Failed to get resource.json")
//       }
//     }

//     load("oboard/mimetype")
//   })
// }
