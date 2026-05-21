import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_spacing.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRetry,
    this.assetName = 'assets/illustrations/no_internet.svg',
  });

  final String title;
  final String subtitle;
  final VoidCallback onRetry;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(assetName, width: 190),
            AppSpacing.vMd,
            Text(title, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.vXs,
            Text(subtitle, style: t.bodySmall, textAlign: TextAlign.center),
            AppSpacing.vMd,
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh, size: 18), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

