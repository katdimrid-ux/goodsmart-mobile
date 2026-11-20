import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color marineBlue = Color(0xFF0F172A);
  static const Color islandGreen = Color(0xFF10B981);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color error = Color(0xFFEF4444);
}

class AppTheme {
  static ThemeData get lightTheme {
    final String? fontFamily = GoogleFonts.plusJakartaSans().fontFamily;

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.islandGreen,
        primary: AppColors.marineBlue,
        secondary: AppColors.islandGreen,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: fontFamily, color: AppColors.marineBlue, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(fontFamily: fontFamily, color: AppColors.marineBlue, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontFamily: fontFamily, color: AppColors.marineBlue, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontFamily: fontFamily, color: AppColors.marineBlue),
        bodyMedium: TextStyle(fontFamily: fontFamily, color: AppColors.marineBlue),
        bodySmall: TextStyle(fontFamily: fontFamily, color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.marineBlue,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.marineBlue.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}