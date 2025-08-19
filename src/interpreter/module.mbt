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
