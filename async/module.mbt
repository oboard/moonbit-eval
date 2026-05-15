///|
let async_pkg : @core.RuntimePackage = @core.RuntimePackage::new(
  "moonbitlang/async",
  files={
    "async.mbt": (
      #|pub(all) enum RetryMethod {
      #|  Immediate
      #|  FixedDelay(Int)
      #|  ExponentialDelay(initial~ : Int, factor~ : Double, maximum~ : Int)
      #|}
      #|
      #|pub async fn[X] retry(
      #|  _method : RetryMethod,
      #|  max_retry? : Int = 0,
      #|  fatal_error? : (Error) -> Bool,
      #|  f : async () -> X,
      #|) -> X = "%eval.async.retry"
      #|
      #|pub async fn[X] with_timeout(
      #|  _time : Int,
      #|  f : async () -> X,
      #|  error? : Error,
      #|) -> X = "%eval.async.with_timeout"
    ),
  },
)

///|
let async_io_pkg : @core.RuntimePackage = @core.RuntimePackage::new(
  "moonbitlang/async/io",
  files={
    "data.mbt": (
      #|pub struct Data {
      #|  text : String
      #|}
      #|
      #|pub fn Data::text(self : Data) -> String {
      #|  self.text
      #|}
    ),
  },
)

///|
let async_http_pkg : @core.RuntimePackage = @core.RuntimePackage::new(
  "moonbitlang/async/http",
  files={
    "http.mbt": (
      #|import {
      #|  "moonbitlang/async/io"
      #|}
      #|
      #|pub struct Cookie {
      #|  name : String
      #|  value : String
      #|}
      #|
      #|pub struct Response {
      #|  code : Int
      #|  reason : String
      #|  headers : Map[String, String]
      #|  cookies : Array[Cookie]
      #|}
      #|
      #|pub async fn get(
      #|  url : String,
      #|  headers? : Map[String, String],
      #|  body? : Data,
      #|  proxy? : Unit,
      #|) -> (Response, Data) = "%eval.async.http.get"
    ),
  },
)

///|
fn run_async_main(f : async () -> Unit) -> Unit {
  @moon_async.run_async_main(f)
}

///|
async fn http_get(url : String) -> (@http.Response, &@io.Data) {
  @http.get(url)
}

///|
let _keep_public_async_bindings : Unit = {
  ignore(run_async_main)
  ignore(http_get)
}

///|
#external
priv type JsHttpResult

///|
extern "js" fn sync_http_get(url : String) -> JsHttpResult =
  #| (url) => {
  #|   const { Worker } = require("node:worker_threads")
  #|   const maxBytes = 1024 * 1024
  #|   const headerBytes = 16
  #|   const buffer = new SharedArrayBuffer(headerBytes + maxBytes)
  #|   const state = new Int32Array(buffer, 0, 4)
  #|   const body = new Uint8Array(buffer, headerBytes, maxBytes)
  #|   const worker = new Worker(`
  #|     const { parentPort, workerData } = require("node:worker_threads")
  #|     const state = new Int32Array(workerData.buffer, 0, 4)
  #|     const body = new Uint8Array(workerData.buffer, workerData.headerBytes, workerData.maxBytes)
  #|     ;(async () => {
  #|       try {
  #|         const response = await fetch(workerData.url)
  #|         const text = await response.text()
  #|         const bytes = new TextEncoder().encode(text)
  #|         const len = Math.min(bytes.length, workerData.maxBytes)
  #|         body.set(bytes.subarray(0, len))
  #|         Atomics.store(state, 1, response.status)
  #|         Atomics.store(state, 2, len)
  #|         Atomics.store(state, 3, bytes.length > workerData.maxBytes ? 1 : 0)
  #|       } catch (error) {
  #|         const bytes = new TextEncoder().encode(String(error && error.message || error))
  #|         const len = Math.min(bytes.length, workerData.maxBytes)
  #|         body.set(bytes.subarray(0, len))
  #|         Atomics.store(state, 1, -1)
  #|         Atomics.store(state, 2, len)
  #|       } finally {
  #|         Atomics.store(state, 0, 1)
  #|         Atomics.notify(state, 0, 1)
  #|       }
  #|     })()
  #|   `, { eval: true, workerData: { url, buffer, headerBytes, maxBytes } })
  #|   const waitResult = Atomics.wait(state, 0, 0, 10000)
  #|   worker.terminate()
  #|   const len = Atomics.load(state, 2)
  #|   const text = new TextDecoder().decode(body.subarray(0, len))
  #|   if (waitResult === "timed-out") {
  #|     return { code: -1, text: "HTTP request timed out", truncated: false }
  #|   }
  #|   return {
  #|     code: Atomics.load(state, 1),
  #|     text,
  #|     truncated: Atomics.load(state, 3) === 1,
  #|   }
  #| }

