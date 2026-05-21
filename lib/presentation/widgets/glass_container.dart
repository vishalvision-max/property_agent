import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF101A2E) : const Color(0xFF0B1220))
            .withValues(alpha: isDark ? 0.55 : 0.10),
        borderRadius: borderRadius,
        border: Border.all(
          color: (isDark ? cs.outlineVariant : AppTheme.gold).withValues(
            alpha: isDark ? 0.35 : 0.28,
          ),
        ),
        boxShadow: [AppTheme.softShadow(context)],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (blur) {
      box = BackdropFilter(
        filter: AppTheme.glassBlur(),
        child: box,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: box,
    );
  }
}
