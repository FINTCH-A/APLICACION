import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';

class StatCard extends StatelessWidget {
  final String title;
  final dynamic value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isCurrency;
  final bool isPercentage;
  final String? suffix;
  final String? prefix;
  final double? fontSize;
  final double? elevation;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.isCurrency = false,
    this.isPercentage = false,
    this.suffix,
    this.prefix,
    this.fontSize,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      margin: EdgeInsets.zero,
      color: backgroundColor ?? AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: iconColor ?? AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _formatValue(),
                style: TextStyles.numberLarge.copyWith(
                  fontSize: fontSize ?? 28,
                  color: _getValueColor(),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );

    return onTap != null ? card : card;
  }

  String _formatValue() {
    String formattedValue;

    if (isCurrency && value is num) {
      formattedValue = formatCurrency(value.toDouble());
    } else if (isPercentage && value is num) {
      formattedValue = '${value.toStringAsFixed(1)}%';
    } else if (value is DateTime) {
      formattedValue = _formatDate(value);
    } else {
      formattedValue = value.toString();
    }

    if (prefix != null) {
      formattedValue = '$prefix $formattedValue';
    }
    if (suffix != null) {
      formattedValue = '$formattedValue $suffix';
    }

    return formattedValue;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getValueColor() {
    if (value is num) {
      final numValue = value as num;
      if (numValue < 0) return AppColors.error;
      if (numValue > 0 && isCurrency) return AppColors.success;
    }
    return AppColors.textPrimary;
  }
}

// Stat card con tendencia (aumento/disminución)
class StatCardWithTrend extends StatelessWidget {
  final String title;
  final dynamic value;
  final IconData icon;
  final double trend;
  final bool isCurrency;
  final VoidCallback? onTap;

  const StatCardWithTrend({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
    this.isCurrency = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = trend >= 0;
    final trendColor = isPositive ? AppColors.success : AppColors.error;
    final trendIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                isCurrency
                    ? formatCurrency(value.toDouble())
                    : value.toString(),
                style: TextStyles.numberLarge.copyWith(fontSize: 28),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(trendIcon, size: 16, color: trendColor),
                  const SizedBox(width: 4),
                  Text(
                    '${trend.abs().toStringAsFixed(1)}%',
                    style: TextStyles.labelSmall.copyWith(color: trendColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isPositive ? 'vs mes anterior' : 'vs mes anterior',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stat card horizontal para dashboards compactos
class StatCardHorizontal extends StatelessWidget {
  final String title;
  final dynamic value;
  final IconData icon;
  final bool isCurrency;

  const StatCardHorizontal({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCurrency
                      ? formatCurrency(value.toDouble())
                      : value.toString(),
                  style: TextStyles.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Stat card con progreso circular
class StatCardCircular extends StatelessWidget {
  final String title;
  final double value;
  final double maxValue;
  final IconData icon;
  final String unit;

  const StatCardCircular({
    super.key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.icon,
    this.unit = '%',
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Icon(icon, size: 20, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 8,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}$unit',
                  style: TextStyles.titleMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
