#!/usr/bin/env python3
"""
Generate embedded core modules for moonbit-eval interpreter.
This script reads all modules from moonbitlang/core and generates
RuntimeModule definitions in the format expected by core_modules.mbt.
"""

from ast import alias
import os
import json
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple

# Core library path
CORE_PATH = ".mooncakes/moonbitlang/parser/core"
OUTPUT_FILE = "src/interpreter/core_modules.mbt"

def extract_all_items(mbt_content: str) -> List[Tuple[str, str, str, str]]:
    """
    Extract all items (functions, constants, and enums) from .mbt file content.
    Returns list of (item_name, item_type, item_signature, item_body) tuples.
    item_type can be 'function', 'constant', or 'enum'
    For functions: item_signature contains the full function signature, item_body contains the body
    For constants: item_signature is empty, item_body contains the value
    For enums: item_signature is empty, item_body contains the complete enum definition
    """
    items = []
    
    # Split content into lines for better processing
    lines = mbt_content.split('\n')
    i = 0
    brace_depth = 0  # Track nesting level to only extract top-level items
    
    while i < len(lines):
        line = lines[i]
        original_line = line
        line = line.strip()
        
        # Look for constants at top level (must be at column 0 and brace_depth == 0)
        if not original_line.startswith(' ') and not original_line.startswith('\t') and (line.startswith('let ') or line.startswith('pub let ')):
            const_match = re.match(r'(?:pub\s+)?let\s+(\w+)\s*=\s*(.+)', line)
            if const_match:
                const_name = const_match.group(1)
                const_value = const_match.group(2)
                items.append((const_name, 'constant', '', const_value))
        
        # Look for enum declarations at top level (must be at column 0 and brace_depth == 0)
        elif not original_line.startswith(' ') and not original_line.startswith('\t') and brace_depth == 0 and (line.startswith('enum') or line.startswith('pub enum')):
            # Extract enum name - handle generic enums
            enum_match = re.match(r'(?:pub\s+)?enum\s+(\w+)(?:\[.*?\])?', line)
            if not enum_match:
                i += 1
                continue
                
            enum_name = enum_match.group(1)
            
            # Find the complete enum definition - preserve original formatting
            current_enum_lines = [line]
            enum_brace_count = line.count('{') - line.count('}')
            
            # If no opening brace on this line, continue reading until we find it
            if '{' not in line:
                i += 1
                while i < len(lines) and '{' not in lines[i]:
                    current_enum_lines.append(lines[i])
                    i += 1
                if i < len(lines):
                    current_enum_lines.append(lines[i])
                    enum_brace_count = lines[i].count('{') - lines[i].count('}')
            
            # Continue reading until braces are balanced
            i += 1
            while i < len(lines) and enum_brace_count > 0:
                current_line = lines[i]
                current_enum_lines.append(current_line)
                enum_brace_count += current_line.count('{') - current_line.count('}')
                # Also update the main brace_depth
                brace_depth += current_line.count('{') - current_line.count('}')
                i += 1
            
            # Store the complete enum definition
            complete_enum = '\n'.join(current_enum_lines)
            items.append((enum_name, 'enum', '', complete_enum))
            
            # i is already incremented in the while loop, so continue
            continue
        
        # Look for function declarations at top level (must be at column 0 and brace_depth == 0)
        elif not original_line.startswith(' ') and not original_line.startswith('\t') and brace_depth == 0 and (line.startswith('fn') or line.startswith('pub fn')):
            # Start collecting function declaration lines
            func_declaration_lines = [line]
            func_declaration_text = line
            
            # Continue reading until we find the opening brace or determine it's not a function
            temp_i = i + 1
            while temp_i < len(lines) and '{' not in func_declaration_text:
                next_line = lines[temp_i]
                # If we hit another top-level declaration, this isn't a function
                if (not next_line.startswith(' ') and not next_line.startswith('\t') and 
                    (next_line.strip().startswith('fn') or next_line.strip().startswith('pub fn') or 
                     next_line.strip().startswith('enum') or next_line.strip().startswith('pub enum') or
                     next_line.strip().startswith('let') or next_line.strip().startswith('pub let'))):
                    break
                func_declaration_lines.append(next_line)
                func_declaration_text += ' ' + next_line.strip()
                temp_i += 1
            
            # Check if we found a valid function declaration
            if '{' not in func_declaration_text:
                i += 1
                continue
                
            # Extract function name from the complete declaration
            func_match = re.search(r'(?:pub\s+)?fn(?:\[.*?\])?\s+(?:(?:\w+::)?(\w+))\s*(?:\[.*?\])?\s*\(', func_declaration_text)
            if not func_match:
                i += 1
                continue
                
            func_name = func_match.group(1)
            
            # Extract function signature (everything before the opening brace)
            brace_pos = func_declaration_text.find('{')
            func_signature = func_declaration_text[:brace_pos].strip()
            
            # Find the complete function body - preserve original formatting
            func_brace_count = func_declaration_text.count('{') - func_declaration_text.count('}')
            func_lines = []
            
            # Start from the collected declaration lines and collect the entire function
            current_func_lines = func_declaration_lines.copy()
            
            # Continue reading until braces are balanced from where we left off
            i = temp_i
            while i < len(lines) and func_brace_count > 0:
                current_line = lines[i]
                current_func_lines.append(current_line)
                func_brace_count += current_line.count('{') - current_line.count('}')
                i += 1
            
            # Reset brace_depth to 0 after processing a complete function
            brace_depth = 0
            
            # Extract just the function body (everything after the opening brace)
            complete_function = '\n'.join(current_func_lines)
            
            # Find the opening brace and extract only the body
            first_brace = complete_function.find('{')
            last_brace = complete_function.rfind('}')
            
            if first_brace != -1 and last_brace != -1:
                func_body = complete_function[first_brace+1:last_brace]
                # Remove leading/trailing whitespace but preserve internal formatting
                func_body = func_body.strip()
            else:
                func_body = complete_function
            
            # Store the function with signature and body separate
            items.append((func_name, 'function', func_signature, func_body))
            
            # i is already incremented in the while loop, so continue
            continue
        
        # Update brace depth for non-function lines
        brace_depth += original_line.count('{') - original_line.count('}')
        i += 1
    
    return items

