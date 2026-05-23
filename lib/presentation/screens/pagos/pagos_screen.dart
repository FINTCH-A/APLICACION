import 'package:aplicacion_avante/config/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/prestamo_model.dart';
import '../../../data/models/cuota_model.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_widget.dart';

class PagosScreen extends StatefulWidget {
  const PagosScreen({super.key});

  @override
  State<PagosScreen> createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  LoanModel? _selectedLoan;
  String _selectedFilter = 'todos';

  final _filters = const [
    _FilterOption(key: 'todos', label: 'Todos', icon: Icons.list_rounded),
    _FilterOption(
      key: 'pendientes',
      label: 'Pendientes',
      icon: Icons.schedule_rounded,
    ),
    _FilterOption(
      key: 'vencidos',
      label: 'Vencidos',
      icon: Icons.warning_amber_rounded,
    ),
    _FilterOption(
      key: 'pagados',
      label: 'Pagados',
      icon: Icons.check_circle_outline_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLoans());
  }

  Future<void> _loadLoans() async {
    final provider = context.read<PrestamoProvider>();
    await provider.loadLoans();
    // Seleccionar el primer préstamo activo automáticamente
    if (mounted) {
      final activos = provider.loans
          .where((l) => l.status == LoanStatus.active)
          .toList();
      if (activos.isNotEmpty) {
        _selectLoan(activos.first);
      }
    }
  }

  Future<void> _selectLoan(LoanModel loan) async {
    setState(() {
      _selectedLoan = loan;
      _selectedFilter = 'todos';
    });
    await context.read<PrestamoProvider>().loadInstallments(loan.id);
  }

  List<InstallmentModel> _getFilteredInstallments(List<InstallmentModel> all) {
    switch (_selectedFilter) {
      case 'pendientes':
        return all
            .where(
              (c) =>
                  c.status == InstallmentStatus.pending ||
                  c.status == InstallmentStatus.partiallyPaid,
            )
            .toList();
      case 'vencidos':
        return all
            .where((c) => c.status == InstallmentStatus.overdue || c.isOverdue)
            .toList();
      case 'pagados':
        return all
            .where(
              (c) =>
                  c.status == InstallmentStatus.paid ||
                  c.status == InstallmentStatus.waived,
            )
            .toList();
      default:
        return all;
    }
  }

