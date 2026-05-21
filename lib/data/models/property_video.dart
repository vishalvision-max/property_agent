import 'package:equatable/equatable.dart';

class PropertyVideo extends Equatable {
  const PropertyVideo({
    required this.id,
    required this.url,
    this.type,
    this.title,
    this.thumbnailUrl,
    this.isFeatured,
  });

  final String id;
  final String url;
  final String? type;
  final String? title;
  final String? thumbnailUrl;
  final bool? isFeatured;

  factory PropertyVideo.fromJson(Map<String, dynamic> json) => PropertyVideo(
        id: (json['id'] ?? '').toString(),
        url: (json['url'] ?? json['video_path'] ?? '').toString(),
        type: json['type']?.toString(),
        title: json['title']?.toString(),
        thumbnailUrl: json['thumbnail']?.toString(),
        isFeatured: json['is_featured'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'type': type,
        'title': title,
        'thumbnailUrl': thumbnailUrl,
        'isFeatured': isFeatured,
      };

  @override
  List<Object?> get props => [id, url, type, title, thumbnailUrl, isFeatured];
}

