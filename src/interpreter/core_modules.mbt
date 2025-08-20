///|
let core_modules : Map[String, RuntimeModule] = { "int": int_module }

///|
let int_module : RuntimeModule = {
  meta: ModuleMeta::new("moonbitlang/core/int"),
  env: RuntimeEnvironment::new(),
}
