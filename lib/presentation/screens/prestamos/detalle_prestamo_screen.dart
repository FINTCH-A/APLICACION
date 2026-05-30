import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';

import '../../../data/models/prestamo_model.dart';
import '../../../data/models/cuota_model.dart';
import '../../../data/providers/prestamo_provider.dart';

import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/badges/estado_badge_prestamo.dart';

import 'widgets/cronograma_cuotas.dart';

class DetallePrestamoScreen extends StatefulWidget {
  final String id;

  const DetallePrestamoScreen({super.key, required this.id});

  @override
  State<DetallePrestamoScreen> createState() => _DetallePrestamoScreenState();
}

class _DetallePrestamoScreenState extends State<DetallePrestamoScreen> {
  LoanModel? _prestamo;
  List<InstallmentModel> _cuotas = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPrestamo();
  }

  Future<void> _loadPrestamo() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final provider = context.read<PrestamoProvider>();

      await provider.loadLoanById(int.parse(widget.id));

      setState(() {
        _prestamo = provider.currentLoan;
        _cuotas = provider.installments;
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

    if (_error != null || _prestamo == null) {
      return Scaffold(
        body: ErrorWidgetCustom(
          message: _error ?? 'No se encontró el préstamo',
          onRetry: _loadPrestamo,
        ),
      );
    }

    final prestamo = _prestamo!;

    final cuotasPagadas = _cuotas.where((c) => c.status.name == 'paid').length;
    final totalCuotas = _cuotas.length;
    final cuotasPendientes = totalCuotas - cuotasPagadas;
    final progreso = totalCuotas > 0 ? cuotasPagadas / totalCuotas : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detalle del préstamo',
          style: TextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPrestamo,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER PRINCIPAL
              _LoanHeaderCard(
                prestamo: prestamo,
                progreso: progreso,
                cuotasPagadas: cuotasPagadas,
                totalCuotas: totalCuotas,
              ),

              const SizedBox(height: 24),

              // KPIS
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      title: 'Pagadas',
                      value: cuotasPagadas.toString(),
                      icon: Icons.check_circle,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      title: 'Pendientes',
                      value: cuotasPendientes.toString(),
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KpiCard(
                      title: 'Cuotas',
                      value: totalCuotas.toString(),
                      icon: Icons.receipt_long,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // INFORMACION FINANCIERA
              _SectionTitle(title: 'Información financiera'),
              const SizedBox(height: 14),
              _ModernCard(
                child: Column(
                  children: [
                    _DetailTile(
                      icon: Icons.account_balance_wallet,
                      label: 'Monto aprobado',
                      value: formatCurrency(prestamo.approvedAmount),
                    ),
                    const Divider(color: AppColors.border),
                    _DetailTile(
                      icon: Icons.payments_outlined,
                      label: 'Monto total a pagar',
                      value: formatCurrency(prestamo.totalAmount),
                    ),
                    const Divider(color: AppColors.border),
                    _DetailTile(
                      icon: Icons.percent_rounded,
                      label: 'Tasa de interés',
                      value:
                          '${prestamo.interestRate.toStringAsFixed(1)}% anual',
                    ),
                    const Divider(color: AppColors.border),
                    _DetailTile(
                      icon: Icons.calendar_month,
                      label: 'Plazo',
                      value: '${prestamo.termMonths} meses',
                    ),
                    const Divider(color: AppColors.border),
                    _DetailTile(
                      icon: Icons.event_available,
                      label: 'Fecha vencimiento',
                      value: DateUtilsCustom.formatDate(prestamo.dueDate),
                    ),
                    if (prestamo.disbursedAt != null) ...[
                      const Divider(color: AppColors.border),
                      _DetailTile(
                        icon: Icons.attach_money,
                        label: 'Fecha desembolso',
                        value: DateUtilsCustom.formatDate(
                          prestamo.disbursedAt!,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // CRONOGRAMA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(title: 'Cronograma'),
                  Text(
                    '${_cuotas.length} cuotas',
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              CronogramaCuotas(
                cuotas: _cuotas,
                onPagarCuota: (cuotaId) {
                  context.push(RouteNames.registrarPagoPath(widget.id));
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          context.push(RouteNames.registrarPagoPath(widget.id));
        },
        icon: const Icon(Icons.payments),
        label: const Text('Registrar pago'),
      ),
    );
  }
}

// =======================================================
// HEADER PRINCIPAL
// =======================================================

class _LoanHeaderCard extends StatelessWidget {
  final LoanModel prestamo;
  final double progreso;
  final int cuotasPagadas;
  final int totalCuotas;

  const _LoanHeaderCard({
    required this.prestamo,
    required this.progreso,
    required this.cuotasPagadas,
    required this.totalCuotas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código préstamo',
                    style: TextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prestamo.loanCode,
                    style: TextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              EstadoBadgePrestamo(status: prestamo.status),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            formatCurrency(prestamo.approvedAmount),
            style: TextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Monto aprobado',
            style: TextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 12,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$cuotasPagadas de $totalCuotas cuotas pagadas',
                style: TextStyles.bodySmall.copyWith(color: Colors.white),
              ),
              Text(
                '${(progreso * 100).toStringAsFixed(0)}%',
                style: TextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =======================================================
// KPI CARD
// =======================================================

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// SECTION TITLE
// =======================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// =======================================================
// MODERN CARD
// =======================================================

class _ModernCard extends StatelessWidget {
  final Widget child;

  const _ModernCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =======================================================
// DETAIL TILE
// =======================================================

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
