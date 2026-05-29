import sys

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
new_file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen_extras.dart'

with open(file_path, 'r') as f:
    lines = f.readlines()

start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('  Widget _buildAmenities() {'):
        start_idx = i
        break

end_idx = -1
for i in range(start_idx, len(lines)):
    if line.startswith('  Widget _buildTextField('):
        end_idx = i
        break
    if 'Widget _buildTextField(' in lines[i]:
        end_idx = i
        break

if start_idx == -1 or end_idx == -1:
    print(f"Could not find start ({start_idx}) or end ({end_idx}) index.")
    sys.exit(1)

method_body = "".join(lines[start_idx:end_idx]).rstrip()

# Replace all method names in the extension
method_body = method_body.replace('  Widget _buildAmenities()', '  Widget buildAmenities()')
method_body = method_body.replace('  Widget _buildFurnishings()', '  Widget buildFurnishings()')
method_body = method_body.replace('  Widget _buildLocation()', '  Widget buildLocation()')
method_body = method_body.replace('  Widget _buildMediaSection()', '  Widget buildMediaSection()')
method_body = method_body.replace('  Widget _buildVideoSection()', '  Widget buildVideoSection()')

new_file_content = f"""part of 'property_create_screen.dart';

extension PropertyCreateScreenExtras on _PropertyCreateScreenState {{
{method_body}
}}
"""

with open(new_file_path, 'w') as f:
    f.write(new_file_content)

# Update main file
# 1. Add part directive
part_str = "part 'property_create_screen_extras.dart';\n\nclass PropertyCreateScreen"
new_content = "".join(lines[:start_idx]) + "".join(lines[end_idx:])
new_content = new_content.replace("class PropertyCreateScreen", part_str, 1)

# 2. Replace calls
new_content = new_content.replace("_buildAmenities()", "buildAmenities()")
new_content = new_content.replace("_buildFurnishings()", "buildFurnishings()")
new_content = new_content.replace("_buildLocation()", "buildLocation()")
new_content = new_content.replace("_buildMediaSection()", "buildMediaSection()")
new_content = new_content.replace("_buildVideoSection()", "buildVideoSection()")

with open(file_path, 'w') as f:
    f.write(new_content)

print("Robust extraction of extras successful.")
