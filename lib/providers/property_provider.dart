import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/property.dart';
import '../data/models/property_enums.dart';
import 'app_providers.dart';
import 'dashboard_provider.dart';

final propertiesProvider = FutureProvider<List<Property>>((ref) async {
  return ref.read(propertyRepositoryProvider).getAssignedProperties();
});

final propertyByIdProvider = FutureProvider.family<Property, String>((ref, id) async {
  return ref.read(propertyRepositoryProvider).getPropertyById(id);
});

class PropertyActionsNotifier extends StateNotifier<AsyncValue<void>> {
  PropertyActionsNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<String> create(Property property) async {
    state = const AsyncValue.loading();
    try {
      final created = await _ref.read(propertyRepositoryProvider).createProperty(property);
      state = const AsyncValue.data(null);
      _ref.invalidate(propertiesProvider);
      _ref.invalidate(propertyByIdProvider(created.id));
      _ref.invalidate(dashboardProvider);
      return created.id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> update(Property property) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(propertyRepositoryProvider).updateProperty(property);
      state = const AsyncValue.data(null);
      _ref.invalidate(propertiesProvider);
      _ref.invalidate(propertyByIdProvider(property.id));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> publish(String id) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(propertyRepositoryProvider).publishProperty(id);
      state = const AsyncValue.data(null);
      _ref.invalidate(propertiesProvider);
      _ref.invalidate(propertyByIdProvider(id));
      _ref.invalidate(dashboardProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> reject({required String id, required String reason}) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(propertyRepositoryProvider).rejectProperty(id: id, reason: reason);
      state = const AsyncValue.data(null);
      _ref.invalidate(propertiesProvider);
      _ref.invalidate(propertyByIdProvider(id));
      _ref.invalidate(dashboardProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final propertyActionsProvider = StateNotifierProvider<PropertyActionsNotifier, AsyncValue<void>>((ref) {
  return PropertyActionsNotifier(ref);
});

List<Property> filterByStatus(List<Property> all, PropertyStatus? status) {
  if (status == null) return List<Property>.of(all);
  return all.where((p) => p.status == status).toList(growable: false);
}
