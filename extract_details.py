import sys

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
new_file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen_details.dart'

with open(file_path, 'r') as f:
    lines = f.readlines()

start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('  Widget _buildPropertyDetails() {'):
        start_idx = i
        break

end_idx = -1
for i in range(start_idx, len(lines)):
    if lines[i].startswith('  Widget _buildFloorDropdown() {'):
        end_idx = i
        break

if start_idx == -1 or end_idx == -1:
    print(f"Could not find start ({start_idx}) or end ({end_idx}) index.")
    sys.exit(1)

method_body = "".join(lines[start_idx:end_idx]).rstrip()

new_file_content = f"""part of 'property_create_screen.dart';

extension PropertyCreateScreenDetails on _PropertyCreateScreenState {{
{method_body.replace('  Widget _buildPropertyDetails()', '  Widget buildPropertyDetails()')}
}}
"""

with open(new_file_path, 'w') as f:
    f.write(new_file_content)

# Update main file
# 1. Add part directive
part_str = "part 'property_create_screen_details.dart';\n\nclass PropertyCreateScreen"
new_content = "".join(lines[:start_idx]) + "".join(lines[end_idx:])
new_content = new_content.replace("class PropertyCreateScreen", part_str, 1)

# 2. Replace calls
new_content = new_content.replace("_buildPropertyDetails()", "buildPropertyDetails()")

with open(file_path, 'w') as f:
    f.write(new_content)

print("Robust extraction of details successful.")
