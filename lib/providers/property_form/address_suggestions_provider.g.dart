// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_suggestions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addressSuggestionsHash() =>
    r'3322ad24745523b33b60f9eff305c1b78689f95f';

/// See also [AddressSuggestions].
@ProviderFor(AddressSuggestions)
final addressSuggestionsProvider =
    AutoDisposeNotifierProvider<
      AddressSuggestions,
      AsyncValue<List<PlacePrediction>>
    >.internal(
      AddressSuggestions.new,
      name: r'addressSuggestionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressSuggestionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressSuggestions =
    AutoDisposeNotifier<AsyncValue<List<PlacePrediction>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
