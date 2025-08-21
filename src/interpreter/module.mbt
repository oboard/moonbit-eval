///|
pub(all) struct RuntimeModule {
  meta : ModuleMeta
  mut env : RuntimeEnvironment
  deps : Map[String, RuntimeModule]
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
  deps~ : Map[String, RuntimeModule],
  builder : (RuntimeEnvironment, (String) -> (String?, RuntimeValue)) -> Map[
    String,
    (String?, RuntimeValue),
  ],
) -> RuntimeModule {
  let values = {}
  let struct_methods = {}
  let env = RuntimeEnvironment::new(values~, struct_methods~)
  ///|
  fn build(code : String) -> (String?, RuntimeValue) {
    if code.has_prefix("pub") || code.has_prefix("fn") {
      let impl_ = parse_code_to_impl(code)
      if impl_ is Ok(impl_) {
        return env.top_func_def_to_closure(impl_)
      }
    }
    let expr = parse_code_to_expr(code)
    (
      None,
      match expr {
        Ok(expr) =>
          match expr {
            Function(func~, ..) => Closure(func, env.create_closure_env())
            _ =>
              Closure(
                @syntax.Func::Lambda(
                  parameters=@list.of([
                    Positional(
                      binder={ name: "self", loc: dummy_loc() },
                      ty=None,
                    ),
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
        Err(_) => Unit
      },
    )
  }

  builder(env, build).each(fn(key, value) {
    if value.0 is Some(name) {
      if !struct_methods.contains(name) {
        struct_methods.set(name, {})
      }
      struct_methods.get(name).unwrap().set(key, value.1)
    }
    values.set(key, value.1)
  })
  { meta: ModuleMeta::new(pkg), env, deps: {} }
}
