import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # We want to replace TextField blocks that have an InputDecoration with DropdownButton
    # The structure is:
    # TextField(
    #   controller: _someController,
    #   keyboardType: TextInputType.number,
    #   onChanged: (_) => _scheduleSaveDraft(),
    #   decoration: InputDecoration(
    #     labelText: 'Something Area',
    #     hintText: 'Area',
    #     prefixIcon: const Icon(Icons.crop_square, size: 18),
    #     suffixIcon: Container(
    #       ...
    #     ),
    #   ),
    # )
    
    # Let's find all TextField( and parse until its closing parenthesis.
    offset = 0
    while True:
        idx = content.find('TextField(', offset)
        if idx == -1:
            break
            
        start_paren = idx + len('TextField')
        
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
            
        tf_block = content[idx:end_idx+1]
        
        # Check if it has InputDecoration and labelText
        if 'InputDecoration(' in tf_block and 'labelText:' in tf_block:
            # We will manually extract the properties using regex
            controller_match = re.search(r'controller:\s*([^,]+),', tf_block)
            label_match = re.search(r"labelText:\s*'([^']+)'", tf_block)
            hint_match = re.search(r"hintText:\s*'([^']+)'", tf_block)
            icon_match = re.search(r'prefixIcon:\s*const\s*Icon\(([^,]+)', tf_block)
            
            # The suffixIcon contains a container with dropdown. 
            # We need to extract the entire suffixIcon value.
            suffix_idx = tf_block.find('suffixIcon:')
            if suffix_idx != -1:
                # find matching brace/paren for suffixIcon value
                suffix_val_start = suffix_idx + len('suffixIcon:')
                suffix_val_end = -1
                p_count = 0
                for i in range(suffix_val_start, len(tf_block)):
                    c = tf_block[i]
                    if c in '([{':
                        p_count += 1
                    elif c in ')]}':
                        p_count -= 1
                    elif c == ',' and p_count == 0:
                        suffix_val_end = i
                        break
                
                if suffix_val_end == -1:
                    suffix_val_end = len(tf_block) - 2 # before the decoration closing
                    
                suffix_val = tf_block[suffix_val_start:suffix_val_end].strip()
                
                if controller_match and label_match:
                    controller = controller_match.group(1).strip()
                    label = label_match.group(1).strip()
                    hint = hint_match.group(1).strip() if hint_match else ""
                    icon = icon_match.group(1).strip() if icon_match else ""
                    
                    new_tf = f"""PropertyTextField(
              controller: {controller},
              keyboardType: TextInputType.number,
              onChanged: (_) => _scheduleSaveDraft(),
              label: '{label}',
              hint: '{hint}',"""
              
                    if icon:
                        new_tf += f"\n              icon: {icon},"
                        
                    new_tf += f"\n              suffixIcon: {suffix_val},\n            )"
                    
                    content = content[:idx] + new_tf + content[end_idx+1:]
                    offset = idx + len(new_tf)
                else:
                    offset = idx + 1
            else:
                offset = idx + 1
        else:
            offset = idx + 1

    with open(filepath, 'w') as f:
        f.write(content)
    print("Done replacing dropdown fields.")

process_file('lib/presentation/screens/property/property_create_screen.dart')
