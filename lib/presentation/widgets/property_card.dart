import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/property.dart';
import '../../data/models/property_enums.dart';
import 'glass_container.dart';
import 'image_tile.dart';
import 'status_badge.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.onEdit,
    this.onPublish,
  });

  final Property property;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onPublish;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final thumb = property.images.isEmpty ? null : property.images.first;
    final radius = BorderRadius.circular(18);
    const cardBg = Color(0xFF0B1220);
    const textPrimary = Color(0xFFF8FAFC);
    const textSecondary = Color(0xFFCBD5E1);

    return GlassContainer(
      blur: false, // Fix ANR by disabling BackdropFilter in lists
      borderRadius: radius,
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: AppTheme.gold.withValues(alpha: 0.55),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.gold.withValues(alpha: 0.12),
                cardBg.withValues(alpha: 0.92),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 58,
                        width: 58,
                        child: thumb == null
                            ? Container(
                                color:
                                    const Color(0xFF111B2D).withValues(alpha: 0.85),
                                child:
                                    const Icon(Icons.photo_outlined, size: 18),
                              )
                            : ImageTile(src: thumb),
                      ),
                    ),
                    AppSpacing.hSm,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  property.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              AppSpacing.hSm,
                              StatusBadge(status: property.status),
                            ],
                          ),
                          AppSpacing.vXs,
                          Text(
                            property.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.bodySmall?.copyWith(
                              color: textSecondary,
                            ),
                          ),
                          AppSpacing.vXs,
                          Row(
                            children: [
                              Text(
                                '₹${property.price.toStringAsFixed(0)}',
                                style: t.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: textPrimary,
                                ),
                              ),
                              AppSpacing.hSm,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.gold.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: AppTheme.gold.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  property.type.label,
                                  style: t.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.vSm,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Owner: ${property.ownerName}',
                        style: t.bodySmall?.copyWith(
                          color: textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onEdit != null)
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: onEdit,
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: textPrimary,
                        ),
                      ),
                    if (onPublish != null)
                      IconButton(
                        tooltip: 'Publish',
                        onPressed: onPublish,
                        icon: const Icon(
                          Icons.public_outlined,
                          size: 18,
                          color: textPrimary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
