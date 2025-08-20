///|
let core_modules : Map[String, RuntimeModule] = { "int": int_module }

///|
let int_module : RuntimeModule = {
  meta: ModuleMeta::new("moonbitlang/core/int"),
  env: {
    fn_aliases: {},
    deps: {},
    struct_methods: {},
    type_definitions: {},
    type_environments: [],
    mutable_vars: {},
    values: {
      "max_value": Int(@int.max_value),
      "min_value": Int(@int.min_value),
    },
    parent: None,
  },
}
