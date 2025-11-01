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
  assert_eq(vm.eval("@math.abs").to_string(), "(Double) -> Double")
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
  assert_eq(vm.eval("@cmp.maximum").to_string(), "(T, T) -> T")
  assert_eq(vm.eval("@cmp.minimum").to_string(), "(T, T) -> T")
  assert_eq(vm.eval("@cmp.maximum(1, 2)").to_string(), "2")
  assert_eq(vm.eval("@cmp.minimum(1, 2)").to_string(), "1")
}

///|
test "cross_package_method_calling" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("let list = @list.from_array([1,2,3]); list").to_string(),
    "More(1, tail=More(2, tail=More(3, tail=Empty)))",
  )
  assert_eq(vm.eval("list.to_array()").to_string(), "[1, 2, 3]")
  assert_eq(
    vm.eval("let arr1 : Array[Int] = [1, 2, 3, 4, 5]").to_string(),
    "()",
  )
  assert_eq(vm.eval("arr1.length()").to_string(), "5")
}

///|
test "online_package" {
  let vm = MoonBitVM::new()
  @mio.run(() => {
    let modules = try? @mooncakes.load_module("wangweigang/hello")
    if modules is Ok(modules) {
      vm.interpreter.main_pkg.deps.set(
        "hello",
        modules.get("wangweigang/hello").unwrap().pkgs["hello"],
      )
      println(vm.eval("@hello.hello()"))
    }
  })
}

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

///|
// test {
//   @mio.run(fn() {
//     let module_name = "oboard/mimetype"
//     if (try? @mooncakes.load_meta(module_name)) is Ok(a) {
//       let res = try? @mio.get(a.get_zip_url())
//       if res is Ok(res) {
//         if (try? @zip.Archive::of_bytes(res.data)) is Ok(zip) {
//           if zip.find(@fpath.Fpath("moon.mod.json")) is Some(m) {
//             if m.kind() is File(data) {
//               let module_info : @interpreter.ModuleInfo = @json.from_json(
//                 @json.parse(@encoding/utf8.decode(data.to_bytes())),
//               ) catch {
//                 _ => abort("Failed to read moon.mod.json")
//               }
//               // println(module_info)
//               let root = if module_info.source is Some(source) {
//                 source
//               } else {
//                 ""
//               }
//               // println(root)
//               fn collect_files(root : String) -> Map[String, String] {
//                 let files = {}
//                 for entry in zip.to_array() {
//                   if entry.kind() is File(file) {
//                     let path = entry.path().to_string()
//                     if path.has_prefix(root) && path.has_suffix(".mbt") {
//                       try {
//                         files[path] = @encoding/utf8.decode(file.to_bytes())
//                       } catch {
//                         _ => abort("Failed to decode file content")
//                       }
//                     }
//                   }
//                 }
//                 files
//               }
//               // 找出所有的 packages
//               fn scan_packages() -> Array[@interpreter.RuntimePackage] {
//                 let pkgs = []
//                 for entry in zip.to_array() {
//                   if entry.is_dir() {
//                     let dir = entry.path().to_string()
//                     if zip.find(@fpath.Fpath(dir + "moon.pkg.json")) is Some(_) {
//                       let pkg_name = module_name +
//                         dir.strip_prefix(root).unwrap_or(dir).to_string()
//                       // println(pkg_name)
//                       // println(dir)
//                       pkgs.push(
//                         @interpreter.RuntimePackage::new(
//                           pkg_name,
//                           files=collect_files(dir),
//                         ),
//                       )
//                     }
//                   }
//                 }
//                 pkgs
//               }

//               let packages = scan_packages()

//             }
//           }
//         }
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
