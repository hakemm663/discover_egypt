import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color brandGold = Color(0xFFD4AF37);
  static const Color brandGoldDark = Color(0xFFB58D1C);
  static const Color brandGoldLight = Color(0xFFE7C86E);
  static const Color brandSand = Color(0xFFEAE2D6);
  static const Color brandNavy = Color(0xFF1C3F95);
  static const Color brandDark = Color(0xFF2B2B2B);

  static Color cardBackground(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color cardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.black.withValues(alpha: isDark ? 0.28 : 0.08);
  }

  static Color mutedForeground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color subtleBorder(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;

  static Color chipBackground(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color chipSelectedBackground(BuildContext context) =>
      Theme.of(context).colorScheme.primary.withValues(alpha: 0.15);

  static Color buttonForeground(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
}
