import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/property_enums.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../routes/route_names.dart';
import '../../widgets/error_state.dart';
import '../../widgets/shimmer_list.dart';

final _dashboardDraftPromptShownProvider = StateProvider<bool>((ref) => false);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const draftPrefsKey = 'property_create_draft_v1';
    final promptShown = ref.watch(_dashboardDraftPromptShownProvider);
    if (!promptShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        ref.read(_dashboardDraftPromptShownProvider.notifier).state = true;

        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString(draftPrefsKey);
        if (raw == null || raw.trim().isEmpty) return;
        if (!context.mounted) return;

        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Draft found. Complete your property listing?'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (!context.mounted) return;
                        ScaffoldMessenger.maybeOf(
                          context,
                        )?.hideCurrentSnackBar();
                        context.goNamed(
                          RouteNames.propertyNew,
                          queryParameters: const {'restoreDraft': '1'},
                        );
                      },
                      child: const Text('YES'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (!context.mounted) return;
                        ScaffoldMessenger.maybeOf(
                          context,
                        )?.hideCurrentSnackBar();
                        await prefs.remove(draftPrefsKey);
                      },
                      child: const Text('NO'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    }

    final connectivity = ref.watch(connectivityStatusProvider);
    final vm = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.dark,
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'PropAgent',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _RoundIconButton(
              icon: Icons.notifications_none_rounded,
              onTap: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            connectivity.when(
              data: (r) {
                final offline =
                    r.length == 1 && r.first == ConnectivityResult.none;
                if (!offline) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dark2,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'No internet connection',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(connectivityStatusProvider),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: AppColors.gold),
                        ),
                      ),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
            ),
            Expanded(
              child: vm.when(
                loading: () => const ShimmerList(itemCount: 6),
                error: (e, _) => ErrorState(
                  title: 'Failed to load dashboard',
                  subtitle: e.toString(),
                  onRetry: () => ref.invalidate(dashboardProvider),
                ),
                data: (data) {
                  final counts = data.counts;
                  final total = counts.values.fold<int>(0, (a, b) => a + b);

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(dashboardProvider),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      children: [
                        const SizedBox(height: 4),
                        const _PageHeader(),
                        const SizedBox(height: 16),
                        _StatsGrid(
                          assigned: total,
                          listed: counts[PropertyStatus.listed] ?? 0,
                          pending: counts[PropertyStatus.pending] ?? 0,
                          rejected: counts[PropertyStatus.rejected] ?? 0,
                        ),
                        const SizedBox(height: 14),
                        _ActionButtons(
                          onView: () => context.goNamed(RouteNames.properties),
                          onAddDetails: () =>
                              context.goNamed(RouteNames.propertyNew),
                        ),
                        const SizedBox(height: 8),
                        _SectionHeader(
                          title: 'Recent Activity',
                          action: 'See all',
                          onTapAction: () =>
                              context.goNamed(RouteNames.properties),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: data.activity
                                .map(
                                  (a) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _ActivityItem(a: a),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WELCOME BACK',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              children: [
                TextSpan(
                  text: 'Your ',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                TextSpan(
                  text: 'Dashboard',
                  style: TextStyle(color: AppColors.gold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.assigned,
    required this.listed,
    required this.pending,
    required this.rejected,
  });

  final int assigned;
  final int listed;
  final int pending;
  final int rejected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.35,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _StatCard(
            icon: Icons.villa_rounded,
            label: 'Assigned',
            value: assigned.toString(),
            badge: '',
            badgePositive: true,
            glowColor: AppColors.gold,
          ),
          _StatCard(
            icon: Icons.language_rounded,
            label: 'Listed',
            value: listed.toString(),
            badge: '',
            badgePositive: true,
            glowColor: AppColors.success,
          ),
          _StatCard(
            icon: Icons.access_time_rounded,
            label: 'Pending',
            value: pending.toString(),
            badge: '',
            badgePositive: true,
            glowColor: AppColors.warning,
          ),
          _StatCard(
            icon: Icons.block_rounded,
            label: 'Rejected',
            value: rejected.toString(),
            badge: '',
            badgePositive: false,
            glowColor: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onView, required this.onAddDetails});

  final VoidCallback onView;
  final VoidCallback onAddDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onView,
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: const Text('View Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.dark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAddDetails,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTapAction,
  });

  final String title;
  final String action;
  final VoidCallback onTapAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: onTapAction,
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================
/// 🧾 ACTIVITY ITEM
/// =====================
class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.a});

  final dynamic a;

  @override
  Widget build(BuildContext context) {
    final subtitle = (a.subtitle ?? '').toString().toLowerCase();
    final dotColor = subtitle.contains('reject')
        ? AppColors.danger
        : (subtitle.contains('pending')
              ? AppColors.warning
              : (subtitle.contains('list')
                    ? AppColors.success
                    : AppColors.gold));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.dark3,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                    children: [TextSpan(text: '${a.subtitle}')],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            DateFormat('MMM d').format(a.at),
            style: const TextStyle(fontSize: 11, color: AppColors.textSubtle),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.dark3,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.gold, size: 20),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.badge,
    required this.badgePositive,
    required this.glowColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String badge;
  final bool badgePositive;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glowColor.withValues(alpha: 0.10),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: glowColor, size: 20),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (badge.trim().isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (badgePositive ? AppColors.success : AppColors.danger)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badgePositive ? AppColors.success : AppColors.danger,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
