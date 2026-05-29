import re
import os

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
new_file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen_payload.dart'

with open(file_path, 'r') as f:
    content = f.read()

# Find the start of _buildApiFields
start_str = "  Map<String, dynamic> _buildApiFields() {"
start_idx = content.find(start_str)

if start_idx == -1:
    print("Could not find _buildApiFields")
    exit(1)

# Find the end of the method by counting braces
brace_count = 0
in_method = False
end_idx = -1

for i in range(start_idx, len(content)):
    char = content[i]
    if char == '{':
        brace_count += 1
        in_method = True
    elif char == '}':
        brace_count -= 1
    
    if in_method and brace_count == 0:
        end_idx = i + 1
        break

if end_idx == -1:
    print("Could not find end of _buildApiFields")
    exit(1)

method_body = content[start_idx:end_idx]

# Create the new file content
new_file_content = f"""part of 'property_create_screen.dart';

extension PropertyCreateScreenPayload on _PropertyCreateScreenState {{
{method_body.replace('  Map<String, dynamic> _buildApiFields', '  Map<String, dynamic> buildApiFields')}
}}
"""

with open(new_file_path, 'w') as f:
    f.write(new_file_content)

# Update the main file
# 1. Add part directive at the top
part_str = "part 'property_create_screen_payload.dart';\n\nclass PropertyCreateScreen"
content = content.replace("class PropertyCreateScreen", part_str, 1)

# 2. Remove the method body from the main file
content = content[:start_idx] + content[end_idx:]

# 3. Replace calls to _buildApiFields() with buildApiFields()
content = content.replace("_buildApiFields()", "buildApiFields()")

with open(file_path, 'w') as f:
    f.write(content)

print("Extraction successful.")
