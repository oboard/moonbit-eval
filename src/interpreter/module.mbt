///|
pub(all) struct RuntimeModule {
  meta : ModuleMeta
  env : RuntimeEnvironment
}

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
