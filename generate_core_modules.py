#!/usr/bin/env python3
"""
Generate embedded core modules for moonbit-eval interpreter.
This script reads all modules from moonbitlang/core and generates
RuntimeModule definitions in the format expected by core_modules.mbt.
"""

import os
import json
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple

# Core library path
CORE_PATH = "/Users/oboard/Development/moonbit-packages/moonbit-eval/.mooncakes/moonbitlang/parser/core"
OUTPUT_FILE = "/Users/oboard/Development/moonbit-packages/moonbit-eval/src/interpreter/core_modules.mbt"

def extract_all_items(mbt_content: str) -> List[Tuple[str, str, str, str]]:
    """
    Extract all items (functions and constants) from .mbt file content.
    Returns list of (item_name, item_type, item_signature, item_body) tuples.
    item_type can be 'function' or 'constant'
    For functions: item_signature contains the full function signature, item_body contains the body
    For constants: item_signature is empty, item_body contains the value
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
        if brace_depth == 0 and not original_line.startswith(' ') and not original_line.startswith('\t') and (line.startswith('let ') or line.startswith('pub let ')):
            const_match = re.match(r'(?:pub\s+)?let\s+(\w+)\s*=\s*(.+)', line)
            if const_match:
                const_name = const_match.group(1)
                const_value = const_match.group(2)
                items.append((const_name, 'constant', '', const_value))
        
        # Look for function declarations at top level (must be at column 0 and brace_depth == 0)
        elif brace_depth == 0 and not original_line.startswith(' ') and not original_line.startswith('\t') and (line.startswith('fn ') or line.startswith('pub fn ')) and '{' in line:
            # Extract function name - handle regular functions, method syntax, and generic functions
            func_match = re.match(r'(?:pub\s+)?fn(?:\[.*?\])?\s+(?:\w+::)?(\w+)', line)
            if not func_match:
                i += 1
                continue
                
            func_name = func_match.group(1)
            
            # Extract function signature (everything before the opening brace)
            brace_pos = line.find('{')
            func_signature = line[:brace_pos].strip()
            
            # Find the complete function body - preserve original formatting
            func_brace_count = line.count('{') - line.count('}')
            func_lines = []
            
            # Start from the current line and collect the entire function
            current_func_lines = [line]
            
            # Continue reading until braces are balanced
            i += 1
            while i < len(lines) and func_brace_count > 0:
                current_line = lines[i]
                current_func_lines.append(current_line)
                func_brace_count += current_line.count('{') - current_line.count('}')
                # Also update the main brace_depth
                brace_depth += current_line.count('{') - current_line.count('}')
                i += 1
            
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
    module_name = module_dir.name
    
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
                # Keep the 4-tuple structure for functions, 3-tuple for constants
                for item_name, item_type, item_signature, item_body in items:
                    if item_type == 'function':
                        # For functions, keep signature and body separate
                        all_items.append((item_name, item_type, item_signature, item_body))
                    else:
                        # For constants, use item_body directly (3-tuple)
                        all_items.append((item_name, item_type, item_body))
        except (UnicodeDecodeError, FileNotFoundError):
            continue
    
    return {
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
    module_name = module_info['name']
    items = module_info['items']
    
    if not items:
        return ""
    
    # Generate the values map
    values_entries = []
    for item in items:
        if len(item) == 3:  # Constants: (name, type, body)
            item_name, item_type, item_body = item
            # For constants, we need to wrap them in the appropriate type
            if item_body.endswith('UL') and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body[:-2]):
                # UInt64 constants (check UL before L to avoid conflict, only if no variables)
                values_entries.append(f'      "{item_name}": UInt64({item_body})')
            elif item_body.endswith('L') and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body[:-1]):
                # Int64 constants (only if no variables in the expression)
                values_entries.append(f'      "{item_name}": Int64({item_body})')
            elif item_body.endswith('N') and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body[:-1]):
                # BigInt constants (only if no variables in the expression)
                values_entries.append(f'      "{item_name}": BigInt({item_body})')
            elif item_body.endswith('U') and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body[:-1]):
                # UInt constants (only if no variables in the expression)
                values_entries.append(f'      "{item_name}": UInt({item_body})')
            elif (item_body.isdigit() or (item_body.startswith('-') and item_body[1:].isdigit())) and not re.search(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', item_body):
                # Int constants (only if no variables in the expression)
                values_entries.append(f'      "{item_name}": Int({item_body})')
            elif item_body in ['true', 'false']:
                # Bool constants
                values_entries.append(f'      "{item_name}": Bool({item_body})')
            elif item_body.startswith('"') and item_body.endswith('"') and '"' not in item_body[1:-1].replace('\\"', '') and '//' not in item_body and '[' not in item_body and '{' not in item_body:
                # Simple string constants (no embedded quotes, comments, expressions, or interpolation)
                values_entries.append(f'      "{item_name}": String({item_body})')
            else:
                # For other constants, use build with the value
                escaped_body = item_body.replace('\\', '\\\\').replace('"', '\\"')
                values_entries.append(f'      "{item_name}": build("{escaped_body}")')
        elif len(item) == 4:  # Functions: (name, type, signature, body)
            item_name, item_type, item_signature, item_body = item
            # Check if function has non-self parameters
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
    
    module_code = f'''///|
let {module_name}_module : RuntimeModule = RuntimeModule::new("moonbitlang/core/{module_name}", fn(
  _env,
  build,
) {{
  {{
{values_map},
  }}
}})'''
    
    return module_code

def generate_core_modules_map(modules: List[str]) -> str:
    """
    Generate the core_modules map declaration.
    """
    entries = [f'"{module}": {module}_module' for module in modules]
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
    
    # Get all module directories
    module_dirs = [d for d in core_path.iterdir() 
                   if d.is_dir() and not d.name.startswith('.') and d.name not in ['coverage']]
    
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
                generated_modules.append(module_info['name'])
                functions_count = len([item for item in module_info['items'] if item[1] == 'function'])
                constants_count = len([item for item in module_info['items'] if item[1] == 'constant'])
                print(f"  Generated {functions_count} functions, {constants_count} constants")
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
    
    print(f"\nGenerated {len(generated_modules)} modules:")
    for module in generated_modules:
        print(f"  - {module}")
    print(f"\nOutput written to: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()