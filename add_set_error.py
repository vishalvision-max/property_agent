import re

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/providers/property_form/property_form_notifier.dart'
with open(file_path, 'r') as f:
    content = f.read()

new_method = """  void setError(String field, String? error) {
    final updated = Map<String, String?>.from(state.validationErrors);
    updated[field] = error;
    state = state.copyWith(validationErrors: updated);
  }

  void clearError(String field) {"""

content = content.replace('  void clearError(String field) {', new_method)

with open(file_path, 'w') as f:
    f.write(content)

print("Done updating property form notifier.")
