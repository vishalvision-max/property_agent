class LookupItem {
  const LookupItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.type,
    required this.isCountable,
    required this.icon,
  });

  final int id;
  final String name;
  final String slug;
  final String type;
  final bool isCountable;
  final String? icon;

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      isCountable: json['is_countable'] == true,
      icon: json['icon']?.toString(),
    );
  }
}

