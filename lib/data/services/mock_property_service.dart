import 'dart:async';
import 'dart:math';

import '../models/activity.dart';
import '../models/property.dart';
import '../models/property_enums.dart';
import '../models/dashboard_counts.dart';
import 'property_service.dart';

class MockPropertyService implements PropertyService {
  MockPropertyService() {
    _seed();
  }

  final _rand = Random(7);
  final List<Property> _properties = [];

  List<ActivityItem> recentActivity({int limit = 8}) {
    final now = DateTime.now();
    final items = <ActivityItem>[
      ActivityItem(
        title: 'Property assigned',
        subtitle: '2 new properties assigned by admin',
        at: now.subtract(const Duration(hours: 3)),
      ),
      ActivityItem(
        title: 'Approval update',
        subtitle: 'Palm Heights is approved',
        at: now.subtract(const Duration(hours: 8)),
      ),
      ActivityItem(
        title: 'Rejection',
        subtitle: 'Ridge Villa rejected (missing documents)',
        at: now.subtract(const Duration(days: 1)),
      ),
      ActivityItem(
        title: 'Listing live',
        subtitle: 'City Center Studio is listed',
        at: now.subtract(const Duration(days: 2)),
      ),
    ];
    return items.take(limit).toList(growable: false);
  }

  void _seed() {
    const amenityPool = [
      'Parking',
      'Gym',
      'Pool',
      'Security',
      'Lift',
      'Power Backup',
      'Garden',
      'Clubhouse',
    ];
    const locations = [
      'Indore, Vijay Nagar',
      'Bhopal, Arera Colony',
      'Pune, Baner',
      'Gurgaon, Sector 52',
      'Noida, Sector 62',
    ];
    const names = [
      'Palm Heights',
      'City Center Studio',
      'Ridge Villa',
      'Emerald Residency',
      'Skyline Towers',
      'Orchid Homes',
    ];

    PropertyStatus statusByIndex(int i) => switch (i % 4) {
      0 => PropertyStatus.pending,
      1 => PropertyStatus.approved,
      2 => PropertyStatus.listed,
      _ => PropertyStatus.rejected,
    };

    for (var i = 0; i < 18; i++) {
      final status = statusByIndex(i);
      final shuffledAmenities = List<String>.of(amenityPool)..shuffle(_rand);
       _properties.add(
         Property(
           id: 'prop_${i + 1}',
           name: '${names[i % names.length]} ${i + 1}',
           ownerName: 'Owner ${String.fromCharCode(65 + (i % 8))}',
           location: locations[i % locations.length],
           price: 45000 + (i * 3200),
           type: i.isEven ? PropertyType.rent : PropertyType.sale,
           amenities: shuffledAmenities.take(3 + (i % 3)).toList(),
           images: const [
             'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=1200',
             'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=1200',
             'https://images.unsplash.com/photo-1501183638710-841dd1904471?w=1200',
           ],
           videos: const [],
           description:
               'Premium property with great connectivity, natural light and modern amenities. Ideal for families and working professionals.',
           status: status,
           area: 650 + (i * 12.0),
           rejectionReason: status == PropertyStatus.rejected
               ? 'Missing required approvals / photos.'
               : null,
           updatedAt: DateTime.now().subtract(Duration(hours: 2 * i)),
           createdAt: DateTime.now().subtract(Duration(days: i)),
           categoryId: '2',
           userId: 4,
           isFeatured: i % 3 == 0,
           featuredExpiry: i % 3 == 0 ? DateTime.now().add(const Duration(days: 365)) : null,
           documents: const [],
         ),
       );
    }
  }

  @override
  Future<List<Property>> getAssignedProperties() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return List<Property>.unmodifiable(_properties);
  }

  @override
  Future<Property> getPropertyById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _properties.firstWhere((p) => p.id == id);
  }

  @override
  Future<Property> updateProperty(Property property) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final idx = _properties.indexWhere((p) => p.id == property.id);
    if (idx == -1) throw Exception('Property not found');
    final updated = property.copyWith(updatedAt: DateTime.now());
    _properties[idx] = updated;
    return updated;
  }

  @override
  Future<Property> createProperty(Property property) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final exists = _properties.any((p) => p.id == property.id);
    if (exists) throw Exception('Property id already exists');
    final created = property.copyWith(updatedAt: DateTime.now());
    _properties.insert(0, created);
    return created;
  }

  @override
  Future<List<String>> uploadImages({
    required String propertyId,
    required List<String> localPaths,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    // Mock: treat local paths as uploaded URLs.
    return localPaths;
  }

  @override
  Future<Property> publishProperty(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final p = await getPropertyById(id);
    if (p.status != PropertyStatus.approved) {
      throw Exception('Publish is allowed only for Approved properties');
    }
    final updated = p.copyWith(
      status: PropertyStatus.listed,
      updatedAt: DateTime.now(),
    );
    return updateProperty(updated);
  }

  @override
  Future<Property> rejectProperty({
    required String id,
    required String reason,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final p = await getPropertyById(id);
    final updated = p.copyWith(
      status: PropertyStatus.rejected,
      rejectionReason: reason,
      updatedAt: DateTime.now(),
    );
    return updateProperty(updated);
  }

  @override
  Future<DashboardCounts> getStatusCounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 420));
    final assigned = _properties.length;
    final listed = _properties.where((p) => p.status == PropertyStatus.listed).length;
    final pending = _properties.where((p) => p.status == PropertyStatus.pending).length;
    final rejected = _properties.where((p) => p.status == PropertyStatus.rejected).length;
    return DashboardCounts(
      assigned: assigned,
      listed: listed,
      pending: pending,
      rejected: rejected,
    );
  }

  @override
  Future<List<ActivityItem>> getDashboardActivity() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return recentActivity();
  }
}
