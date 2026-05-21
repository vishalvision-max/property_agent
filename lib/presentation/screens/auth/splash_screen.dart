import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.home_work_rounded, color: cs.onPrimaryContainer, size: 30),
                ),
                AppSpacing.vMd,
                Text(
                  'Property Agent',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                AppSpacing.vXs,
                Text('Sales CRM for listings', style: Theme.of(context).textTheme.bodySmall),
                AppSpacing.vLg,
                const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
