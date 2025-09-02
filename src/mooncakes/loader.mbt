///|
pub async fn load_module(
  mod_name : String,
  version? : String,
) -> Array[@interpreter.RuntimeModule] noraise {
  let mod_name = mod_name + (if version is Some(v) { "@" + v } else { "" })
  let modules = []

  // 获取模块元信息
  let url = "https://mooncakes.io/assets/\{mod_name}/resource.json"
  let info = @mio.get(url).json() catch { _ => {} }
  let meta = if info is { "meta_info": meta_info, .. } {
    @json.from_json(meta_info) catch {
      _ => @interpreter.ModuleInfo::new("")
    }
  } else {
    @interpreter.ModuleInfo::new("")
  }

  // 处理依赖模块
  if info is { "meta_info": meta_info, .. } {
    match meta_info {
      Object(obj) =>
        match obj.get("deps") {
          Some(String(name)) => {
            let dep_modules = load_module(name)
            for dep_module in dep_modules {
              modules.push(dep_module)
            }
          }
          Some(Object(deps_obj)) => {
            // 收集所有依赖名称
            let dep_names = []
            for name, version in deps_obj {
              if version is String(version) {
                dep_names.push(name + "@" + version)
              } else {
                dep_names.push(name)
              }
            }
            // 加载所有依赖
            for name in dep_names {
              let dep_modules = load_module(name)
              for dep_module in dep_modules {
                modules.push(dep_module)
              }
            }
          }
          _ => ()
        }
      _ => ()
    }
  }
  let url = "https://mooncakes.io/assets/\{mod_name}/module_index.json"
  let module_index = @mio.get(url).json() catch { _ => {} }
  let pkgs : Map[String, @interpreter.RuntimePackage] = {}

  // 解析 module_index.json 中的包信息
  if module_index is { "childs": Array(childs), .. } {
    for child in childs {
      if child is { "name": String(pkg_name), "package": package_info, .. } {
        if package_info is { "path": String(path), .. } {
          match load_package(path, {}) {
            Some(pkg) => pkgs.set(pkg_name, pkg)
            None => ()
          }
        }
      }
    }
  }
  modules.push(@interpreter.RuntimeModule::{ meta, pkgs })
  modules
}

///|
pub async fn load_package(
  pkg_name : String,
  deps : Map[String, @interpreter.RuntimePackage],
) -> @interpreter.RuntimePackage? noraise {
  let url = "https://mooncakes.io/assets/\{pkg_name}/resource.json"
  let info = @mio.get(url).json() catch { _ => {} }
  let sources : Map[String, String] = {}
  if info is { "source_files": Array(source_files), .. } {
    for file in source_files {
      if file is String(name) {
        let source = @mio.get("https://mooncakes.io/assets/\{pkg_name}/\{name}").text() catch {
          _ => ""
        }
        sources.set(name, source)
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
