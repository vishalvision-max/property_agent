import os
import subprocess
import re

# Run dart analyze and get output
result = subprocess.run(['dart', 'analyze'], capture_output=True, text=True, cwd='/home/pc/Downloads/property_agent/property_agent')
output = result.stdout

# Pattern for errors:
# error - lib/presentation/screens/property/property_create_screen_details.dart:3599:17 - Static members from the extended type...
error_pattern = re.compile(r"error - (lib/presentation/screens/property/[^:]+):(\d+):(\d+) - Static members.* Try adding '(_PropertyCreateScreenState\.)' before the name")

fixes = {}

for line in output.splitlines():
    match = error_pattern.search(line)
    if match:
        file_path = match.group(1)
        line_num = int(match.group(2))
        col_num = int(match.group(3))
        prefix = match.group(4)
        
        if file_path not in fixes:
            fixes[file_path] = []
        fixes[file_path].append((line_num, col_num, prefix))

# Apply fixes
for file_path, file_fixes in fixes.items():
    full_path = os.path.join('/home/pc/Downloads/property_agent/property_agent', file_path)
    with open(full_path, 'r') as f:
        lines = f.readlines()
    
    # Sort fixes by line and column in reverse order so inserting doesn't mess up offsets
    file_fixes.sort(key=lambda x: (x[0], x[1]), reverse=True)
    
    for line_num, col_num, prefix in file_fixes:
        idx = line_num - 1
        line_content = lines[idx]
        col_idx = col_num - 1
        # Insert the prefix at the specified column
        lines[idx] = line_content[:col_idx] + prefix + line_content[col_idx:]
        
    with open(full_path, 'w') as f:
        f.writelines(lines)

print("Fixed static member references.")
