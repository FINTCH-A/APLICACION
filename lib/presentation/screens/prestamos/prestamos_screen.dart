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

  @override
  void initState() {
    super.initState();
    _loadPrestamos();
  }

  Future<void> _loadPrestamos() async {
    final provider = context.read<PrestamoProvider>();
    await provider.loadLoans();
  }

  List<dynamic> _getFilteredLoans(PrestamoProvider provider) {
    final loans = provider.loans;

    switch (_selectedFilter) {
      case 'activos':
        return loans.where((l) => l.status.name == 'active').toList();
      case 'pagados':
        return loans.where((l) => l.status.name == 'paid').toList();
      default:
        return loans;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Préstamos'), centerTitle: true),
      body: Consumer<PrestamoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingLoans) {
            return const LoadingWidget();
          }

          if (provider.loansError != null) {
            return ErrorWidgetCustom(
              message: provider.loansError!,
              onRetry: _loadPrestamos,
            );
          }

          final filteredLoans = _getFilteredLoans(provider);

          if (filteredLoans.isEmpty) {
            return EmptyState(
              title: 'No tienes préstamos',
              message: 'Tus préstamos aparecerán aquí una vez sean aprobados',
              icon: Icons.account_balance_wallet_outlined,
            );
          }

          return Column(
            children: [
              // Filtros
              _buildFilters(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadPrestamos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredLoans.length,
                    itemBuilder: (context, index) {
                      final loan = filteredLoans[index];
                      return PrestamoCard(
                        prestamo: loan,
                        onTap: () {
                          context.push(
                            RouteNames.detallePrestamoPath(loan.id.toString()),
                          );
                        },
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
            label: 'Activos',
            isSelected: _selectedFilter == 'activos',
            onSelected: () => setState(() => _selectedFilter = 'activos'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pagados',
            isSelected: _selectedFilter == 'pagados',
            onSelected: () => setState(() => _selectedFilter = 'pagados'),
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
