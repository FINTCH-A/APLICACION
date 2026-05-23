import 'package:flutter/material.dart';

class AppBorders {
  // Bordes pequeños
  static BorderRadius get small => BorderRadius.circular(8);
  static BorderRadius get medium => BorderRadius.circular(12);
  static BorderRadius get large => BorderRadius.circular(16);

  // Bordes para cards (shadcn/ui style)
  static BorderRadius get card => BorderRadius.circular(20);
  static BorderRadius get cardLarge => BorderRadius.circular(24);
  static BorderRadius get cardXLarge => BorderRadius.circular(28);

  // Bordes para botones
  static BorderRadius get button => BorderRadius.circular(12);
  static BorderRadius get buttonLarge => BorderRadius.circular(16);

  // Bordes para inputs
  static BorderRadius get input => BorderRadius.circular(14);

  // Bordes para modales
  static BorderRadius get modal => BorderRadius.circular(28);

  // Bordes para badges
  static BorderRadius get badge => BorderRadius.circular(20);

  // Bordes específicos
  static BorderRadius get topRounded => const BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  static BorderRadius get bottomRounded => const BorderRadius.only(
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  );
}
