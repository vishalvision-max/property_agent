import sys

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
new_file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen_basics.dart'

with open(file_path, 'r') as f:
    lines = f.readlines()

start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('  Widget _buildSection(String title, String key, IconData icon, Widget child) {'):
        start_idx = i
        break

end_idx = -1
for i in range(start_idx, len(lines)):
    if line.startswith('  Widget _buildFloorDropdown() {'):
        end_idx = i
        break
    if 'Widget _buildFloorDropdown(' in lines[i]:
        end_idx = i
        break

if start_idx == -1 or end_idx == -1:
    print(f"Could not find start ({start_idx}) or end ({end_idx}) index.")
    sys.exit(1)

method_body = "".join(lines[start_idx:end_idx]).rstrip()

method_body = method_body.replace('  Widget _buildSection(', '  Widget buildSection(')
method_body = method_body.replace('  Widget _buildBasicInfo()', '  Widget buildBasicInfo()')
method_body = method_body.replace('  Widget _buildPricingAndArea()', '  Widget buildPricingAndArea()')
method_body = method_body.replace('  Widget _buildDescriptionField()', '  Widget buildDescriptionField()')
method_body = method_body.replace('  Widget _buildCategorySelector()', '  Widget buildCategorySelector()')

new_file_content = f"""part of 'property_create_screen.dart';

extension PropertyCreateScreenBasics on _PropertyCreateScreenState {{
{method_body}
}}
"""

with open(new_file_path, 'w') as f:
    f.write(new_file_content)

# Update main file
# 1. Add part directive
part_str = "part 'property_create_screen_basics.dart';\n\nclass PropertyCreateScreen"
new_content = "".join(lines[:start_idx]) + "".join(lines[end_idx:])
new_content = new_content.replace("class PropertyCreateScreen", part_str, 1)

# 2. Replace calls
new_content = new_content.replace("_buildSection(", "buildSection(")
new_content = new_content.replace("_buildBasicInfo()", "buildBasicInfo()")
new_content = new_content.replace("_buildPricingAndArea()", "buildPricingAndArea()")
new_content = new_content.replace("_buildDescriptionField()", "buildDescriptionField()")
new_content = new_content.replace("_buildCategorySelector()", "buildCategorySelector()")

with open(file_path, 'w') as f:
    f.write(new_content)

print("Robust extraction of basics successful.")
