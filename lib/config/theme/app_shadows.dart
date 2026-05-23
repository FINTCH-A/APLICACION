import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  // Sombra suave para elementos elevados
  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Sombra media para cards
  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Sombra fuerte para modales
  static List<BoxShadow> strong = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // Sombra con glow primary
  static List<BoxShadow> glow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 0),
    ),
  ];

  // Sombra con glow secondary
  static List<BoxShadow> glowSecondary = [
    BoxShadow(
      color: AppColors.secondary.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 0),
    ),
  ];

  // Efecto glassmorphism
  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppColors.glassBackground,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.glassBorder, width: 1),
  );
}
