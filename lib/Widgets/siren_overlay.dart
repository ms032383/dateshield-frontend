import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../themes/app_colors.dart';

class SirenOverlay extends StatefulWidget {
  const SirenOverlay({super.key});

  @override
  State<SirenOverlay> createState() => _SirenOverlayState();
}

class _SirenOverlayState extends State<SirenOverlay>
    with TickerProviderStateMixin {
  late AnimationController _flashController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _flashController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pink flash overlay
        AnimatedBuilder(
          animation: _flashController,
          builder: (context, child) {
            final opacity = _flashController.value < 0.5
                ? _flashController.value * 2
                : (1 - _flashController.value) * 2;

            return Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.5,
                      colors: [
                        AppColors.vibrantPink.withOpacity(opacity * 0.15),
                        AppColors.vibrantPurple.withOpacity(opacity * 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Cyan flash overlay (offset)
        AnimatedBuilder(
          animation: _flashController,
          builder: (context, child) {
            final opacity = _flashController.value < 0.5
                ? (1 - _flashController.value) * 2
                : _flashController.value * 2;

            return Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: 1.5,
                      colors: [
                        AppColors.vibrantCyan.withOpacity(opacity * 0.15),
                        AppColors.vibrantPurple.withOpacity(opacity * 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Corner accents with pulsing
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = 1.0 + (_pulseController.value * 0.3);
            final opacity = 0.3 + (_pulseController.value * 0.2);

            return Stack(
              children: [
                // Top-left corner
                Positioned(
                  top: -50,
                  left: -50,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.vibrantPink.withOpacity(opacity),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom-right corner
                Positioned(
                  bottom: -50,
                  right: -50,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.vibrantCyan.withOpacity(opacity),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Top-right corner
                Positioned(
                  top: -30,
                  right: -30,
                  child: Transform.scale(
                    scale: scale * 0.8,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.vibrantPurple.withOpacity(opacity * 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom-left corner
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Transform.scale(
                    scale: scale * 0.8,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.vibrantYellow.withOpacity(opacity * 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Scanning line effect
        AnimatedBuilder(
          animation: _flashController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * _flashController.value,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.vibrantCyan.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.vibrantCyan.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Border pulse effect
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final borderOpacity = 0.2 + (_pulseController.value * 0.3);

            return Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.vibrantPink.withOpacity(borderOpacity),
                      width: 3,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Alternative: More aggressive siren for high-risk
class AggressiveSirenOverlay extends StatelessWidget {
  const AggressiveSirenOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    const flashDuration = Duration(milliseconds: 300);

    return RepaintBoundary(
      child: Stack(
        children: [
          // Pink intense flash
          Positioned.fill(
            child: IgnorePointer(
              child: Animate(
                onPlay: (controller) => controller.repeat(),
                effects: [
                  FadeEffect(
                    duration: flashDuration,
                    begin: 0,
                    end: 1,
                    curve: Curves.easeInOut,
                  ),
                  ThenEffect(),
                  FadeEffect(
                    duration: flashDuration,
                    begin: 1,
                    end: 0,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.vibrantPink.withOpacity(0.25),
                        AppColors.vibrantPurple.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Cyan counter-flash
          Positioned.fill(
            child: IgnorePointer(
              child: Animate(
                delay: const Duration(milliseconds: 300),
                onPlay: (controller) => controller.repeat(),
                effects: [
                  FadeEffect(
                    duration: flashDuration,
                    begin: 0,
                    end: 1,
                    curve: Curves.easeInOut,
                  ),
                  ThenEffect(),
                  FadeEffect(
                    duration: flashDuration,
                    begin: 1,
                    end: 0,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      colors: [
                        AppColors.vibrantCyan.withOpacity(0.25),
                        AppColors.vibrantPurple.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Warning stripes
          Positioned.fill(
            child: IgnorePointer(
              child: Animate(
                onPlay: (controller) => controller.repeat(),
                effects: [
                  SlideEffect(
                    duration: const Duration(seconds: 2),
                    begin: const Offset(0, -1),
                    end: const Offset(0, 1),
                    curve: Curves.linear,
                  ),
                ],
                child: CustomPaint(
                  painter: _DiagonalStripesPainter(
                    color: AppColors.vibrantPink.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Diagonal stripes painter
class _DiagonalStripesPainter extends CustomPainter {
  final Color color;

  _DiagonalStripesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const stripeWidth = 50.0;
    const spacing = 100.0;

    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth, 0)
        ..lineTo(x + stripeWidth + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}