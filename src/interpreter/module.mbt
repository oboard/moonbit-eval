///|
pub(all) struct RuntimeModule {
  meta : ModuleMeta
  env : RuntimeEnvironment
} derive(ToJson)

///| 模块元数据
pub struct ModuleMeta {
  name : String
  version : String?
  deps : Map[String, String]?
  readme : String?
  repository : String?
  license : String?
  keywords : Array[String]?
  description : String?
  source : String?
} derive(Show, ToJson, FromJson)

///| 模块元数据构造函数
pub fn ModuleMeta::new(
  name : String,
  version? : String,
  readme? : String,
  repository? : String,
  license? : String,
  keywords? : Array[String],
  description? : String,
  source? : String,
  deps? : Map[String, String],
) -> ModuleMeta {
  {
    name,
    version,
    deps,
    readme,
    repository,
    license,
    keywords,
    description,
    source,
  }
}

///|
pub fn RuntimeModule::new(
  pkg : String,
  builder : (RuntimeEnvironment, (String) -> RuntimeValue) -> Map[
    String,
    RuntimeValue,
  ],
) -> RuntimeModule {
  let values = {}
  let env = RuntimeEnvironment::new(values~)
  ///|
  fn build(code : String) -> RuntimeValue {
    if code.has_prefix("pub") || code.has_prefix("fn") {
      let impl_ = parse_code_to_impl(code)
      if impl_ is Ok(impl_) {
        return env.top_func_def_to_closure(impl_)
      }
    }
    let expr = parse_code_to_expr(code)
    match expr {
      Ok(expr) =>
        match expr {
          Function(func~, ..) => Closure(func, env.create_closure_env())
          _ =>
            Closure(
              @syntax.Func::Lambda(
                parameters=@list.of([
                  Positional(binder={ name: "self", loc: dummy_loc() }, ty=None),
                ]),
                params_loc=dummy_loc(),
                body=expr,
                return_type=None,
                error_type=NoErrorType,
                kind=Arrow,
                has_error=None,
                is_async=false,
                loc=dummy_loc(),
              ),
              RuntimeEnvironment::new(),
            )
        }
      Err(error) => RuntimeValue::Error(Failure(error))
    }
  }

  builder(env, build).each(fn(key, value) { values.set(key, value) })
  { meta: ModuleMeta::new(pkg), env }
}
