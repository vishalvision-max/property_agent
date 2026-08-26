import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/category.dart';
import '../data/models/category_features.dart';
import '../data/models/media_type.dart';
import '../data/services/lookup_service.dart';

part 'lookup_provider.g.dart';

@Riverpod(keepAlive: true)
LookupService lookupService(Ref ref) {
  return LookupService();
}

@Riverpod(keepAlive: true)
Future<List<Category>> categories(Ref ref) {
  return ref.read(lookupServiceProvider).getCategories();
}

/// Fetches the sub-categories for [categoryId] from the dedicated
/// /property-categories/{id}/sub-categories endpoint.
@riverpod
Future<List<Category>> subCategories(Ref ref, int categoryId) {
  return ref.read(lookupServiceProvider).getSubCategories(categoryId);
}

/// Fetches the amenities + furnishings configured for [categoryId] from
/// /property-categories/{id}/features. Drives the category-specific amenity
/// and furnishing pickers on the property create screen.
@riverpod
Future<CategoryFeatures> categoryFeatures(Ref ref, int categoryId) {
  return ref.read(lookupServiceProvider).getCategoryFeatures(categoryId);
}

/// Fetches the photo/video media-type tags for [categoryId] from
/// /property-categories/{id}/media-types. Drives the dynamic tag dropdowns
/// on the property create screen.
@riverpod
Future<CategoryMediaTypes> mediaTypes(Ref ref, int categoryId) {
  return ref.read(lookupServiceProvider).getMediaTypes(categoryId);
}
