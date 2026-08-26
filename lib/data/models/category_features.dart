import 'lookup_item.dart';

/// Amenities + furnishings configured for a property category, fetched from
/// /property-categories/{id}/features. Replaces the global /amenities and
/// /furnishings lookups so the create screen shows only the features that
/// apply to the selected subcategory.
class CategoryFeatures {
  const CategoryFeatures({required this.amenities, required this.furnishings});

  final List<LookupItem> amenities;
  final List<LookupItem> furnishings;

  static List<LookupItem> _parseList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => LookupItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }

  factory CategoryFeatures.fromJson(Map<String, dynamic> json) {
    return CategoryFeatures(
      amenities: _parseList(json['amenities']),
      furnishings: _parseList(json['furnishings']),
    );
  }

  static const empty = CategoryFeatures(amenities: [], furnishings: []);
}