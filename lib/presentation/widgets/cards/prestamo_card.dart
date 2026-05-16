import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/prestamo_model.dart';
import '../badges/estado_badge_prestamo.dart';

class PrestamoCard extends StatelessWidget {
  final LoanModel prestamo;
  final VoidCallback? onTap;

  const PrestamoCard({super.key, required this.prestamo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Código del préstamo
              Text(
                'Préstamo #${prestamo.loanCode}',
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              // Fila: Monto y Plazo
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: 'Monto',
                      value: formatCurrency(prestamo.approvedAmount),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoItem(
                      label: 'Plazo',
                      value: '${prestamo.termMonths} meses',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fila: Tasa y Cuotas
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      label: 'Tasa interés',
                      value: '${prestamo.interestRate.toStringAsFixed(1)}%',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _InfoItem(
                      label: 'Cuotas pagadas',
                      value: '0 / ${prestamo.termMonths}',
                    ),
                  ),
                ],
              ),

              // Fecha de desembolso (si existe)
              if (prestamo.disbursedAt != null) ...[
                const SizedBox(height: 12),
                _InfoItem(
                  label: 'Desembolsado',
                  value: _formatDate(prestamo.disbursedAt!),
                ),
              ],

              const SizedBox(height: 16),

              // Badge de estado alineado a la derecha al final
              Align(
                alignment: Alignment.centerRight,
                child: EstadoBadgePrestamo(status: prestamo.status),
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
          style: TextStyles.bodyMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
