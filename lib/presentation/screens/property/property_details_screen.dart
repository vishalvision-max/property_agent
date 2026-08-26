import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:property_agent/presentation/screens/property/property_edit_screen.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/price_format.dart';
import '../../../core/utils/text_format.dart';
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

  Future<void> _refreshProperty() async {
    final propertyId = widget.propertyId;
    ref.invalidate(propertyByIdProvider(propertyId));
    await ref.read(propertyByIdProvider(propertyId).future);
  }

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
          title: const Text('Property Details',
              style: TextStyle(color: textPrimary)),
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

          return RefreshIndicator(
            onRefresh: _refreshProperty,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                '${formatIndianPrice(p.price)} • ${p.displayTag}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
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
                              label: formatIndianNumber(p.price),
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
                      ..._buildCaseSpecificSections(context, p),
                      if (selectedVideo != null) ...[
                        AppSpacing.vLg,
                        Text(
                          'Videos',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.gold,
                                  ),
                        ),
                        AppSpacing.vSm,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.gold.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: PropertyVideoPlayer(
                            key: ValueKey<String>(selectedVideo.url),
                            url: selectedVideo.url,
                            autoPlay: selectedVideo == videos.first,
                          ),
                        ),
                        if (videos.length > 1) ...[
                          AppSpacing.vSm,
                          GlassContainer(
                            blur: false,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                for (final v in videos)
                                  Builder(builder: (context) {
                                    final isPlaying = v.id == selectedVideo.id;
                                    final label = (v.title ?? '').trim().isEmpty
                                        ? humanizeLabel(
                                            (v.type ?? '').trim().isEmpty
                                                ? 'Video'
                                                : v.type)
                                        : v.title!.trim();
                                    return ListTile(
                                      dense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      leading: Icon(
                                        isPlaying
                                            ? Icons.play_circle_fill
                                            : Icons.play_circle_outline,
                                        color: isPlaying
                                            ? AppTheme.gold
                                            : textPrimary,
                                      ),
                                      title: Text(
                                        label,
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
                                        isPlaying
                                            ? 'Now playing'
                                            : 'Tap to play',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: textSecondary),
                                      ),
                                      trailing: isPlaying
                                          ? const Icon(Icons.equalizer_rounded,
                                              color: AppTheme.gold)
                                          : null,
                                      selected: isPlaying,
                                      onTap: () => setState(() {
                                        _selectedVideoId = v.id.isEmpty
                                            ? videos.first.id
                                            : v.id;
                                      }),
                                    );
                                  }),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.gold.withOpacity(0.18),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.gold.withOpacity(0.14),
                              child: const Icon(
                                Icons.person_outline,
                                size: 18,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.ownerName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: textPrimary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    (p.ownerPhone ?? '').trim().isNotEmpty
                                        ? p.ownerPhone!.trim()
                                        : 'No contact number added',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (p.amenities.isNotEmpty) ...[
                        AppSpacing.vLg,
                        Text(
                          'Amenities',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.gold,
                                  ),
                        ),
                        AppSpacing.vSm,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (_showAllAmenities
                                  ? p.amenities
                                  : p.amenities.take(4).toList())
                              .map(
                                (a) => Chip(
                                  label: Text(a),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor:
                                      AppTheme.gold.withOpacity(0.12),
                                  side: BorderSide(
                                    color: AppTheme.gold.withOpacity(0.35),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                              )
                              .toList(),
                        ),
                        if (p.amenities.length > 4) ...[
                          AppSpacing.vXs,
                          InkWell(
                            onTap: () => setState(
                                () => _showAllAmenities = !_showAllAmenities),
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
                      ],
                      if (furnishingLabels.isNotEmpty) ...[
                        AppSpacing.vLg,
                        Text(
                          'Furnishings',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.gold,
                                  ),
                        ),
                        AppSpacing.vSm,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (_showAllFurnishings
                                  ? furnishingLabels
                                  : furnishingLabels.take(4).toList())
                              .map(
                                (f) => Chip(
                                  label: Text(f),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor:
                                      AppTheme.gold.withOpacity(0.12),
                                  side: BorderSide(
                                    color: AppTheme.gold.withOpacity(0.35),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                              )
                              .toList(),
                        ),
                        if (furnishingLabels.length > 4) ...[
                          AppSpacing.vXs,
                          InkWell(
                            onTap: () => setState(() =>
                                _showAllFurnishings = !_showAllFurnishings),
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
                        if (p.cafeteria ?? false)
                          list.add('Cafeteria Available');
                        if (p.serverRoom ?? false) list.add('Server Room');
                        if (p.fireSafetyInstalled ?? false)
                          list.add('Fire Safety Installed');
                        if (p.centralAC ?? false) list.add('Central AC');
                        if (p.visitorParking ?? false)
                          list.add('Visitor Parking');
                        if (p.boundaryWall ?? false) list.add('Boundary Wall');
                        if (p.constructionDone ?? false)
                          list.add('Construction Done');
                        if ((p.plotRoadAccess ?? false) ||
                            (p.duplexRoadAccess ?? false))
                          list.add('Road Access');
                        if ((p.agriFencing ?? false) ||
                            (p.rentFarmFencing ?? false))
                          list.add('Fencing Done');
                        if (p.petFriendly ?? false) list.add('Pet Friendly');
                        if (p.wheelchairFriendly ?? false)
                          list.add('Wheelchair Friendly');
                        if (p.rentSolarPower ?? false) list.add('Solar Power');
                        if (p.rentIndependentEntry ?? false)
                          list.add('Independent Entry');
                        if ((p.rentLiftAvailable ?? false) ||
                            (p.liftAvailable ?? false))
                          list.add('Lift Available');
                        if (p.rentFarmPool ?? false) list.add('Swimming Pool');

                        if (list.isEmpty) return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpacing.vLg,
                            Text(
                              'Key Features',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
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
                                      avatar: const Icon(
                                          Icons.check_circle_outline,
                                          size: 16,
                                          color: AppTheme.gold),
                                      label: Text(item),
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor:
                                          AppTheme.gold.withOpacity(0.12),
                                      side: BorderSide(
                                        color: AppTheme.gold.withOpacity(0.35),
                                      ),
                                      labelStyle: const TextStyle(
                                          color: Colors.black, fontSize: 12),
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
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: textSecondary),
                          ),
                        ),
                      ],
                      AppSpacing.vXl,
                      SizedBox(
                        width: double.infinity,
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
                      AppSpacing.vXl,
                    ]),
                  ),
                ),
              ],
            ),
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

  List<Widget> _buildCaseSpecificSections(BuildContext context, Property p) {
    final widgets = <Widget>[];
    final api = p.apiFields ?? const <String, dynamic>{};
    final residential = api['residential_details'] as Map?;
    final plot = api['plot_details'] as Map?;
    final office = api['office_details'] as Map?;
    final shop = api['shop_details'] as Map?;
    final showroom = api['showroom_details'] as Map?;
    final warehouse = api['warehouse_details'] as Map?;
    final pg = api['pg_details'] as Map?;

    String? pick(Map<String, dynamic>? source, List<String> keys) {
      if (source == null) return null;
      for (final key in keys) {
        final value = source[key];
        if (value == null) continue;
        final text = value.toString().trim();
        if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
      }
      return null;
    }

    bool? pickBool(Map<String, dynamic>? source, List<String> keys) {
      if (source == null) return null;
      for (final key in keys) {
        final value = source[key];
        if (value == null) continue;
        if (value is bool) return value;
        if (value is num) return value != 0;
        final text = value.toString().trim().toLowerCase();
        if (text.isEmpty) continue;
        if (text == 'true' || text == '1' || text == 'yes') return true;
        if (text == 'false' || text == '0' || text == 'no') return false;
      }
      return null;
    }

    String? yesNo(bool? value) => value == null ? null : (value ? 'Yes' : 'No');

    // Display-only: turn a raw snake_case value like `fully_furnished` into a
    // readable label like `Fully furnished`. Does not alter stored data.
    String? prettify(String? value) {
      final v = (value ?? '').trim().replaceAll(RegExp(r'[_-]+'), ' ');
      if (v.isEmpty) return null;
      final lower = v.toLowerCase();
      return lower[0].toUpperCase() + lower.substring(1);
    }

    List<String> listFrom(dynamic value) {
      if (value is List) {
        return value
            .where((e) => e != null)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);
      }
      if (value is String && value.trim().isNotEmpty) {
        return value
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);
      }
      return const <String>[];
    }

    void addSection({
      required String title,
      required List<_DetailItem> items,
    }) {
      final visibleItems =
          items.where((i) => i.hasValue).toList(growable: false);
      if (visibleItems.isEmpty) return;
      widgets.addAll([
        AppSpacing.vLg,
        GlassContainer(
          blur: false,
          padding: EdgeInsets.zero,
          child: ExpansionTile(
            initiallyExpanded: false,
            collapsedIconColor: AppTheme.gold,
            iconColor: AppTheme.gold,
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.gold,
                  ),
            ),
            children: [
              Column(
                children: visibleItems
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _InfoRow(
                          icon: item.icon,
                          label: '${item.label}: ${item.value}',
                          iconColor: AppTheme.gold,
                          textColor: Colors.white,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ]);
    }

    addSection(
      title: 'Top Level Details',
      items: [
        _DetailItem('Booking Amount', p.bookingAmount?.toString(),
            Icons.payments_outlined),
        _DetailItem('Maintenance Charges', p.maintenanceCharges?.toString(),
            Icons.receipt_long_outlined),
        _DetailItem('Security Deposit', p.securityDeposit?.toString(),
            Icons.account_balance_wallet_outlined),
        _DetailItem(
            'Price Negotiable', yesNo(p.priceNegotiable), Icons.sell_outlined),
        _DetailItem(
            'Available From', p.availableFrom, Icons.event_available_outlined),
        _DetailItem('Possession By', p.possessionBy, Icons.event_note_outlined),
        _DetailItem('Ownership', p.ownership, Icons.badge_outlined),
        _DetailItem(
            'Commercial Type', p.commercialType, Icons.business_outlined),
        _DetailItem('Property Kind', p.propertyKind, Icons.category_outlined),
        _DetailItem(
            'Listing Type', p.listingType, Icons.manage_accounts_outlined),
        _DetailItem('Village', p.village, Icons.location_city_outlined),
        _DetailItem('Landmark', p.landmark, Icons.place_outlined),
        _DetailItem(
            'Whatsapp Updates', yesNo(p.whatsappUpdates), Icons.chat_outlined),
        _DetailItem(
            'Electricity Included',
            yesNo(api['electricity_included'] == 1 ||
                api['electricity_included'] == true),
            Icons.bolt_outlined),
        _DetailItem(
            'Gas Included',
            yesNo(api['gas_included'] == 1 || api['gas_included'] == true),
            Icons.local_fire_department_outlined),
        _DetailItem(
            'Water Included',
            yesNo(api['water_included'] == 1 || api['water_included'] == true),
            Icons.water_drop_outlined),
        _DetailItem(
            'Wifi Included',
            yesNo(api['wifi_included'] == 1 || api['wifi_included'] == true),
            Icons.wifi_outlined),
      ],
    );

    addSection(
      title: 'Residential Details',
      items: [
        _DetailItem(
            'BHK', residential?['bhk']?.toString(), Icons.numbers_outlined),
        _DetailItem('Bedrooms', p.bedrooms?.toString(), Icons.bed_outlined),
        _DetailItem(
            'Bathrooms', p.bathrooms?.toString(), Icons.bathtub_outlined),
        _DetailItem(
            'Balconies', p.balconies?.toString(), Icons.balcony_outlined),
        _DetailItem('Furnishing', p.furnishing, Icons.chair_outlined),
        _DetailItem('Floor', p.floor?.toString(), Icons.stairs_outlined),
        _DetailItem('Total Floors', p.totalFloors?.toString(),
            Icons.apartment_outlined),
        _DetailItem(
            'Maintenance',
            residential?['maintenance_charges']?.toString() ??
                p.maintenanceCharges?.toString(),
            Icons.currency_rupee),
        _DetailItem(
            'Ownership',
            residential?['ownership']?.toString() ?? p.ownership,
            Icons.badge_outlined),
        _DetailItem(
            'Corner Property',
            yesNo(pickBool(
                residential?.cast<String, dynamic>(), ['corner_property'])),
            Icons.crop_square_outlined),
        _DetailItem(
            'Parking',
            pick(residential?.cast<String, dynamic>(), ['parking']),
            Icons.local_parking_outlined),
        _DetailItem(
            'Additional Rooms',
            listFrom(residential?['additional_rooms']).join(', '),
            Icons.room_preferences_outlined),
        _DetailItem('Nearby', listFrom(residential?['nearby']).join(', '),
            Icons.near_me_outlined),
        _DetailItem(
            'Facing',
            pick(residential?.cast<String, dynamic>(), ['facing']),
            Icons.explore_outlined),
        _DetailItem(
            'Gated Society',
            yesNo(pickBool(
                residential?.cast<String, dynamic>(), ['gated_society'])),
            Icons.emoji_transportation_outlined),
        _DetailItem(
            'Pet Friendly',
            yesNo(pickBool(
                residential?.cast<String, dynamic>(), ['pet_friendly'])),
            Icons.pets_outlined),
        _DetailItem(
            'Wheelchair Friendly',
            yesNo(pickBool(
                residential?.cast<String, dynamic>(), ['wheelchair_friendly'])),
            Icons.accessible_outlined),
        _DetailItem(
            'Possession Status',
            pick(residential?.cast<String, dynamic>(), ['possession_status']),
            Icons.assignment_turned_in_outlined),
        _DetailItem(
            'Possession By',
            pick(residential?.cast<String, dynamic>(), ['possession_by']),
            Icons.event_outlined),
      ],
    );

    addSection(
      title: 'Plot Details',
      items: [
        _DetailItem(
            'Plot Area',
            pick(plot?.cast<String, dynamic>(), ['plot_area']),
            Icons.terrain_outlined),
        _DetailItem(
            'Plot Area Unit',
            pick(plot?.cast<String, dynamic>(), ['plot_area_unit']),
            Icons.square_foot_outlined),
        _DetailItem(
            'Plot Length (ft)',
            pick(plot?.cast<String, dynamic>(), ['plot_length_ft']),
            Icons.straighten),
        _DetailItem(
            'Plot Breadth (ft)',
            pick(plot?.cast<String, dynamic>(), ['plot_breadth_ft']),
            Icons.straighten),
        _DetailItem(
            'Floors Allowed',
            pick(plot?.cast<String, dynamic>(), ['floors_allowed']),
            Icons.layers_outlined),
        _DetailItem(
            'Open Sides',
            pick(plot?.cast<String, dynamic>(), ['open_sides']),
            Icons.open_in_full_outlined),
        _DetailItem(
            'Boundary Wall',
            yesNo(pickBool(plot?.cast<String, dynamic>(), ['boundary_wall'])),
            Icons.fence_outlined),
        _DetailItem(
            'Construction Done',
            yesNo(
                pickBool(plot?.cast<String, dynamic>(), ['construction_done'])),
            Icons.verified_outlined),
        _DetailItem(
            'Land Type',
            pick(plot?.cast<String, dynamic>(), ['land_type']),
            Icons.landscape_outlined),
        _DetailItem(
            'Ownership',
            pick(plot?.cast<String, dynamic>(), ['ownership']),
            Icons.badge_outlined),
        _DetailItem(
            'Road Width (ft)',
            pick(plot?.cast<String, dynamic>(), ['road_width_ft']),
            Icons.route_outlined),
        _DetailItem(
            'Construction Allowed',
            yesNo(pickBool(
                plot?.cast<String, dynamic>(), ['construction_allowed'])),
            Icons.construction_outlined),
        _DetailItem(
            'Water Connection',
            yesNo(
                pickBool(plot?.cast<String, dynamic>(), ['water_connection'])),
            Icons.water_drop_outlined),
        _DetailItem(
            'Electricity Connection',
            yesNo(pickBool(
                plot?.cast<String, dynamic>(), ['electricity_connection'])),
            Icons.bolt_outlined),
        _DetailItem(
            'Road Access',
            yesNo(pickBool(plot?.cast<String, dynamic>(), ['road_access'])),
            Icons.traffic_outlined),
        _DetailItem(
            'Corner Plot',
            yesNo(pickBool(
                plot?.cast<String, dynamic>(), ['corner_plot', 'plot_corner'])),
            Icons.crop_square_outlined),
        _DetailItem(
            'Nearby Facilities',
            listFrom(plot?['nearby_facilities']).join(', '),
            Icons.near_me_outlined),
        _DetailItem(
            'Agri Fencing',
            yesNo(pickBool(plot?.cast<String, dynamic>(), ['agri_fencing'])),
            Icons.park_outlined),
        _DetailItem(
            'Agri Water Source',
            pick(plot?.cast<String, dynamic>(), ['agri_water_source']),
            Icons.water_outlined),
        _DetailItem(
            'Farm Land Area',
            pick(plot?.cast<String, dynamic>(), ['farm_land_area']),
            Icons.terrain_outlined),
        _DetailItem(
            'Farm Built Up Area',
            pick(plot?.cast<String, dynamic>(), ['farm_built_up_area']),
            Icons.home_work_outlined),
        _DetailItem(
            'Farm Rooms',
            pick(plot?.cast<String, dynamic>(), ['farm_rooms']),
            Icons.meeting_room_outlined),
        _DetailItem(
            'Farm Garden',
            yesNo(pickBool(plot?.cast<String, dynamic>(), ['farm_garden'])),
            Icons.park_outlined),
        _DetailItem(
            'Farm Swimming Pool',
            yesNo(pickBool(
                plot?.cast<String, dynamic>(), ['farm_swimming_pool'])),
            Icons.pool_outlined),
        _DetailItem(
            'Farm Utilities',
            listFrom(plot?['farm_utilities']).join(', '),
            Icons.handyman_outlined),
        _DetailItem(
            'Farm Monthly Charges',
            pick(plot?.cast<String, dynamic>(), ['farm_monthly_charges']),
            Icons.payments_outlined),
        _DetailItem(
            'Farm Daily Charges',
            pick(plot?.cast<String, dynamic>(), ['farm_daily_charges']),
            Icons.payments_outlined),
        _DetailItem(
            'Farm Event Charges',
            pick(plot?.cast<String, dynamic>(), ['farm_event_charges']),
            Icons.payments_outlined),
        _DetailItem(
            'Min Stay Days',
            pick(plot?.cast<String, dynamic>(), ['min_stay_days']),
            Icons.calendar_today_outlined),
      ],
    );

    addSection(
      title: 'Commercial Details',
      items: [
        _DetailItem(
            'Commercial Type', p.commercialType, Icons.business_outlined),
        _DetailItem(
            'Parking Type', p.parkingType, Icons.local_parking_outlined),
        _DetailItem('Washrooms', p.washrooms?.toString(), Icons.wc_outlined),
        _DetailItem('Seats', p.seats?.toString(), Icons.event_seat_outlined),
        _DetailItem(
            'Max Seats', p.maxSeats?.toString(), Icons.chair_alt_outlined),
        _DetailItem(
            'Quality Rating', p.qualityRating?.toString(), Icons.star_outline),
        _DetailItem('Pre Leased', yesNo(p.preLeased), Icons.verified_outlined),
      ],
    );

    addSection(
      title: 'PG Details',
      items: [
        _DetailItem('Occupancy Type', p.pgOccupancyType, Icons.bed_outlined),
        _DetailItem(
            'Property Type', p.pgPropertyType, Icons.home_work_outlined),
        _DetailItem('Bathroom Type', p.pgBathroomType, Icons.bathtub_outlined),
        _DetailItem('Suitable For', p.pgSuitableFor, Icons.groups_outlined),
        _DetailItem(
            'Total Beds', p.pgTotalBeds?.toString(), Icons.bed_outlined),
        _DetailItem('Available Beds', p.pgAvailableBeds?.toString(),
            Icons.bed_outlined),
        _DetailItem('PG Security Deposit', p.pgSecurityDeposit?.toString(),
            Icons.account_balance_wallet_outlined),
        _DetailItem('PG Maintenance Charges',
            p.pgMaintenanceCharges?.toString(), Icons.receipt_long_outlined),
        _DetailItem('PG Availability', p.pgAvailability,
            Icons.event_available_outlined),
        _DetailItem('PG Smoking Allowed', yesNo(p.pgSmokingAllowed),
            Icons.smoking_rooms_outlined),
        _DetailItem('PG Drinking Allowed', yesNo(p.pgDrinkingAllowed),
            Icons.local_bar_outlined),
        _DetailItem(
            'PG Pets Allowed', yesNo(p.pgPetsAllowed), Icons.pets_outlined),
        _DetailItem('PG Visitors Allowed', yesNo(p.pgVisitorsAllowed),
            Icons.groups_outlined),
        _DetailItem('PG Gate Locked At Night', yesNo(p.pgGateLockedAtNight),
            Icons.lock_outlined),
        _DetailItem(
            'PG Security', yesNo(p.pgSecurity), Icons.security_outlined),
        _DetailItem('PG Near By', listFrom(p.pgNearbyPreferences).join(', '),
            Icons.near_me_outlined),
      ],
    );

    addSection(
      title: 'Office Details',
      items: [
        _DetailItem('Office Type', prettify(p.officeType),
            Icons.business_center_outlined),
        _DetailItem('Floor Plate Area', p.floorPlateArea?.toString(),
            Icons.square_foot_outlined),
        _DetailItem('Meeting Rooms', p.meetingRooms?.toString(),
            Icons.meeting_room_outlined),
        _DetailItem('Cabins', p.cabins?.toString(), Icons.workspaces_outline),
        _DetailItem('Reception Area', yesNo(p.receptionArea),
            Icons.meeting_room_outlined),
        _DetailItem('Pantry', yesNo(p.pantry), Icons.restaurant_outlined),
        _DetailItem('Cafeteria', yesNo(p.cafeteria), Icons.local_cafe_outlined),
        _DetailItem('Server Room', yesNo(p.serverRoom), Icons.dns_outlined),
        _DetailItem('Fire Safety', yesNo(p.fireSafetyInstalled),
            Icons.fire_extinguisher_outlined),
        _DetailItem('Central AC', yesNo(p.centralAC), Icons.ac_unit_outlined),
        _DetailItem('Visitor Parking', yesNo(p.visitorParking),
            Icons.local_parking_outlined),
        _DetailItem('Pre Leased', yesNo(p.preLeased), Icons.verified_outlined),
      ],
    );

    addSection(
      title: 'Shop Details',
      items: [
        _DetailItem('Shop Type', p.shopType, Icons.store_outlined),
        _DetailItem(
            'Shop Area', p.shopArea?.toString(), Icons.square_foot_outlined),
        _DetailItem(
            'Frontage Width', p.frontageWidth?.toString(), Icons.straighten),
        _DetailItem(
            'Floor Type',
            p.floorType == null ? null : humanizeLabel(p.floorType),
            Icons.layers_outlined),
        _DetailItem('Shop Facade', p.shopFacade, Icons.storefront_outlined),
        _DetailItem('Washrooms', p.washrooms?.toString(), Icons.wc_outlined),
        _DetailItem(
            'Main Road Facing', yesNo(p.mainRoadFacing), Icons.route_outlined),
        _DetailItem(
            'Corner Shop', yesNo(p.cornerShop), Icons.crop_square_outlined),
      ],
    );

    addSection(
      title: 'Showroom Details',
      items: [
        _DetailItem('Showroom Area', p.showroomArea?.toString(),
            Icons.square_foot_outlined),
        _DetailItem('Frontage Width', p.showroomFrontageWidth?.toString(),
            Icons.straighten),
        _DetailItem('Floor Type', p.showroomFloorType, Icons.layers_outlined),
        _DetailItem('Parking Slots', p.showroomParkingSlots?.toString(),
            Icons.local_parking_outlined),
        _DetailItem('Main Road Facing', yesNo(p.showroomMainRoadFacing),
            Icons.route_outlined),
        _DetailItem(
            'Corner', yesNo(p.showroomCorner), Icons.crop_square_outlined),
        _DetailItem('Washroom', yesNo(p.showroomWashroom), Icons.wc_outlined),
      ],
    );

    addSection(
      title: 'Warehouse Details',
      items: [
        _DetailItem(
            'Warehouse Type', p.warehouseType, Icons.warehouse_outlined),
        _DetailItem('Plot Area', p.warehousePlotArea?.toString(),
            Icons.square_foot_outlined),
        _DetailItem('Ceiling Height', p.warehouseCeilingHeight?.toString(),
            Icons.height_outlined),
        _DetailItem('Loading Bays', p.warehouseLoadingBays?.toString(),
            Icons.local_shipping_outlined),
        _DetailItem('Dock Levelers', p.warehouseDockLevelers?.toString(),
            Icons.elevator_outlined),
        _DetailItem(
            'Power Supply', p.warehousePowerSupply, Icons.bolt_outlined),
        _DetailItem('Industrial License', yesNo(p.warehouseIndustrialLicense),
            Icons.assignment_turned_in_outlined),
        _DetailItem('Truck Access', p.warehouseTruckAccess,
            Icons.local_shipping_outlined),
      ],
    );

    if ((residential != null ||
            plot != null ||
            office != null ||
            shop != null ||
            showroom != null ||
            warehouse != null ||
            pg != null) &&
        widgets.isEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'Additional data is available in the response.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      );
    }

    return widgets;
  }
}

class _DetailItem {
  const _DetailItem(this.label, this.value, this.icon);

  final String label;
  final String? value;
  final IconData icon;

  bool get hasValue => (value ?? '').trim().isNotEmpty;
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
