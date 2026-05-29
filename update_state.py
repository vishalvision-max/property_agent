import re

# Update PropertyFormNotifier
notifier_path = '/home/pc/Downloads/property_agent/property_agent/lib/providers/property_form/property_form_notifier.dart'
with open(notifier_path, 'r') as f:
    content = f.read()

content = re.sub(r'\s*void setSubmitting\(bool v\) => state = state\.copyWith\(isSubmitting: v\);\n', '\n', content)
content = re.sub(r'\s*void setDraftSaving\(bool v\) => state = state\.copyWith\(isDraftSaving: v\);\n', '\n', content)

with open(notifier_path, 'w') as f:
    f.write(content)

# Update PropertyFormState
state_path = '/home/pc/Downloads/property_agent/property_agent/lib/providers/property_form/property_form_state.dart'
with open(state_path, 'r') as f:
    content = f.read()

content = re.sub(r'\s*this\.isSubmitting = false,\n', '\n', content)
content = re.sub(r'\s*this\.isDraftSaving = false,\n', '\n', content)
content = re.sub(r'\s*final bool isSubmitting;\n', '\n', content)
content = re.sub(r'\s*final bool isDraftSaving;\n', '\n', content)
content = re.sub(r'\s*bool\? isSubmitting,\n', '\n', content)
content = re.sub(r'\s*bool\? isDraftSaving,\n', '\n', content)
content = re.sub(r'\s*isSubmitting: isSubmitting \?\? this\.isSubmitting,\n', '\n', content)
content = re.sub(r'\s*isDraftSaving: isDraftSaving \?\? this\.isDraftSaving,\n', '\n', content)

with open(state_path, 'w') as f:
    f.write(content)

print("Done updating state.")
