import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'app_theme.dart';

// Theme mode provider - can be toggled between light and dark
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// Dark theme provider
final darkThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.dark();
});

// Light theme provider
final lightThemeProvider = Provider<ThemeData>((ref) {
  return AppTheme.light();
});

// Legacy support
final themeProvider = Provider<ThemeData>((ref) {
  return AppTheme.dark();
});