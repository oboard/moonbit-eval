///|
pub async fn load_meta(
  mod_name : String,
  version? : String,
) -> @interpreter.ModuleInfo raise {
  ///|
  let mod_name = mod_name + (if version is Some(v) { "@" + v } else { "" })
  // 获取模块元信息
  let url = "https://mooncakes.io/assets/\{mod_name}/resource.json"
  let info = try? @mio.get(url).unwrap_json()
  if info is Ok({ "meta_info": meta_info, .. }) {
    @json.from_json(meta_info)
  } else {
    @interpreter.ModuleInfo::new("")
  }
}

///|
pub async fn load_module(
  mod_name : String,
  version? : String,
) -> Map[String, @interpreter.RuntimeModule] raise {
  let mod_name = mod_name + (if version is Some(v) { "@" + v } else { "" })
  let modules : Map[String, @interpreter.RuntimeModule] = {}

  // 获取模块元信息
  let meta = load_meta(mod_name, version?)

  // 处理依赖模块
  if meta.deps is Some(deps) {
    // for name, version in deps {
    let deps = deps.to_array()
    while deps.pop() is Some((name, version)) {
      let dep_modules = load_module(name, version~)
      for name, dep_module in dep_modules {
        modules.set(name, dep_module)
      }
    }
  }
  let url = "https://mooncakes.io/assets/\{mod_name}/module_index.json"
  let module_index = @mio.get(url).unwrap_json()
  let pkgs : Map[String, @interpreter.RuntimePackage] = {}

  // Parse package information from module_index.json recursively
  async fn parse_child(
    child : Json,
    pkgs : Map[String, @interpreter.RuntimePackage],
  ) raise {
    if child is { "childs": Array(childs), .. } {
      while childs.pop() is Some(sub_child) {
        parse_child(sub_child, pkgs)
      }
    }
    if child is { "name": String(pkg_name), "package": package_info, .. } {
      if package_info is { "path": String(path), .. } {
        match load_package(path, pkgs) {
          Some(pkg) => pkgs.set(pkg_name, pkg)
          None => ()
        }
      }
    }
  }

  parse_child(module_index, pkgs)
  modules.set(mod_name, @interpreter.RuntimeModule::{ meta, pkgs })
  modules
}

///|
pub async fn load_package(
  pkg_name : String,
  deps : Map[String, @interpreter.RuntimePackage],
) -> @interpreter.RuntimePackage? raise {
  let url = "https://mooncakes.io/assets/\{pkg_name}/resource.json"
  let info = @mio.get(url).unwrap_json()
  let sources : Map[String, String] = {}
  if info is { "source_files": Array(source_files), .. } {
    while source_files.pop() is Some(file) {
      if file is String(name) {
        let source = @mio.get(
          "https://mooncakes.io/assets/\{pkg_name}/\{name}.html",
        ).text() catch {
          _ => ""
        }
        let start = source.find("<pre><code class=\"moonbit\">")
        let end = source.rev_find("</code></pre>")
        if (start, end) is (Some(start), Some(end)) {
          sources.set(name, source[start:end].to_string())
        }
      }
    }
    Some({
      name: pkg_name,
      traits: Map::new(),
      fn_aliases: Map::new(),
      type_aliases: Map::new(),
      trait_aliases: Map::new(),
      stubs: Map::new(),
      type_definitions: Map::new(),
      constructors: Map::new(),
      struct_methods: Map::new(),
      values: Map::new(),
      env: @interpreter.RuntimeEnvironment::new(),
      deps,
      files: sources,
      loaded: false,
    })
  } else {
    None
  }
}
