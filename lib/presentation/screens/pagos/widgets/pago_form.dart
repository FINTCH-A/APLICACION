import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/models/pago_model.dart';
import '../../../../data/providers/pago_provider.dart';
import '../../../../data/providers/prestamo_provider.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_text_field.dart';
import '../../../widgets/common/loading_widget.dart';

class PagoForm extends StatefulWidget {
  final int? prestamoId;
  final int? cuotaId;
  final double? montoSugerido;

  const PagoForm({
    super.key,
    this.prestamoId,
    this.cuotaId,
    this.montoSugerido,
  });

  @override
  State<PagoForm> createState() => _PagoFormState();
}

class _PagoFormState extends State<PagoForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedPaymentMethod;
  bool _isSubmitting = false;
  bool _isLoadingPrestamos = false;
  int? _selectedPrestamoId;
  List<dynamic> _prestamosActivos = [];

  final List<Map<String, dynamic>> _paymentMethods = [
    {'value': 'yape', 'label': 'Yape', 'icon': Icons.phone_android},
    {'value': 'plin', 'label': 'Plin', 'icon': Icons.phone_iphone},
    {
      'value': 'transfer',
      'label': 'Transferencia Bancaria',
      'icon': Icons.account_balance,
    },
    {'value': 'cash', 'label': 'Efectivo', 'icon': Icons.money},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPrestamoId = widget.prestamoId;
    if (widget.montoSugerido != null) {
      _amountController.text = widget.montoSugerido!.toStringAsFixed(2);
    }
    _selectedPaymentMethod = _paymentMethods.first['value'];

    if (widget.prestamoId == null) {
      _loadPrestamosActivos();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadPrestamosActivos() async {
    setState(() {
      _isLoadingPrestamos = true;
    });

    final provider = context.read<PrestamoProvider>();
    await provider.loadLoans(status: 'active');

    setState(() {
      _prestamosActivos = provider.loans;
      _isLoadingPrestamos = false;
      if (_prestamosActivos.isNotEmpty && _selectedPrestamoId == null) {
        _selectedPrestamoId = _prestamosActivos.first.id;
      }
    });
  }

  Future<void> _submitPago() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPrestamoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Seleccione un préstamo')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final dto = CreatePaymentDto(
      loanId: _selectedPrestamoId!,
      installmentId: widget.cuotaId,
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
      Navigator.pop(context, true);
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
    return _isSubmitting
        ? const LoadingWidget(message: 'Procesando pago...')
        : Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selección de préstamo (si no viene por parámetro)
                if (widget.prestamoId == null) ...[
                  _buildPrestamoSelector(),
                  const SizedBox(height: 16),
                ],

                // Método de pago
                _buildPaymentMethodSelector(),
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
                    if (widget.montoSugerido != null &&
                        amount > widget.montoSugerido!) {
                      return 'El monto no puede superar el saldo pendiente';
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
                  validator: Validators.required,
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
                _buildInfoBox(),
                const SizedBox(height: 24),

                // Botón de registrar
                CustomButton(
                  text: 'Registrar Pago',
                  onPressed: _submitPago,
                  icon: Icons.payment,
                ),
              ],
            ),
          );
  }

  Widget _buildPrestamoSelector() {
    if (_isLoadingPrestamos) {
      return const LoadingWidget();
    }

    if (_prestamosActivos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.warning),
            const SizedBox(height: 8),
            Text(
              'No tienes préstamos activos',
              style: TextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Para realizar un pago, primero debes tener un préstamo activo',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<int>(
        value: _selectedPrestamoId,
        decoration: const InputDecoration(
          labelText: 'Seleccionar préstamo',
          prefixIcon: Icon(Icons.account_balance_wallet),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: _prestamosActivos.map<DropdownMenuItem<int>>((prestamo) {
          return DropdownMenuItem<int>(
            value: prestamo.id as int,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Préstamo #${prestamo.loanCode}',
                  style: TextStyles.bodyMedium,
                ),
                Text(
                  'Monto: ${formatCurrency(prestamo.approvedAmount)}',
                  style: TextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedPrestamoId = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Seleccione un préstamo';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Método de pago',
              style: TextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 1),
          ..._paymentMethods.map(
            (method) => RadioListTile<String>(
              value: method['value'] as String,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              title: Text(method['label'] as String),
              secondary: Icon(
                method['icon'] as IconData,
                color: AppColors.primary,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
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
              Icon(Icons.info_outline, size: 20, color: AppColors.info),
              const SizedBox(width: 8),
              Text(
                'Información importante',
                style: TextStyles.labelMedium.copyWith(color: AppColors.info),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• El pago será verificado por nuestro equipo\n'
            '• La actualización de tu cuota puede tomar hasta 24 horas\n'
            '• Guarda tu voucher como comprobante\n'
            '• Para pagos con Yape/Plin, usa el número asociado a tu cuenta',
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
