// ///|
// test {
//   let result = StringBuilder::new()
//     ..write_char('a')
//     ..write_char('a')
//     ..write_object(1001)
//     ..write_string("abcdef")
//     .to_string()
//   inspect(result, content="aa1001abcdef")
// }

// ///|
// test {
//   let vm = MoonBitVM::new(log=true)
//   assert_eq(
//     vm
//     .eval(
//       (
//         #|let buf = StringBuilder::new()
//         #|
//         #|  //..write_char('a')
//         #|  //..write_object(1001)
//         #|  //..write_string("abcdef")
//         #|  //.to_string()
//       ),
//     )
//     .to_string(),
//     "()",
//   )
//   println(vm.eval("buf.write_char('a')"))
//   // println(vm.eval("buf.write_char('a')"))
//   // inspect(vm.eval("result"), content="Error: variable @main.result not found")
// }

// ///|
// test {
//   let vm = MoonBitVM::new()
//   inspect(
//     vm.eval("StringBuilder::new"),
//     content="(size_hint~: Int = 0) -> StringBuilder",
//   )
//   inspect(
//     vm.eval("StringBuilder::new()"),
//     content="@moonbitlang/core/builtin.StringBuilder::{data: [0], len: 0}",
//   )
//   inspect(
//     vm.eval("typeof(StringBuilder::new())"),
//     content="@moonbitlang/core/builtin.StringBuilder",
//   )
// }
