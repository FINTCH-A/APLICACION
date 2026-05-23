import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/text_styles.dart';
import '../../../config/routes/route_names.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/models/user_model.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.editarPerfil),
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Editar perfil',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          children: [
            // ── Hero del perfil ──────────────────────
            _buildProfileHero(user),
            const SizedBox(height: 20),

            // ── Badges de verificación ───────────────
            _buildVerificationRow(user),
            const SizedBox(height: 20),

            // ── Información personal ─────────────────
            _SectionCard(
              title: 'Información Personal',
              icon: Icons.person_outline_rounded,
              children: [
                _InfoTile(
                  icon: Icons.badge_outlined,
                  label: 'DNI',
                  value: user?.dni ?? '-',
                ),
                _InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Correo electrónico',
                  value: user?.email ?? '-',
                  canCopy: true,
                ),
                _InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Teléfono',
                  value: user?.phone ?? '-',
                ),
                _InfoTile(
                  icon: Icons.cake_outlined,
                  label: 'Fecha de nacimiento',
                  value: user?.dateOfBirth != null
                      ? DateUtilsCustom.formatDate(user!.dateOfBirth)
                      : '-',
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Información de cuenta ────────────────
            _SectionCard(
              title: 'Información de Cuenta',
              icon: Icons.manage_accounts_outlined,
              children: [
                _InfoTile(
                  icon: Icons.verified_outlined,
                  label: 'Email verificado',
                  value: user?.emailVerified == true
                      ? 'Verificado'
                      : 'No verificado',
                  valueColor: user?.emailVerified == true
                      ? AppColors.success
                      : AppColors.warning,
                  trailingIcon: user?.emailVerified == true
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                ),
                _InfoTile(
                  icon: Icons.phone_android_outlined,
                  label: 'Teléfono verificado',
                  value: user?.phoneVerified == true
                      ? 'Verificado'
                      : 'No verificado',
                  valueColor: user?.phoneVerified == true
                      ? AppColors.success
                      : AppColors.warning,
                  trailingIcon: user?.phoneVerified == true
                      ? Icons.check_circle_rounded
                      : Icons.error_outline_rounded,
                ),
                if (user?.lastLogin != null)
                  _InfoTile(
                    icon: Icons.history_rounded,
                    label: 'Último acceso',
                    value: DateUtilsCustom.formatDateTime(user!.lastLogin!),
                  ),
                _InfoTile(
                  icon: Icons.calendar_month_outlined,
                  label: 'Miembro desde',
                  value: user?.createdAt != null
                      ? DateUtilsCustom.formatDate(user!.createdAt)
                      : '-',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Acciones ─────────────────────────────
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  // ── Hero del perfil ───────────────────────────────────

  Widget _buildProfileHero(UserModel? user) {
    final roleColor = _getRoleColor(user?.role);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF0F1A2E), const Color(0xFF162236)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF1E3A5F), width: 1),
      ),
      child: Column(
        children: [
          // Avatar con anillo de gradiente
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1A2B3C),
                ),
                child: Center(
                  child: Text(
                    _getInitials(user),
                    style: TextStyles.headlineMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Nombre completo
          Text(
            user?.fullName ?? 'Usuario',
            style: TextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            user?.email ?? '',
            style: TextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.55),
            ),
          ),
          const SizedBox(height: 14),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: roleColor.withOpacity(0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, size: 13, color: roleColor),
                const SizedBox(width: 5),
                Text(
                  _getRoleText(user?.role),
                  style: TextStyles.labelSmall.copyWith(
                    color: roleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Fila de verificación rápida ───────────────────────

  Widget _buildVerificationRow(UserModel? user) {
    return Row(
      children: [
        Expanded(
          child: _VerificationCard(
            icon: Icons.email_rounded,
            label: 'Email',
            verified: user?.emailVerified ?? false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _VerificationCard(
            icon: Icons.phone_rounded,
            label: 'Teléfono',
            verified: user?.phoneVerified ?? false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _VerificationCard(
            icon: Icons.badge_rounded,
            label: 'Cuenta',
            verified:
                (user?.emailVerified ?? false) &&
                (user?.phoneVerified ?? false),
          ),
        ),
      ],
    );
  }

  // ── Botones de acción ─────────────────────────────────

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        // Editar perfil
        _ActionButton(
          icon: Icons.edit_outlined,
          label: 'Editar Perfil',
          color: AppColors.primary,
          onTap: () => context.push(RouteNames.editarPerfil),
        ),
        const SizedBox(height: 10),

        // Cambiar contraseña
        _ActionButton(
          icon: Icons.lock_outline_rounded,
          label: 'Cambiar Contraseña',
          color: AppColors.secondary,
          onTap: () => _showChangePasswordDialog(context),
        ),
        const SizedBox(height: 10),

        // Seguridad
        _ActionButton(
          icon: Icons.security_outlined,
          label: 'Seguridad y privacidad',
          color: AppColors.accent,
          onTap: () {},
        ),
        const SizedBox(height: 20),

        // Cerrar sesión
        _ActionButton(
          icon: Icons.logout_rounded,
          label: 'Cerrar Sesión',
          color: AppColors.error,
          isDestructive: true,
          onTap: () => _confirmLogout(context),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────

  String _getInitials(UserModel? user) {
    if (user == null) return '?';
    final first = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final last = user.lastName.isNotEmpty ? user.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  Color _getRoleColor(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return AppColors.error;
      case UserRole.analyst:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  String _getRoleText(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.analyst:
        return 'Analista';
      default:
        return 'Cliente';
    }
  }

  void _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Cerrar Sesión'),
          ],
        ),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.logout();
      if (context.mounted) context.go(RouteNames.login);
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          bool obscureCurrent = true;
          bool obscureNew = true;
          bool obscureConfirm = true;

          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Cambiar Contraseña'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PasswordField(
                  controller: currentCtrl,
                  label: 'Contraseña actual',
                  obscure: obscureCurrent,
                  onToggle: () => setS(() => obscureCurrent = !obscureCurrent),
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  controller: newCtrl,
                  label: 'Nueva contraseña',
                  obscure: obscureNew,
                  onToggle: () => setS(() => obscureNew = !obscureNew),
                ),
                const SizedBox(height: 12),
                _PasswordField(
                  controller: confirmCtrl,
                  label: 'Confirmar nueva contraseña',
                  obscure: obscureConfirm,
                  onToggle: () => setS(() => obscureConfirm = !obscureConfirm),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newCtrl.text != confirmCtrl.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                    return;
                  }
                  final auth = context.read<AuthProvider>();
                  final ok = await auth.changePassword(
                    currentCtrl.text,
                    newCtrl.text,
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? 'Contraseña cambiada exitosamente'
                              : auth.error ?? 'Error al cambiar contraseña',
                        ),
                        backgroundColor: ok
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text('Cambiar'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// SECTION CARD
// ══════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de sección
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.border, height: 1),
          // Items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// INFO TILE
// ══════════════════════════════════════════════════════

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? trailingIcon;
  final bool canCopy;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.trailingIcon,
    this.canCopy = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: canCopy && value != '-'
          ? () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label copiado'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (trailingIcon != null)
              Icon(
                trailingIcon,
                size: 15,
                color: valueColor ?? AppColors.textSecondary,
              ),
            if (trailingIcon != null) const SizedBox(width: 5),
            Text(
              value,
              style: TextStyles.bodySmall.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
            if (canCopy && value != '-') ...[
              const SizedBox(width: 6),
              Icon(
                Icons.copy_outlined,
                size: 13,
                color: AppColors.textTertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// VERIFICATION CARD
// ══════════════════════════════════════════════════════

class _VerificationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool verified;

  const _VerificationCard({
    required this.icon,
    required this.label,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    final color = verified ? AppColors.success : AppColors.textDisabled;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: verified
              ? AppColors.success.withOpacity(0.3)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyles.labelSmall.copyWith(color: color, fontSize: 10),
          ),
          const SizedBox(height: 3),
          Icon(
            verified
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 12,
            color: color,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// ACTION BUTTON
// ══════════════════════════════════════════════════════

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppColors.error.withOpacity(0.07)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDestructive
                  ? AppColors.error.withOpacity(0.2)
                  : AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyles.bodyMedium.copyWith(
                    color: isDestructive
                        ? AppColors.error
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDestructive
                    ? AppColors.error.withOpacity(0.5)
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// PASSWORD FIELD
// ══════════════════════════════════════════════════════

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
