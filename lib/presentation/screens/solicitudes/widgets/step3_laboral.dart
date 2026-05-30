import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class Step3Laboral extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrev;

  const Step3Laboral({
    super.key,
    this.initialData,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<Step3Laboral> createState() => _Step3LaboralState();
}

class _Step3LaboralState extends State<Step3Laboral> {
  final _formKey = GlobalKey<FormState>();
  final _employerController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  final _dependentsController = TextEditingController();
  final _otherIncomeController = TextEditingController();

  String _employmentStatus = 'EMPLOYED';

  final Map<String, String> _employmentLabels = {
    'EMPLOYED': 'Empleado',
    'SELF_EMPLOYED': 'Independiente',
    'UNEMPLOYED': 'Desempleado',
    'RETIRED': 'Jubilado/Pensionista',
    'STUDENT': 'Estudiante',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _employmentStatus = widget.initialData!['employmentStatus'] ?? 'EMPLOYED';
      _employerController.text = widget.initialData!['employerName'] ?? '';
      _incomeController.text =
          widget.initialData!['monthlyIncome']?.toString() ?? '';
      _expensesController.text =
          widget.initialData!['monthlyExpenses']?.toString() ?? '';
      _dependentsController.text =
          widget.initialData!['numberOfDependents']?.toString() ?? '0';
      _otherIncomeController.text =
          widget.initialData!['otherIncomeSources']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _employerController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    _dependentsController.dispose();
    _otherIncomeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext({
        'employmentStatus': _employmentStatus,
        'employerName': _employerController.text.trim().isEmpty
            ? null
            : _employerController.text.trim(),
        'monthlyIncome': double.parse(_incomeController.text),
        'monthlyExpenses': double.parse(_expensesController.text),
        'numberOfDependents': int.parse(_dependentsController.text),
        'otherIncomeSources': _otherIncomeController.text.trim().isEmpty
            ? null
            : double.parse(_otherIncomeController.text),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Situación laboral e ingresos',
                          style: TextStyles.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _employmentStatus,
                      decoration: InputDecoration(
                        labelText: 'Situación laboral',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _employmentLabels.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _employmentStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Empresa / Negocio (opcional)',
                      _employerController,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            'Ingresos mensuales (S/)',
                            _incomeController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            'Gastos mensuales (S/)',
                            _expensesController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            'N° dependientes',
                            _dependentsController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            'Otros ingresos (S/)',
                            _otherIncomeController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Atrás',
                    onPressed: widget.onPrev,
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Continuar',
                    onPressed: _submit,
                    icon: Icons.arrow_forward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (label.contains('dependientes') &&
            value != null &&
            value.isNotEmpty) {
          final num = int.tryParse(value);
          if (num != null && num < 0) return 'No puede ser negativo';
        }
        if (value == null || value.isEmpty) return '$label es requerido';
        final number = double.tryParse(value);
        if (number == null || number < 0) return 'Ingrese un valor válido';
        return null;
      },
    );
  }
}
