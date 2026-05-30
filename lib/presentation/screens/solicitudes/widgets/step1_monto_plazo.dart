import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class Step1MontoPlazo extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onNext;

  const Step1MontoPlazo({super.key, this.initialData, required this.onNext});

  @override
  State<Step1MontoPlazo> createState() => _Step1MontoPlazoState();
}

class _Step1MontoPlazoState extends State<Step1MontoPlazo> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _termController = TextEditingController();
  final _purposeController = TextEditingController();

  final List<int> _termOptions = [3, 6, 12, 18, 24, 36, 48, 60];
  final List<double> _amountOptions = [
    500,
    1000,
    2000,
    3000,
    5000,
    10000,
    15000,
    20000,
  ];

  double _selectedAmount = 0;
  int _selectedTerm = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _selectedAmount = widget.initialData!['requestedAmount'] ?? 0;
      _selectedTerm = widget.initialData!['requestedTerm'] ?? 0;
      _amountController.text = _selectedAmount > 0
          ? _selectedAmount.toString()
          : '';
      _termController.text = _selectedTerm > 0 ? _selectedTerm.toString() : '';
      _purposeController.text = widget.initialData!['purpose'] ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  double _calculateMonthlyFee() {
    if (_selectedAmount <= 0 || _selectedTerm <= 0) return 0;
    const annualRate = 0.18;
    final monthlyRate = annualRate / 12;
    final factor =
        monthlyRate *
        pow(1 + monthlyRate, _selectedTerm) /
        (pow(1 + monthlyRate, _selectedTerm) - 1);
    return _selectedAmount * factor;
  }

  double _calculateTotalPayment() {
    return _calculateMonthlyFee() * _selectedTerm;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext({
        'requestedAmount': _selectedAmount,
        'requestedTerm': _selectedTerm,
        'purpose': _purposeController.text.trim().isNotEmpty
            ? _purposeController.text.trim()
            : null,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthlyFee = _calculateMonthlyFee();
    final totalPayment = _calculateTotalPayment();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monto solicitado
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '¿Cuánto necesitas?',
                          style: TextStyles.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        prefixText: 'S/ ',
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese el monto';
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 100)
                          return 'Monto mínimo S/ 100';
                        if (amount > 50000) return 'Monto máximo S/ 50,000';
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedAmount = double.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _amountOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, index) {
                        final amount = _amountOptions[index];
                        final isSelected = _selectedAmount == amount;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAmount = amount;
                              _amountController.text = amount.toString();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              'S/ ${amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Plazo
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '¿En cuántos meses pagarás?',
                      style: TextStyles.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _termOptions.map((term) {
                        final isSelected = _selectedTerm == term;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTerm = term;
                              _termController.text = term.toString();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Text(
                              '${term}m',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Estimación
            if (_selectedAmount > 0 && _selectedTerm > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimado referencial (18% anual)',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: 'Cuota mensual',
                            value: 'S/ ${monthlyFee.toStringAsFixed(2)}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InfoCard(
                            label: 'Total a pagar',
                            value: 'S/ ${totalPayment.toStringAsFixed(2)}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InfoCard(
                            label: 'Plazo',
                            value: '$_selectedTerm meses',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Propósito
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Para qué usarás el préstamo? (opcional)',
                      style: TextStyles.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _purposeController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText:
                            'Ej: Compra de equipos, capital de trabajo...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Continuar',
              onPressed: _submit,
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Función de potencia
double pow(double base, int exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
