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
import 'widgets/progreso_prestamo.dart';

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
    final progreso = totalCuotas > 0 ? cuotasPagadas / totalCuotas : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Préstamo #${prestamo.loanCode}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado y código
            _InfoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código',
                        style: TextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(prestamo.loanCode, style: TextStyles.titleMedium),
                    ],
                  ),
                  EstadoBadgePrestamo(status: prestamo.status),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Progreso del préstamo
            ProgresoPrestamo(
              progreso: progreso,
              cuotasPagadas: cuotasPagadas,
              totalCuotas: totalCuotas,
            ),
            const SizedBox(height: 16),

            // Información del préstamo
            _InfoCard(
              title: 'Información del Préstamo',
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Monto aprobado',
                    value: formatCurrency(prestamo.approvedAmount),
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Monto total a pagar',
                    value: formatCurrency(prestamo.totalAmount),
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Tasa de interés',
                    value: '${prestamo.interestRate.toStringAsFixed(1)}% anual',
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Plazo',
                    value: '${prestamo.termMonths} meses',
                  ),
                  const Divider(),
                  _DetailRow(
                    label: 'Fecha de vencimiento',
                    value: DateUtilsCustom.formatDate(prestamo.dueDate),
                  ),
                  if (prestamo.disbursedAt != null) ...[
                    const Divider(),
                    _DetailRow(
                      label: 'Fecha de desembolso',
                      value: DateUtilsCustom.formatDate(prestamo.disbursedAt!),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cronograma de cuotas
            CronogramaCuotas(
              cuotas: _cuotas,
              onPagarCuota: (cuotaId) {
                context.push(RouteNames.registrarPagoPath(widget.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _InfoCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title!, style: TextStyles.titleSmall),
            ),
            const Divider(height: 1),
          ],
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyles.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
