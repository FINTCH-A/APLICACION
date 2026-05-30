import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/route_names.dart';
import '../../../config/theme/app_borders.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_shadows.dart';
import '../../../config/theme/text_styles.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';

import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');

      _birthDateController.text = '$day/$month/${date.year}';
    }
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppBorders.medium),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final registerData = RegisterDto(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dni: _dniController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      dateOfBirth: _birthDateController.text.trim(),
      password: _passwordController.text,
    );

    final success = await authProvider.register(registerData);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cuenta creada correctamente'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppBorders.medium),
        ),
      );

      context.go(RouteNames.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error ?? 'No se pudo completar el registro',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppBorders.medium),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBackButton(),
                const SizedBox(height: 8),
                _buildHeader(),
                const SizedBox(height: 28),
                _buildRegisterCard(),
                const SizedBox(height: 20),
                _buildLoginSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.pop(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Hero(
          tag: 'app-logo',
          child: Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: AppShadows.medium,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.15),
                width: 1.5,
              ),
            ),
            child: Image.asset(
              'assets/images/logo-dark.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Crear Cuenta',
          style: TextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Regístrate y accede a préstamos rápidos, seguros y 100% digitales',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppBorders.cardLarge,
        boxShadow: AppShadows.medium,
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildSectionTitle(
              icon: Icons.person_outline_rounded,
              title: 'Información personal',
            ),
            const SizedBox(height: 16),

            // ================= NOMBRE (Campo completo) =================
            CustomTextField(
              label: 'Nombre',
              hint: 'Juan Carlos',
              controller: _firstNameController,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tu nombre';
                }
                if (value.trim().length < 2) {
                  return 'Nombre inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ================= APELLIDO (Campo completo) =================
            CustomTextField(
              label: 'Apellido',
              hint: 'Pérez Gómez',
              controller: _lastNameController,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tu apellido';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ================= DNI =================
            CustomTextField(
              label: 'DNI',
              hint: '12345678',
              controller: _dniController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.badge_outlined,
              maxLength: 8,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa tu DNI';
                }
                if (value.length != 8) {
                  return 'El DNI debe tener 8 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ================= CORREO =================
            CustomTextField(
              label: 'Correo electrónico',
              hint: 'usuario@correo.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tu correo';
                }
                if (!value.contains('@')) {
                  return 'Correo inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ================= TELÉFONO =================
            CustomTextField(
              label: 'Teléfono',
              hint: '987654321',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tu teléfono';
                }
                if (value.length < 9) {
                  return 'Número inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ================= FECHA NACIMIENTO =================
            CustomTextField(
              label: 'Fecha de nacimiento',
              hint: 'DD/MM/AAAA',
              controller: _birthDateController,
              readOnly: true,
              prefixIcon: Icons.cake_outlined,
              suffixIcon: IconButton(
                onPressed: _selectDate,
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecciona tu fecha';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(
              icon: Icons.lock_outline_rounded,
              title: 'Seguridad de la cuenta',
            ),
            const SizedBox(height: 16),

            // ================= CONTRASEÑA =================
            CustomTextField(
              label: 'Contraseña',
              hint: '••••••••',
              controller: _passwordController,
              obscureText: _obscurePassword,
              prefixIcon: Icons.lock_outline,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa una contraseña';
                }
                if (value.length < 6) {
                  return 'Mínimo 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            // ================= CONFIRMAR CONTRASEÑA =================
            CustomTextField(
              label: 'Confirmar contraseña',
              hint: '••••••••',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirma tu contraseña';
                }
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // ================= TÉRMINOS =================
            _buildTermsCheck(),
            const SizedBox(height: 24),

            // ================= BOTÓN REGISTRO =================
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheck() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Acepto los términos, condiciones y políticas de privacidad de la plataforma.',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return CustomButton(
          text: 'Crear Cuenta',
          onPressed: authProvider.isLoading ? null : _handleRegister,
          isLoading: authProvider.isLoading,
        );
      },
    );
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            '¿Ya tienes cuenta?',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () {
            context.go(RouteNames.login);
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Iniciar sesión',
            style: TextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
