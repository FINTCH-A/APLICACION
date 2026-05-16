import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../data/models/cuota_model.dart';
import '../../../widgets/badges/estado_cuota_badge.dart';

class CronogramaCuotas extends StatelessWidget {
  final List<InstallmentModel> cuotas;
  final Function(int)? onPagarCuota;

  const CronogramaCuotas({super.key, required this.cuotas, this.onPagarCuota});

  @override
  Widget build(BuildContext context) {
    if (cuotas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No hay cuotas registradas',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Cronograma de Cuotas', style: TextStyles.titleSmall),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cuotas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cuota = cuotas[index];
              return _CuotaRow(
                cuota: cuota,
                onPagar: onPagarCuota != null && cuota.status.name == 'pending'
                    ? () => onPagarCuota!(cuota.id)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CuotaRow extends StatelessWidget {
  final InstallmentModel cuota;
  final VoidCallback? onPagar;

  const _CuotaRow({required this.cuota, this.onPagar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Número de cuota
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${cuota.installmentNumber}',
                style: TextStyles.titleMedium.copyWith(
                  color: _getStatusColor(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cuota ${cuota.installmentNumber}',
                  style: TextStyles.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Vence: ${DateUtilsCustom.formatDate(cuota.dueDate)}',
                  style: TextStyles.labelSmall.copyWith(
                    color: cuota.isOverdue
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Monto
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatCurrency(cuota.totalAmount),
                style: TextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              EstadoCuotaBadge(status: cuota.status),
            ],
          ),
          // Botón pagar
          if (onPagar != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: onPagar,
              icon: const Icon(Icons.payment, color: AppColors.primary),
              tooltip: 'Pagar',
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (cuota.status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.overdue:
        return AppColors.error;
      case InstallmentStatus.pending:
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}
