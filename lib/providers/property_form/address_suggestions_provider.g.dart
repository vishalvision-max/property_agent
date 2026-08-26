// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_suggestions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddressSuggestions)
final addressSuggestionsProvider = AddressSuggestionsProvider._();

final class AddressSuggestionsProvider extends $NotifierProvider<
    AddressSuggestions, AsyncValue<List<PlacePrediction>>> {
  AddressSuggestionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'addressSuggestionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$addressSuggestionsHash();

  @$internal
  @override
  AddressSuggestions create() => AddressSuggestions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<PlacePrediction>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<PlacePrediction>>>(value),
    );
  }
}

String _$addressSuggestionsHash() =>
    r'3322ad24745523b33b60f9eff305c1b78689f95f';

abstract class _$AddressSuggestions
    extends $Notifier<AsyncValue<List<PlacePrediction>>> {
  AsyncValue<List<PlacePrediction>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<PlacePrediction>>,
        AsyncValue<List<PlacePrediction>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PlacePrediction>>,
            AsyncValue<List<PlacePrediction>>>,
        AsyncValue<List<PlacePrediction>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
