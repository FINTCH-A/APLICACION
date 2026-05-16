import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/text_styles.dart';

class ProgresoPrestamo extends StatelessWidget {
  final double progreso;
  final int cuotasPagadas;
  final int totalCuotas;

  const ProgresoPrestamo({
    super.key,
    required this.progreso,
    required this.cuotasPagadas,
    required this.totalCuotas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso del préstamo',
                style: TextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${(progreso * 100).toStringAsFixed(0)}%',
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progreso,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$cuotasPagadas cuotas pagadas',
                style: TextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$totalCuotas total',
                style: TextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
