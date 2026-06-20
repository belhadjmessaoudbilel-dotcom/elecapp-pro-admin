import 'package:flutter/material.dart';

// Palette claire partagée par les 4 apps Elecapp Pro (écrans auth : fond blanc)
class AppColors {
  static const primary      = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFF3B82F6);
  static const accent       = Color(0xFFF59E0B);
  static const accentLight  = Color(0xFFFBBF24);
  static const success      = Color(0xFF16A34A);
  static const successLight = Color(0xFF22C55E);
  static const danger       = Color(0xFFDC2626);
  static const dangerLight  = Color(0xFFEF4444);
  static const warning      = Color(0xFFF59E0B);
  static const text         = Color(0xFF1E293B);
  static const textMuted    = Color(0xFF64748B);
  static const border       = Color(0xFFE2E8F0);
  static const surface      = Color(0xFFF8FAFC);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Colors.white,
      error: AppColors.dangerLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    ),
  );
}
