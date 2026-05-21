import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/utils/local_image.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({super.key, required this.src});

  final String src;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
    );

    if (src.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image_outlined, size: 18)),
      );
    }

    return buildLocalImage(
      src,
      fit: BoxFit.cover,
      placeholder: placeholder,
    );
  }
}

