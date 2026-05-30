// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/route_names.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';

import '../../../data/models/prestamo_model.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/prestamo_provider.dart';

import '../../navigation/bottom_nav_bar.dart';

import '../../screens/pagos/pagos_screen.dart';
import '../../screens/perfil/perfil_screen.dart';
import '../../screens/prestamos/prestamos_screen.dart';

import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_widget.dart';

import 'widgets/home_header.dart';
import 'widgets/quick_actions.dart';
import 'widgets/stats_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prestamoProvider = context.read<PrestamoProvider>();

    await Future.wait([
      prestamoProvider.loadLoans(),
      prestamoProvider.loadLoanApplications(status: 'APPROVED'),
    ]);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomeContent(),
          const PrestamosScreen(),
          const PagosScreen(),
          const PerfilScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  // ═════════════════════════════════════════════════════
  // HOME CONTENT
  // ═════════════════════════════════════════════════════

  Widget _buildHomeContent() {
    return Consumer2<AuthProvider, PrestamoProvider>(
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

        final user = authProvider.currentUser;

        final totalPrestamos = prestamoProvider.loans.fold<double>(
          0,
          (sum, loan) => sum + loan.approvedAmount,
        );

        final prestamosActivos = prestamoProvider.loans
            .where((loan) => loan.status == LoanStatus.active)
            .length;

        final prestamosPendientes = prestamoProvider.loans
            .where((loan) => loan.status == LoanStatus.pending)
            .length;

        return RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeHeader(),
                    const SizedBox(height: 16),
                    StatsSection(
                      totalPrestamos: totalPrestamos,
                      totalPagado: 0,
                      prestamosActivos: prestamosActivos,
                    ),
                    const SizedBox(height: 18),
                    _buildHeroBanner(),
                    const SizedBox(height: 24),
                    const QuickActions(),
                    const SizedBox(height: 28),
                    _buildResumeCards(
                      activos: prestamosActivos,
                      pendientes: prestamosPendientes,
                    ),
                    const SizedBox(height: 26),
                    _buildLoanSection(prestamoProvider),
                    const SizedBox(height: 24),
                    _buildSecuritySection(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════
  // HERO BANNER
  // ═════════════════════════════════════════════════════

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF062B30), Color(0xFF0E4B4F), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.flash_on_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '100% Digital',
                        style: TextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Obtén tu préstamo\nrápido y seguro',
                  style: TextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Solicita créditos desde tu celular y recibe respuesta en minutos.',
                  style: TextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.82),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(RouteNames.nuevaSolicitud);
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Solicitar préstamo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: TextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════
  // RESUME CARDS
  // ═════════════════════════════════════════════════════

  Widget _buildResumeCards({required int activos, required int pendientes}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _MiniResumeCard(
              title: 'Activos',
              value: '$activos',
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MiniResumeCard(
              title: 'Pendientes',
              value: '$pendientes',
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════
  // LOAN SECTION
  // ═════════════════════════════════════════════════════

  Widget _buildLoanSection(PrestamoProvider prestamoProvider) {
    final loans = prestamoProvider.loans.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mis préstamos',
                  style: TextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _goToPage(1),
                child: Text(
                  'Ver todos',
                  style: TextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (loans.isEmpty)
            _buildEmptyLoans()
          else
            ...loans.map((loan) => _LoanCard(loan: loan)),
        ],
      ),
    );
  }

  Widget _buildEmptyLoans() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: 40,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No tienes préstamos activos',
            style: TextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Solicita un préstamo y comienza a disfrutar de nuestros beneficios.',
            textAlign: TextAlign.center,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.push(RouteNames.nuevaSolicitud);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Solicitar préstamo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════
  // SECURITY SECTION
  // ═════════════════════════════════════════════════════

  Widget _buildSecuritySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu seguridad es nuestra prioridad',
                  style: TextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Protegemos tus datos y transacciones con estándares avanzados de seguridad y cifrado.',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
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

// ═════════════════════════════════════════════════════
// MINI RESUME CARD
// ═════════════════════════════════════════════════════

class _MiniResumeCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniResumeCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
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

// ═════════════════════════════════════════════════════
// LOAN CARD (CORREGIDO)
// ═════════════════════════════════════════════════════

class _LoanCard extends StatelessWidget {
  final LoanModel loan;

  const _LoanCard({required this.loan});

  Color _getStatusColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.active:
        return AppColors.success;
      case LoanStatus.pending:
        return AppColors.warning;
      case LoanStatus.paid:
        return AppColors.info;
      case LoanStatus.approved:
        return AppColors.primary;
      case LoanStatus.rejected:
        return AppColors.error;
      case LoanStatus.defaulted:
        return AppColors.error;
      case LoanStatus.cancelled:
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
      case LoanStatus.approved:
        return 'Aprobado';
      case LoanStatus.rejected:
        return 'Rechazado';
      case LoanStatus.defaulted:
        return 'Incumplido';
      case LoanStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _formatCurrency(double amount) {
    return 'S/ ${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(loan.status);

    return GestureDetector(
      onTap: () {
        // CORREGIDO: Usar la ruta correcta con RouteNames
        context.push(RouteNames.detallePrestamoPath(loan.id.toString()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: statusColor.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: statusColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Préstamo #${loan.loanCode}',
                    style: TextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatCurrency(loan.approvedAmount),
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _getStatusText(loan.status),
                    style: TextStyles.labelMedium.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
