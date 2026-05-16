// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../data/models/solicitud_model.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/loading_widget.dart';

class NuevaSolicitudScreen extends StatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  State<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends State<NuevaSolicitudScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _termController = TextEditingController();
  final _purposeController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _submitSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final dto = CreateLoanApplicationDto(
      requestedAmount: double.parse(_amountController.text),
      requestedTerm: int.parse(_termController.text),
      purpose: _purposeController.text.isNotEmpty
          ? _purposeController.text
          : null,
    );

    final prestamoProvider = context.read<PrestamoProvider>();
    final success = await prestamoProvider.createLoanApplication(dto);

    setState(() {
      _isSubmitting = false;
    });

    if (success && mounted) {
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud creada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    } else if (mounted && prestamoProvider.applicationsError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(prestamoProvider.applicationsError!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Solicitud'), centerTitle: true),
      body: _isSubmitting
          ? const LoadingWidget(message: 'Creando solicitud...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Monto solicitado
                    CustomTextField(
                      label: 'Monto Solicitado (S/)',
                      hint: '1000',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.attach_money,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el monto solicitado';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount < 100) {
                          return 'El monto mínimo es S/ 100';
                        }
                        if (amount > 50000) {
                          return 'El monto máximo es S/ 50,000';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Plazo solicitado
                    CustomTextField(
                      label: 'Plazo (meses)',
                      hint: '12',
                      controller: _termController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.calendar_month,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese el plazo';
                        }
                        final term = int.tryParse(value);
                        if (term == null || term < 3) {
                          return 'El plazo mínimo es 3 meses';
                        }
                        if (term > 60) {
                          return 'El plazo máximo es 60 meses';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Propósito
                    CustomTextField(
                      label: 'Propósito (opcional)',
                      hint: 'Describe el motivo del préstamo',
                      controller: _purposeController,
                      maxLines: 3,
                      prefixIcon: Icons.description_outlined,
                    ),
                    const SizedBox(height: 24),

                    // Información adicional
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
                            '• Monto mínimo: S/ 100\n'
                            '• Monto máximo: S/ 50,000\n'
                            '• Plazo mínimo: 3 meses\n'
                            '• Plazo máximo: 60 meses\n'
                            '• La solicitud será revisada por un analista\n'
                            '• Recibirás notificación por correo y en la app',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón de enviar
                    CustomButton(
                      text: 'Enviar Solicitud',
                      onPressed: _submitSolicitud,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
