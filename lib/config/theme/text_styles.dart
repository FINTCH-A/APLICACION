import 'package:aplicacion_avante/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  // =========================================================
  // FUENTES
  // =========================================================

  static final fontFamily = GoogleFonts.inter().fontFamily;

  static final fontFamilyMono = GoogleFonts.jetBrainsMono().fontFamily;

  // =========================================================
  // DISPLAY (GRANDES / HERO)
  // =========================================================

  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
    height: 1.1,
  );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.15,
  );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );

  // =========================================================
  // HEADLINES
  // =========================================================

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.2,
  );

  // =========================================================
  // TITLES
  // =========================================================

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static TextStyle get titleSmall =>
      GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600);

  // =========================================================
  // BODY
  // =========================================================

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // =========================================================
  // LABELS
  // =========================================================

  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  // =========================================================
  // NÚMEROS / FINANZAS
  // =========================================================

  static TextStyle get numberLarge => GoogleFonts.jetBrainsMono(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static TextStyle get numberMedium => GoogleFonts.jetBrainsMono(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle get numberSmall =>
      GoogleFonts.jetBrainsMono(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get currency =>
      GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w600);

  // =========================================================
  // BOTONES
  // =========================================================

  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  // =========================================================
  // ESPECIALES
  // =========================================================

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static TextStyle get chip =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600);

  static TextStyle get tableHeader =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700);

  static TextStyle get tableCell =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500);
}
