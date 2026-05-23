import 'package:flutter/material.dart';
import '../../../../config/theme/text_styles.dart';

class StatsSection extends StatelessWidget {
  final double totalPrestamos;
  final double totalPagado;
  final int prestamosActivos;

  const StatsSection({
    super.key,
    required this.totalPrestamos,
    required this.totalPagado,
    required this.prestamosActivos,
  });

  // Formatter propio: sin intl, sin locale → siempre "S/ 3,000.00"
  static String _fmt(double amount) {
    // Separar entero y decimal
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0]; // ej: "3000"
    final decPart = parts[1]; // ej: "00"

    // Insertar coma cada 3 dígitos desde la derecha
    final buffer = StringBuffer();
    final digits = intPart.replaceAll('-', '');
    final isNegative = amount < 0;
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    return 'S/ ${isNegative ? '-' : ''}$buffer.$decPart';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B6B65), Color(0xFF27BAAE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de tu cuenta',
              style: TextStyles.labelMedium.copyWith(
                color: Colors.white.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.account_balance_wallet_outlined,
                      value: _fmt(totalPrestamos),
                      label: 'Total\nPréstamos',
                    ),
                  ),
                  _Divider(),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.payments_outlined,
                      value: _fmt(totalPagado),
                      label: 'Total Pagado',
                    ),
                  ),
                  _Divider(),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.trending_up_rounded,
                      value: prestamosActivos.toString(),
                      label: 'Préstamos\nActivos',
                      isNumber: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white.withOpacity(0.25),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isNumber;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: isNumber
                  ? const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    )
                  : const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 10,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
