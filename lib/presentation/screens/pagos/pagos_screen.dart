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
    _FilterOption(key: 'todos', label: 'Todos', icon: Icons.grid_view_rounded),
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
      icon: Icons.check_circle_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLoans();
    });
  }

  Future<void> _loadLoans() async {
    final provider = context.read<PrestamoProvider>();
    await provider.loadLoans();
    if (!mounted) return;
    final activos = provider.loans
        .where((l) => l.status == LoanStatus.active)
        .toList();
    if (activos.isNotEmpty) {
      _selectLoan(activos.first);
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
        return all.where((c) {
          return c.status == InstallmentStatus.pending ||
              c.status == InstallmentStatus.partiallyPaid;
        }).toList();
      case 'vencidos':
        return all.where((c) {
          return c.status == InstallmentStatus.overdue || c.isOverdue;
        }).toList();
      case 'pagados':
        return all.where((c) {
          return c.status == InstallmentStatus.paid ||
              c.status == InstallmentStatus.waived;
        }).toList();
      default:
        return all;
    }
  }

  static String _fmt(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final digits = parts[0];
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buf.write(',');
      }
      buf.write(digits[i]);
    }
    return 'S/ $buf.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Mis Pagos',
          style: TextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
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
                  'Cuando tengas un préstamo activo podrás ver tus cuotas aquí.',
              icon: Icons.account_balance_wallet_outlined,
            );
          }

          final cuotas = _getFilteredInstallments(provider.installments);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSummary(provider.installments),
              _buildLoanSelector(prestamos),
              const SizedBox(height: 12),
              _buildFilterBar(),
              const SizedBox(height: 8),
              Expanded(child: _buildCuotasList(provider, cuotas)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            'Consulta el estado de tus cuotas y realiza pagos rápidamente.',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(List<InstallmentModel> all) {
    final pendientes = all.where((c) {
      return c.status == InstallmentStatus.pending ||
          c.status == InstallmentStatus.partiallyPaid;
    }).length;

    final vencidas = all.where((c) {
      return c.status == InstallmentStatus.overdue || c.isOverdue;
    }).length;

    final pagadas = all.where((c) {
      return c.status == InstallmentStatus.paid;
    }).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
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

  Widget _buildLoanSelector(List<LoanModel> prestamos) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: prestamos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final loan = prestamos[i];
          return _LoanChip(
            loan: loan,
            isSelected: _selectedLoan?.id == loan.id,
            onTap: () => _selectLoan(loan),
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final filter = _filters[i];
          return _FilterTab(
            label: filter.label,
            icon: filter.icon,
            isSelected: _selectedFilter == filter.key,
            onTap: () {
              setState(() {
                _selectedFilter = filter.key;
              });
            },
          );
        },
      ),
    );
  }

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
        message: 'Elige un préstamo para visualizar sus cuotas.',
        icon: Icons.touch_app_rounded,
      );
    }

    if (cuotas.isEmpty) {
      return EmptyState(
        title: 'Sin cuotas',
        message: 'No existen cuotas para este filtro.',
        icon: Icons.receipt_long_outlined,
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await provider.loadInstallments(_selectedLoan!.id);
      },
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        itemCount: cuotas.length,
        itemBuilder: (_, i) {
          final cuota = cuotas[i];
          return _CuotaCard(
            cuota: cuota,
            fmt: _fmt,
            onPagar: () {
              context.push(
                RouteNames.nuevaPagoPath(
                  loanId: cuota.loanId,
                  installmentId: cuota.id,
                ),
              );
            },
            onVerDetalle: () {
              context.push('/pagos/${cuota.loanId}/cuota/${cuota.id}');
            },
          );
        },
      ),
    );
  }
}

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

// =========================================================
// LOAN CHIP (CORREGIDO)
// =========================================================

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
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 16,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              '#${loan.loanCode}',
              style: TextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// FILTER TAB (CORREGIDO)
// =========================================================

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
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyles.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// SUMMARY CHIP
// =========================================================

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
            style: TextStyles.displaySmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
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
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withOpacity(0.15),
    );
  }
}

// =========================================================
// CUOTA CARD (CORREGIDO - SIN COLORES BLANCOS FIJOS)
// =========================================================

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

  bool get _isPagable {
    return cuota.status == InstallmentStatus.pending ||
        cuota.status == InstallmentStatus.overdue ||
        cuota.status == InstallmentStatus.partiallyPaid ||
        cuota.isOverdue;
  }

  Color get _statusColor {
    if (cuota.status == InstallmentStatus.paid) {
      return AppColors.success;
    }
    if (cuota.status == InstallmentStatus.overdue || cuota.isOverdue) {
      return AppColors.error;
    }
    if (cuota.status == InstallmentStatus.partiallyPaid) {
      return AppColors.warning;
    }
    return AppColors.warning;
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

    return GestureDetector(
      onTap: onVerDetalle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPaid ? AppColors.border : color.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              // Cabecera con número de cuota y badge
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${cuota.installmentNumber}',
                        style: TextStyles.titleMedium.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuota #${cuota.installmentNumber}',
                          style: TextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'Vence ${_fmtDate(cuota.dueDate)}',
                                style: TextStyles.bodySmall.copyWith(
                                  color: cuota.isOverdue
                                      ? AppColors.error
                                      : AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(label: _statusLabel, color: color),
                ],
              ),
              const SizedBox(height: 18),
              Divider(color: AppColors.border),
              const SizedBox(height: 18),

              // Montos
              Row(
                children: [
                  Expanded(
                    child: _AmountItem(
                      title: 'Monto',
                      value: fmt(cuota.totalAmount),
                      color: AppColors.primary,
                    ),
                  ),
                  if (cuota.pendingAmount > 0 && !isPaid)
                    Expanded(
                      child: _AmountItem(
                        title: 'Pendiente',
                        value: fmt(cuota.pendingAmount),
                        color: color,
                      ),
                    ),
                ],
              ),

              // Días vencidos
              if (cuota.daysOverdue > 0) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Vencida hace ${cuota.daysOverdue} día${cuota.daysOverdue != 1 ? 's' : ''}',
                          style: TextStyles.labelMedium.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 18),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onVerDetalle,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Detalle'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  if (_isPagable) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onPagar,
                        icon: const Icon(Icons.payment, size: 18),
                        label: const Text('Pagar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// AMOUNT ITEM
// =========================================================

class _AmountItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _AmountItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyles.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// =========================================================
// STATUS BADGE
// =========================================================

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
