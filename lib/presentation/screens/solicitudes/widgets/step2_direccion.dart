import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class Step2Direccion extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrev;

  const Step2Direccion({
    super.key,
    this.initialData,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<Step2Direccion> createState() => _Step2DireccionState();
}

class _Step2DireccionState extends State<Step2Direccion> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _departmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _streetController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _countryController.text = widget.initialData!['country'] ?? '';
      _departmentController.text = widget.initialData!['department'] ?? '';
      _cityController.text = widget.initialData!['city'] ?? '';
      _districtController.text = widget.initialData!['district'] ?? '';
      _streetController.text = widget.initialData!['streetAddress'] ?? '';
      _postalCodeController.text = widget.initialData!['postalCode'] ?? '';
    } else {
      _countryController.text = 'Perú';
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    _departmentController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext({
        'country': _countryController.text.trim(),
        'department': _departmentController.text.trim(),
        'city': _cityController.text.trim(),
        'district': _districtController.text.trim(),
        'streetAddress': _streetController.text.trim(),
        'postalCode': _postalCodeController.text.trim().isEmpty
            ? null
            : _postalCodeController.text.trim(),
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
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tu dirección actual',
                          style: TextStyles.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('País', _countryController, enabled: false),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Departamento',
                            _departmentController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('Ciudad', _cityController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('Distrito', _districtController),
                    const SizedBox(height: 12),
                    _buildTextField('Dirección completa', _streetController),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Código postal (opcional)',
                      _postalCodeController,
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (!enabled) return null;
        if (value == null || value.isEmpty) return '$label es requerido';
        return null;
      },
    );
  }
}
