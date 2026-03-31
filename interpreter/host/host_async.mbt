///|
pub async fn[T, E : Error] async_suspend(
  cb : ((T) -> Unit, (E) -> Unit) -> Unit,
) -> T raise E = "%async.suspend"

///|
pub fn run_async(f : async () -> Unit noraise) = "%async.run"
