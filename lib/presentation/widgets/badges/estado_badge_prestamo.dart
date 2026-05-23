import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/prestamo_model.dart';

class EstadoBadgePrestamo extends StatelessWidget {
  final LoanStatus status;

  const EstadoBadgePrestamo({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            config.text,
            style: TextStyles.labelSmall.copyWith(
              color: config.color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig() {
    switch (status) {
      case LoanStatus.active:
        return _StatusConfig(text: 'Activo', color: AppColors.success);
      case LoanStatus.paid:
        return _StatusConfig(text: 'Pagado', color: AppColors.info);
      case LoanStatus.pending:
        return _StatusConfig(text: 'Pendiente', color: AppColors.warning);
      case LoanStatus.approved:
        return _StatusConfig(text: 'Aprobado', color: AppColors.primary);
      case LoanStatus.rejected:
        return _StatusConfig(text: 'Rechazado', color: AppColors.error);
      case LoanStatus.defaulted:
        return _StatusConfig(text: 'Incumplido', color: AppColors.error);
      case LoanStatus.cancelled:
        return _StatusConfig(text: 'Cancelado', color: AppColors.textSecondary);
    }
  }
}

class _StatusConfig {
  final String text;
  final Color color;
  _StatusConfig({required this.text, required this.color});
}
