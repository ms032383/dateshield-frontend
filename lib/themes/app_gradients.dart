import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {
  AppGradients._();

  // === DARK MODE GRADIENTS ===
  static const backgroundDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A2E), // Deep dark
      Color(0xFF0F0F1E), // Darker
      Color(0xFF0A0A0F), // Darkest
    ],
  );

  // === LIGHT MODE GRADIENTS ===
  static const backgroundLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFEFEFE), // Almost white
      Color(0xFFF8F9FA), // Soft white
      Color(0xFFF0F0F5), // Light gray
    ],
  );

  // === VIBRANT ACCENT GRADIENTS ===
  static const vibrantGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.vibrantPink, // Hot pink
      AppColors.vibrantPurple, // Purple
      AppColors.vibrantCyan, // Cyan
    ],
  );

  static const glowGradient = RadialGradient(
    colors: [
      Color(0x66FF006E), // Pink glow
      Color(0x338B5CF6), // Purple glow
      Color(0x0000F5FF), // Transparent cyan
    ],
  );

  // === BUTTON GRADIENTS ===
  static const primaryButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.vibrantPink,
      AppColors.vibrantPurple,
    ],
  );

  static const successButton = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.vibrantGreen,
      Color(0xFF059669),
    ],
  );

  // === CARD GRADIENTS ===
  static const cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1F1F3A),
      Color(0xFF16213E),
    ],
  );

  static const cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8F9FA),
    ],
  );

  // === LEGACY COMPATIBILITY ===
  static const background = backgroundDark;

  static const siren = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FF006E), // Pink
      Color(0x338B5CF6), // Purple
      Color(0x3300F5FF), // Cyan
    ],
  );
}