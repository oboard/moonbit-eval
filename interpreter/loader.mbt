///|
pub fn load_package_dir(pkg_name : String, path : String) -> RuntimePackage? {
  try {
    let entries = @fs.read_dir(path)
    let _ = @fs.read_file_to_string([path, "moon.pkg.json"].join("/"))
    let deps = {}
    let files : Map[String, String] = {}
    for entry in entries {
      let file_path = [path, entry].join("/")
      if @fs.is_file(file_path) {
        files.set(entry, @fs.read_file_to_string(file_path))
      }
    }
    Some(RuntimePackage::new(pkg_name, deps~, files~))
  } catch {
    _ => None
  }
}
