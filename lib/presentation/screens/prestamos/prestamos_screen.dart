import 'package:aplicacion_avante/data/models/prestamo_model.dart';
import 'package:aplicacion_avante/data/models/solicitud_model.dart';
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
import '../../widgets/cards/solicitud_card.dart';

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
    _FilterOption(
      key: 'proceso',
      label: 'En Proceso',
      icon: Icons.hourglass_empty_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = context.read<PrestamoProvider>();
    await Future.wait([provider.loadLoans(), provider.loadLoanApplications()]);
  }

  List<dynamic> _getFilteredItems(PrestamoProvider provider) {
    final allLoans = provider.loans;
    final allApplications = provider.loanApplications;

    switch (_selectedFilter) {
      case 'activos':
        return allLoans.where((l) => l.status == LoanStatus.active).toList();
      case 'pagados':
        return allLoans.where((l) => l.status == LoanStatus.paid).toList();
      case 'proceso':
        return allApplications
            .where(
              (a) =>
                  a.status == LoanApplicationStatus.draft ||
                  a.status == LoanApplicationStatus.submitted ||
                  a.status == LoanApplicationStatus.underReview,
            )
            .toList();
      default: // 'todos'
        final List<dynamic> items = [];
        items.addAll(allLoans);
        items.addAll(allApplications);
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return items;
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
              onRetry: _loadData,
            );
          }

          final filteredItems = _getFilteredItems(provider);

          return Column(
            children: [
              _buildFilterBar(),
              if (filteredItems.isEmpty)
                Expanded(
                  child: EmptyState(
                    title: _selectedFilter == 'proceso'
                        ? 'Sin solicitudes en proceso'
                        : 'Sin préstamos',
                    message: _selectedFilter == 'proceso'
                        ? 'No tienes solicitudes pendientes'
                        : 'No hay préstamos en esta categoría',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];

                        if (item is LoanModel) {
                          return PrestamoCard(
                            prestamo: item,
                            onTap: () => context.push(
                              RouteNames.detallePrestamoPath(
                                item.id.toString(),
                              ),
                            ),
                          );
                        } else if (item is LoanApplicationModel) {
                          return SolicitudCard(
                            solicitud: item,
                            onTap: () => context.push(
                              RouteNames.detalleSolicitudPath(
                                item.id.toString(),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
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
