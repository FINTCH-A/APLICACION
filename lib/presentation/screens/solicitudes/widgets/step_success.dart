import 'package:aplicacion_avante/config/routes/route_names.dart';
import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StepSuccess extends StatelessWidget {
  final int? applicationId;

  const StepSuccess({super.key, this.applicationId});

  String _generateApplicationNumber() {
    final random = DateTime.now().millisecondsSinceEpoch.toString().substring(
      8,
    );
    return 'SOL-${applicationId ?? 'XX'}-$random';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de éxito
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '¡Solicitud enviada!',
                style: TextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Tu solicitud ha sido registrada con éxito. En breve recibirás una respuesta.',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'N° de solicitud:',
                      value: _generateApplicationNumber(),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Estado:',
                      value: 'En evaluación',
                      valueColor: AppColors.warning,
                      valueIcon: Icons.hourglass_empty,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nuestro equipo evaluará tu solicitud en las próximas 24-48 horas. Te notificaremos por correo electrónico y SMS cuando haya una respuesta.',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Ver mis préstamos',
                      onPressed: () {
                        context.go(RouteNames.prestamos);
                      },
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Ir al inicio',
                      onPressed: () {
                        context.go(RouteNames.home);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? valueIcon;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Row(
          children: [
            if (valueIcon != null) ...[
              Icon(
                valueIcon,
                size: 14,
                color: valueColor ?? AppColors.textPrimary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
