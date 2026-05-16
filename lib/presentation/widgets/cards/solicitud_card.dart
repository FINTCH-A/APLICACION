import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/solicitud_model.dart';
import '../badges/estado_badge.dart';

class SolicitudCard extends StatelessWidget {
  final LoanApplicationModel solicitud;
  final VoidCallback? onTap;

  const SolicitudCard({super.key, required this.solicitud, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior con ID y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Solicitud #${solicitud.id}',
                      style: TextStyles.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  EstadoBadge(status: solicitud.status),
                ],
              ),
              const SizedBox(height: 12),

              // Monto y plazo
              Row(
                children: [
                  Expanded(
                    child: _InfoRow(
                      label: 'Monto',
                      value: formatCurrency(solicitud.requestedAmount),
                      icon: Icons.attach_money,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoRow(
                      label: 'Plazo',
                      value: '${solicitud.requestedTerm} meses',
                      icon: Icons.calendar_month,
                    ),
                  ),
                ],
              ),

              // Propósito (si existe)
              if (solicitud.purpose != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Propósito',
                  value: solicitud.purpose!,
                  icon: Icons.description_outlined,
                  maxLines: 2,
                ),
              ],

              // Fecha de revisión (si existe)
              if (solicitud.reviewedAt != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Revisado',
                  value: _formatDate(solicitud.reviewedAt!),
                  icon: Icons.check_circle_outline,
                ),
              ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final int maxLines;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyles.bodySmall,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
