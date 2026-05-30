import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';

import '../../../core/utils/currency_formatter.dart';

import '../../../data/models/pago_model.dart';
import '../../../data/providers/pago_provider.dart';
import '../../../data/providers/prestamo_provider.dart';

import '../../widgets/common/loading_widget.dart';

class RegistrarPagoScreen extends StatefulWidget {
  final String? prestamoId;
  final int? cuotaId;

  const RegistrarPagoScreen({super.key, this.prestamoId, this.cuotaId});

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
  bool _isLoading = false;
  double? _suggestedAmount;

  final List<_PaymentMethodItem> _paymentMethods = [
    _PaymentMethodItem(
      name: 'Yape',
      icon: Icons.phone_android,
      color: const Color(0xFF9C27B0),
    ),
    _PaymentMethodItem(
      name: 'Plin',
      icon: Icons.flash_on_rounded,
      color: const Color(0xFF2196F3),
    ),
    _PaymentMethodItem(
      name: 'Transferencia',
      icon: Icons.account_balance,
      color: const Color(0xFF4CAF50),
    ),
    _PaymentMethodItem(
      name: 'Efectivo',
      icon: Icons.payments_rounded,
      color: const Color(0xFFFF9800),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSuggestedAmount();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestedAmount() async {
    if (widget.cuotaId != null && widget.prestamoId != null) {
      setState(() => _isLoading = true);

      try {
        final provider = context.read<PrestamoProvider>();

        await provider.loadInstallments(int.parse(widget.prestamoId!));

        final cuota = provider.installments.firstWhere(
          (c) => c.id == widget.cuotaId,
          orElse: () => throw Exception('Cuota no encontrada'),
        );

        setState(() {
          _suggestedAmount = cuota.pendingAmount > 0
              ? cuota.pendingAmount
              : cuota.totalAmount;

          _amountController.text = _suggestedAmount!.toStringAsFixed(2);
        });
      } catch (e) {
        debugPrint('Error cargando monto sugerido: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitPago() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final dto = CreatePaymentDto(
      loanId: int.parse(widget.prestamoId!),
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
        SnackBar(
          content: const Text('Pago registrado exitosamente'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      context.pop();
    } else if (mounted && pagoProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pagoProvider.error!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isSubmitting) {
      return const Scaffold(body: LoadingWidget(message: 'Procesando pago...'));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Registrar pago',
          style: TextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              _PaymentHeaderCard(
                prestamoId: widget.prestamoId,
                cuotaId: widget.cuotaId,
                suggestedAmount: _suggestedAmount,
              ),
              const SizedBox(height: 28),

              // METODOS DE PAGO (REDISEÑADO)
              _SectionTitle(title: 'Método de pago'),
              const SizedBox(height: 14),
              _PaymentMethodGrid(
                selectedMethod: _selectedPaymentMethod,
                methods: _paymentMethods,
                onMethodSelected: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
              ),
              const SizedBox(height: 28),

              // INFORMACION DE PAGO
              _SectionTitle(title: 'Información del pago'),
              const SizedBox(height: 14),
              _ModernCard(
                child: Column(
                  children: [
                    _ModernTextField(
                      controller: _amountController,
                      label: 'Monto a pagar',
                      hint: '0.00',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
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
                    const SizedBox(height: 18),
                    _ModernTextField(
                      controller: _referenceController,
                      label: 'N° de operación',
                      hint: 'Número de operación',
                      icon: Icons.receipt_long,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la referencia';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _ModernTextField(
                      controller: _notesController,
                      label: 'Notas adicionales',
                      hint: 'Información adicional del pago',
                      icon: Icons.description,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // INFORMACION IMPORTANTE
              _buildInfoSection(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.info.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info),
              const SizedBox(width: 10),
              Text(
                'Información importante',
                style: TextStyles.titleSmall.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoItem(text: 'El pago será verificado por nuestro equipo.'),
          _InfoItem(text: 'La actualización puede tardar hasta 24 horas.'),
          _InfoItem(text: 'Guarda tu voucher como comprobante.'),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          height: 58,
          child: ElevatedButton.icon(
            onPressed: _submitPago,
            icon: const Icon(Icons.payment_rounded),
            label: const Text('Registrar Pago'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: TextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================
// PAYMENT METHOD GRID (REDISEÑADO)
// =========================================================

class _PaymentMethodGrid extends StatelessWidget {
  final String? selectedMethod;
  final List<_PaymentMethodItem> methods;
  final Function(String) onMethodSelected;

  const _PaymentMethodGrid({
    required this.selectedMethod,
    required this.methods,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 3.5,
      children: methods.map((method) {
        final isSelected = selectedMethod == method.name;
        return _PaymentMethodChip(
          method: method,
          isSelected: isSelected,
          onTap: () => onMethodSelected(method.name),
        );
      }).toList(),
    );
  }
}

// =========================================================
// PAYMENT METHOD CHIP
// =========================================================

class _PaymentMethodChip extends StatelessWidget {
  final _PaymentMethodItem method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodChip({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? method.color : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? method.color : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: method.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              method.icon,
              size: 22,
              color: isSelected ? Colors.white : method.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                method.name,
                style: TextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// HEADER CARD
// =========================================================

class _PaymentHeaderCard extends StatelessWidget {
  final String? prestamoId;
  final int? cuotaId;
  final double? suggestedAmount;

  const _PaymentHeaderCard({
    required this.prestamoId,
    required this.cuotaId,
    required this.suggestedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registrar pago',
                      style: TextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Préstamo #$prestamoId',
                      style: TextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (suggestedAmount != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monto sugerido',
                  style: TextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(suggestedAmount!),
                  style: TextStyles.displaySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (cuotaId != null) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Cuota #$cuotaId',
                style: TextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =========================================================
// SECTION TITLE
// =========================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// =========================================================
// MODERN CARD
// =========================================================

class _ModernCard extends StatelessWidget {
  final Widget child;

  const _ModernCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// =========================================================
// MODERN TEXT FIELD
// =========================================================

class _ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textTertiary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
    );
  }
}

// =========================================================
// INFO ITEM
// =========================================================

class _InfoItem extends StatelessWidget {
  final String text;

  const _InfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.info,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// PAYMENT METHOD ITEM
// =========================================================

class _PaymentMethodItem {
  final String name;
  final IconData icon;
  final Color color;

  _PaymentMethodItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}
