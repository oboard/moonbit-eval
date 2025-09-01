#!/usr/bin/env python3
"""
Generate embedded core modules for moonbit-eval interpreter.
This script reads all modules from moonbitlang/core and generates
RuntimePackage definitions in the format expected by core_modules.mbt.
"""

from ast import alias
import os
import json
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple

# Core library path
CORE_PATH = "/Users/oboard/.moon/lib/core"
OUTPUT_FILE = "src/interpreter/core_modules.mbt"

# Removed extract_all_items function - no longer needed with new format

def read_module_info(module_dir: Path) -> Dict:
    """
    Read module information from a directory.
    Returns dict with module name, dependencies, and concatenated code content.
    """
    pkg = "moonbitlang/core/" + module_dir.relative_to(CORE_PATH).as_posix()
    alias = module_dir.relative_to(CORE_PATH).as_posix()
    module_name = pkg.replace('/', '_')
    
    # Read moon.pkg.json if it exists
    pkg_json_path = module_dir / "moon.pkg.json"
    dependencies = []
    if pkg_json_path.exists():
        try:
            with open(pkg_json_path, 'r') as f:
                pkg_data = json.load(f)
                dependencies = pkg_data.get('import', [])
        except (json.JSONDecodeError, FileNotFoundError):
            pass
    
    # Find all .mbt files (excluding test files)
    mbt_files = [f for f in module_dir.glob("*.mbt") 
                 if not f.name.endswith('_test.mbt') and not f.name.endswith('_wbtest.mbt')]
    
    # Collect file contents with their names
    file_contents = {}
    
    # Add moon.pkg.json if it exists
    if pkg_json_path.exists():
        try:
            with open(pkg_json_path, 'r', encoding='utf-8') as f:
                content = f.read().strip()
                if content:
                    file_contents['moon.pkg.json'] = content
        except (UnicodeDecodeError, FileNotFoundError):
            pass
    
    for mbt_file in sorted(mbt_files):  # Sort for consistent ordering
        try:
            with open(mbt_file, 'r', encoding='utf-8') as f:
                content = f.read().strip()
                if content:  # Only add non-empty content
                    file_contents[mbt_file.name] = content
        except (UnicodeDecodeError, FileNotFoundError):
            continue
    
    # Join all content with double newlines for backward compatibility
    concatenated_code = '\n\n'.join(file_contents.values())
    
    return {
        'alias': alias,
        'pkg': pkg,
        'name': module_name,
        'dependencies': dependencies,
        'code': concatenated_code,
        'files': file_contents
    }

# Removed has_non_self_parameters function - no longer needed with new format

def generate_module_code(module_info: Dict) -> str:
    """
    Generate RuntimePackage code for a single module.
    """
    pkg = module_info['pkg']
    module_name = module_info['name']
    code = module_info['code']
    dependencies = module_info['dependencies']
    files = module_info['files']
    
    if not code.strip():
        return ""
    
    # Generate dependencies map
    print(dependencies)
    dependencies_map_entries = []
    for dep in dependencies:
        if isinstance(dep, str):
            name = dep.replace('/', '_')
            dependencies_map_entries.append(f'"{dep}": {name}_module')
        elif isinstance(dep, dict):
            name = dep["path"].replace('/', '_')
            dependencies_map_entries.append(f'"{dep["alias"]}": {name}_module')
    dependencies_map_str = ", ".join(dependencies_map_entries)
    
    # Generate files map
    files_map_entries = []
    for filename, content in files.items():
        # Format the code with #| prefix for each line, filtering out comments and empty lines
        code_lines = content.split('\n')
        formatted_code_lines = []
        for line in code_lines:
            # Skip comment lines and empty lines to reduce file size
            stripped_line = line.strip()
            if not stripped_line or stripped_line.startswith('//') or stripped_line.startswith('///') or stripped_line.startswith('///'):
                continue
            # Escape quotes and backslashes for the string literal
            formatted_code_lines.append(f'    #|{line}')
        
        if formatted_code_lines:
            formatted_content = '\n'.join(formatted_code_lines)
            files_map_entries.append(f'  "{filename}": (\n{formatted_content}\n  )')
        else:
            # For empty files, generate empty string
            files_map_entries.append(f'  "{filename}": ""')
    
    files_map_str = ',\n'.join(files_map_entries)
    
    module_code = f'''///|
let {module_name}_module : RuntimePackage = RuntimePackage::new(
  "{pkg}",
  deps={{ {dependencies_map_str} }},
  files={{
{files_map_str}
  }}
)'''
    
    return module_code

def generate_core_modules_map(modules: List[dict]) -> str:
    """
    Generate the core_modules map declaration.
    """
    entries = []
    for module in modules: 
        entries.append(f'"{module['alias']}": {module['name']}_module')
        entries.append(f'"{module['pkg']}": {module['name']}_module')
    map_content = ", ".join(entries)
    
    return f'''///|
let core_modules : Map[String, RuntimePackage] = {{ {map_content} }}'''

def main():
    """
    Main function to generate all core modules.
    """
    core_path = Path(CORE_PATH)
    
    if not core_path.exists():
        print(f"Error: Core path {CORE_PATH} does not exist")
        return
    # Get all module directories recursively
    module_dirs = []
    for root, dirs, _ in os.walk(core_path):
        root_path = Path(root)
        # Skip hidden directories and coverage directory
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'coverage']
        module_dirs.extend([root_path / d for d in dirs])
    
    print(f"Found {len(module_dirs)} modules to process")
    
    generated_modules = []
    module_codes = []
    
    # Process each module
    for module_dir in sorted(module_dirs):
        print(f"Processing module: {module_dir.name}")
        
        module_info = read_module_info(module_dir)
        
        if module_info['code'].strip():
            module_code = generate_module_code(module_info)
            if module_code:
                module_codes.append(module_code)
                generated_modules.append(module_info)
                code_lines = len([line for line in module_info['code'].split('\n') if line.strip()])
                print(f"  Generated module with {code_lines} lines of code")
        else:
            print(f"  No code content found")
    
    # Generate the complete file content
    header = '''///|
/// Auto-generated core modules for moonbit-eval interpreter
/// This file contains embedded RuntimePackage definitions for all moonbitlang/core modules
'''
    
    dummy_loc = '''///|
fn dummy_loc() -> @basic.Location {
  {
    start: { fname: "", lnum: 0, bol: 0, cnum: 0 },
    end: { fname: "", lnum: 0, bol: 0, cnum: 0 },
  }
}'''
    
    # Generate core_modules map
    core_modules_map = generate_core_modules_map(generated_modules)
    
    # Combine all parts
    full_content = "\n\n".join([
        header,
        core_modules_map,
        dummy_loc
    ] + module_codes)
    
    # Write to output file
    output_path = Path(OUTPUT_FILE)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(full_content)
    
    module_names = [module['name'] for module in generated_modules]
    print(f"\nGenerated {len(module_names)} modules:")
    for module_name in module_names:
        print(f"  - {module_name}")
    print(f"\nOutput written to: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()