import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/models/cuota_model.dart';

class CuotaBadge extends StatelessWidget {
  final InstallmentStatus status;
  final bool showIcon;
  final double? customSize;

  const CuotaBadge({
    super.key,
    required this.status,
    this.showIcon = false,
    this.customSize,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final text = _getStatusText();
    final icon = _getStatusIcon();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: customSize != null ? customSize! * 0.5 : 8,
        vertical: customSize != null ? customSize! * 0.25 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          customSize != null ? customSize! : 12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              size: customSize != null ? customSize! * 0.6 : 12,
              color: color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyles.labelSmall.copyWith(
              color: color,
              fontSize: customSize != null ? customSize! * 0.35 : 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.overdue:
        return AppColors.error;
      case InstallmentStatus.pending:
        return AppColors.warning;
      case InstallmentStatus.partiallyPaid:
        return AppColors.info;
      case InstallmentStatus.waived:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText() {
    switch (status) {
      case InstallmentStatus.paid:
        return 'Pagada';
      case InstallmentStatus.overdue:
        return 'Vencida';
      case InstallmentStatus.pending:
        return 'Pendiente';
      case InstallmentStatus.partiallyPaid:
        return 'Parcial';
      case InstallmentStatus.waived:
        return 'Condonada';
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case InstallmentStatus.paid:
        return Icons.check_circle;
      case InstallmentStatus.overdue:
        return Icons.warning_amber;
      case InstallmentStatus.pending:
        return Icons.schedule;
      case InstallmentStatus.partiallyPaid:
        return Icons.hourglass_empty;
      case InstallmentStatus.waived:
        return Icons.remove_circle_outline;
    }
  }
}

// Badge simplificado para usar en listas
class CuotaBadgeSimple extends StatelessWidget {
  final InstallmentStatus status;

  const CuotaBadgeSimple({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final text = _getStatusText();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.overdue:
        return AppColors.error;
      case InstallmentStatus.pending:
        return AppColors.warning;
      case InstallmentStatus.partiallyPaid:
        return AppColors.info;
      case InstallmentStatus.waived:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText() {
    switch (status) {
      case InstallmentStatus.paid:
        return 'Pagada';
      case InstallmentStatus.overdue:
        return 'Vencida';
      case InstallmentStatus.pending:
        return 'Pendiente';
      case InstallmentStatus.partiallyPaid:
        return 'Parcial';
      case InstallmentStatus.waived:
        return 'Condonada';
    }
  }
}

// Badge con tamaño circular para tableros
class CuotaBadgeCircular extends StatelessWidget {
  final InstallmentStatus status;
  final double size;

  const CuotaBadgeCircular({super.key, required this.status, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final icon = _getStatusIcon();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case InstallmentStatus.paid:
        return AppColors.success;
      case InstallmentStatus.overdue:
        return AppColors.error;
      case InstallmentStatus.pending:
        return AppColors.warning;
      case InstallmentStatus.partiallyPaid:
        return AppColors.info;
      case InstallmentStatus.waived:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case InstallmentStatus.paid:
        return Icons.check;
      case InstallmentStatus.overdue:
        return Icons.priority_high;
      case InstallmentStatus.pending:
        return Icons.access_time;
      case InstallmentStatus.partiallyPaid:
        return Icons.payments;
      case InstallmentStatus.waived:
        return Icons.remove;
    }
  }
}
