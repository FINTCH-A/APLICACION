import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../config/routes/route_names.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Acciones Rápidas', style: TextStyles.titleMedium),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _ActionCard(
                icon: Icons.add_circle_outline,
                label: 'Nueva\nSolicitud',
                color: AppColors.primary,
                onTap: () => context.push(RouteNames.nuevaSolicitud),
              ),
              _ActionCard(
                icon: Icons.payments_outlined,
                label: 'Pagar\nCuota',
                color: AppColors.success,
                onTap: () => context.push(RouteNames.pagos),
              ),
              _ActionCard(
                icon: Icons.receipt_outlined,
                label: 'Mis\nPréstamos',
                color: AppColors.accent,
                onTap: () => context.push(RouteNames.prestamos),
              ),
              _ActionCard(
                icon: Icons.support_agent_outlined,
                label: 'Soporte',
                color: AppColors.info,
                onTap: () {
                  // TODO: Abrir soporte
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyles.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
