///|
let url_base = "https://moonbitlang-mooncakes.s3.us-west-2.amazonaws.com/user"

///|
pub(all) struct RuntimeModule {
  meta : ModuleInfo
  pkgs : Map[String, RuntimePackage]
} derive(ToJson)

///|
/// 包元数据
pub(all) struct ModuleInfo {
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
pub async fn ModuleInfo::get_zip_url(self : ModuleInfo) -> String noraise {
  let v = self.version.map_or("", v => "/\{v}")
  "\{url_base}/\{self.name}\{v}.zip"
}

///|
pub(all) struct RuntimePackage {
  name : String
  traits : Map[String, @syntax.TraitDecl]
  // 函数别名存储 - 存储函数名到其实际实现的映射
  fn_aliases : Map[String, RuntimeValue]
  type_aliases : Map[String, WithType[@syntax.TypeDecl]]
  // trait 别名存储 - 存储 trait 名到其实际实现的映射
  trait_aliases : Map[String, WithType[@syntax.TraitDecl]]
  // 存根 - 存储函数名到其实际实现的映射
  stubs : Map[String, String]
  // 类型定义
  type_definitions : Map[String, @syntax.TypeDecl]
  // 类型派生的trait映射 - 存储类型名到其derive的trait列表
  type_derived_traits : Map[String, Array[String]] // type_name -> [trait_name]
  // 构造函数集合 - 存储构造函数名
  constructors : Map[String, String] // constructor_name -> type_name
  struct_methods : Map[String, Map[String, RuntimeValue]]
  // trait 方法存储 - 存储 trait_id -> method_name -> function
  trait_methods : Map[String, Map[String, RuntimeValue]]
  values : Map[String, RuntimeValue]
  mut env : RuntimeEnvironment
  deps : Map[String, RuntimePackage]
  files : Map[String, String]
  mut loaded : Bool
} derive(ToJson)

///|
/// 模块元数据构造函数
pub fn ModuleInfo::new(
  name : String,
  version? : String,
  readme? : String,
  repository? : String,
  license? : String,
  keywords? : Array[String],
  description? : String,
  source? : String,
  deps? : Map[String, String],
) -> ModuleInfo {
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
pub fn RuntimePackage::new(
  pkg : String,
  deps? : Map[String, RuntimePackage],
  files? : Map[String, String],
) -> RuntimePackage {
  let env = RuntimeEnvironment::new()
  {
    name: pkg,
    traits: Map::new(),
    stubs: core_stubs,
    type_definitions: Map::new(),
    type_derived_traits: Map::new(),
    constructors: Map::new(),
    struct_methods: Map::new(),
    type_aliases: Map::new(),
    trait_aliases: Map::new(),
    fn_aliases: Map::new(),
    trait_methods: Map::new(),
    values: Map::new(),
    env,
    deps: deps.unwrap_or(Map::new()),
    files: files.unwrap_or(Map::new()),
    loaded: false,
  }
}

///|
pub fn RuntimePackage::find(
  self : RuntimePackage,
  name : String,
) -> RuntimeValue? {
  match self.env.find(name) {
    None => self.values.get(name)
    v => v
  }
}

///|
/// 构造 Constructor
pub fn RuntimePackage::cons(
  self : RuntimePackage,
  name : String,
  args : Array[RuntimeValue],
) -> RuntimeValue {
  let fields = args.map(value => { name: None, value, mutable: false })
  Constructor({ val: { name, fields }, ty: self.find_static_type(name) })
}

///|
/// 构造带标签参数的 Constructor
pub fn RuntimePackage::cons_with_labels(
  self : RuntimePackage,
  name : String,
  labeled_args : Array[(String?, RuntimeValue, Bool)], // (label, value, mutable)
) -> RuntimeValue {
  let fields = labeled_args.map(fn(arg) {
    let (label, value, mutable) = arg
    { name: label, value, mutable }
  })
  Constructor({ val: { name, fields }, ty: self.find_static_type(name) })
}

///|
///
/// 检查名称是否为构造函数
pub fn RuntimePackage::is_constructor(
  self : RuntimePackage,
  name : String,
) -> Bool {
  // 直接检查构造函数集合
  self.constructors.contains(name)
}
