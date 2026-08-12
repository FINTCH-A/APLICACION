import 'package:flutter/material.dart';

class AppColors {
  // ==================== PRIMARIOS ====================
  // Modo Oscuro: #129BF3 | Modo Claro: #0EA5E9
  static const Color primary = Color(0xFF129BF3); // Azul principal
  static const Color primaryDark = Color(0xFF0D7BC2); // Azul oscuro
  static const Color primaryLight = Color(0xFF4DB4F6); // Azul claro
  static const Color primarySurface = Color(
    0xFF0A1628,
  ); // Superficie con primary

  // ==================== SECUNDARIOS ====================
  // Modo Oscuro: #06C8D9 | Modo Claro: #0891B2
  static const Color secondary = Color(0xFF06C8D9); // Cyan
  static const Color secondaryDark = Color(0xFF04A0AE);
  static const Color secondaryLight = Color(0xFF38D6E3);

  // ==================== ACENTOS ====================
  // Modo Oscuro: #19D3B2 | Modo Claro: #0D9488
  static const Color accent = Color(0xFF19D3B2); // Turquesa
  static const Color accentGreen = Color(0xFF10B981); // Verde éxito
  static const Color accentCyan = Color(0xFF06B6D4); // Cyan brillante
  static const Color accentPink = Color(0xFFEC4899); // Rosa acento

  // ==================== ESTADOS ====================
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ==================== FONDO (DARK MODE) ====================
  static const Color background = Color(0xFF020B16); // Fondo principal #020B16
  static const Color backgroundAlt = Color(
    0xFF071522,
  ); // Fondo secundario #071522
  static const Color surface = Color(0xFF0B1B2A); // Tarjetas #0B1B2A
  static const Color surfaceAlt = Color(0xFF0F2335); // Superficie alternativa
  static const Color surfaceVariant = Color(0xFF142C3F); // Variante

  // ==================== BORDES Y DIVISORES ====================
  static const Color border = Color(0xFF183044); // Bordes #183044
  static const Color borderLight = Color(0xFF1E3D55);
  static const Color divider = Color(0xFF0F2335);

  // ==================== TEXTO ====================
  static const Color textPrimary = Color(0xFFF8FAFC); // Texto principal #F8FAFC
  static const Color textSecondary = Color(
    0xFF94A3B8,
  ); // Texto secundario #94A3B8
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
    colors: [accent, Color(0xFF14B89A)],
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
  static Color glassBackground = const Color(0xFF0B1B2A).withOpacity(0.7);
  static Color glassBorder = const Color(0xFF129BF3).withOpacity(0.2);
}
