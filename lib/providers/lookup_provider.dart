import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/lookup_item.dart';
import '../data/models/category.dart';
import '../data/services/lookup_service.dart';

part 'lookup_provider.g.dart';

@Riverpod(keepAlive: true)
LookupService lookupService(LookupServiceRef ref) {
  return LookupService();
}

@Riverpod(keepAlive: true)
Future<List<LookupItem>> amenities(AmenitiesRef ref) {
  return ref.read(lookupServiceProvider).getAmenities();
}

@Riverpod(keepAlive: true)
Future<List<LookupItem>> furnishings(FurnishingsRef ref) {
  return ref.read(lookupServiceProvider).getFurnishings();
}

@Riverpod(keepAlive: true)
Future<List<Category>> categories(CategoriesRef ref) {
  return ref.read(lookupServiceProvider).getCategories();
}
