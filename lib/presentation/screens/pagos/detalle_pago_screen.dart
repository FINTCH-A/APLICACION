import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/pago_model.dart';

class DetallePagoScreen extends StatelessWidget {
  final PaymentModel pago;

  const DetallePagoScreen({super.key, required this.pago});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Pago'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Referencia
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.receipt_outlined,
              label: 'Referencia',
              value: pago.reference,
              isCopyable: true,
            ),
            const SizedBox(height: 16),

            // Monto
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.attach_money,
              label: 'Monto',
              value: formatCurrency(pago.amount),
              isHighlighted: true,
            ),
            const SizedBox(height: 16),

            // Fecha
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.calendar_today,
              label: 'Fecha de pago',
              value: DateUtilsCustom.formatDate(pago.paymentDate),
            ),
            const SizedBox(height: 16),

            // Estado
            _buildStatusRow(),
            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 16),

            // Método de pago
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.credit_card,
              label: 'Método de pago',
              value: pago.paymentMethodId != null
                  ? 'Método #${pago.paymentMethodId}'
                  : 'No especificado',
            ),
            const SizedBox(height: 16),

            // ID del préstamo
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.account_balance,
              label: 'ID del préstamo',
              value: '#${pago.loanId}',
              isCopyable: true,
            ),
            const SizedBox(height: 16),

            // Cuota asociada
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.numbers,
              label: 'Cuota asociada',
              value: pago.installmentId != null
                  ? '#${pago.installmentId}'
                  : 'Pago directo a préstamo',
            ),
            const SizedBox(height: 16),

            // Notas
            if (pago.notes != null && pago.notes!.trim().isNotEmpty) ...[
              _buildDetailRow(
                context: context, // PASAMOS EL CONTEXT
                icon: Icons.description_outlined,
                label: 'Notas',
                value: pago.notes!,
                multiline: true,
              ),
              const SizedBox(height: 16),
            ],

            const Divider(),
            const SizedBox(height: 16),

            // Fechas de creación y actualización
            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.create,
              label: 'Creado',
              value: DateUtilsCustom.formatDateTime(pago.createdAt),
            ),
            const SizedBox(height: 12),

            _buildDetailRow(
              context: context, // PASAMOS EL CONTEXT
              icon: Icons.update,
              label: 'Actualizado',
              value: DateUtilsCustom.formatDateTime(pago.updatedAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context, // AHORA RECIBE EL CONTEXT
    required IconData icon,
    required String label,
    required String value,
    bool isCopyable = false,
    bool isHighlighted = false,
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: 16),
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
              const SizedBox(height: 4),
              multiline
                  ? Text(
                      value,
                      style: isHighlighted
                          ? TextStyles.titleLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            )
                          : TextStyles.bodyMedium,
                    )
                  : Text(
                      value,
                      style: isHighlighted
                          ? TextStyles.titleLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            )
                          : TextStyles.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        ),
        if (isCopyable)
          IconButton(
            icon: Icon(Icons.copy, size: 20, color: AppColors.primary),
            onPressed: () {
              // Mostrar mensaje de copiado
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado al portapapeles'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStatusRow() {
    Color bgColor;
    IconData icon;

    switch (pago.status) {
      case PaymentStatus.completed:
        bgColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case PaymentStatus.pending:
        bgColor = AppColors.warning;
        icon = Icons.pending;
        break;
      case PaymentStatus.failed:
        bgColor = AppColors.error;
        icon = Icons.error;
        break;
      case PaymentStatus.reversed:
        bgColor = AppColors.textSecondary;
        icon = Icons.refresh;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: bgColor, size: 24),
          const SizedBox(width: 12),
          Text(
            pago.statusText,
            style: TextStyles.titleMedium.copyWith(
              color: bgColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
