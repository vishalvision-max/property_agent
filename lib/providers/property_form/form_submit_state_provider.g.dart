// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_submit_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FormSubmitState)
final formSubmitStateProvider = FormSubmitStateProvider._();

final class FormSubmitStateProvider
    extends $NotifierProvider<FormSubmitState, bool> {
  FormSubmitStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'formSubmitStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$formSubmitStateHash();

  @$internal
  @override
  FormSubmitState create() => FormSubmitState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$formSubmitStateHash() => r'99181ecc328225cf8df162265d7ebff34df0bbc3';

abstract class _$FormSubmitState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FormDraftSavingState)
final formDraftSavingStateProvider = FormDraftSavingStateProvider._();

final class FormDraftSavingStateProvider
    extends $NotifierProvider<FormDraftSavingState, bool> {
  FormDraftSavingStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'formDraftSavingStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$formDraftSavingStateHash();

  @$internal
  @override
  FormDraftSavingState create() => FormDraftSavingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$formDraftSavingStateHash() =>
    r'535ddff68f66b3978aa6c27387df1d163a9b26e0';

abstract class _$FormDraftSavingState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
