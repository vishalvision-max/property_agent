import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/property.dart';
import '../../../data/models/property_enums.dart';
import '../../../providers/property_provider.dart';
import '../../../routes/route_names.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/property_card.dart';
import '../../widgets/shimmer_list.dart';

class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = const ['All', 'Pending', 'Approved', 'Rejected'];

  PropertyStatus? get _statusFilter {
    switch (_selectedFilter) {
      case 1:
        return PropertyStatus.pending;
      case 2:
        return PropertyStatus.approved;
      case 3:
        return PropertyStatus.rejected;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = ref.watch(propertiesProvider);

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        toolbarHeight: 72,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'MANAGE',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.2,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Properties',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: InkWell(
              onTap: () => ref.invalidate(propertiesProvider),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.dark3,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _FilterChips(
              filters: _filters,
              selectedIndex: _selectedFilter,
              onSelect: (i) => setState(() => _selectedFilter = i),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: props.when(
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: ShimmerList(itemCount: 6),
                ),
                error: (e, _) => ErrorState(
                  title: 'Failed to load properties',
                  subtitle: e.toString(),
                  onRetry: () => ref.invalidate(propertiesProvider),
                ),
                data: (list) => _PropertyListBody(
                  list: list,
                  status: _statusFilter,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _Fab(
        onTap: () => context.goNamed(RouteNames.propertyNew),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final active = selectedIndex == i;
          return InkWell(
            onTap: () => onSelect(i),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? AppColors.gold : AppColors.border,
                ),
              ),
              child: Text(
                filters[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.dark : AppColors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PropertyListBody extends ConsumerWidget {
  const _PropertyListBody({required this.list, required this.status});

  final List<Property> list;
  final PropertyStatus? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = filterByStatus(list, status);

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: EmptyState(
            title: 'No properties',
            subtitle: 'When properties are assigned, they will appear here.',
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(propertiesProvider),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final p = filtered[i];
          return Container(
            decoration: BoxDecoration(
              color: AppColors.dark2,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: PropertyCard(
              property: p,
              onTap: () => context.goNamed(
                RouteNames.propertyDetails,
                pathParameters: {'id': p.id},
              ),
              onEdit: () => context.goNamed(
                RouteNames.propertyEdit,
                pathParameters: {'id': p.id},
              ),
              onPublish: p.status == PropertyStatus.approved
                  ? () async {
                      try {
                        await ref
                            .read(propertyActionsProvider.notifier)
                            .publish(p.id);
                        if (context.mounted) AppSnackbar.show(context, 'Published');
                      } catch (e) {
                        if (context.mounted) AppSnackbar.show(context, e.toString());
                      }
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: AppColors.dark, size: 26),
      ),
    );
  }
}
