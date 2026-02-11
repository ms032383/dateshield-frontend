import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // === DARK THEME ===
  static ThemeData dark() {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
    );

    final poppins = GoogleFonts.poppinsTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: AppColors.vibrantPink,
        secondary: AppColors.vibrantPurple,
        tertiary: AppColors.vibrantCyan,
        surface: AppColors.darkSurface,
        background: AppColors.darkBg,
        error: AppColors.danger,
      ),
      textTheme: poppins.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.glassBorderDark,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.bebasNeue(
            fontSize: 18,
            letterSpacing: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 24,
          letterSpacing: 2,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  // === LIGHT THEME ===
  static ThemeData light() {
    final base = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
    );

    final poppins = GoogleFonts.poppinsTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.light,
        primary: AppColors.vibrantPink,
        secondary: AppColors.vibrantPurple,
        tertiary: AppColors.vibrantCyan,
        surface: AppColors.lightSurface,
        background: AppColors.lightBg,
        error: AppColors.danger,
      ),
      textTheme: poppins.apply(
        bodyColor: AppColors.textLight,
        displayColor: AppColors.textLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.glassBorderLight,
            width: 1,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.bebasNeue(
            fontSize: 18,
            letterSpacing: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bebasNeue(
          fontSize: 24,
          letterSpacing: 2,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  /// Bebas Neue headline helper (use per-widget)
  static TextStyle bebas({
    double size = 48,
    Color? color,
    double letterSpacing = 2,
    FontWeight? weight,
  }) {
    return GoogleFonts.bebasNeue(
      fontSize: size,
      color: color,
      letterSpacing: letterSpacing,
      fontWeight: weight,
    );
  }

  /// Poppins text helper
  static TextStyle poppins({
    double size = 16,
    Color? color,
    FontWeight? weight,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }
}