import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_borders.dart';
import '../../../config/theme/text_styles.dart';

enum PremiumBadgeVariant {
  success,
  warning,
  error,
  info,
  primary,
  secondary,
  neutral,
}

class PremiumBadge extends StatelessWidget {
  final String text;
  final PremiumBadgeVariant variant;
  final IconData? icon;
  final bool outline;
  final bool dot;

  const PremiumBadge({
    super.key,
    required this.text,
    this.variant = PremiumBadgeVariant.primary,
    this.icon,
    this.outline = false,
    this.dot = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: outline ? Colors.transparent : color.withOpacity(0.12),
        borderRadius: AppBorders.badge,
        border: outline ? Border.all(color: color, width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyles.labelSmall.copyWith(
              color: outline ? color : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (variant) {
      case PremiumBadgeVariant.success:
        return AppColors.success;
      case PremiumBadgeVariant.warning:
        return AppColors.warning;
      case PremiumBadgeVariant.error:
        return AppColors.error;
      case PremiumBadgeVariant.info:
        return AppColors.info;
      case PremiumBadgeVariant.primary:
        return AppColors.primary;
      case PremiumBadgeVariant.secondary:
        return AppColors.secondary;
      case PremiumBadgeVariant.neutral:
        return AppColors.textSecondary;
    }
  }
}
