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
          child: Text(
            '¿Qué deseas hacer?',
            style: TextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Primera acción destacada (fondo verde)
              _ActionButton(
                icon: Icons.add,
                label: 'Nueva\nSolicitud',
                color: Colors.white,
                backgroundColor: AppColors.primary,
                isHighlighted: true,
                onTap: () => context.push(RouteNames.nuevaSolicitud),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.payments_outlined,
                  label: 'Pagar\nCuota',
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onTap: () => context.push(RouteNames.pagos),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.receipt_long_outlined,
                  label: 'Mis\nPréstamos',
                  color: AppColors.accent,
                  backgroundColor: AppColors.surface,
                  onTap: () => context.push(RouteNames.prestamos),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.verified_user_outlined,
                  label: 'Seguridad\ny tips',
                  color: AppColors.secondary,
                  backgroundColor: AppColors.surface,
                  onTap: () => _showSecurityTips(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSecurityTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Consejos de Seguridad'),
        backgroundColor: AppColors.surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTip('🔐', 'No compartas tu contraseña con nadie'),
            const SizedBox(height: 8),
            _buildTip('📱', 'Activa la verificación en dos pasos'),
            const SizedBox(height: 8),
            _buildTip('⚠️', 'Desconfía de enlaces sospechosos'),
            const SizedBox(height: 8),
            _buildTip('🔄', 'Cambia tu contraseña periódicamente'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    // El botón destacado tiene ancho fijo más grande
    final Widget content = GestureDetector(
      onTap: onTap,
      child: Container(
        width: isHighlighted ? 80 : null,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isHighlighted ? 12 : 10),
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Colors.white.withOpacity(0.2)
                    : color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: isHighlighted ? 26 : 22, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyles.labelSmall.copyWith(
                color: isHighlighted ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return isHighlighted ? content : content;
  }
}
