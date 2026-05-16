import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import 'widgets/perfil_info.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? 'Usuario',
                    style: TextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user?.role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getRoleText(user?.role),
                      style: TextStyles.labelSmall.copyWith(
                        color: _getRoleColor(user?.role),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Información personal
            PerfilInfo(
              title: 'Información Personal',
              children: [
                _InfoRow(
                  label: 'DNI',
                  value: user?.dni ?? '-',
                  icon: Icons.badge_outlined,
                ),
                _InfoRow(
                  label: 'Correo electrónico',
                  value: user?.email ?? '-',
                  icon: Icons.email_outlined,
                ),
                _InfoRow(
                  label: 'Teléfono',
                  value: user?.phone ?? '-',
                  icon: Icons.phone_outlined,
                ),
                _InfoRow(
                  label: 'Fecha de nacimiento',
                  value: user?.dateOfBirth != null
                      ? DateUtilsCustom.formatDate(user!.dateOfBirth)
                      : '-',
                  icon: Icons.cake_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Información de cuenta
            PerfilInfo(
              title: 'Información de Cuenta',
              children: [
                _InfoRow(
                  label: 'Verificación de email',
                  value: user?.emailVerified == true
                      ? 'Verificado'
                      : 'No verificado',
                  icon: Icons.email_outlined,
                  valueColor: user?.emailVerified == true
                      ? AppColors.success
                      : AppColors.warning,
                ),
                _InfoRow(
                  label: 'Verificación de teléfono',
                  value: user?.phoneVerified == true
                      ? 'Verificado'
                      : 'No verificado',
                  icon: Icons.phone_outlined,
                  valueColor: user?.phoneVerified == true
                      ? AppColors.success
                      : AppColors.warning,
                ),
                if (user?.lastLogin != null)
                  _InfoRow(
                    label: 'Último acceso',
                    value: DateUtilsCustom.formatDateTime(user!.lastLogin!),
                    icon: Icons.history_outlined,
                  ),
                _InfoRow(
                  label: 'Miembro desde',
                  value: user?.createdAt != null
                      ? DateUtilsCustom.formatDate(user!.createdAt)
                      : '-',
                  icon: Icons.calendar_today_outlined,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botones de acción
            CustomButton(
              text: 'Editar Perfil',
              onPressed: () {
                context.push(RouteNames.editarPerfil);
              },
              icon: Icons.edit_outlined,
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Cambiar Contraseña',
              onPressed: () {
                _showChangePasswordDialog(context);
              },
              icon: Icons.lock_outline,
              isOutlined: true,
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Cerrar Sesión',
              onPressed: () => _confirmLogout(context),
              icon: Icons.logout_outlined,
              backgroundColor: AppColors.error,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      if (context.mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Cambiar Contraseña'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Contraseña actual',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          obscureCurrent = !obscureCurrent;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirmar nueva contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setStateDialog(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                    return;
                  }

                  final authProvider = context.read<AuthProvider>();
                  final success = await authProvider.changePassword(
                    currentPasswordController.text,
                    newPasswordController.text,
                  );

                  if (success && context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contraseña cambiada exitosamente'),
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          authProvider.error ?? 'Error al cambiar contraseña',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Cambiar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getRoleColor(dynamic role) {
    final roleStr = role?.toString().toLowerCase() ?? 'customer';
    switch (roleStr) {
      case 'admin':
        return AppColors.error;
      case 'analyst':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  String _getRoleText(dynamic role) {
    final roleStr = role?.toString().toLowerCase() ?? 'customer';
    switch (roleStr) {
      case 'admin':
        return 'Administrador';
      case 'analyst':
        return 'Analista';
      default:
        return 'Cliente';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyles.bodySmall.copyWith(
                color: valueColor ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
