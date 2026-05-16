import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/cuota_model.dart';

class EstadoCuotaBadge extends StatelessWidget {
  final InstallmentStatus status;

  const EstadoCuotaBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getBackgroundColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getText(),
        style: TextStyles.labelSmall.copyWith(
          color: _getBackgroundColor(),
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.overdue:
        return AppColors.error;
      case InstallmentStatus.pending:
        return AppColors.warning;
      case InstallmentStatus.partiallyPaid:
        return AppColors.info;
      case InstallmentStatus.waived:
        return AppColors.textSecondary;
    }
  }

  String _getText() {
    switch (status) {
      case InstallmentStatus.paid:
        return 'Pagada';
      case InstallmentStatus.overdue:
        return 'Vencida';
      case InstallmentStatus.pending:
        return 'Pendiente';
      case InstallmentStatus.partiallyPaid:
        return 'Parcial';
      case InstallmentStatus.waived:
        return 'Condonada';
    }
  }
}
