import 'package:aplicacion_avante/data/models/prestamo_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/cards/prestamo_card.dart';

class PrestamosScreen extends StatefulWidget {
  const PrestamosScreen({super.key});

  @override
  State<PrestamosScreen> createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  String _selectedFilter = 'todos';

  final _filters = const [
    _FilterOption(key: 'todos', label: 'Todos', icon: Icons.list_rounded),
    _FilterOption(key: 'activos', label: 'Activos', icon: Icons.bolt_rounded),
    _FilterOption(
      key: 'pagados',
      label: 'Pagados',
      icon: Icons.check_circle_outline_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadPrestamos();
  }

  Future<void> _loadPrestamos() async {
    await context.read<PrestamoProvider>().loadLoans();
  }

  List<dynamic> _getFilteredLoans(PrestamoProvider provider) {
    switch (_selectedFilter) {
      case 'activos':
        return provider.loans
            .where((l) => l.status == LoanStatus.active)
            .toList();
      case 'pagados':
        return provider.loans
            .where((l) => l.status == LoanStatus.paid)
            .toList();
      default:
        return provider.loans;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mis Préstamos'), centerTitle: true),
      body: Consumer<PrestamoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingLoans) return const LoadingWidget();

          if (provider.loansError != null) {
            return ErrorWidgetCustom(
              message: provider.loansError!,
              onRetry: _loadPrestamos,
            );
          }

          final filteredLoans = _getFilteredLoans(provider);

          return Column(
            children: [
              _buildFilterBar(),
              if (filteredLoans.isEmpty)
                Expanded(
                  child: EmptyState(
                    title: 'Sin préstamos',
                    message: 'No hay préstamos en esta categoría',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadPrestamos,
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: filteredLoans.length,
                      itemBuilder: (context, index) {
                        final loan = filteredLoans[index];
                        return PrestamoCard(
                          prestamo: loan,
                          onTap: () => context.push(
                            RouteNames.detallePrestamoPath(loan.id.toString()),
                          ),
                        );
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

  Widget _buildFilterBar() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final f = _filters[index];
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
}

// ── Modelo interno de filtro ──────────────────────────────

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

// ── Tab de filtro personalizado ───────────────────────────

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
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
