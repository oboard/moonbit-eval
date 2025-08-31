///|
pub async fn load_package(
  pkg : String,
) -> Map[String, @interpreter.RuntimeModule] noraise {
  let interpreter = @interpreter.ClosureInterpreter::new()
  let url = "https://mooncakes.io/assets/\{pkg}/module_index.json"
  let module_index = @mio.get(url).json() catch { _ => {} }
  let deps = if module_index is { "childs": Array(childs), .. } {
    let deps : Map[String, @interpreter.RuntimeModule] = {}
    while childs.pop() is Some(String(name)) {
      load_package(name).each(deps.set(_, _))
    }
    deps
  } else {
    {}
  }
  let url = "https://mooncakes.io/assets/\{pkg}/resource.json"
  let info = @mio.get(url).json() catch { _ => {} }
  let sources = []
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
      sources.push(source)
      let (impls, _diagnostics) = @moonbitlang/parser.parse_string(source)
      impls.each(node => {
        interpreter.start()
        interpreter.top_visit(node) |> ignore
        interpreter.stop()
      }) catch {
        _ => println("error loading source file: \{name}")
      }
    }
    let env = interpreter.current_module.env
    deps.set(pkg, @interpreter.RuntimeModule::{ meta: meta_info, env, deps })
    return deps
  }
  return {}
}
