// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/pago_model.dart';
import '../../../data/providers/pago_provider.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';

class PagosScreen extends StatefulWidget {
  const PagosScreen({super.key});

  @override
  State<PagosScreen> createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  String _selectedFilter = 'todos';

  @override
  void initState() {
    super.initState();
    _loadPagos();
  }

  Future<void> _loadPagos() async {
    final provider = context.read<PagoProvider>();
    await provider.loadPayments();
  }

  List<PaymentModel> _getFilteredPayments(PagoProvider provider) {
    final payments = provider.payments;

    switch (_selectedFilter) {
      case 'completados':
        return payments
            .where((p) => p.status == PaymentStatus.completed)
            .toList();
      case 'pendientes':
        return payments
            .where((p) => p.status == PaymentStatus.pending)
            .toList();
      default:
        return payments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pagos'), centerTitle: true),
      body: Consumer<PagoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.error != null) {
            return ErrorWidgetCustom(
              message: provider.error!,
              onRetry: _loadPagos,
            );
          }

          final filteredPayments = _getFilteredPayments(provider);

          if (filteredPayments.isEmpty) {
            return EmptyState(
              title: 'No tienes pagos registrados',
              message:
                  'Tus pagos aparecerán aquí cuando realices tu primera transacción',
              icon: Icons.payments_outlined,
            );
          }

          return Column(
            children: [
              // Filtros
              _buildFilters(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadPagos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredPayments.length,
                    itemBuilder: (context, index) {
                      final pago = filteredPayments[index];
                      return _PagoCard(pago: pago);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'Todos',
            isSelected: _selectedFilter == 'todos',
            onSelected: () => setState(() => _selectedFilter = 'todos'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completados',
            isSelected: _selectedFilter == 'completados',
            onSelected: () => setState(() => _selectedFilter = 'completados'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pendientes',
            isSelected: _selectedFilter == 'pendientes',
            onSelected: () => setState(() => _selectedFilter = 'pendientes'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyles.labelMedium.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }
}

class _PagoCard extends StatelessWidget {
  final PaymentModel pago;

  const _PagoCard({required this.pago});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Referencia: ${pago.reference}',
                  style: TextStyles.titleSmall,
                ),
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
        Text(value, style: TextStyles.bodyMedium),
      ],
    );
  }
}
