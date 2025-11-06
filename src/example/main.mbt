fn main {
  let result = @eval.MoonBitVM::new().eval("1 + 2");
  println(result);
}