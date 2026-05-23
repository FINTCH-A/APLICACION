import 'package:flutter/material.dart';

class AppColors {
  // ==================== PRIMARIOS ====================
  static const Color primary = Color(0xFF27BAAE); // Teal/Cyan premium
  static const Color primaryDark = Color(0xFF1E8F85); // Teal oscuro
  static const Color primaryLight = Color(0xFF4CD4C8); // Teal claro
  static const Color primarySurface = Color(
    0xFF0D2A2B,
  ); // Superficie con primary

  // ==================== SECUNDARIOS ====================
  static const Color secondary = Color(0xFF3B82F6); // Azul eléctrico
  static const Color secondaryDark = Color(0xFF2563EB);
  static const Color secondaryLight = Color(0xFF60A5FA);

  // ==================== ACENTOS ====================
  static const Color accent = Color(0xFF8B5CF6); // Púrpura premium
  static const Color accentGreen = Color(0xFF10B981); // Verde éxito
  static const Color accentCyan = Color(0xFF06B6D4); // Cyan brillante
  static const Color accentPink = Color(0xFFEC4899); // Rosa acento

  // ==================== ESTADOS ====================
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ==================== FONDO (DARK MODE PREMIUM) ====================
  static const Color background = Color(0xFF0A0C10); // Azul oscuro casi negro
  static const Color backgroundAlt = Color(0xFF0F1117); // Alternativo
  static const Color surface = Color(0xFF1A1D24); // Superficie elegante
  static const Color surfaceAlt = Color(0xFF222530); // Superficie alternativa
  static const Color surfaceVariant = Color(0xFF2A2E3A); // Variante

  // ==================== BORDES Y DIVISORES ====================
  static const Color border = Color(0xFF2A2E3A);
  static const Color borderLight = Color(0xFF353A47);
  static const Color divider = Color(0xFF1F232B);

  // ==================== TEXTO ====================
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // ==================== GRADIENTES PREMIUM ====================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surface, surfaceAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== GLASSMORPHISM ====================
  static Color glassBackground = const Color(0xFF1A1D24).withOpacity(0.7);
  static Color glassBorder = const Color(0xFF27BAAE).withOpacity(0.2);
}
