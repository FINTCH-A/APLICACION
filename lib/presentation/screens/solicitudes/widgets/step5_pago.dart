import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:aplicacion_avante/config/theme/text_styles.dart';
import 'package:aplicacion_avante/presentation/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';

class Step5Pago extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onPrev;

  const Step5Pago({
    super.key,
    this.initialData,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<Step5Pago> createState() => _Step5PagoState();
}

class _Step5PagoState extends State<Step5Pago> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();

  String _paymentType = '';
  String _provider = '';

  final Map<String, List<Map<String, String>>> _providers = {
    'DIGITAL_WALLET': [
      {'value': 'YAPE', 'label': 'Yape'},
      {'value': 'PLIN', 'label': 'Plin'},
      {'value': 'TUNKI', 'label': 'Tunki'},
    ],
    'BANK_ACCOUNT': [
      {'value': 'BCP', 'label': 'BCP'},
      {'value': 'BBVA', 'label': 'BBVA'},
      {'value': 'INTERBANK', 'label': 'Interbank'},
      {'value': 'SCOTIABANK', 'label': 'Scotiabank'},
      {'value': 'BANCO_DE_LA_NACION', 'label': 'Banco de la Nación'},
    ],
  };

  List<Map<String, String>> get _currentProviders {
    if (_paymentType == 'DIGITAL_WALLET') return _providers['DIGITAL_WALLET']!;
    if (_paymentType == 'BANK_ACCOUNT') return _providers['BANK_ACCOUNT']!;
    return [];
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _paymentType = widget.initialData!['type'] ?? '';
      _provider = widget.initialData!['provider'] ?? '';
      _accountNumberController.text =
          widget.initialData!['accountNumber'] ?? '';
      _accountHolderController.text =
          widget.initialData!['accountHolder'] ?? '';
    }
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext({
        'type': _paymentType,
        'provider': _provider,
        'accountNumber': _accountNumberController.text.trim(),
        'accountHolder': _accountHolderController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
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
                          Icons.credit_card,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '¿Cómo quieres recibir el dinero?',
                          style: TextStyles.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeCard(
                            'Billetera digital',
                            Icons.qr_code,
                            'DIGITAL_WALLET',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTypeCard(
                            'Cuenta bancaria',
                            Icons.account_balance,
                            'BANK_ACCOUNT',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_paymentType.isNotEmpty) ...[
                      DropdownButtonFormField<String>(
                        value: _provider.isNotEmpty ? _provider : null,
                        decoration: InputDecoration(
                          labelText: 'Proveedor',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _currentProviders.map((p) {
                          return DropdownMenuItem(
                            value: p['value'],
                            child: Text(p['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _provider = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Seleccione un proveedor';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _accountNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: _paymentType == 'DIGITAL_WALLET'
                              ? 'Número de teléfono'
                              : 'Número de cuenta',
                          hintText: _paymentType == 'DIGITAL_WALLET'
                              ? 'Ej: 987654321'
                              : 'Ej: 1234-5678-9012-3456',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Campo requerido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _accountHolderController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del titular',
                          hintText: 'Como aparece en tu documento',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Campo requerido';
                          return null;
                        },
                      ),
                    ],
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
            const SizedBox(height: 20), // Espacio extra al final
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(String title, IconData icon, String type) {
    final isSelected = _paymentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentType = type;
          _provider = '';
          _accountNumberController.clear();
          _accountHolderController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
