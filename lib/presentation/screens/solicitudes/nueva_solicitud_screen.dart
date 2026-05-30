// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../data/models/solicitud_model.dart';
import '../../../data/providers/prestamo_provider.dart';
import '../../widgets/common/loading_widget.dart';
import 'widgets/step1_monto_plazo.dart';
import 'widgets/step2_direccion.dart';
import 'widgets/step3_laboral.dart';
import 'widgets/step4_personal.dart';
import 'widgets/step5_pago.dart';
import 'widgets/step6_confirmar.dart';
import 'widgets/step_success.dart';

class NuevaSolicitudScreen extends StatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  State<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends State<NuevaSolicitudScreen> {
  int _currentStep = 1;
  bool _isSubmitting = false;
  bool _success = false;
  int? _applicationId;

  // Datos del wizard
  final Map<String, dynamic> _formData = {
    'step1': null,
    'step2': null,
    'step3': null,
    'step4': null,
    'step5': null,
  };

  final List<String> _stepTitles = [
    'Monto y plazo',
    'Dirección',
    'Situación laboral',
    'Información personal',
    'Datos de pago',
    'Confirmar',
  ];

  void _saveStep1(Map<String, dynamic> data) {
    setState(() {
      _formData['step1'] = data;
      _currentStep = 2;
    });
  }

  void _saveStep2(Map<String, dynamic> data) {
    setState(() {
      _formData['step2'] = data;
      _currentStep = 3;
    });
  }

  void _saveStep3(Map<String, dynamic> data) {
    setState(() {
      _formData['step3'] = data;
      _currentStep = 4;
    });
  }

  void _saveStep4(Map<String, dynamic> data) {
    setState(() {
      _formData['step4'] = data;
      _currentStep = 5;
    });
  }

  void _saveStep5(Map<String, dynamic> data) {
    setState(() {
      _formData['step5'] = data;
      _currentStep = 6;
    });
  }

  void _goToPreviousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitApplication() async {
    setState(() {
      _isSubmitting = true;
    });

    final step1 = _formData['step1'] as Map<String, dynamic>;

    // 1. Crear DTO solo con los campos que el backend espera
    final createDto = CreateLoanApplicationDto(
      requestedAmount: step1['requestedAmount'].toDouble(),
      requestedTerm: step1['requestedTerm'] as int,
      purpose: step1['purpose'] as String?,
    );

    final prestamoProvider = context.read<PrestamoProvider>();

    // 2. Crear la solicitud (estado DRAFT)
    final createSuccess = await prestamoProvider.createLoanApplication(
      createDto,
    );

    if (!createSuccess && mounted) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            prestamoProvider.applicationsError ?? 'Error al crear la solicitud',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // 3. Obtener el ID de la solicitud creada
    final applicationId = prestamoProvider.currentApplication?.id;

    if (applicationId == null) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se pudo obtener el ID de la solicitud'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // 4. Enviar la solicitud (cambiar de DRAFT a SUBMITTED)
    final submitSuccess = await prestamoProvider.submitLoanApplication(
      applicationId,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (submitSuccess && mounted) {
      setState(() {
        _success = true;
        _applicationId = applicationId;
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            prestamoProvider.applicationsError ??
                'Error al enviar la solicitud',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  double get _progress => ((_currentStep - 1) / 6) * 100;

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return StepSuccess(applicationId: _applicationId);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nueva Solicitud'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isSubmitting
          ? const LoadingWidget(message: 'Enviando solicitud...')
          : Column(
              children: [
                // Progress bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Paso $_currentStep de 6',
                            style: TextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            _stepTitles[_currentStep - 1],
                            style: TextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _progress / 100,
                        backgroundColor: AppColors.surfaceVariant,
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildCurrentStep(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return Step1MontoPlazo(
          key: const ValueKey('step1'),
          initialData: _formData['step1'],
          onNext: _saveStep1,
        );
      case 2:
        return Step2Direccion(
          key: const ValueKey('step2'),
          initialData: _formData['step2'],
          onNext: _saveStep2,
          onPrev: _goToPreviousStep,
        );
      case 3:
        return Step3Laboral(
          key: const ValueKey('step3'),
          initialData: _formData['step3'],
          onNext: _saveStep3,
          onPrev: _goToPreviousStep,
        );
      case 4:
        return Step4Personal(
          key: const ValueKey('step4'),
          initialData: _formData['step4'],
          onNext: _saveStep4,
          onPrev: _goToPreviousStep,
        );
      case 5:
        return Step5Pago(
          key: const ValueKey('step5'),
          initialData: _formData['step5'],
          onNext: _saveStep5,
          onPrev: _goToPreviousStep,
        );
      case 6:
        return Step6Confirmar(
          key: const ValueKey('step6'),
          formData: _formData,
          onSubmit: _submitApplication,
          onPrev: _goToPreviousStep,
          isLoading: _isSubmitting,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
