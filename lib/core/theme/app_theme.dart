import 'package:flutter/material.dart';
import 'dart:ui';

class AppTheme {
  // Keep in sync with `property_customer` app for consistent branding.
  static const _seed = Color(0xFF7C3AED);
  static const gold = Color(0xFFD4AF37);

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF070B14) : Colors.white,
      visualDensity: VisualDensity.compact,
    );

    final textTheme = _compactTextTheme(base.textTheme).apply(
      bodyColor: isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A),
      displayColor: isDark ? const Color(0xFFE5E7EB) : const Color(0xFF0F172A),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark
            ? const Color(0xFF0E1626).withValues(alpha: 0.96)
            : const Color(0xFFFFFBF0),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: (isDark ? colorScheme.outlineVariant : gold).withValues(
              alpha: isDark ? 0.35 : 0.28,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: isDark
            ? const Color(0xFF0E1626).withValues(alpha: 0.96)
            : const Color(0xFFF4F6FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF93A4B8) : const Color(0xFF64748B),
        ),
        errorStyle: const TextStyle(fontSize: 11, height: 1.1),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF0E1626).withValues(alpha: 0.96)
            : Colors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor:
            isDark ? const Color(0xFFF8FAFC) : const Color(0xFF64748B),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _compactTextTheme(TextTheme t) {
    TextStyle? s(TextStyle? v, double size, {FontWeight? w}) =>
        v?.copyWith(fontSize: size, fontWeight: w ?? v.fontWeight);

    return t.copyWith(
      titleLarge: s(t.titleLarge, 20, w: FontWeight.w800),
      titleMedium: s(t.titleMedium, 16, w: FontWeight.w700),
      titleSmall: s(t.titleSmall, 14, w: FontWeight.w700),
      bodyLarge: s(t.bodyLarge, 14),
      bodyMedium: s(t.bodyMedium, 13),
      bodySmall: s(t.bodySmall, 12),
      labelLarge: s(t.labelLarge, 13, w: FontWeight.w700),
      labelMedium: s(t.labelMedium, 12, w: FontWeight.w700),
      labelSmall: s(t.labelSmall, 11, w: FontWeight.w700),
    );
  }

  static BoxShadow softShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: (isDark ? Colors.black : const Color(0xFF0F172A)).withValues(
        alpha: isDark ? 0.35 : 0.08,
      ),
      blurRadius: 28,
      offset: const Offset(0, 12),
    );
  }

  static ImageFilter glassBlur() => ImageFilter.blur(sigmaX: 14, sigmaY: 14);
}
