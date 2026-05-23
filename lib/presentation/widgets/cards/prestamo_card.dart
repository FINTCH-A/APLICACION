// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/prestamo_model.dart';
import '../badges/estado_badge_prestamo.dart';

class PrestamoCard extends StatelessWidget {
  final LoanModel prestamo;
  final VoidCallback? onTap;

  const PrestamoCard({super.key, required this.prestamo, this.onTap});

  // Formatter sin intl: "S/ 3,000.00"
  static String _fmt(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final digits = parts[0].replaceAll('-', '');
    final isNegative = amount < 0;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return 'S/ ${isNegative ? '-' : ''}$buffer.${parts[1]}';
  }

  static String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Color _getStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.active:
        return AppColors.success;
      case LoanStatus.paid:
        return AppColors.info;
      case LoanStatus.pending:
        return AppColors.warning;
      case LoanStatus.approved:
        return AppColors.primary;
      case LoanStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = prestamo.status == LoanStatus.active;
    final statusColor = _getStatusColor(prestamo.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withOpacity(0.25)
              : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
              // ── Cabecera ──────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ícono de préstamo
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Código del préstamo (más espacio)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Préstamo',
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          prestamo.loanCode,
                          style: TextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge
                  EstadoBadgePrestamo(status: prestamo.status),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),

              // ── Fila de datos: Monto | Plazo | Tasa interés ──────
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _DataItem(
                      icon: Icons.payments_outlined,
                      label: 'Monto',
                      value: _fmt(prestamo.approvedAmount),
                      valueColor: AppColors.primary,
                    ),
                  ),
                  _VerticalDivider(),
                  Expanded(
                    flex: 2,
                    child: _DataItem(
                      icon: Icons.calendar_month_outlined,
                      label: 'Plazo',
                      value: '${prestamo.termMonths} meses',
                    ),
                  ),
                  _VerticalDivider(),
                  Expanded(
                    flex: 2,
                    child: _DataItem(
                      icon: Icons.percent_rounded,
                      label: 'Tasa interés',
                      value: '${prestamo.interestRate.toStringAsFixed(1)}%',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Fila inferior: Cuotas + Fecha ─────────────
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  // Cuotas pagadas
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 2.2,
                    child: _MetaRow(
                      icon: Icons.receipt_long_outlined,
                      label: 'Cuotas pagadas',
                      value: '0 / ${prestamo.termMonths}',
                      valueColor: AppColors.primary,
                    ),
                  ),
                  // Fecha de desembolso
                  if (prestamo.disbursedAt != null)
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 2.2,
                      child: _MetaRow(
                        icon: Icons.event_available_outlined,
                        label: 'Desembolsado',
                        value: _formatDate(prestamo.disbursedAt!),
                      ),
                    ),
                ],
              ),

              // ── Flecha de navegación ──────────────────────
              if (onTap != null) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ver detalle',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ítem de dato (Monto / Plazo / Tasa) ──────────────────

class _DataItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DataItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}

// ── Separador vertical entre datos ───────────────────────

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.border,
    );
  }
}

// ── Fila de metadato (ícono + label + value) ──────────────

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
