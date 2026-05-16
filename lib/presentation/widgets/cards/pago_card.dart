import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/pago_model.dart';

class PagoCard extends StatelessWidget {
  final PaymentModel pago;
  final VoidCallback? onTap;

  const PagoCard({super.key, required this.pago, this.onTap});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pago #${pago.id}', style: TextStyles.titleSmall),
                  _StatusBadge(status: pago.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: 'Monto',
                      value: formatCurrency(pago.amount),
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: 'Préstamo',
                      value: '#${pago.loanId}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: 'Referencia',
                      value: pago.reference,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      label: 'Fecha',
                      value: DateUtilsCustom.formatDate(pago.paymentDate),
                    ),
                  ),
                ],
              ),
              if (pago.notes != null) ...[
                const SizedBox(height: 8),
                _InfoItem(label: 'Nota', value: pago.notes!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PaymentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = {
      PaymentStatus.completed: AppColors.success,
      PaymentStatus.pending: AppColors.warning,
      PaymentStatus.failed: AppColors.error,
      PaymentStatus.reversed: AppColors.textSecondary,
    };

    final texts = {
      PaymentStatus.completed: 'Completado',
      PaymentStatus.pending: 'Pendiente',
      PaymentStatus.failed: 'Fallido',
      PaymentStatus.reversed: 'Revertido',
    };

    final color = colors[status] ?? AppColors.textSecondary;
    final text = texts[status] ?? 'Desconocido';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyles.labelSmall.copyWith(color: color)),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyles.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