def read_module_info(module_dir: Path) -> Dict:
    """
    Read module information from a directory.
    Returns dict with module name, dependencies, and items (functions/constants).
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
    
    all_items = []
    
    for mbt_file in mbt_files:
        try:
            with open(mbt_file, 'r', encoding='utf-8') as f:
                content = f.read()
                items = extract_all_items(content)
                # Keep the 4-tuple structure for functions and enums, 3-tuple for constants
                for item_name, item_type, item_signature, item_body in items:
                    if item_type == 'function' or item_type == 'enum':
                        # For functions and enums, keep signature and body separate
                        all_items.append((item_name, item_type, item_signature, item_body))
                    else:
                        # For constants, use item_body directly (3-tuple)
                        all_items.append((item_name, item_type, item_body))
        except (UnicodeDecodeError, FileNotFoundError):
            continue
    
    return {
        'alias': alias,
        'pkg': pkg,
        'name': module_name,
        'dependencies': dependencies,
        'items': all_items
    }

def has_non_self_parameters(func_signature: str) -> bool:
    """
    Check if a function has parameters other than 'self'.
    """
    # Extract parameters from function signature
    paren_start = func_signature.find('(')
    paren_end = func_signature.rfind(')')
    
    if paren_start == -1 or paren_end == -1:
        return False
    
    params_str = func_signature[paren_start+1:paren_end].strip()
    
    # If no parameters, return False
    if not params_str:
        return False
    
    # Split parameters by comma and check
    params = [p.strip() for p in params_str.split(',')]
    
    # Filter out 'self' parameter
    non_self_params = [p for p in params if not p.startswith('self') and p != 'self']
    
    return len(non_self_params) > 0

def generate_module_code(module_info: Dict) -> str:
    """
    Generate RuntimeModule code for a single module.
    """
    pkg = module_info['pkg']
    module_name = module_info['name']
    items = module_info['items']
    dependencies = module_info['dependencies']
    
    if not items:
        return ""
    
    # Generate the values map
    values_entries = []
    for item in items:
        if len(item) == 3:  # Constants: (name, type, body)
            item_name, item_type, item_body = item
            # Define type mapping for different constant suffixes
            type_mapping = {
                'UL': ('UInt64', 2),
                'L': ('Int64', 1), 
                'N': ('BigInt', 1),
                'U': ('UInt', 1)
            }
            prefix = "None"
            # Handle different constant types
            for suffix, (type_name, trim_len) in type_mapping.items():
                if item_body.endswith(suffix) and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body[:-trim_len]):
                    values_entries.append(f'      "{item_name}": ({prefix}, {type_name}({item_body}))')
                    break
            else:
                # Handle other constant types
                if (item_body.isdigit() or (item_body.startswith('-') and item_body[1:].isdigit())) and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body):
                    values_entries.append(f'      "{item_name}": ({prefix}, Int({item_body}))')
                elif item_body in ['true', 'false']:
                    values_entries.append(f'      "{item_name}": ({prefix}, Bool({item_body}))')
                elif (item_body.startswith('"') and item_body.endswith('"') and 
                      '"' not in item_body[1:-1].replace('\\"', '') and 
                      '//' not in item_body and '[' not in item_body and '{' not in item_body):
                    values_entries.append(f'      "{item_name}": ({prefix}, String({item_body}))')
                else:
                    escaped_body = item_body.replace('\\', '\\\\').replace('"', '\\"')
                    values_entries.append(f'      "{item_name}": ({prefix}, String("{escaped_body}"))')
        elif len(item) == 4:  # Functions or Enums: (name, type, signature, body)
            item_name, item_type, item_signature, item_body = item
            
            if item_type == 'enum':
                # For enums, item_body contains the complete enum definition
                complete_enum = item_body
                # Split into lines and add #| prefix to each line
                lines = complete_enum.split('\n')
                formatted_lines = []
                for line in lines:
                    # Keep original indentation but escape quotes and backslashes
                    if line.strip():  # Only process non-empty lines
                        escaped_line = line.replace('\\', '\\\\')
                        escaped_line = escaped_line.replace('"', '\\"')
                        formatted_lines.append(f'        #|{escaped_line}')
                
                if formatted_lines:
                    multiline_body = '\n'.join(formatted_lines)
                    values_entries.append(f'      "{item_name}": build(\n        (\n{multiline_body}\n        ),\n      )')
            
            elif item_type == 'function':
                # For functions with parameters, use the complete function definition
                # Combine signature and body
                complete_func = f"{item_signature} {{ {item_body} }}"
                # Split into lines and add #| prefix to each line
                lines = complete_func.split('\n')
                formatted_lines = []
                for line in lines:
                    # Keep original indentation but escape quotes and backslashes
                    if line.strip():  # Only process non-empty lines
                        escaped_line = line.replace('\\', '\\\\')
                        escaped_line = escaped_line.replace('"', '\\"')
                        formatted_lines.append(f'        #|{escaped_line}')
                
                if formatted_lines:
                    multiline_body = '\n'.join(formatted_lines)
                    values_entries.append(f'      "{item_name}": build(\n        (\n{multiline_body}\n        ),\n      )')
            
    values_map = ",\n".join(values_entries)
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
    
    module_code = f'''///|
let {module_name}_module : RuntimeModule = RuntimeModule::new("{pkg}",
  deps={{ {dependencies_map_str} }},
  fn(_env, build) {{
  {{
{values_map},
  }}
}})'''
    
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
let core_modules : Map[String, RuntimeModule] = {{ {map_content} }}'''

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
        
        if module_info['items']:
            module_code = generate_module_code(module_info)
            if module_code:
                module_codes.append(module_code)
                generated_modules.append(module_info)
                functions_count = len([item for item in module_info['items'] if item[1] == 'function'])
                constants_count = len([item for item in module_info['items'] if item[1] == 'constant'])
                enums_count = len([item for item in module_info['items'] if item[1] == 'enum'])
                print(f"  Generated {functions_count} functions, {constants_count} constants, {enums_count} enums")
        else:
            print(f"  No public items found")
    
    # Generate the complete file content
    header = '''///|
/// Auto-generated core modules for moonbit-eval interpreter
/// This file contains embedded RuntimeModule definitions for all moonbitlang/core modules
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