  // Formatter sin intl
  static String _fmt(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final digits = parts[0];
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
      buf.write(digits[i]);
    }
    return 'S/ $buf.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mis Pagos'), centerTitle: true),
      body: Consumer<PrestamoProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingLoans) {
            return const LoadingWidget(fullScreen: true);
          }

          final prestamos = provider.loans
              .where((l) => l.status == LoanStatus.active)
              .toList();

          if (prestamos.isEmpty) {
            return EmptyState(
              title: 'Sin préstamos activos',
              message:
                  'Cuando tengas un préstamo activo podrás ver sus cuotas aquí',
              icon: Icons.account_balance_wallet_outlined,
            );
          }

          final cuotas = _getFilteredInstallments(provider.installments);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Resumen rápido ──────────────────────────
              _buildSummary(provider.installments),

              // ── Selector de préstamos ──────────────────
              _buildLoanSelector(prestamos),

              const SizedBox(height: 4),

              // ── Filtros de cuotas ──────────────────────
              _buildFilterBar(),

              const SizedBox(height: 4),

              // ── Lista de cuotas ────────────────────────
              Expanded(child: _buildCuotasList(provider, cuotas)),
            ],
          );
        },
      ),
    );
  }

  // ── Resumen rápido ────────────────────────────────────

  Widget _buildSummary(List<InstallmentModel> all) {
    final pendientes = all
        .where(
          (c) =>
              c.status == InstallmentStatus.pending ||
              c.status == InstallmentStatus.partiallyPaid,
        )
        .length;
    final vencidas = all
        .where((c) => c.status == InstallmentStatus.overdue || c.isOverdue)
        .length;
    final pagadas = all.where((c) => c.status == InstallmentStatus.paid).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B6B65), Color(0xFF27BAAE)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _SummaryChip(
            label: 'Pendientes',
            count: pendientes,
            color: Colors.white,
          ),
          _VSep(),
          _SummaryChip(
            label: 'Vencidas',
            count: vencidas,
            color: const Color(0xFFFFD580),
          ),
          _VSep(),
          _SummaryChip(
            label: 'Pagadas',
            count: pagadas,
            color: const Color(0xFF86EFAC),
          ),
        ],
      ),
    );
  }

  // ── Selector de préstamos ─────────────────────────────

  Widget _buildLoanSelector(List<LoanModel> prestamos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Selecciona un préstamo',
            style: TextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: prestamos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final loan = prestamos[i];
              final isSelected = _selectedLoan?.id == loan.id;
              return _LoanChip(
                loan: loan,
                isSelected: isSelected,
                onTap: () => _selectLoan(loan),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Filtros ───────────────────────────────────────────

  Widget _buildFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final isSelected = _selectedFilter == f.key;
          return _FilterTab(
            label: f.label,
            icon: f.icon,
            isSelected: isSelected,
            onTap: () => setState(() => _selectedFilter = f.key),
          );
        },
      ),
    );
  }

  // ── Lista de cuotas ───────────────────────────────────

  Widget _buildCuotasList(
    PrestamoProvider provider,
    List<InstallmentModel> cuotas,
  ) {
    if (provider.isLoadingInstallments) {
      return const LoadingWidget();
    }

    if (_selectedLoan == null) {
      return EmptyState(
        title: 'Selecciona un préstamo',
        message: 'Elige un préstamo arriba para ver sus cuotas',
        icon: Icons.touch_app_outlined,
      );
    }

    if (cuotas.isEmpty) {
      return EmptyState(
        title: 'Sin cuotas',
        message: 'No hay cuotas en esta categoría',
        icon: Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (_selectedLoan != null) {
          await provider.loadInstallments(_selectedLoan!.id);
        }
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: cuotas.length,
        itemBuilder: (_, i) => _CuotaCard(
          cuota: cuotas[i],
          fmt: _fmt,
          onPagar: () {
            context.push(
              RouteNames.nuevaPagoPath(
                loanId: cuotas[i].loanId,
                installmentId: cuotas[i].id,
              ),
            );
          },
          onVerDetalle: () {
            context.push(
              '/prestamos/${cuotas[i].loanId}/cuota/${cuotas[i].id}',
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// LOAN CHIP
// ══════════════════════════════════════════════════════

class _LoanChip extends StatelessWidget {
  final LoanModel loan;
  final bool isSelected;
  final VoidCallback onTap;

  const _LoanChip({
    required this.loan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 13,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              '#${loan.loanCode}',
              style: TextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// FILTER TAB
// ══════════════════════════════════════════════════════

class _FilterOption {
  final String key;
  final String label;
  final IconData icon;
  const _FilterOption({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class _FilterTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SUMMARY CHIP
// ══════════════════════════════════════════════════════

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white.withOpacity(0.25),
    );
  }
}

// ══════════════════════════════════════════════════════
// CUOTA CARD
// ══════════════════════════════════════════════════════

class _CuotaCard extends StatelessWidget {
  final InstallmentModel cuota;
  final String Function(double) fmt;
  final VoidCallback onPagar;
  final VoidCallback onVerDetalle;

  const _CuotaCard({
    required this.cuota,
    required this.fmt,
    required this.onPagar,
    required this.onVerDetalle,
  });

  bool get _isPagable =>
      cuota.status == InstallmentStatus.pending ||
      cuota.status == InstallmentStatus.overdue ||
      cuota.status == InstallmentStatus.partiallyPaid ||
      cuota.isOverdue;

  Color get _statusColor {
    if (cuota.status == InstallmentStatus.paid) return AppColors.success;
    if (cuota.status == InstallmentStatus.overdue || cuota.isOverdue)
      return AppColors.error;
    if (cuota.status == InstallmentStatus.partiallyPaid)
      return AppColors.warning;
    if (cuota.status == InstallmentStatus.waived) return AppColors.info;
    return AppColors.warning; // pending
  }

  String get _statusLabel => cuota.statusText;

  static String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor;
    final isPaid =
        cuota.status == InstallmentStatus.paid ||
        cuota.status == InstallmentStatus.waived;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPaid ? AppColors.border : color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Fila superior: nro cuota + badge ──────
            Row(
              children: [
                // Número de cuota con ícono
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${cuota.installmentNumber}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuota #${cuota.installmentNumber}',
                        style: TextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 12,
                            color: cuota.isOverdue
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Vence: ${_fmtDate(cuota.dueDate)}',
                            style: TextStyles.labelSmall.copyWith(
                              color: cuota.isOverdue
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Badge de estado
                _StatusBadge(label: _statusLabel, color: color),
              ],
            ),

            const SizedBox(height: 14),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 14),

            // ── Fila de datos + botón ─────────────────
            Row(
              children: [
                // Monto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monto total',
                        style: TextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        fmt(cuota.totalAmount),
                        style: TextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pendiente (si aplica)
                if (cuota.pendingAmount > 0 && !isPaid) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pendiente',
                          style: TextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          fmt(cuota.pendingAmount),
                          style: TextStyles.titleSmall.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Botón acción
                _ActionButton(
                  isPagable: _isPagable,
                  isPaid: isPaid,
                  color: color,
                  onPagar: onPagar,
                  onVerDetalle: onVerDetalle,
                ),
              ],
            ),

            // ── Días vencidos (si aplica) ─────────────
            if (cuota.daysOverdue > 0) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 13,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Vencida hace ${cuota.daysOverdue} día${cuota.daysOverdue != 1 ? 's' : ''}',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Badge de estado ───────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón de acción ───────────────────────────────────

class _ActionButton extends StatelessWidget {
  final bool isPagable;
  final bool isPaid;
  final Color color;
  final VoidCallback onPagar;
  final VoidCallback onVerDetalle;

  const _ActionButton({
    required this.isPagable,
    required this.isPaid,
    required this.color,
    required this.onPagar,
    required this.onVerDetalle,
  });

  @override
  Widget build(BuildContext context) {
    if (isPaid) {
      return TextButton.icon(
        onPressed: onVerDetalle,
        icon: const Icon(Icons.visibility_outlined, size: 14),
        label: const Text('Ver'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.info,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPagar,
      icon: const Icon(Icons.payment_rounded, size: 14),
      label: const Text('Pagar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    );
  }
}
