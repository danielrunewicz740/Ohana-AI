import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// San Diego dog training themed color palette.
class AppColors {
  AppColors._();

  /// Warm sandy beach – used as the primary background.
  static const Color sand = Color(0xFFF5E6C8);

  /// Deep ocean blue – primary interactive color.
  static const Color oceanBlue = Color(0xFF1A6B8A);

  /// Sunny golden – accent / highlight color.
  static const Color sunGold = Color(0xFFF4AB1C);

  /// Coral sunset – emergency / warning color.
  static const Color coral = Color(0xFFE85D3A);

  /// Soft seafoam – success / check-in color.
  static const Color seafoam = Color(0xFF4CAF7D);

  /// Warm cream – card / bubble backgrounds.
  static const Color cream = Color(0xFFFFF8EE);

  /// Dark charcoal – primary text.
  static const Color charcoal = Color(0xFF2C2C2C);

  /// Medium grey – secondary text.
  static const Color grey = Color(0xFF757575);

  /// Light grey – dividers / disabled.
  static const Color lightGrey = Color(0xFFE0E0E0);

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    final nunitoTextTheme = GoogleFonts.nunitoTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: AppColors.charcoal,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.charcoal,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.charcoal,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.charcoal,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.charcoal,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.charcoal,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
          letterSpacing: 0.5,
        ),
      ),
    );

    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.oceanBlue,
        onPrimary: AppColors.white,
        secondary: AppColors.sunGold,
        onSecondary: AppColors.charcoal,
        error: AppColors.coral,
        onError: AppColors.white,
        surface: AppColors.cream,
        onSurface: AppColors.charcoal,
      ),
      scaffoldBackgroundColor: AppColors.sand,
      textTheme: nunitoTextTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.oceanBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 3,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cream,
        elevation: 4,
        shadowColor: AppColors.oceanBlue.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
    );
  }
}
