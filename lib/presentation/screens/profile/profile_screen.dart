import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../routes/route_names.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider).valueOrNull;
    final dash = ref.watch(dashboardProvider).valueOrNull;
    final counts = dash?.counts;
    final total = counts?.assigned ?? 0;
    final listed = counts?.listed ?? 0;
    final pending = counts?.pending ?? 0;

    final nameRaw = state?.agent?.name.trim();
    final userName = (nameRaw != null && nameRaw.isNotEmpty) ? nameRaw : 'Agent';
    final userEmail = state?.agent?.email ?? '';
    final initials = _initialsFromName(userName);
    final profileImage = state?.agent?.image;

    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NavBar(onSettings: () {}),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    _ProfileHero(
                      userName: userName,
                      userEmail: userEmail,
                      initials: initials,
                      image: profileImage,
                    ),
                    const SizedBox(height: 4),
                    _StatsRow(
                      assigned: total,
                      listed: listed,
                      pending: pending,
                    ),
                    const SizedBox(height: 24),
                    _MenuSection(
                      onChangePassword: () =>
                          context.pushNamed(RouteNames.changePassword),
                      onNotifications: () => AppSnackbar.show(
                        context,
                        'Notifications are mocked for now.',
                      ),
                      onEditProfile: () =>
                          context.pushNamed(RouteNames.editProfile),
                      onHelp: () =>
                          AppSnackbar.show(context, 'Help is not available yet.'),
                      onLogout: () => _showLogoutDialog(context, ref),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _initialsFromName(String name) {
  final parts =
      name.trim().split(RegExp(r'\\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return 'A';
  final first = parts.first.characters.first.toUpperCase();
  final last = (parts.length > 1 ? parts.last : '').characters;
  final second = last.isNotEmpty ? last.first.toUpperCase() : '';
  return (first + second).trim();
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          InkWell(
            onTap: onSettings,
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
                Icons.settings_outlined,
                color: AppColors.gold,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.userName,
    required this.userEmail,
    required this.initials,
    required this.image,
  });

  final String userName;
  final String userEmail;
  final String initials;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final img = (image ?? '').trim();
    final imageUrl = img.isEmpty
        ? null
        : (img.startsWith('http')
            ? img
            : '${ApiConstants.publicOrigin}/storage/${img.startsWith('/') ? img.substring(1) : img}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.dark3,
                border: Border.all(color: AppColors.gold, width: 2),
              ),
              child: imageUrl != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: 84,
                        height: 84,
                        placeholder: (_, __) => Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 13,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Verified Agent',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.assigned,
    required this.listed,
    required this.pending,
  });

  final int assigned;
  final int listed;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _StatCell(label: 'Assigned', value: '$assigned'),
              const VerticalDivider(color: AppColors.border, width: 1),
              _StatCell(label: 'Listed', value: '$listed'),
              const VerticalDivider(color: AppColors.border, width: 1),
              _StatCell(label: 'Pending', value: '$pending'),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.onChangePassword,
    required this.onNotifications,
    required this.onEditProfile,
    required this.onHelp,
    required this.onLogout,
  });

  final VoidCallback onChangePassword;
  final VoidCallback onNotifications;
  final VoidCallback onEditProfile;
  final VoidCallback onHelp;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.lock_outline_rounded,
            label: 'Change password',
            onTap: onChangePassword,
          ),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            subtitle: 'New property • Approval status • Rejection reason',
            onTap: onNotifications,
          ),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.person_outline_rounded,
            label: 'Edit profile',
            onTap: onEditProfile,
          ),
          const SizedBox(height: 8),
          _MenuItem(
            icon: Icons.help_outline_rounded,
            label: 'Help & support',
            onTap: onHelp,
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x22C9A84C)),
          const SizedBox(height: 8),
          _LogoutButton(onTap: onLogout),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.dark2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.dark3,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.gold, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style:
                          const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSubtle, size: 20),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.dark2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.danger.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded,
                  color: AppColors.danger, size: 20),
            ),
            const SizedBox(width: 14),
            const Text(
              'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.dark2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text(
            'Logout?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of your account?',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) AppSnackbar.show(context, 'Logged out');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
  );
}
