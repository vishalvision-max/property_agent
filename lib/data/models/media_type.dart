/// Media-type tags for a property category, fetched from
/// /property-categories/{id}/media-types. Drives the tag dropdowns on the
/// property create screen so photo/video tags are dynamic per subcategory
/// instead of a hardcoded list.
class MediaTypeItem {
  const MediaTypeItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.isRequired,
    required this.minFiles,
    required this.maxFiles,
  });

  final int id;
  final String name;
  final String slug;
  final bool isRequired;
  final int minFiles;
  final int maxFiles;

  factory MediaTypeItem.fromJson(Map<String, dynamic> json) {
    return MediaTypeItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      isRequired: json['is_required'] == true,
      minFiles: (json['min_files'] as num?)?.toInt() ?? 0,
      maxFiles: (json['max_files'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Groups the photo and video tag options returned for a category.
class CategoryMediaTypes {
  const CategoryMediaTypes({required this.photos, required this.videos});

  final List<MediaTypeItem> photos;
  final List<MediaTypeItem> videos;

  static List<MediaTypeItem> _parseList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => MediaTypeItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }

  factory CategoryMediaTypes.fromJson(Map<String, dynamic> json) {
    return CategoryMediaTypes(
      photos: _parseList(json['photos']),
      videos: _parseList(json['videos']),
    );
  }

  static const empty = CategoryMediaTypes(photos: [], videos: []);
}