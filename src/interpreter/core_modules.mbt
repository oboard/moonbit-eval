///|
let core_modules : Map[String, RuntimeModule] = { "int": int_module }

///|
fn dummy_loc() -> @basic.Location {
  {
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
}

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
      "abs": build("if self < 0 { -self } else { self }"),
      "to_be_bytes": build("self.reinterpret_as_uint().to_be_bytes()"),
      "to_le_bytes": build("self.reinterpret_as_uint().to_le_bytes()"),
    },
    parent: None,
  },
}
