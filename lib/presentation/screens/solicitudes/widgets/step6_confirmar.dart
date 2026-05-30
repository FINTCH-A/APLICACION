import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class Step6Confirmar extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onSubmit;
  final VoidCallback onPrev;
  final bool isLoading;

  const Step6Confirmar({
    super.key,
    required this.formData,
    required this.onSubmit,
    required this.onPrev,
    this.isLoading = false,
  });

  String _formatCurrency(double amount) {
    return 'S/ ${amount.toStringAsFixed(2)}';
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final step1 = formData['step1'] as Map<String, dynamic>;
    final step2 = formData['step2'] as Map<String, dynamic>;
    final step3 = formData['step3'] as Map<String, dynamic>;
    final step4 = formData['step4'] as Map<String, dynamic>;
    final step5 = formData['step5'] as Map<String, dynamic>;

    final amount = step1['requestedAmount'] as double;
    final term = step1['requestedTerm'] as int;
    final monthlyFee = _calculateMonthlyFee(amount, term);
    final totalPayment = monthlyFee * term;
    final disposableIncome =
        (step3['monthlyIncome'] as double) -
        (step3['monthlyExpenses'] as double);
    final debtToIncomeRatio =
        (monthlyFee / (step3['monthlyIncome'] as double)) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Resumen del préstamo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONTO SOLICITADO',
                            style: TextStyles.labelSmall,
                          ),
                          Text(
                            _formatCurrency(amount),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('CUOTA MENSUAL', style: TextStyles.labelSmall),
                          Text(
                            _formatCurrency(monthlyFee),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Plazo', style: TextStyles.labelSmall),
                          Text(
                            '$term meses',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Total a pagar', style: TextStyles.labelSmall),
                          Text(
                            _formatCurrency(totalPayment),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Detalle del préstamo
          _SectionCard(
            icon: Icons.receipt,
            title: 'Detalle del préstamo',
            children: [
              _DetailRow(
                'Finalidad:',
                step1['purpose'] != null &&
                        step1['purpose'].toString().isNotEmpty
                    ? _truncateText(step1['purpose'], 35)
                    : 'No especificada',
              ),
              _DetailRow('TEA:', '18% anual'),
              _DetailRow(
                'Capacidad de pago:',
                '${debtToIncomeRatio.toStringAsFixed(1)}% de ingresos',
                color: debtToIncomeRatio <= 30
                    ? AppColors.success
                    : (debtToIncomeRatio <= 50
                          ? AppColors.warning
                          : AppColors.error),
              ),
            ],
          ),

          // Dirección
          _SectionCard(
            icon: Icons.location_on,
            title: 'Dirección',
            children: [
              Text(
                step2['streetAddress'] != null
                    ? _truncateText(step2['streetAddress'], 45)
                    : '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                step2['district'] != null &&
                        step2['city'] != null &&
                        step2['department'] != null
                    ? _truncateText(
                        '${step2['district']}, ${step2['city']} - ${step2['department']}',
                        50,
                      )
                    : '',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),

          // Situación laboral
          _SectionCard(
            icon: Icons.work,
            title: 'Situación laboral',
            children: [
              _DetailRow(
                'Situación:',
                _getEmploymentLabel(step3['employmentStatus']),
              ),
              _DetailRow(
                'Ingresos mensuales:',
                _formatCurrency(step3['monthlyIncome']),
              ),
              _DetailRow(
                'Gastos mensuales:',
                _formatCurrency(step3['monthlyExpenses']),
              ),
              _DetailRow(
                'Capacidad residual:',
                _formatCurrency(disposableIncome),
                color: AppColors.success,
              ),
            ],
          ),

          // Información personal
          _SectionCard(
            icon: Icons.person,
            title: 'Información personal',
            children: [
              _DetailRow(
                'Estado civil:',
                _getMaritalLabel(step4['maritalStatus']),
              ),
              _DetailRow('Hijos:', step4['numberOfChildren'].toString()),
              _DetailRow('Vivienda:', _getHousingLabel(step4['housingType'])),
            ],
          ),

          // Datos de pago
          _SectionCard(
            icon: Icons.credit_card,
            title: 'Datos de pago',
            children: [
              _DetailRow(
                'Tipo:',
                step5['type'] == 'DIGITAL_WALLET'
                    ? 'Billetera digital'
                    : 'Cuenta bancaria',
              ),
              _DetailRow('Proveedor:', step5['provider']),
              _DetailRow(
                'Número:',
                _truncateText(step5['accountNumber'] ?? '', 20),
              ),
              _DetailRow(
                'Titular:',
                _truncateText(step5['accountHolder'] ?? '', 28),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Atrás',
                  onPressed: onPrev,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: isLoading ? 'Enviando...' : 'Confirmar solicitud',
                  onPressed: isLoading ? null : onSubmit,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  double _calculateMonthlyFee(double amount, int term) {
    const annualRate = 0.18;
    final monthlyRate = annualRate / 12;
    final factor =
        monthlyRate *
        _pow(1 + monthlyRate, term) /
        (_pow(1 + monthlyRate, term) - 1);
    return amount * factor;
  }

  double _pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  String _getEmploymentLabel(String key) {
    const labels = {
      'EMPLOYED': 'Empleado',
      'SELF_EMPLOYED': 'Independiente',
      'UNEMPLOYED': 'Desempleado',
      'RETIRED': 'Jubilado/Pensionista',
      'STUDENT': 'Estudiante',
    };
    return labels[key] ?? key;
  }

  String _getMaritalLabel(String key) {
    const labels = {
      'SINGLE': 'Soltero/a',
      'MARRIED': 'Casado/a',
      'DIVORCED': 'Divorciado/a',
      'WIDOWED': 'Viudo/a',
      'DOMESTIC_PARTNERSHIP': 'Conviviente',
    };
    return labels[key] ?? key;
  }

  String _getHousingLabel(String key) {
    const labels = {
      'OWNED': 'Casa propia',
      'RENTED': 'Alquilada',
      'FAMILY': 'Casa familiar',
      'OTHER': 'Otra',
    };
    return labels[key] ?? key;
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: TextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _DetailRow(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color ?? AppColors.textPrimary,
                fontSize: 13,
              ),
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
