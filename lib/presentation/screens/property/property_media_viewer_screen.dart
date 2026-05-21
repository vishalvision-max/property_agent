import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/local_image.dart';

class PropertyMediaViewerScreen extends StatefulWidget {
  const PropertyMediaViewerScreen({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<PropertyMediaViewerScreen> createState() =>
      _PropertyMediaViewerScreenState();
}

class _PropertyMediaViewerScreenState extends State<PropertyMediaViewerScreen> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex.clamp(0, (widget.images.length - 1).clamp(0, 1 << 30)),
  );
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, (widget.images.length - 1).clamp(0, 1 << 30));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(imgs.isEmpty ? 'Media' : '${_index + 1}/${imgs.length}'),
      ),
      body: imgs.isEmpty
          ? const Center(child: Text('No images', style: TextStyle(color: Colors.white70)))
          : PageView.builder(
              controller: _controller,
              itemCount: imgs.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) {
                final src = imgs[i];
                final image = src.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: src,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.white70),
                        ),
                      )
                    : buildLocalImage(
                        src,
                        fit: BoxFit.contain,
                        placeholder: const Center(
                          child: Icon(Icons.broken_image_outlined, color: Colors.white70),
                        ),
                      );

                // Zoom + pan. When zoomed, user can "scroll/pan" within the image.
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  panEnabled: true,
                  clipBehavior: Clip.none,
                  child: Center(child: image),
                );
              },
            ),
    );
  }
}

