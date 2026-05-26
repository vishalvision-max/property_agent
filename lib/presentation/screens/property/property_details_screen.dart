import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:property_agent/presentation/screens/property/property_edit_screen.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/property_enums.dart';
import '../../../data/models/property.dart';
import '../../../providers/property_provider.dart';
import '../../../routes/route_names.dart';
import '../../widgets/error_state.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/image_carousel.dart';
import '../../widgets/property_video_player.dart';
import '../../widgets/shimmer_list.dart';
import '../../widgets/status_badge.dart';
import 'property_media_viewer_screen.dart';

class PropertyDetailsScreen extends ConsumerStatefulWidget {
  const PropertyDetailsScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailsScreen> createState() =>
      _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends ConsumerState<PropertyDetailsScreen> {
  String? _selectedVideoId;
  String? _prefetchedForPropertyId;
  bool _showAllAmenities = false;
  bool _showAllFurnishings = false;

  @override
  Widget build(BuildContext context) {
    final propertyId = widget.propertyId;
    final async = ref.watch(propertyByIdProvider(propertyId));
    final actions = ref.watch(propertyActionsProvider);
    const pageBg = Color(0xFF070B14);
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: async.when(
        loading: () => AppBar(
          backgroundColor: pageBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Property Details', style: TextStyle(color: textPrimary)),
        ),
        error: (e, _) => AppBar(
          backgroundColor: pageBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: textPrimary),
            onPressed: () => context.pop(),
          ),
          title: const Text('Error', style: TextStyle(color: textPrimary)),
        ),
        data: (p) => null,
      ),
      body: async.when(
          loading: () => const ShimmerList(itemCount: 5),
          error: (e, _) => ErrorState(
            title: 'Failed to load property',
            subtitle: e.toString(),
            onRetry: () => ref.invalidate(propertyByIdProvider(propertyId)),
          ),
          data: (p) {
            final videos = p.videos;
            final furnishingsRaw = p.apiFields?['furnishings'] as List? ??
                p.apiFields?['furnishing_selections'] as List?;
            final furnishingLabels = furnishingsRaw != null
                ? furnishingsRaw
                    .map((f) {
                      if (f is Map) {
                        final name = (f['name'] ?? f['title'] ?? '').toString();
                        final pivot = f['pivot'] as Map?;
                        final qty = pivot?['quantity'] ?? f['quantity'];
                        final isCountable = f['is_countable'] == true ||
                            f['is_countable'] == 1 ||
                            f['is_countable'] == '1';
                        if (name.isNotEmpty) {
                          if (isCountable &&
                              qty != null &&
                              qty is num &&
                              qty > 0) {
                            return '$name ($qty)';
                          }
                          return name;
                        }
                      }
                      return '';
                    })
                    .where((s) => s.isNotEmpty)
                    .toList()
                : const <String>[];
            // Set the initial selected video without scheduling a second build.
            if (videos.isNotEmpty && _selectedVideoId == null) {
              _selectedVideoId = videos.first.id;
            }
            final selectedVideo = videos.isEmpty
                ? null
                : videos.firstWhere(
                    (v) => v.id.isNotEmpty && v.id == _selectedVideoId,
                    orElse: () => videos.first,
                  );

            if (_prefetchedForPropertyId != p.id) {
              _prefetchedForPropertyId = p.id;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _prefetchMedia(p);
              });
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 310,
                  backgroundColor: pageBg,
                  surfaceTintColor: Colors.transparent,
                  foregroundColor: textPrimary,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  title: Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textPrimary),
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => context.goNamed(
                        RouteNames.propertyEdit,
                        pathParameters: {'id': propertyId},
                      ),
                      icon: const Icon(Icons.edit_outlined, color: textPrimary),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 12,
                        top: 96,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ImageCarousel(
                              images: p.images,
                              height: 200,
                              onTap: (index) {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => PropertyMediaViewerScreen(
                                      images: p.images,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          AppSpacing.vSm,
                          Row(
                            children: [
                              StatusBadge(status: p.status),
                              AppSpacing.hSm,
                              Text(
                                '₹${p.price.toStringAsFixed(0)} • ${p.displayTag}',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.gold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      GlassContainer(
                        blur: false,
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(
                              icon: Icons.place_outlined,
                              label: p.location,
                              iconColor: AppTheme.gold,
                              textColor: textPrimary,
                            ),
                            AppSpacing.vXs,
                            _InfoRow(
                              icon: Icons.currency_rupee_rounded,
                              label: p.price.toStringAsFixed(0),
                              iconColor: AppTheme.gold,
                              textColor: textPrimary,
                            ),
                            AppSpacing.vXs,
                            _InfoRow(
                              icon: Icons.category_outlined,
                              label: p.displayTag,
                              iconColor: AppTheme.gold,
                              textColor: textPrimary,
                            ),
                            if (p.area != null) ...[
                              AppSpacing.vXs,
                              _InfoRow(
                                icon: Icons.square_foot_outlined,
                                label:
                                    '${p.area!.toStringAsFixed(0)} ${p.areaUnit ?? 'sq ft'}',
                                iconColor: AppTheme.gold,
                                textColor: textPrimary,
                              ),
                            ],
                            if ((p.address ?? '').trim().isNotEmpty) ...[
                              AppSpacing.vXs,
                              _InfoRow(
                                icon: Icons.map_outlined,
                                label: p.address!.trim(),
                                iconColor: AppTheme.gold,
                                textColor: textPrimary,
                              ),
                            ],
                            if ((p.city ?? '').trim().isNotEmpty ||
                                (p.state ?? '').trim().isNotEmpty) ...[
                              AppSpacing.vXs,
                              _InfoRow(
                                icon: Icons.location_city_outlined,
                                label: [
                                  if ((p.city ?? '').trim().isNotEmpty)
                                    p.city!.trim(),
                                  if ((p.state ?? '').trim().isNotEmpty)
                                    p.state!.trim(),
                                  if ((p.pincode ?? '').trim().isNotEmpty)
                                    p.pincode!.trim(),
                                ].join(', '),
                                iconColor: AppTheme.gold,
                                textColor: textPrimary,
                              ),
                            ],
                            if (p.bedrooms != null || p.bathrooms != null) ...[
                              AppSpacing.vXs,
                              _InfoRow(
                                icon: Icons.meeting_room_outlined,
                                label: [
                                  if (p.bedrooms != null) '${p.bedrooms} bed',
                                  if (p.bathrooms != null)
                                    '${p.bathrooms} bath',
                                ].join(' • '),
                                iconColor: AppTheme.gold,
                                textColor: textPrimary,
                              ),
                            ],
                            if ((p.furnishing ?? '').trim().isNotEmpty) ...[
                              AppSpacing.vXs,
                              _InfoRow(
                                icon: Icons.chair_outlined,
                                label: p.furnishing!.trim(),
                                iconColor: AppTheme.gold,
                                textColor: textPrimary,
                              ),
                            ],
                            if (p.floor != null || p.totalFloors != null) ...[
                              AppSpacing.vXs,
                              _InfoRow(
                                icon: Icons.apartment_outlined,
                                label: [
                                  if (p.floor != null) 'Floor ${p.floor}',
                                  if (p.totalFloors != null)
                                    'of ${p.totalFloors}',
                                ].join(' '),
                                iconColor: AppTheme.gold,
                                textColor: textPrimary,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (selectedVideo != null) ...[
                        AppSpacing.vLg,
                        Text(
                          'Videos',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.gold,
                              ),
                        ),
                        AppSpacing.vSm,
                        PropertyVideoPlayer(
                          key: ValueKey<String>(selectedVideo.url),
                          url: selectedVideo.url,
                          autoPlay: selectedVideo == videos.first,
                        ),
                        if (videos.length > 1) ...[
                          AppSpacing.vSm,
                          GlassContainer(
                            blur: false,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                for (final v in videos)
                                  ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    leading: const Icon(
                                      Icons.play_circle_outline,
                                      color: textPrimary,
                                    ),
                                    title: Text(
                                      (v.title ?? '').trim().isEmpty
                                          ? (v.type ?? 'Video')
                                          : v.title!.trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: textPrimary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    subtitle: Text(
                                      v.url,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: textSecondary),
                                    ),
                                    trailing: IconButton(
                                      tooltip: 'Open',
                                      onPressed: () => context.pushNamed(
                                        RouteNames.propertyVideo,
                                        pathParameters: {
                                          'id': p.id,
                                          'videoId': v.id.isEmpty ? '0' : v.id,
                                        },
                                        extra: v,
                                      ),
                                      icon: const Icon(
                                        Icons.open_in_new,
                                        color: textPrimary,
                                      ),
                                    ),
                                    selected: v.id == selectedVideo.id,
                                    onTap: () => setState(() {
                                      _selectedVideoId = v.id.isEmpty
                                          ? videos.first.id
                                          : v.id;
                                    }),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                      AppSpacing.vLg,
                      Text(
                        'Owner',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.gold,
                        ),
                      ),
                      AppSpacing.vSm,
                      GlassContainer(
                        blur: false,
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.gold.withValues(
                              alpha: 0.14,
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              size: 18,
                              color: textPrimary,
                            ),
                          ),
                          title: Text(
                            p.ownerName,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          subtitle: Text(
                            'Owner details (mock)',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: textSecondary),
                          ),
                        ),
                      ),
                      AppSpacing.vLg,
                      Text(
                        'Amenities',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.gold,
                        ),
                      ),
                      AppSpacing.vSm,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_showAllAmenities ? p.amenities : p.amenities.take(4).toList())
                            .map(
                              (a) => Chip(
                                label: Text(a),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: AppTheme.gold.withValues(
                                  alpha: 0.12,
                                ),
                                side: BorderSide(
                                  color: AppTheme.gold.withValues(alpha: 0.35),
                                ),
                                labelStyle: const TextStyle(color: Colors.black),
                              ),
                            )
                            .toList(),
                      ),
                      if (p.amenities.length > 4) ...[
                        AppSpacing.vXs,
                        InkWell(
                          onTap: () => setState(() => _showAllAmenities = !_showAllAmenities),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _showAllAmenities ? 'Show Less' : 'Show More',
                              style: const TextStyle(
                                color: AppTheme.gold,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (furnishingLabels.isNotEmpty) ...[
                        AppSpacing.vLg,
                        Text(
                          'Furnishings',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppTheme.gold,
                          ),
                        ),
                        AppSpacing.vSm,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (_showAllFurnishings ? furnishingLabels : furnishingLabels.take(4).toList())
                              .map(
                                (f) => Chip(
                                  label: Text(f),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: AppTheme.gold.withValues(
                                    alpha: 0.12,
                                  ),
                                  side: BorderSide(
                                    color: AppTheme.gold.withValues(alpha: 0.35),
                                  ),
                                  labelStyle: const TextStyle(color: Colors.black),
                                ),
                              )
                              .toList(),
                        ),
                        if (furnishingLabels.length > 4) ...[
                          AppSpacing.vXs,
                          InkWell(
                            onTap: () => setState(() => _showAllFurnishings = !_showAllFurnishings),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                _showAllFurnishings ? 'Show Less' : 'Show More',
                                style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                      // Additional features section
                      () {
                        final list = <String>[];
                        final isCorner = (p.cornerProperty ?? false) ||
                            (p.rentCornerProperty ?? false) ||
                            (p.villaCornerProperty ?? false) ||
                            (p.builderCornerProperty ?? false) ||
                            (p.duplexCornerPlot ?? false) ||
                            (p.cornerShop ?? false) ||
                            (p.showroomCorner ?? false) ||
                            (p.plotCorner ?? false);
                        if (isCorner) {
                          list.add('Corner Property');
                        }

                        final isGated = (p.gatedCommunity ?? false) ||
                            (p.rentGatedSociety ?? false) ||
                            (p.builderGatedSociety ?? false) ||
                            (p.duplexGatedCommunity ?? false);
                        if (isGated) {
                          list.add('Gated Society/Community');
                        }

                        final isMainRoad = (p.mainRoadFacing ?? false) ||
                            (p.showroomMainRoadFacing ?? false);
                        if (isMainRoad) {
                          list.add('Main Road Facing');
                        }

                        final isWashroom = (p.washroomAvailable ?? false) ||
                            (p.showroomWashroom ?? false) ||
                            ((p.washrooms ?? 0) > 0);
                        if (isWashroom) {
                          list.add('Washroom Available');
                        }

                        if (p.preLeased ?? false) list.add('Pre-Leased');
                        if (p.pantry ?? false) list.add('Pantry Available');
                        if (p.cafeteria ?? false) list.add('Cafeteria Available');
                        if (p.serverRoom ?? false) list.add('Server Room');
                        if (p.fireSafetyInstalled ?? false) list.add('Fire Safety Installed');
                        if (p.centralAC ?? false) list.add('Central AC');
                        if (p.visitorParking ?? false) list.add('Visitor Parking');
                        if (p.boundaryWall ?? false) list.add('Boundary Wall');
                        if (p.constructionDone ?? false) list.add('Construction Done');
                        if ((p.plotRoadAccess ?? false) || (p.duplexRoadAccess ?? false)) list.add('Road Access');
                        if ((p.agriFencing ?? false) || (p.rentFarmFencing ?? false)) list.add('Fencing Done');
                        if (p.petFriendly ?? false) list.add('Pet Friendly');
                        if (p.wheelchairFriendly ?? false) list.add('Wheelchair Friendly');
                        if (p.rentSolarPower ?? false) list.add('Solar Power');
                        if (p.rentIndependentEntry ?? false) list.add('Independent Entry');
                        if ((p.rentLiftAvailable ?? false) || (p.liftAvailable ?? false)) list.add('Lift Available');
                        if (p.rentFarmPool ?? false) list.add('Swimming Pool');

                        if (list.isEmpty) return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpacing.vLg,
                            Text(
                              'Key Features',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.gold,
                              ),
                            ),
                            AppSpacing.vSm,
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: list
                                  .map(
                                    (item) => Chip(
                                      avatar: const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.gold),
                                      label: Text(item),
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor: AppTheme.gold.withValues(
                                        alpha: 0.12,
                                      ),
                                      side: BorderSide(
                                        color: AppTheme.gold.withValues(alpha: 0.35),
                                      ),
                                      labelStyle: const TextStyle(color: Colors.black, fontSize: 12),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        );
                      }(),
                      AppSpacing.vLg,
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppTheme.gold,
                        ),
                      ),
                      AppSpacing.vSm,
                      GlassContainer(
                        blur: false,
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          p.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: textSecondary),
                        ),
                      ),
                      if (p.status == PropertyStatus.rejected &&
                          (p.rejectionReason ?? '').isNotEmpty) ...[
                        AppSpacing.vLg,
                        Text(
                          'Rejection reason',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppTheme.gold,
                              ),
                        ),
                        AppSpacing.vSm,
                        GlassContainer(
                          blur: false,
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            p.rejectionReason!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: textSecondary),
                          ),
                        ),
                      ],
                      AppSpacing.vXl,
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: actions.isLoading
                                  ? null
                                  : () => context.goNamed(
                                      RouteNames.propertyEdit,
                                      pathParameters: {'id': p.id},
                                    ),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('Edit'),
                            ),
                          ),
                          AppSpacing.hSm,
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: actions.isLoading
                                  ? null
                                  : (p.status == PropertyStatus.approved)
                                  ? () async {
                                      try {
                                        await ref
                                            .read(
                                              propertyActionsProvider.notifier,
                                            )
                                            .publish(p.id);
                                        if (context.mounted) {
                                          AppSnackbar.show(
                                            context,
                                            'Published',
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          AppSnackbar.show(
                                            context,
                                            e.toString(),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              icon: const Icon(Icons.public_rounded, size: 18),
                              label: const Text('Publish'),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vXl,
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      );
  }

  Future<void> _prefetchMedia(Property p) async {
    // Images: warm up cache so gallery opens instantly next time.
    final imageUrls = p.images.where((s) => s.startsWith('http'));
    for (final url in imageUrls) {
      // ignore: unawaited_futures
      precacheImage(CachedNetworkImageProvider(url), context);
    }

    // Videos: only pre-cache the first (selected) video to avoid saturating
    // the network and filling disk cache with videos the user may never watch.
    final firstVideoUrl = p.videos
        .map((v) => v.url)
        .where((u) => u.startsWith('http'))
        .firstOrNull;
    if (firstVideoUrl != null) {
      // ignore: unawaited_futures
      DefaultCacheManager().downloadFile(firstVideoUrl);
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        AppSpacing.hXs,
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: textColor),
          ),
        ),
      ],
    );
  }
}
