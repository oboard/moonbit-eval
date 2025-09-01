///|
pub async fn load_package(
  pkg : String,
) -> Map[String, @interpreter.RuntimePackage] noraise {
  let url = "https://mooncakes.io/assets/\{pkg}/module_index.json"
  let module_index = @mio.get(url).json() catch { _ => {} }
  let deps = if module_index is { "childs": Array(childs), .. } {
    let deps : Map[String, @interpreter.RuntimePackage] = {}
    while childs.pop() is Some(String(name)) {
      load_package(name).each(deps.set(_, _))
    }
    deps
  } else {
    {}
  }
  let url = "https://mooncakes.io/assets/\{pkg}/resource.json"
  let info = @mio.get(url).json() catch { _ => {} }
  let sources = {}
  if info
    is {
      "meta_info": meta_info,
      "source_files": Array(source_files),
      "deps": Array(dep_names),
      ..
    } {
    while dep_names.pop() is Some(String(name)) {
      load_package(name).each(deps.set(_, _))
    }
    let meta_info = @json.from_json(meta_info) catch {
      _ => @interpreter.ModuleMeta::new("")
    }
    while source_files.pop() is Some(String(name)) {
      let source = @mio.get("https://mooncakes.io/assets/\{pkg}/\{name}").text() catch {
        _ => ""
      }
      sources.set(name, source)
    }
    deps.set(pkg, @interpreter.RuntimePackage::{
      meta: meta_info,
      stubs: Map::new(),
      type_definitions: Map::new(),
      struct_methods: Map::new(),
      traits: Map::new(),
      values: Map::new(),
      fn_aliases: Map::new(),
      type_aliases: Map::new(),
      env: @interpreter.RuntimeEnvironment::new(),
      deps,
      files: sources,
      loaded: false,
    })
    return deps
  }
  return {}
}
