import re

file_path = '/home/pc/Downloads/property_agent/property_agent/lib/presentation/screens/property/property_create_screen.dart'

with open(file_path, 'r') as f:
    content = f.read()

# Replace _onAddressChanged
old_on_address = """  void _onAddressChanged(String _) {
    if (_suppressAddressAutocomplete) return;
    _validateField('address');
    _addressDebounce?.cancel();
    _addressDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      final q = _address.text.trim();
      if (q.length < 3 || !_addressFocus.hasFocus) {
        setState(() => _addressPredictions = const []);
        return;
      }
      setState(() => _isFetchingAddress = true);
      try {
        final preds = await _places.autocomplete(
          input: q,
          country: 'in',
          language: 'en',
        );
        if (!mounted) return;
        setState(() => _addressPredictions = preds);
      } catch (e) {
        if (!mounted) return;
        setState(() => _addressPredictions = const []);
        if (!_didShowPlacesError && _addressFocus.hasFocus) {
          _didShowPlacesError = true;
          AppSnackbar.show(
            context,
            'Address suggestions not available: ${e.toString()}',
          );
        }
      } finally {
        if (!mounted) return;
        setState(() => _isFetchingAddress = false);
      }
    });
  }"""

new_on_address = """  void _onAddressChanged(String _) {
    if (_suppressAddressAutocomplete) return;
    _validateField('address');
    _addressDebounce?.cancel();
    _addressDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      final q = _address.text.trim();
      if (q.length < 3 || !_addressFocus.hasFocus) {
        ref.read(addressSuggestionsProvider.notifier).clear();
        return;
      }
      try {
        await ref.read(addressSuggestionsProvider.notifier).fetchSuggestions(q);
      } catch (e) {
        if (!mounted) return;
        if (!_didShowPlacesError && _addressFocus.hasFocus) {
          _didShowPlacesError = true;
          AppSnackbar.show(
            context,
            'Address suggestions not available: ${e.toString()}',
          );
        }
      }
    });
  }"""

content = content.replace(old_on_address, new_on_address)

# Replace _selectAddressPrediction
old_select = """  Future<void> _selectAddressPrediction(PlacePrediction p) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isFetchingAddress = true;
      _addressPredictions = const [];
    });"""

new_select = """  Future<void> _selectAddressPrediction(PlacePrediction p) async {
    FocusScope.of(context).unfocus();
    ref.read(addressSuggestionsProvider.notifier).clear();
    // Start loader via new FormSubmitState for place details
    ref.read(formSubmitStateProvider.notifier).setSubmitting(true);
    """

content = content.replace(old_select, new_select)

# Replace the finally block of _selectAddressPrediction
old_finally = """    } finally {
      if (!mounted) return;
      setState(() => _isFetchingAddress = false);
    }
  }"""

new_finally = """    } finally {
      if (!mounted) return;
      ref.read(formSubmitStateProvider.notifier).setSubmitting(false);
    }
  }"""

content = content.replace(old_finally, new_finally)

# Now, UI replacements for _isFetchingAddress
content = content.replace(
    "if (_isFetchingAddress)",
    "final isAddressLoading = ref.watch(addressSuggestionsProvider).isLoading || ref.watch(formSubmitStateProvider);\n            if (isAddressLoading)"
)

# And UI replacements for _addressPredictions
content = content.replace(
    "if (_addressFocus.hasFocus && _addressPredictions.isNotEmpty)",
    "final preds = ref.watch(addressSuggestionsProvider).valueOrNull ?? [];\n            if (_addressFocus.hasFocus && preds.isNotEmpty)"
)

content = content.replace("itemCount: _addressPredictions.length,", "itemCount: preds.length,")
content = content.replace("final pred = _addressPredictions[i];", "final pred = preds[i];")

# Clear up the top declarations
content = content.replace("bool _isFetchingAddress = false;", "// bool _isFetchingAddress = false;")
content = content.replace("List<PlacePrediction> _addressPredictions = const [];", "// List<PlacePrediction> _addressPredictions = const [];")

# Add imports
imports = """import 'package:property_agent/providers/property_form/address_suggestions_provider.dart';
import 'package:property_agent/providers/property_form/form_submit_state_provider.dart';"""

if "address_suggestions_provider.dart" not in content:
    content = content.replace("import 'package:flutter_riverpod/flutter_riverpod.dart';", f"import 'package:flutter_riverpod/flutter_riverpod.dart';\n{imports}")

# Write back
with open(file_path, 'w') as f:
    f.write(content)

print("Done replacing.")
