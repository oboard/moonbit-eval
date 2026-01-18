///|
/// 解释器性能基准测试
/// 测试核心性能路径：表达式求值、模式匹配、函数调用

// 表达式求值基准测试
test "benchmark_arithmetic_expressions" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "1 + 2 * 3 - 4 / 2 + (5 * 6) - 7"
  b.bench(fn() { b.keep(vm.eval(code)) })
}

// 变量访问基准测试

///|
test "benchmark_variable_access" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)

  // 设置变量
  vm.eval("let x = 42; let y = 100; let z = x + y") |> ignore
  b.bench(fn() { b.keep(vm.eval("x + y + z")) })
}

// 函数调用基准测试

///|
test "benchmark_function_calls" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "fn add(x, y) { x + y }; fn mul(x, y) { x * y }; fn complex(a, b, c) { add(mul(a, b), c) }; complex(10, 20, 30)"
  b.bench(fn() { b.keep(vm.eval(code)) })
}

// 数组操作基准测试

///|
test "benchmark_array_operations" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]; let sum = arr[0] + arr[1] + arr[2] + arr[3] + arr[4]; sum"
  b.bench(fn() { b.keep(vm.eval(code)) })
}

// 递归函数基准测试

///|
test "benchmark_recursive_functions" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "fn fibonacci(n) { if n <= 1 { n } else { fibonacci(n - 1) + fibonacci(n - 2) } }; fibonacci(10)"
  b.bench(fn() { b.keep(vm.eval(code)) })
}

// 尾递归优化测试 - 证明算法比数据结构更重要

///|
test "benchmark_tail_recursive_fibonacci" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "fn fib_tail(n, a, b) { if n == 0 { a } else { fib_tail(n - 1, b, a + b) } }; fn fibonacci_fast(n) { fib_tail(n, 0, 1) }; fibonacci_fast(10)"
  b.bench(fn() { b.keep(vm.eval(code)) })
}

// 迭代版本测试 - 最优算法

///|
test "benchmark_iterative_fibonacci" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "fn fibonacci_iter(n) { let mut a = 0; let mut b = 1; let mut i = 0; while i < n { let temp = a + b; a = b; b = temp; i = i + 1 }; a }; fibonacci_iter(10)"
  b.bench(fn() { b.keep(vm.eval(code)) })
}

// 复杂表达式基准测试

///|
test "benchmark_complex_expressions" (b : @bench.T) {
  let vm = MoonBitVM::new(log=false)
  let code = "let a = 10; let b = 20; let c = 30; (a + b) * c - (a * b) + (c / 2) - (a - b)"
  b.bench(fn() { b.keep(vm.eval(code)) })
}
