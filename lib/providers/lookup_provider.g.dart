// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lookupService)
final lookupServiceProvider = LookupServiceProvider._();

final class LookupServiceProvider
    extends $FunctionalProvider<LookupService, LookupService, LookupService>
    with $Provider<LookupService> {
  LookupServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lookupServiceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lookupServiceHash();

  @$internal
  @override
  $ProviderElement<LookupService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LookupService create(Ref ref) {
    return lookupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LookupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LookupService>(value),
    );
  }
}

String _$lookupServiceHash() => r'2ae4b1c33c80caff21940c3a82bbbbc56446c430';

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider extends $FunctionalProvider<
        AsyncValue<List<Category>>, List<Category>, FutureOr<List<Category>>>
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  CategoriesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'categoriesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'7c079c476673159c7774157cda620746167486cd';

/// Fetches the sub-categories for [categoryId] from the dedicated
/// /property-categories/{id}/sub-categories endpoint.

@ProviderFor(subCategories)
final subCategoriesProvider = SubCategoriesFamily._();

/// Fetches the sub-categories for [categoryId] from the dedicated
/// /property-categories/{id}/sub-categories endpoint.

final class SubCategoriesProvider extends $FunctionalProvider<
        AsyncValue<List<Category>>, List<Category>, FutureOr<List<Category>>>
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// Fetches the sub-categories for [categoryId] from the dedicated
  /// /property-categories/{id}/sub-categories endpoint.
  SubCategoriesProvider._(
      {required SubCategoriesFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'subCategoriesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$subCategoriesHash();

  @override
  String toString() {
    return r'subCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    final argument = this.argument as int;
    return subCategories(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SubCategoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subCategoriesHash() => r'908e80fe425713cdf4bc4a448f0e1df639fcdc5c';

/// Fetches the sub-categories for [categoryId] from the dedicated
/// /property-categories/{id}/sub-categories endpoint.

final class SubCategoriesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Category>>, int> {
  SubCategoriesFamily._()
      : super(
          retry: null,
          name: r'subCategoriesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Fetches the sub-categories for [categoryId] from the dedicated
  /// /property-categories/{id}/sub-categories endpoint.

  SubCategoriesProvider call(
    int categoryId,
  ) =>
      SubCategoriesProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'subCategoriesProvider';
}

/// Fetches the amenities + furnishings configured for [categoryId] from
/// /property-categories/{id}/features. Drives the category-specific amenity
/// and furnishing pickers on the property create screen.

@ProviderFor(categoryFeatures)
final categoryFeaturesProvider = CategoryFeaturesFamily._();

/// Fetches the amenities + furnishings configured for [categoryId] from
/// /property-categories/{id}/features. Drives the category-specific amenity
/// and furnishing pickers on the property create screen.

final class CategoryFeaturesProvider extends $FunctionalProvider<
        AsyncValue<CategoryFeatures>,
        CategoryFeatures,
        FutureOr<CategoryFeatures>>
    with $FutureModifier<CategoryFeatures>, $FutureProvider<CategoryFeatures> {
  /// Fetches the amenities + furnishings configured for [categoryId] from
  /// /property-categories/{id}/features. Drives the category-specific amenity
  /// and furnishing pickers on the property create screen.
  CategoryFeaturesProvider._(
      {required CategoryFeaturesFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'categoryFeaturesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$categoryFeaturesHash();

  @override
  String toString() {
    return r'categoryFeaturesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CategoryFeatures> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CategoryFeatures> create(Ref ref) {
    final argument = this.argument as int;
    return categoryFeatures(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryFeaturesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryFeaturesHash() => r'52e71e0eb6e88f54c95b882aa92917078b35a4fa';

/// Fetches the amenities + furnishings configured for [categoryId] from
/// /property-categories/{id}/features. Drives the category-specific amenity
/// and furnishing pickers on the property create screen.

final class CategoryFeaturesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CategoryFeatures>, int> {
  CategoryFeaturesFamily._()
      : super(
          retry: null,
          name: r'categoryFeaturesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Fetches the amenities + furnishings configured for [categoryId] from
  /// /property-categories/{id}/features. Drives the category-specific amenity
  /// and furnishing pickers on the property create screen.

  CategoryFeaturesProvider call(
    int categoryId,
  ) =>
      CategoryFeaturesProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'categoryFeaturesProvider';
}

/// Fetches the photo/video media-type tags for [categoryId] from
/// /property-categories/{id}/media-types. Drives the dynamic tag dropdowns
/// on the property create screen.

@ProviderFor(mediaTypes)
final mediaTypesProvider = MediaTypesFamily._();

/// Fetches the photo/video media-type tags for [categoryId] from
/// /property-categories/{id}/media-types. Drives the dynamic tag dropdowns
/// on the property create screen.

final class MediaTypesProvider extends $FunctionalProvider<
        AsyncValue<CategoryMediaTypes>,
        CategoryMediaTypes,
        FutureOr<CategoryMediaTypes>>
    with
        $FutureModifier<CategoryMediaTypes>,
        $FutureProvider<CategoryMediaTypes> {
  /// Fetches the photo/video media-type tags for [categoryId] from
  /// /property-categories/{id}/media-types. Drives the dynamic tag dropdowns
  /// on the property create screen.
  MediaTypesProvider._(
      {required MediaTypesFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'mediaTypesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mediaTypesHash();

  @override
  String toString() {
    return r'mediaTypesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CategoryMediaTypes> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CategoryMediaTypes> create(Ref ref) {
    final argument = this.argument as int;
    return mediaTypes(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MediaTypesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaTypesHash() => r'20cecb5b092e0556d5369140ad12cc43211a1f54';

/// Fetches the photo/video media-type tags for [categoryId] from
/// /property-categories/{id}/media-types. Drives the dynamic tag dropdowns
/// on the property create screen.

final class MediaTypesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CategoryMediaTypes>, int> {
  MediaTypesFamily._()
      : super(
          retry: null,
          name: r'mediaTypesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Fetches the photo/video media-type tags for [categoryId] from
  /// /property-categories/{id}/media-types. Drives the dynamic tag dropdowns
  /// on the property create screen.

  MediaTypesProvider call(
    int categoryId,
  ) =>
      MediaTypesProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'mediaTypesProvider';
}
