/// Shared media model used by the property form and media widgets.
/// Extracted from property_create_screen.dart so it can be imported
/// by providers and section widgets without a circular dependency.
enum MediaType { image, video }

class MediaItem {
  final String path;
  final MediaType type;
  String? tag;

  MediaItem({required this.path, required this.type, this.tag});
}
