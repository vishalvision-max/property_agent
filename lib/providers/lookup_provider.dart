import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/lookup_item.dart';
import '../data/models/category.dart';
import '../data/services/lookup_service.dart';

final lookupServiceProvider = Provider<LookupService>((ref) {
  return LookupService();
});

final amenitiesProvider = FutureProvider<List<LookupItem>>((ref) async {
  return ref.read(lookupServiceProvider).getAmenities();
});

final furnishingsProvider = FutureProvider<List<LookupItem>>((ref) async {
  return ref.read(lookupServiceProvider).getFurnishings();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(lookupServiceProvider).getCategories();
});
