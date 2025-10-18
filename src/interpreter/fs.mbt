///|
pub let fs_package : RuntimePackage = {
  let env = RuntimeEnvironment::new()
  {
    name: "moonbitlang/x/fs",
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
    deps: Map::new(),
    files: Map::new(),
    loaded: true,
  }
}

///|
pub let fs_methods : Map[String, RuntimeFunction] = {
  "read_file": fs_read_file_fn,
  "create_dir": fs_create_dir_fn,
  "write_file": fs_write_file_fn,
  "is_dir": fs_is_dir_fn,
  "is_file": fs_is_file_fn,
  "path_exists": fs_path_exists_fn,
  "read_dir": fs_read_dir_fn,
  "read_file_to_bytes": fs_read_file_to_bytes_fn,
  "read_file_to_string": fs_read_file_to_string_fn,
  "remove_dir": fs_remove_dir_fn,
  "remove_file": fs_remove_file_fn,
  "write_bytes_to_file": fs_write_bytes_to_file_fn,
}

///|
let fs_read_file_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  Array(
    (@fs.read_dir(path) catch { IOError(msg) => raise Raise(String(msg)) }).map(
      String(_),
    ),
  )
} else {
  Unit
}

///|
let fs_create_dir_fn : RuntimeFunction = ctx => {
  if ctx.args is [{ val: String(path), .. }] {
    @fs.create_dir(path) catch {
      IOError(msg) => raise Raise(String(msg))
    }
  }
  Unit
}

///|
let fs_write_file_fn : RuntimeFunction = ctx => {
  if ctx.args is [{ val: String(path), .. }, { val: String(content), .. }] {
    @fs.write_string_to_file(path, content) catch {
      IOError(msg) => raise Raise(String(msg))
    }
  }
  Unit
}

///|
let fs_is_dir_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  Bool(@fs.is_dir(path) catch { IOError(msg) => raise Raise(String(msg)) })
} else {
  Unit
}

///|
let fs_is_file_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  Bool(@fs.is_file(path) catch { IOError(msg) => raise Raise(String(msg)) })
} else {
  Unit
}

///|
let fs_path_exists_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  Bool(@fs.path_exists(path))
} else {
  Unit
}

///|
let fs_read_dir_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  Array(
    (@fs.read_dir(path) catch { IOError(msg) => raise Raise(String(msg)) }).map(
      String(_),
    ),
  )
} else {
  Unit
}

///|
let fs_read_file_to_bytes_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  Bytes(
    @fs.read_file_to_bytes(path) catch {
      IOError(msg) => raise Raise(String(msg))
    },
  )
} else {
  Unit
}

///|
let fs_read_file_to_string_fn : RuntimeFunction = ctx => if ctx.args
  is [{ val: String(path), .. }] {
  String(
    @fs.read_file_to_string(path) catch {
      IOError(msg) => raise Raise(String(msg))
    },
  )
} else {
  Unit
}

///|
let fs_remove_dir_fn : RuntimeFunction = ctx => {
  if ctx.args is [{ val: String(path), .. }] {
    @fs.remove_dir(path) catch {
      IOError(msg) => raise Raise(String(msg))
    }
  }
  Unit
}

///|
let fs_remove_file_fn : RuntimeFunction = ctx => {
  if ctx.args is [{ val: String(path), .. }] {
    @fs.remove_file(path) catch {
      IOError(msg) => raise Raise(String(msg))
    }
  }
  Unit
}

///|
let fs_write_bytes_to_file_fn : RuntimeFunction = ctx => {
  if ctx.args is [{ val: String(path), .. }, { val: Bytes(content), .. }] {
    @fs.write_bytes_to_file(path, content) catch {
      IOError(msg) => raise Raise(String(msg))
    }
  }
  Unit
}
