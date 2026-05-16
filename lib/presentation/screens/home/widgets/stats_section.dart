// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';

class StatsSection extends StatelessWidget {
  final double totalPrestamos;
  final double totalPagado;
  final int prestamosActivos;

  const StatsSection({
    super.key,
    required this.totalPrestamos,
    required this.totalPagado,
    required this.prestamosActivos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Total Préstamos',
            value: formatCurrency(totalPrestamos),
            icon: Icons.account_balance_wallet_outlined,
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _StatItem(
            label: 'Total Pagado',
            value: formatCurrency(totalPagado),
            icon: Icons.payments_outlined,
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _StatItem(
            label: 'Activos',
            value: prestamosActivos.toString(),
            icon: Icons.trending_up_outlined,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
