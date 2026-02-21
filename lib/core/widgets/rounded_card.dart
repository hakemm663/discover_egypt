import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const RoundedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.color,
    this.borderRadius = 20,
    this.onTap,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: AppColors.cardShadow(context),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}
