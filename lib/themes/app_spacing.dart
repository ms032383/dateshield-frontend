import 'package:flutter/material.dart';

class AppSpacing {
  final double pagePaddingX;
  final double pagePaddingY;

  final double gap12;
  final double gap16;
  final double gap20;
  final double gap24;
  final double gap32;

  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  AppSpacing._({
    required this.pagePaddingX,
    required this.pagePaddingY,
    required this.gap12,
    required this.gap16,
    required this.gap20,
    required this.gap24,
    required this.gap32,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  static AppSpacing of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    final isMobile = w < 720;
    final isTablet = w >= 720 && w < 1100;
    final isDesktop = w >= 1100;

    // ✅ tuned like the screenshot (desktop roomy)
    final px = isMobile ? 16.0 : isTablet ? 24.0 : 32.0;
    final py = isMobile ? 18.0 : 28.0;

    return AppSpacing._(
      pagePaddingX: px,
      pagePaddingY: py,
      gap12: 12,
      gap16: 16,
      gap20: 20,
      gap24: 24,
      gap32: 32,
      isMobile: isMobile,
      isTablet: isTablet,
      isDesktop: isDesktop,
    );
  }
}
