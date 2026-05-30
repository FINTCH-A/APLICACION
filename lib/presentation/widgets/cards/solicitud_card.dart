import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/solicitud_model.dart';

class SolicitudCard extends StatelessWidget {
  final LoanApplicationModel solicitud;
  final VoidCallback? onTap;

  const SolicitudCard({super.key, required this.solicitud, this.onTap});

  Color _getStatusColor() {
    switch (solicitud.status) {
      case LoanApplicationStatus.draft:
        return AppColors.warning;
      case LoanApplicationStatus.submitted:
        return AppColors.info;
      case LoanApplicationStatus.underReview:
        return AppColors.primary;
      case LoanApplicationStatus.approved:
        return AppColors.success;
      case LoanApplicationStatus.rejected:
        return AppColors.error;
      case LoanApplicationStatus.cancelled:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (solicitud.status) {
      case LoanApplicationStatus.draft:
        return Icons.edit_note;
      case LoanApplicationStatus.submitted:
        return Icons.send;
      case LoanApplicationStatus.underReview:
        return Icons.hourglass_empty;
      case LoanApplicationStatus.approved:
        return Icons.check_circle;
      case LoanApplicationStatus.rejected:
        return Icons.cancel;
      case LoanApplicationStatus.cancelled:
        return Icons.remove_circle;
    }
  }

  String _getStatusText() {
    switch (solicitud.status) {
      case LoanApplicationStatus.draft:
        return 'Borrador';
      case LoanApplicationStatus.submitted:
        return 'Enviada';
      case LoanApplicationStatus.underReview:
        return 'En Revisión';
      case LoanApplicationStatus.approved:
        return 'Aprobada';
      case LoanApplicationStatus.rejected:
        return 'Rechazada';
      case LoanApplicationStatus.cancelled:
        return 'Cancelada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_getStatusIcon(), color: statusColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solicitud',
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '#${solicitud.id}',
                          style: TextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge de estado
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: TextStyles.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),

              // Información de la solicitud
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monto solicitado',
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(solicitud.requestedAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plazo',
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${solicitud.requestedTerm} meses',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Propósito (si existe)
              if (solicitud.purpose != null &&
                  solicitud.purpose!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        solicitud.purpose!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Fecha de creación
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Solicitado: ${_formatDate(solicitud.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
