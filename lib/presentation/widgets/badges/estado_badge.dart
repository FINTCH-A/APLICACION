import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/solicitud_model.dart';

class EstadoBadge extends StatelessWidget {
  final LoanApplicationStatus status;

  const EstadoBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 60, maxWidth: 90),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBackgroundColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          _getText(),
          style: TextStyles.labelSmall.copyWith(
            color: _getBackgroundColor(),
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (status) {
      case LoanApplicationStatus.approved:
        return AppColors.success;
      case LoanApplicationStatus.rejected:
        return AppColors.error;
      case LoanApplicationStatus.underReview:
        return AppColors.warning;
      case LoanApplicationStatus.submitted:
        return AppColors.info;
      case LoanApplicationStatus.draft:
        return AppColors.textSecondary;
      case LoanApplicationStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getText() {
    switch (status) {
      case LoanApplicationStatus.approved:
        return 'Aprobada';
      case LoanApplicationStatus.rejected:
        return 'Rechazada';
      case LoanApplicationStatus.underReview:
        return 'En Revisión';
      case LoanApplicationStatus.submitted:
        return 'Enviada';
      case LoanApplicationStatus.draft:
        return 'Borrador';
      case LoanApplicationStatus.cancelled:
        return 'Cancelada';
    }
  }
}
