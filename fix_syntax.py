import re

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'
with open(file_path, 'r') as f:
    content = f.read()

# Fix isAddressLoading
old_loading = """            final isAddressLoading = ref.watch(addressSuggestionsProvider).isLoading || ref.watch(formSubmitStateProvider);
            if (isAddressLoading)"""

new_loading = """            if (ref.watch(addressSuggestionsProvider).isLoading || ref.watch(formSubmitStateProvider))"""

content = content.replace(old_loading, new_loading)

# Fix preds
old_preds = """            final preds = ref.watch(addressSuggestionsProvider).valueOrNull ?? [];
            if (_addressFocus.hasFocus && preds.isNotEmpty)"""

new_preds = """            if (_addressFocus.hasFocus && (ref.watch(addressSuggestionsProvider).valueOrNull ?? []).isNotEmpty)"""

content = content.replace(old_preds, new_preds)

# The items loop used `preds`! We need to change that.
content = content.replace("itemCount: preds.length,", "itemCount: (ref.watch(addressSuggestionsProvider).valueOrNull ?? []).length,")
content = content.replace("final pred = preds[i];", "final pred = (ref.watch(addressSuggestionsProvider).valueOrNull ?? [])[i];")

with open(file_path, 'w') as f:
    f.write(content)

print("Done fixing syntax.")
