import sys

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
new_file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen_widgets.dart'

with open(file_path, 'r') as f:
    lines = f.readlines()

start_idx = -1
for i, line in enumerate(lines):
    if line.startswith('class MediaItem {'):
        start_idx = i
        break

if start_idx == -1:
    print("Could not find start index for independent widgets.")
    sys.exit(1)

widgets_content = "".join(lines[start_idx:])

new_file_content = f"""part of 'property_create_screen.dart';

{widgets_content}
"""

with open(new_file_path, 'w') as f:
    f.write(new_file_content)

# Update main file
# 1. Add part directive
part_str = "part 'property_create_screen_widgets.dart';\n\nclass PropertyCreateScreen"
new_content = "".join(lines[:start_idx])
new_content = new_content.replace("class PropertyCreateScreen", part_str, 1)

with open(file_path, 'w') as f:
    f.write(new_content)

print("Widgets extraction successful.")
