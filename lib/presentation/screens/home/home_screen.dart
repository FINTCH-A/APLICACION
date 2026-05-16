import 'package:aplicacion_avante/data/models/prestamo_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../navigation/bottom_nav_bar.dart';
import 'widgets/home_header.dart';
import 'widgets/stats_section.dart';
import 'widgets/quick_actions.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Usar WidgetsBinding para asegurar que el contexto esté disponible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final prestamoProvider = context.read<PrestamoProvider>();
    await Future.wait([
      prestamoProvider.loadLoans(),
      prestamoProvider.loadLoanApplications(status: 'APPROVED'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, PrestamoProvider>(
        builder: (context, authProvider, prestamoProvider, child) {
          if (prestamoProvider.isLoadingLoans) {
            return const LoadingWidget(fullScreen: true);
          }

          if (prestamoProvider.loansError != null) {
            return ErrorWidgetCustom(
              message: prestamoProvider.loansError!,
              onRetry: _loadData,
            );
          }

          // Calcular estadísticas
          final totalPrestamos = prestamoProvider.loans.fold<double>(
            0,
            (sum, loan) => sum + loan.totalAmount,
          );

          // TODO: Calcular total pagado desde los pagos
          final totalPagado = 0.0;

          final prestamosActivos = prestamoProvider.loans
              .where((loan) => loan.status.name == 'active')
              .length;

          return RefreshIndicator(
            onRefresh: _loadData,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeHeader(),
                      const SizedBox(height: 8),
                      StatsSection(
                        totalPrestamos: totalPrestamos,
                        totalPagado: totalPagado,
                        prestamosActivos: prestamosActivos,
                      ),
                      const SizedBox(height: 16),
                      const QuickActions(),
                      const SizedBox(height: 24),
                      _buildRecentLoansSection(prestamoProvider),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: Navegar a otras pantallas
        },
      ),
    );
  }

  Widget _buildRecentLoansSection(PrestamoProvider provider) {
    final loans = provider.loans.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Préstamos Recientes',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navegar a todos los préstamos
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (loans.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 48,
                    color: AppColors.textDisabled,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No tienes préstamos activos',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navegar a solicitar préstamo
                    },
                    child: const Text('Solicitar Préstamo'),
                  ),
                ],
              ),
            )
          else
            ...loans.map((loan) => _LoanCard(loan: loan)),
        ],
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final dynamic loan;

  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Préstamo #${loan.loanCode}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Monto: S/ ${loan.approvedAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(loan.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatusText(loan.status),
              style: TextStyle(
                fontSize: 12,
                color: _getStatusColor(loan.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.active:
        return AppColors.success;
      case LoanStatus.pending:
        return AppColors.warning;
      case LoanStatus.paid:
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(LoanStatus status) {
    switch (status) {
      case LoanStatus.active:
        return 'Activo';
      case LoanStatus.pending:
        return 'Pendiente';
      case LoanStatus.paid:
        return 'Pagado';
      default:
        return 'Desconocido';
    }
  }
}
