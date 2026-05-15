///|
test "async module is injected explicitly" {
  let vm = MoonBitVM::new(modules=[@eval/async.module()])
  inspect(
    vm.eval(
      (
        #|async test "retry timeout" {
        #|  let value = @async.retry(FixedDelay(1), max_retry=3, () => {
        #|    @async.with_timeout(100, () => 42)
        #|  })
        #|  assert_true(value == 42)
        #|}
      ),
    ),
    content="()",
  )
}

///|
test "async module http get" {
  let vm = MoonBitVM::new(modules=[@eval/async.module()])
  inspect(
    vm.test_all(
      (
        #|import { "moonbitlang/async/http" }
        #|async test "https request" {
        #|  let (response, body) = @async.retry(FixedDelay(250), max_retry=3, () => {
        #|    @async.with_timeout(3000, () => @http.get("https://www.moonbitlang.com"))
        #|  })
        #|  assert_true(response.code is (200..<300), msg=response.code.to_string())
        #|  assert_true(body.text().to_lower().has_prefix("<!doctype html>"), msg=body.text())
        #|}
      ),
    ),
    content=(
      #|TestResult(total=1, passed=1, failed=0)
    ),
  )
}

///|
test "async http is loaded lazily" {
  let vm = MoonBitVM::new(modules=[@eval/async.module()])
  let result = vm.test_all(
    (
      #|async test "missing http import" {
      #|  let _ = @http.get("https://www.moonbitlang.com")
      #|}
    ),
  )
  assert_true(result.failed > 0)
}

///|
test "async module is not loaded by default" {
  let vm = MoonBitVM::new()
  assert_eq(
    vm.eval("@async.with_timeout(100, () => 1)").to_string(),
    "Error: execute_function_by_name method @main.with_timeout not found",
  )
}

///|
test "test result reports assertion failure" {
  let vm = MoonBitVM::new(modules=[@eval/async.module()])
  inspect(
    vm.test_all(
      (
        #|async test "failure" {
        #|  assert_true(false)
        #|}
      ),
    ),
    content=(
      #|TestResult(total=1, passed=0, failed=1)
      #|FAILED failure: `false` is not true
    ),
  )
}
