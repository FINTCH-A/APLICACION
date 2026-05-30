import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/pago_model.dart';

class DetallePagoScreen extends StatelessWidget {
  final PaymentModel pago;

  const DetallePagoScreen({super.key, required this.pago});

  Color get _statusColor {
    switch (pago.status) {
      case PaymentStatus.completed:
        return AppColors.success;
      case PaymentStatus.pending:
        return AppColors.warning;
      case PaymentStatus.failed:
        return AppColors.error;
      case PaymentStatus.reversed:
        return AppColors.textSecondary;
    }
  }

  IconData get _statusIcon {
    switch (pago.status) {
      case PaymentStatus.completed:
        return Icons.check_circle_rounded;
      case PaymentStatus.pending:
        return Icons.pending_rounded;
      case PaymentStatus.failed:
        return Icons.cancel_rounded;
      case PaymentStatus.reversed:
        return Icons.refresh_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Detalle del Pago',
          style: TextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          children: [
            // ───────────────── HEADER ─────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [statusColor, statusColor.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_statusIcon, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    formatCurrency(pago.amount),
                    style: TextStyles.numberLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      pago.statusText,
                      style: TextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Referencia',
                    style: TextStyles.labelMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pago.reference,
                    textAlign: TextAlign.center,
                    style: TextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ───────────────── INFORMACIÓN PRINCIPAL ─────────────────
            _SectionCard(
              title: 'Información del Pago',
              icon: Icons.receipt_long_rounded,
              children: [
                _DetailTile(
                  context: context,
                  icon: Icons.calendar_month_rounded,
                  label: 'Fecha de pago',
                  value: DateUtilsCustom.formatDate(pago.paymentDate),
                ),
                _DetailTile(
                  context: context,
                  icon: Icons.credit_card_rounded,
                  label: 'Método de pago',
                  value: pago.paymentMethodId != null
                      ? 'Método #${pago.paymentMethodId}'
                      : 'No especificado',
                ),
                _DetailTile(
                  context: context,
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Préstamo',
                  value: '#${pago.loanId}',
                  isCopyable: true,
                ),
                _DetailTile(
                  context: context,
                  icon: Icons.payments_outlined,
                  label: 'Cuota asociada',
                  value: pago.installmentId != null
                      ? '#${pago.installmentId}'
                      : 'Pago general al préstamo',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ───────────────── NOTAS ─────────────────
            if (pago.notes != null && pago.notes!.trim().isNotEmpty)
              _SectionCard(
                title: 'Notas',
                icon: Icons.description_outlined,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      pago.notes!,
                      style: TextStyles.bodyMedium.copyWith(
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            if (pago.notes != null && pago.notes!.trim().isNotEmpty)
              const SizedBox(height: 16),

            // ───────────────── AUDITORÍA ─────────────────
            _SectionCard(
              title: 'Información del Sistema',
              icon: Icons.verified_user_outlined,
              children: [
                _DetailTile(
                  context: context,
                  icon: Icons.access_time_rounded,
                  label: 'Registrado',
                  value: DateUtilsCustom.formatDateTime(pago.createdAt),
                ),
                _DetailTile(
                  context: context,
                  icon: Icons.update_rounded,
                  label: 'Última actualización',
                  value: DateUtilsCustom.formatDateTime(pago.updatedAt),
                ),
                _DetailTile(
                  context: context,
                  icon: Icons.tag_rounded,
                  label: 'Referencia',
                  value: pago.reference,
                  isCopyable: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ───────────────── BOTÓN ─────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Volver'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  textStyle: TextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SECTION CARD
// ══════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// DETAIL TILE
// ══════════════════════════════════════════════════════

class _DetailTile extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final String value;
  final bool isCopyable;

  const _DetailTile({
    required this.context,
    required this.icon,
    required this.label,
    required this.value,
    this.isCopyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
          if (isCopyable)
            IconButton(
              tooltip: 'Copiar',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label copiado'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(
                Icons.copy_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
