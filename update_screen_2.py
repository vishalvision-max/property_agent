import re

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

# Replace ref.read(propertyFormProvider.notifier).setSubmitting(v) -> ref.read(formSubmitStateProvider.notifier).setSubmitting(v)
content = re.sub(r'ref\.read\(propertyFormProvider\.notifier\)\.setSubmitting\((.*?)\);', r'ref.read(formSubmitStateProvider.notifier).setSubmitting(\1);', content)

# Replace ref.read(propertyFormProvider.notifier).setDraftSaving(v) -> ref.read(formDraftSavingStateProvider.notifier).setSaving(v)
content = re.sub(r'ref\.read\(propertyFormProvider\.notifier\)\.setDraftSaving\((.*?)\);', r'ref.read(formDraftSavingStateProvider.notifier).setSaving(\1);', content)

# Replace state.isSubmitting -> isSubmitting
content = re.sub(r'state\.isSubmitting', 'isSubmitting', content)
content = re.sub(r'state\.isDraftSaving', 'isDraftSaving', content)

with open(file_path, 'w') as f:
    f.write(content)

print("Done updating property create screen.")
