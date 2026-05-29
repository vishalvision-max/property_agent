import sys

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
new_file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen_payload.dart'

with open(file_path, 'r') as f:
    lines = f.readlines()

start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('  Map<String, dynamic> _buildApiFields() {'):
        start_idx = i
        break

end_idx = -1
for i in range(start_idx, len(lines)):
    if lines[i].startswith('  @override') and lines[i+1].startswith('  void dispose() {'):
        end_idx = i
        break

if start_idx == -1 or end_idx == -1:
    print("Could not find start or end index.")
    sys.exit(1)

method_body = "".join(lines[start_idx:end_idx]).rstrip()

new_file_content = f"""part of 'property_create_screen.dart';

extension PropertyCreateScreenPayload on _PropertyCreateScreenState {{
{method_body.replace('  Map<String, dynamic> _buildApiFields', '  Map<String, dynamic> buildApiFields')}
}}
"""

with open(new_file_path, 'w') as f:
    f.write(new_file_content)

# Update main file
# 1. Add part directive
part_str = "part 'property_create_screen_payload.dart';\n\nclass PropertyCreateScreen"
new_content = "".join(lines[:start_idx]) + "".join(lines[end_idx:])
new_content = new_content.replace("class PropertyCreateScreen", part_str, 1)

# 2. Replace calls
new_content = new_content.replace("_buildApiFields()", "buildApiFields()")

with open(file_path, 'w') as f:
    f.write(new_content)

print("Robust extraction successful.")
