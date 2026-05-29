import os

def parse_args(s):
    args = []
    current = ""
    bracket_level = 0
    paren_level = 0
    brace_level = 0
    in_single_quote = False
    in_double_quote = False
    escape = False

    for char in s:
        if escape:
            current += char
            escape = False
            continue
            
        if char == '\\':
            escape = True
            current += char
            continue
            
        if char == "'" and not in_double_quote:
            in_single_quote = not in_single_quote
        elif char == '"' and not in_single_quote:
            in_double_quote = not in_double_quote
            
        if in_single_quote or in_double_quote:
            current += char
            continue
            
        if char == '[':
            bracket_level += 1
        elif char == ']':
            bracket_level -= 1
        elif char == '(':
            paren_level += 1
        elif char == ')':
            paren_level -= 1
        elif char == '{':
            brace_level += 1
        elif char == '}':
            brace_level -= 1
            
        if char == ',' and bracket_level == 0 and paren_level == 0 and brace_level == 0:
            args.append(current)
            current = ""
        else:
            current += char
            
    if current.strip():
        args.append(current)
    return [a.strip() for a in args if a.strip()]

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Find the definition and remove it first!
    def_start = content.find('Widget _buildChoiceChipRow(')
    if def_start != -1:
        # find matching brace for the method body
        brace_count = 0
        def_end = -1
        in_body = False
        for i in range(def_start, len(content)):
            if content[i] == '{':
                brace_count += 1
                in_body = True
            elif content[i] == '}':
                brace_count -= 1
                if in_body and brace_count == 0:
                    def_end = i
                    break
        if def_end != -1:
            content = content[:def_start] + content[def_end+1:]

    # Now replace usages
    offset = 0
    while True:
        idx = content.find('_buildChoiceChipRow(', offset)
        if idx == -1:
            break
            
        start_paren = idx + len('_buildChoiceChipRow')
        
        # find matching closing parenthesis
        paren_count = 0
        end_idx = -1
        in_sq = False
        in_dq = False
        escape = False
        for i in range(start_paren, len(content)):
            char = content[i]
            if escape:
                escape = False
                continue
            if char == '\\':
                escape = True
                continue
            if char == "'" and not in_dq:
                in_sq = not in_sq
            elif char == '"' and not in_sq:
                in_dq = not in_dq
                
            if in_sq or in_dq:
                continue
                
            if char == '(':
                paren_count += 1
            elif char == ')':
                paren_count -= 1
                if paren_count == 0:
                    end_idx = i
                    break
                    
        if end_idx == -1:
            break
            
        args_str = content[start_paren+1:end_idx]
        args = parse_args(args_str)
        
        if len(args) >= 4:
            new_str = f"PropertyChoiceChipField(\n  title: {args[0]},\n  options: {args[1]},\n  selectedValue: {args[2]},\n  onChanged: {args[3]},"
            for a in args[4:]:
                if a.startswith("displayFor:"):
                    new_str += f"\n  {a},"
                else:
                    new_str += f"\n  displayFor: {a},"
            new_str += "\n)"
            content = content[:idx] + new_str + content[end_idx+1:]
            offset = idx + len(new_str)
        else:
            offset = idx + 1

    # Add import statement if not exists
    import_stmt = "import 'package:property_agent/presentation/widgets/property/property_choice_chip_field.dart';"
    if import_stmt not in content:
        import_idx = content.find("import 'package:flutter/material.dart';")
        if import_idx != -1:
            # We want to insert the import without messing up everything!
            before = content[:import_idx]
            match_str = "import 'package:flutter/material.dart';\n"
            end_match = import_idx + len("import 'package:flutter/material.dart';")
            if content[end_match] == '\n':
                end_match += 1
            after = content[end_match:]
            content = before + match_str + import_stmt + '\n' + after
            
    with open(filepath, 'w') as f:
        f.write(content)
    print("Done replacing.")

process_file('lib/presentation/screens/property/property_create_screen.dart')
