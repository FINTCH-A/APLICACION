import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class Step4Personal extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrev;

  const Step4Personal({
    super.key,
    this.initialData,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<Step4Personal> createState() => _Step4PersonalState();
}

class _Step4PersonalState extends State<Step4Personal> {
  final _formKey = GlobalKey<FormState>();
  final _childrenController = TextEditingController();

  String _maritalStatus = 'SINGLE';
  String _housingType = 'RENTED';

  final Map<String, String> _maritalLabels = {
    'SINGLE': 'Soltero/a',
    'MARRIED': 'Casado/a',
    'DIVORCED': 'Divorciado/a',
    'WIDOWED': 'Viudo/a',
    'DOMESTIC_PARTNERSHIP': 'Conviviente',
  };

  final Map<String, String> _housingLabels = {
    'OWNED': 'Casa propia',
    'RENTED': 'Alquilada',
    'FAMILY': 'Casa familiar',
    'OTHER': 'Otra',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _maritalStatus = widget.initialData!['maritalStatus'] ?? 'SINGLE';
      _housingType = widget.initialData!['housingType'] ?? 'RENTED';
      _childrenController.text =
          widget.initialData!['numberOfChildren']?.toString() ?? '0';
    }
  }

  @override
  void dispose() {
    _childrenController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext({
        'maritalStatus': _maritalStatus,
        'housingType': _housingType,
        'numberOfChildren': int.parse(_childrenController.text),
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
                          Icons.person_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Información personal',
                          style: TextStyles.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _maritalStatus,
                      decoration: InputDecoration(
                        labelText: 'Estado civil',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _maritalLabels.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _maritalStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _housingType,
                      decoration: InputDecoration(
                        labelText: 'Tipo de vivienda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _housingLabels.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _housingType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _childrenController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número de hijos',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Campo requerido';
                        final num = int.tryParse(value);
                        if (num == null || num < 0)
                          return 'Ingrese un número válido';
                        return null;
                      },
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
}