///|
extern "js" fn JsHttpResult::code(self : JsHttpResult) -> Int =
  #| (result) => result.code

///|
extern "js" fn JsHttpResult::text(self : JsHttpResult) -> String =
  #| (result) => result.text

///|
fn last_fn_arg(
  ctx : @core.RuntimeFunctionContext,
) -> @core.WithType[@core.RuntimeFunction]? {
  let mut result = None
  for arg in ctx.args {
    if arg.val is @core.RuntimeValue::Fn(func) {
      result = Some(func)
    }
  }
  result
}

///|
fn string_pos_arg(ctx : @core.RuntimeFunctionContext, index : Int) -> String? {
  let mut pos = 0
  for arg in ctx.args {
    if arg.kind is @core.RuntimeArgumentKind::Positional {
      if pos == index {
        return match arg.val {
          @core.RuntimeValue::String(value) => Some(value)
          _ => None
        }
      }
      pos = pos + 1
    }
  }
  None
}

///|
let eval_async_with_timeout_fn : @core.RuntimeFunction = ctx => {
  match last_fn_arg(ctx) {
    Some(func) => ctx.context.call(func.val, ctx.pkg, [])
    None => @core.RuntimeValue::Unit
  }
}

///|
let eval_async_retry_fn : @core.RuntimeFunction = ctx => {
  match last_fn_arg(ctx) {
    Some(func) => ctx.context.call(func.val, ctx.pkg, [])
    None => @core.RuntimeValue::Unit
  }
}

///|
fn response_to_value(
  pkg : @core.RuntimePackage,
  response : @http.Response,
) -> @core.RuntimeValue {
  pkg.cons_with_labels("Response", [
    (Some("code"), @core.RuntimeValue::Int(response.code, raw=None), false),
    (Some("reason"), @core.RuntimeValue::String(response.reason), false),
    (Some("headers"), @core.RuntimeValue::Map({}), false),
    (Some("cookies"), @core.RuntimeValue::Array([]), false),
  ])
}

///|
fn data_to_value(
  pkg : @core.RuntimePackage,
  text : String,
) -> @core.RuntimeValue {
  pkg.cons_with_labels("Data", [
    (Some("text"), @core.RuntimeValue::String(text), false),
  ])
}

///|
let eval_async_http_get_fn : @core.RuntimeFunction = ctx => {
  match string_pos_arg(ctx, 0) {
    Some(url) => {
      let http_pkg = ctx.context.find_pkg("http")
      let io_pkg = http_pkg.deps
        .get("moonbitlang/async/io")
        .unwrap_or(http_pkg.deps.get("io").unwrap_or(http_pkg))
      let result = sync_http_get(url)
      let code = result.code()
      if code < 0 {
        raise @core.control_error(result.text())
      }
      @core.RuntimeValue::Tuple([
        response_to_value(http_pkg, {
          code,
          reason: "",
          headers: {},
          cookies: [],
        }),
        data_to_value(io_pkg, result.text()),
      ])
    }
    None => @core.RuntimeValue::Unit
  }
}

///|
#alias(module)
pub fn module_() -> @core.RuntimeModule {
  {
    meta: @core.ModuleInfo::new(
      "moonbitlang/async",
      version="0.19.0",
      description="Injected async runtime bindings for oboard/eval",
    ),
    pkgs: {
      "async": async_pkg,
      "moonbitlang/async": async_pkg,
      "io": async_io_pkg,
      "moonbitlang/async/io": async_io_pkg,
      "http": async_http_pkg,
      "moonbitlang/async/http": async_http_pkg,
    },
    embedded_fns: {
      "%eval.async.retry": eval_async_retry_fn,
      "%eval.async.with_timeout": eval_async_with_timeout_fn,
      "%eval.async.http.get": eval_async_http_get_fn,
    },
  }
}
