// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_borders.dart';
import '../../../config/theme/app_shadows.dart';
import '../../../config/theme/text_styles.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? elevation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool withGlow;
  final bool isGlass;
  final Gradient? gradient;

  const PremiumCard({
    super.key,
    required this.child,
    this.onTap,
    this.elevation,
    this.padding,
    this.margin,
    this.withGlow = false,
    this.isGlass = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient ?? (isGlass ? null : AppColors.cardGradient),
        color: isGlass ? AppColors.glassBackground : null,
        borderRadius: AppBorders.cardLarge,
        border: isGlass
            ? Border.all(color: AppColors.glassBorder, width: 1)
            : null,
        boxShadow: withGlow
            ? AppShadows.glow
            : (elevation != null && elevation! > 0 ? AppShadows.medium : null),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppBorders.cardLarge,
          child: card,
        ),
      );
    }

    return card;
  }
}
