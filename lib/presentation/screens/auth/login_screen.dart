import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/theme/app_borders.dart';
import '../../../config/theme/app_shadows.dart';
import '../../../config/routes/route_names.dart';
import '../../../data/providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      context.go(RouteNames.home);
    } else if (mounted && authProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error!),
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
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Logo circular (nuevo diseño)
                _buildLogo(),

                const SizedBox(height: 24),

                // Título (nuevo diseño)
                _buildTitle(),

                const SizedBox(height: 48),

                // Formulario
                _buildForm(),

                const SizedBox(height: 24),

                // Botón de Login
                _buildLoginButton(),

                const SizedBox(height: 16),

                // Olvidé mi contraseña
                _buildForgotPassword(),

                const SizedBox(height: 40),

                // Divider
                _buildDivider(),

                const SizedBox(height: 24),

                // Registro
                _buildRegisterSection(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // LOGO CIRCULAR (nuevo diseño)
  // =========================================================

  Widget _buildLogo() {
    return Center(
      child: Hero(
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
    );
  }

  // =========================================================
  // TÍTULO
  // =========================================================

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Iniciar Sesión',
          style: TextStyles.headlineLarge.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ingresa tus credenciales para continuar',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FORMULARIO
  // =========================================================

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Correo Electrónico',
            hint: 'tu@email.com',
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El correo es requerido';
              }
              if (!value.contains('@')) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Contraseña',
            hint: '••••••••',
            controller: _passwordController,
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                return 'La contraseña es requerida';
              }
              if (value.length < 6) {
                return 'Mínimo 6 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTÓN DE LOGIN
  // =========================================================

  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return CustomButton(
          text: 'Iniciar Sesión',
          onPressed: authProvider.isLoading ? null : _handleLogin,
          isLoading: authProvider.isLoading,
        );
      },
    );
  }

  // =========================================================
  // OLVIDÉ CONTRASEÑA
  // =========================================================

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.push(RouteNames.forgotPassword);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        ),
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyles.labelMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  // =========================================================
  // DIVIDER
  // =========================================================

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'O',
            style: TextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }

  // =========================================================
  // SECCIÓN DE REGISTRO
  // =========================================================

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () {
            context.push(RouteNames.register);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Regístrate',
            style: TextStyles.labelLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
