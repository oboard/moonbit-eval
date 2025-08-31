///|
pub(all) struct RuntimeModule {
  meta : ModuleMeta
  mut env : RuntimeEnvironment
  deps : Map[String, RuntimeModule]
} derive(ToJson)

// TODO: reflactor package struct
// pub(all) struct MoonBitPackage {
//   name: String
//   traits: Map[String, @syntax.TraitDecl]
//   errors: Map[String, String]
//   types: Map[String, RuntimeType]
//   typealiases: Map[String, String]
//   values: Map[String, RuntimeValue]
// }

///|
/// 模块元数据
pub(all) struct ModuleMeta {
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

///|
/// 模块元数据构造函数
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
    if code.has_prefix("pub") ||
      code.has_prefix("fn") ||
      code.has_prefix("enum") {
      let impl_ = parse_code_to_impl(code)
      if impl_ is Ok(impl_) {
        if impl_ is TopFuncDef(_) {
          return env.top_func_def_to_closure(impl_)
        }
        if impl_ is TopTypeDef(def) {
          match def {
            { tycon, params, components, .. } => {
              env.type_definitions.set(tycon, def)
              env.struct_methods.set(tycon, Map::new())

              // 处理泛型类型参数
              let type_params = []
              for param in params {
                match param {
                  { name, .. } => type_params.push(name)
                }
              } else {
                ()
              }

              // 注册枚举构造函数到运行时环境
              match components {
                Variant(constructors) =>
                  for constr in constructors {
                    let constr_name = constr.name.name
                    env.type_definitions.set(constr_name, def)
                  } else {
                    ()
                  }
                _ => () // Record类型不需要注册构造函数
              }
            }
          }
          return (None, Unit)
        }
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
  { meta: ModuleMeta::new(pkg), env, deps }
}

///|
/// 构造 Constructor
pub fn RuntimeModule::cons(
  self : RuntimeModule,
  name : String,
  args : Array[RuntimeValue],
) -> RuntimeValue {
  let fields = args.map(value => { name: None, value, mutable: false })
  Constructor({ val: { name, fields }, type_info: self.find_static_type(name) })
}

///|
/// 构造带标签参数的 Constructor
pub fn RuntimeModule::cons_with_labels(
  self : RuntimeModule,
  name : String,
  labeled_args : Array[(String?, RuntimeValue, Bool)], // (label, value, mutable)
) -> RuntimeValue {
  let fields = labeled_args.map(fn(arg) {
    let (label, value, mutable) = arg
    { name: label, value, mutable }
  })
  Constructor({ val: { name, fields }, type_info: self.find_static_type(name) })
}
