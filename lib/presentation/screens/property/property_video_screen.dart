import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/property_video.dart';
import '../../widgets/property_video_player.dart';

class PropertyVideoScreen extends StatelessWidget {
  const PropertyVideoScreen({
    super.key,
    required this.propertyId,
    required this.video,
  });

  final String propertyId;
  final PropertyVideo video;

  @override
  Widget build(BuildContext context) {
    const pageBg = Color(0xFF070B14);
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFFCBD5E1);

    final title = (video.title ?? '').trim().isNotEmpty
        ? video.title!.trim()
        : ((video.type ?? '').trim().isNotEmpty ? video.type!.trim() : 'Video');

    return SafeArea(
      child: Scaffold(
        backgroundColor: pageBg,
        appBar: AppBar(
          backgroundColor: pageBg,
          foregroundColor: textPrimary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PropertyVideoPlayer(url: video.url, autoPlay: true),
            const SizedBox(height: 14),
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.gold,
                  ),
            ),
            const SizedBox(height: 8),
            _kv(context, 'Property ID', propertyId, textPrimary, textSecondary),
            _kv(context, 'Video ID', video.id, textPrimary, textSecondary),
            if ((video.type ?? '').trim().isNotEmpty)
              _kv(context, 'Type', video.type!, textPrimary, textSecondary),
            _kv(context, 'URL', video.url, textPrimary, textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _kv(
    BuildContext context,
    String k,
    String v,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              k,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: textSecondary, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              v,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

