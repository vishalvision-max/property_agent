// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_form_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Business logic for the property creation/edit form.
/// All field mutations go through here — the UI just calls methods and reads state.

@ProviderFor(PropertyForm)
final propertyFormProvider = PropertyFormProvider._();

/// Business logic for the property creation/edit form.
/// All field mutations go through here — the UI just calls methods and reads state.
final class PropertyFormProvider
    extends $NotifierProvider<PropertyForm, PropertyFormState> {
  /// Business logic for the property creation/edit form.
  /// All field mutations go through here — the UI just calls methods and reads state.
  PropertyFormProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'propertyFormProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$propertyFormHash();

  @$internal
  @override
  PropertyForm create() => PropertyForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PropertyFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PropertyFormState>(value),
    );
  }
}

String _$propertyFormHash() => r'625f24d86a7440b81c759cbdbf358ad2a2e897fc';

/// Business logic for the property creation/edit form.
/// All field mutations go through here — the UI just calls methods and reads state.

abstract class _$PropertyForm extends $Notifier<PropertyFormState> {
  PropertyFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PropertyFormState, PropertyFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PropertyFormState, PropertyFormState>,
        PropertyFormState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
