// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/pago_model.dart';
import '../../../data/providers/pago_provider.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';

class RegistrarPagoScreen extends StatefulWidget {
  final String prestamoId;
  const RegistrarPagoScreen({super.key, required this.prestamoId});

  @override
  State<RegistrarPagoScreen> createState() => _RegistrarPagoScreenState();
}

class _RegistrarPagoScreenState extends State<RegistrarPagoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedPaymentMethod = 'Yape';
  bool _isSubmitting = false;

  final List<String> _paymentMethods = [
    'Yape',
    'Plin',
    'Transferencia Bancaria',
    'Efectivo',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitPago() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final dto = CreatePaymentDto(
      loanId: int.parse(widget.prestamoId),
      amount: double.parse(_amountController.text),
      reference: _referenceController.text,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    final pagoProvider = context.read<PagoProvider>();
    final success = await pagoProvider.createPayment(dto);

    setState(() {
      _isSubmitting = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pago registrado exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else if (mounted && pagoProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pagoProvider.error!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Pago'), centerTitle: true),
      body: _isSubmitting
          ? const LoadingWidget(message: 'Procesando pago...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Método de pago
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        decoration: const InputDecoration(
                          labelText: 'Método de pago',
                          prefixIcon: Icon(Icons.credit_card),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: _paymentMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Monto
                    CustomTextField(
                      label: 'Monto a pagar (S/)',
                      hint: '0.00',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el monto';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Monto inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Referencia
                    CustomTextField(
                      label: 'Referencia',
                      hint: 'Número de operación o voucher',
                      controller: _referenceController,
                      prefixIcon: Icons.receipt_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la referencia';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notas
                    CustomTextField(
                      label: 'Notas (opcional)',
                      hint: 'Información adicional sobre el pago',
                      controller: _notesController,
                      maxLines: 3,
                      prefixIcon: Icons.description_outlined,
                    ),
                    const SizedBox(height: 24),

                    // Información importante
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: AppColors.info,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Información importante',
                                style: TextStyles.labelMedium.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• El pago será verificado por nuestro equipo\n'
                            '• La actualización de tu cuota puede tomar hasta 24 horas\n'
                            '• Guarda tu voucher como comprobante',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón de registrar
                    CustomButton(
                      text: 'Registrar Pago',
                      onPressed: _submitPago,
                      icon: Icons.payment,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
