import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/prestamo_model.dart';

class EstadoBadgePrestamo extends StatelessWidget {
  final LoanStatus status;

  const EstadoBadgePrestamo({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        _getText(),
        style: TextStyles.labelMedium.copyWith(
          color: _getBackgroundColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case LoanStatus.active:
        return AppColors.success;
      case LoanStatus.pending:
        return AppColors.warning;
      case LoanStatus.paid:
        return AppColors.info;
      case LoanStatus.approved:
        return AppColors.primary;
      case LoanStatus.rejected:
        return AppColors.error;
      case LoanStatus.defaulted:
        return AppColors.error;
      case LoanStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  String _getText() {
    switch (status) {
      case LoanStatus.active:
        return '● Activo';
      case LoanStatus.pending:
        return '● Pendiente';
      case LoanStatus.paid:
        return '● Pagado';
      case LoanStatus.approved:
        return '● Aprobado';
      case LoanStatus.rejected:
        return '● Rechazado';
      case LoanStatus.defaulted:
        return '● Incumplido';
      case LoanStatus.cancelled:
        return '● Cancelado';
    }
  }
}
