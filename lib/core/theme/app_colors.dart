import 'package:flutter/material.dart';

/// Film4us's own dark, cinematic color identity.
///
/// Deliberately restrained: one accent color, deep neutral backgrounds,
/// and no neon gradients — see design principles in the project brief.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceElevated = Color(0xFF1C1C1C);
  static const Color border = Color(0xFF2A2A2A);

  static const Color accent = Color(0xFF25D400); // Film4us signature green
  static const Color accentMuted = Color(0xFF1B8F00);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF6E6E6E);

  static const Color error = Color(0xFFE06C6C);
  static const Color success = Color(0xFF25D400);
}
