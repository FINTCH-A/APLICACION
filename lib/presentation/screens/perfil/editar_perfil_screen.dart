import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../data/providers/auth_provider.dart';
import '../../widgets/common/loading_widget.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _firstNameCtrl.addListener(_onChanged);
    _lastNameCtrl.addListener(_onChanged);
    _phoneCtrl.addListener(_onChanged);
  }

  void _loadUserData() {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _firstNameCtrl.text = user.firstName;
      _lastNameCtrl.text = user.lastName;
      _phoneCtrl.text = user.phone;
    }
  }

  void _onChanged() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // TODO: Implementar actualización cuando el endpoint esté disponible
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Perfil actualizado exitosamente'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaving) return const LoadingWidget(message: 'Guardando cambios...');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        centerTitle: true,
        actions: [
          // Botón guardar en AppBar si hay cambios
          if (_hasChanges)
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'Guardar',
                style: TextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar editable ───────────────────
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(),
                          style: TextStyles.headlineSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Sección: Datos personales ─────────
              _sectionLabel('Datos Personales'),
              const SizedBox(height: 10),

              _FormField(
                controller: _firstNameCtrl,
                label: 'Nombre',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'El nombre es requerido' : null,
              ),
              const SizedBox(height: 12),

              _FormField(
                controller: _lastNameCtrl,
                label: 'Apellido',
                icon: Icons.person_outline_rounded,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'El apellido es requerido'
                    : null,
              ),
              const SizedBox(height: 12),

              _FormField(
                controller: _phoneCtrl,
                label: 'Teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'El teléfono es requerido'
                    : null,
              ),

              const SizedBox(height: 28),

              // ── Botones ───────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _OutlineBtn(
                      label: 'Cancelar',
                      onTap: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryBtn(
                      label: 'Guardar cambios',
                      enabled: _hasChanges,
                      onTap: _saveChanges,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return '?';
    final f = _firstNameCtrl.text.isNotEmpty
        ? _firstNameCtrl.text[0]
        : user.firstName.isNotEmpty
        ? user.firstName[0]
        : '';
    final l = _lastNameCtrl.text.isNotEmpty
        ? _lastNameCtrl.text[0]
        : user.lastName.isNotEmpty
        ? user.lastName[0]
        : '';
    return '$f$l'.toUpperCase();
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyles.labelMedium.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
        fontSize: 11,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// FORM FIELD
// ══════════════════════════════════════════════════════

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// BOTONES
// ══════════════════════════════════════════════════════

class _OutlineBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onTap, child: Text(label));
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PrimaryBtn({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.primary : AppColors.surfaceVariant,
        foregroundColor: Colors.white,
      ),
      child: Text(label),
    );
  }
}
