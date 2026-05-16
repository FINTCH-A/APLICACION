import 'package:flutter/material.dart';

class AppColors {
  // Primarios - Azul corporativo
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Secundarios
  static const Color secondary = Color(0xFF10B981); // Verde éxito
  static const Color accent = Color(0xFFF59E0B); // Ámbar

  // Estados
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutrales - Fondo (Dark Mode)
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceVariant = Color(0xFF334155);

  // Texto (Dark Mode)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF475569);
  static const Color textHint = Color(0xFF64748B);

  // Bordes
  static const Color border = Color(0xFF334155);
  static const Color divider = Color(0xFF1E293B);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
