import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color brandGold = Color(0xFFC89B3C);
  static const Color brandGoldDark = Color(0xFFB58526);
  static const Color brandGoldLight = Color(0xFFE5C87B);

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
