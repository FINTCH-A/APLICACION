// lib/presentation/screens/pagos/detalle_cuota_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/cuota_model.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../../config/routes/route_names.dart';

class DetalleCuotaScreen extends StatefulWidget {
  final int loanId;
  final int cuotaId;

  const DetalleCuotaScreen({
    super.key,
    required this.loanId,
    required this.cuotaId,
  });

  @override
  State<DetalleCuotaScreen> createState() => _DetalleCuotaScreenState();
}

class _DetalleCuotaScreenState extends State<DetalleCuotaScreen> {
  InstallmentModel? _cuota;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCuota();
  }

  Future<void> _loadCuota() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final provider = context.read<PrestamoProvider>();
      await provider.loadInstallments(widget.loanId);

      final cuota = provider.installments.firstWhere(
        (c) => c.id == widget.cuotaId,
        orElse: () => throw Exception('Cuota no encontrada'),
      );

      setState(() {
        _cuota = cuota;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (_error != null) {
      return Scaffold(
        body: ErrorWidgetCustom(message: _error!, onRetry: _loadCuota),
      );
    }

    final cuota = _cuota!;
    final isPaid = cuota.status == InstallmentStatus.paid;
    final statusColor = _getStatusColor(cuota.status);
    final montoPendiente = cuota.pendingAmount > 0
        ? cuota.pendingAmount
        : cuota.totalAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Cuota #${cuota.installmentNumber}'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Tarjeta principal
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
                    child: Center(
                      child: Text(
                        '${cuota.installmentNumber}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    formatCurrency(montoPendiente),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                      cuota.statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Información detallada
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border.withOpacity(0.6)),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Préstamo', value: '#${cuota.loanId}'),
                  const Divider(color: AppColors.border),
                  _DetailRow(
                    label: 'Monto total',
                    value: formatCurrency(cuota.totalAmount),
                  ),
                  if (!isPaid) ...[
                    const Divider(color: AppColors.border),
                    _DetailRow(
                      label: 'Monto pendiente',
                      value: formatCurrency(cuota.pendingAmount),
                      valueColor: AppColors.warning,
                    ),
                  ],
                  const Divider(color: AppColors.border),
                  _DetailRow(
                    label: 'Fecha de vencimiento',
                    value: DateUtilsCustom.formatDate(cuota.dueDate),
                  ),
                  if (cuota.isOverdue) ...[
                    const Divider(color: AppColors.border),
                    _DetailRow(
                      label: 'Días vencidos',
                      value: '${cuota.daysOverdue} días',
                      valueColor: AppColors.error,
                    ),
                  ],
                  if (cuota.paidAt != null) ...[
                    const Divider(color: AppColors.border),
                    _DetailRow(
                      label: 'Fecha de pago',
                      value: DateUtilsCustom.formatDate(cuota.paidAt!),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botón de acción
            if (!isPaid)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(
                      RouteNames.nuevaPagoPath(
                        loanId: cuota.loanId,
                        installmentId: cuota.id,
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment_rounded),
                  label: const Text('Pagar esta cuota'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(InstallmentStatus status) {
    switch (status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.overdue:
        return AppColors.error;
      case InstallmentStatus.pending:
        return AppColors.warning;
      case InstallmentStatus.partiallyPaid:
        return AppColors.warning;
      case InstallmentStatus.waived:
        return AppColors.info;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
