import 'package:flutter/material.dart';

import '../../data/models/property_enums.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final PropertyStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, glow) = switch (status) {
      PropertyStatus.pending => (
        const Color(0xFFFFEDD5),
        const Color(0xFF9A3412),
        const Color(0xFFFB923C),
      ),
      PropertyStatus.approved => (
        const Color(0xFFDCFCE7),
        const Color(0xFF065F46),
        const Color(0xFF22C55E),
      ),
      PropertyStatus.listed => (
        const Color(0xFFDBEAFE),
        const Color(0xFF1D4ED8),
        const Color(0xFF3B82F6),
      ),
      PropertyStatus.rejected => (
        const Color(0xFFFFE4E6),
        const Color(0xFF991B1B),
        const Color(0xFFFB7185),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.22),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
