import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/providers/property_form/property_form_notifier.dart';
import 'package:property_agent/providers/property_form/property_form_state.dart';

/// Auto-disposed so state resets when the create/edit screen is popped.
final propertyFormProvider =
    StateNotifierProvider.autoDispose<PropertyFormNotifier, PropertyFormState>(
  (ref) => PropertyFormNotifier(),
);
