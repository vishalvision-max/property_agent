class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parentId,
    required this.status,
    required this.children,
  });

  final int id;
  final String name;
  final String slug;
  final int? parentId;
  final String? status;
  final List<Category> children;

  factory Category.fromJson(Map<String, dynamic> json) {
    final rawChildren = (json['children'] as List?) ?? const [];
    return Category(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      parentId: (json['parent_id'] as num?)?.toInt(),
      status: json['status']?.toString(),
      children: rawChildren
          .whereType<Map>()
          .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false),
    );
  }
}

