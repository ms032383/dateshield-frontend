import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === DARK MODE COLORS ===
  static const darkBg = Color(0xFF0A0A0F); // Deep dark purple-ish black
  static const darkSurface = Color(0xFF1A1A2E); // Dark surface
  static const darkCard = Color(0xFF16213E); // Card background

  // === LIGHT MODE COLORS ===
  static const lightBg = Color(0xFFF8F9FA); // Soft white
  static const lightSurface = Color(0xFFFFFFFF); // Pure white
  static const lightCard = Color(0xFFF0F0F5); // Light card

  // === GEN-Z VIBRANT COLORS ===
  static const vibrantPink = Color(0xFFFF006E); // Hot pink for danger/toxic
  static const vibrantPurple = Color(0xFF8B5CF6); // Purple accent
  static const vibrantCyan = Color(0xFF00F5FF); // Cyan for safe/cool
  static const vibrantYellow = Color(0xFFFBBF24); // Yellow for warnings
  static const vibrantGreen = Color(0xFF10B981); // Green for safe

  // === GRADIENT COLORS ===
  static const gradientStart = Color(0xFFFF006E); // Pink
  static const gradientMid = Color(0xFF8B5CF6); // Purple
  static const gradientEnd = Color(0xFF3B82F6); // Blue

  // === GLASS MORPHISM ===
  static const glassDark = Color(0x1AFFFFFF); // Glass effect dark mode
  static const glassLight = Color(0x1A000000); // Glass effect light mode
  static const glassBorderDark = Color(0x33FFFFFF);
  static const glassBorderLight = Color(0x33000000);

  // === TEXT COLORS ===
  static const textDark = Color(0xFFFFFFFF); // White text for dark mode
  static const textLight = Color(0xFF1F2937); // Dark gray text for light mode
  static const textMutedDark = Color(0xB3FFFFFF); // Muted white
  static const textMutedLight = Color(0xFF6B7280); // Muted gray

  // === STATUS COLORS ===
  static const danger = Color(0xFFFF006E); // Pink danger
  static const warning = Color(0xFFFBBF24); // Yellow warning
  static const success = Color(0xFF10B981); // Green success
  static const info = Color(0xFF3B82F6); // Blue info

  // === LEGACY COMPATIBILITY (for existing code) ===
  static const pitchBlack = darkBg;
  static const neonRed = vibrantPink;
  static const neonGreen = vibrantGreen;
  static const policeBlue = vibrantPurple;
  static const glass = glassDark;
  static const glassBorder = glassBorderDark;
  static const mutedText = textMutedDark;
}