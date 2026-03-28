// =============================================================================
// ASYNC BRIDGE TESTS
// =============================================================================

///|
test "async_run_executes_function_immediately" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      "fn run_async(f : async () -> Unit noraise) = \"%async.run\"",
      top=true,
    ),
  )
  inspect(vm.eval("run_async(() => 7)"), content="7")
}

///|
test "async_suspend_success" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|async fn[T, E : Error] async_suspend(
        #|  cb : ((T) -> Unit, (E) -> Unit) -> Unit,
        #|) -> T raise E = "%async.suspend"
      ),
      top=true,
    ),
  )
  inspect(vm.eval("async_suspend((ok, _err) => ok(42))"), content="42")
}

///|
test "async_suspend_error_branch" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|async fn[T, E : Error] async_suspend(
        #|  cb : ((T) -> Unit, (E) -> Unit) -> Unit,
        #|) -> T raise E = "%async.suspend"
      ),
      top=true,
    ),
  )
  inspect(
    vm.eval(
      (
        #|try {
        #|  async_suspend((_ok, err) => err("boom"))
        #|  "unreachable"
        #|} catch {
        #|  e => e
        #|}
      ),
    ),
    content="boom",
  )
}

///|
test "async_suspend_callback_not_resolved" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|async fn[T, E : Error] async_suspend(
        #|  cb : ((T) -> Unit, (E) -> Unit) -> Unit,
        #|) -> T raise E = "%async.suspend"
      ),
      top=true,
    ),
  )
  assert_eq(
    vm
    .eval(
      (
        #|async_suspend((_ok, _err) => ())
      ),
    )
    .to_string(),
    "Error: %async.suspend callback not resolved",
  )
}

///|
test "async_suspend_first_callback_wins" {
  let vm = MoonBitVM::new()
  ignore(
    vm.eval(
      (
        #|async fn[T, E : Error] async_suspend(
        #|  cb : ((T) -> Unit, (E) -> Unit) -> Unit,
        #|) -> T raise E = "%async.suspend"
      ),
      top=true,
    ),
  )
  inspect(
    vm.eval(
      (
        #|async_suspend((ok, err) => {
        #|  ok(1)
        #|  err("boom")
        #|  ok(2)
        #|})
      ),
    ),
    content="1",
  )
}
