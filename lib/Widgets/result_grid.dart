import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../state/scan_state.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_theme.dart';

class ResultGrid extends StatelessWidget {
  const ResultGrid({
    super.key,
    required this.spacing,
    required this.result,
  });

  final AppSpacing spacing;
  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    if (spacing.isMobile) {
      return Column(
        children: [
          ToxicityCard(result: result),
          const SizedBox(height: 16),
          VerdictCard(result: result),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ToxicityCard(result: result)),
        const SizedBox(width: 20),
        Expanded(child: VerdictCard(result: result)),
      ],
    );
  }
}

class ToxicityCard extends StatefulWidget {
  const ToxicityCard({
    super.key,
    required this.result,
  });

  final ScanResult result;

  @override
  State<ToxicityCard> createState() => _ToxicityCardState();
}

class _ToxicityCardState extends State<ToxicityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine colors based on risk
    final statusColor = widget.result.risk == ScamRisk.high
        ? AppColors.vibrantPink
        : (widget.result.risk == ScamRisk.medium
        ? AppColors.vibrantYellow
        : AppColors.vibrantGreen);

    final gradientColors = widget.result.risk == ScamRisk.high
        ? [AppColors.vibrantPink, AppColors.vibrantPurple]
        : widget.result.risk == ScamRisk.medium
        ? [AppColors.vibrantYellow, AppColors.vibrantPurple]
        : [AppColors.vibrantGreen, AppColors.vibrantCyan];

    return _PremiumGlassCard(
      isDark: isDark,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          statusColor.withOpacity(0.05),
          Colors.transparent,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "TOXICITY GAUGE",
                style: AppTheme.bebas(
                  size: 16,
                  letterSpacing: 1.2,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Animated Ring Gauge
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return _AnimatedRingGauge(
                  value: widget.result.toxicity,
                  gradientColors: gradientColors,
                  pulseValue: _pulseController.value,
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Confidence score with animated bar
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_rounded,
                      color: AppColors.vibrantCyan,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${(widget.result.confidence * 100).toStringAsFixed(0)}% AI Confidence",
                      style: AppTheme.poppins(
                        size: 13,
                        color: isDark
                            ? AppColors.textMutedDark
                            : AppColors.textMutedLight,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _AnimatedProgressBar(
                  value: widget.result.confidence,
                  colors: [AppColors.vibrantCyan, AppColors.vibrantPurple],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Meta info cards
          _MetaCard(
            icon: Icons.warning_rounded,
            label: "Scam Risk",
            value: widget.result.risk.name.toUpperCase(),
            valueColor: statusColor,
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _MetaCard(
            icon: Icons.signal_cellular_alt_rounded,
            label: "Signal Strength",
            value: widget.result.risk == ScamRisk.high ? "CRITICAL" : "STABLE",
            valueColor: widget.result.risk == ScamRisk.high
                ? AppColors.vibrantPink
                : AppColors.vibrantGreen,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class VerdictCard extends StatefulWidget {
  const VerdictCard({super.key, required this.result});
  final ScanResult result;

  @override
  State<VerdictCard> createState() => _VerdictCardState();
}

class _VerdictCardState extends State<VerdictCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = widget.result.risk == ScamRisk.high
        ? AppColors.vibrantPink
        : AppColors.vibrantGreen;

    final gradientColors = widget.result.risk == ScamRisk.high
        ? [AppColors.vibrantPink, AppColors.vibrantPurple]
        : [AppColors.vibrantGreen, AppColors.vibrantCyan];

    return _PremiumGlassCard(
      isDark: isDark,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          statusColor.withOpacity(0.05),
          Colors.transparent,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "AI VERDICT",
                style: AppTheme.bebas(
                  size: 16,
                  letterSpacing: 1.2,
                  color: isDark
                      ? AppColors.textMutedDark
                      : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Verdict text with gradient and shimmer
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final shimmerPosition = _shimmerController.value;

              return ShaderMask(
                shaderCallback: (bounds) {
                  // Calculate stops ensuring they're always valid
                  final double stop1 = (shimmerPosition - 0.3).clamp(0.0, 1.0);
                  final double stop2 = shimmerPosition.clamp(0.0, 1.0);
                  final double stop3 = (shimmerPosition + 0.3).clamp(0.0, 1.0);

                  // Ensure we have at least 2 unique stops
                  final stops = <double>[];
                  final colors = <Color>[];

                  if (stop1 < 1.0) {
                    stops.add(stop1);
                    colors.add(gradientColors[0]);
                  }

                  if (stop2 != stop1 && stop2 < 1.0) {
                    stops.add(stop2);
                    colors.add(gradientColors[1]);
                  }

                  if (stop3 != stop2 && stop3 <= 1.0) {
                    stops.add(stop3);
                    colors.add(gradientColors[0]);
                  }

                  // Fallback to simple gradient if we don't have enough stops
                  if (stops.length < 2) {
                    return LinearGradient(
                      colors: gradientColors,
                    ).createShader(bounds);
                  }

                  return LinearGradient(
                    colors: colors,
                    stops: stops,
                  ).createShader(bounds);
                },
                child: Text(
                  widget.result.verdict,
                  style: AppTheme.bebas(
                    size: 36,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Roast container with glassmorphism
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.03),
                  isDark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.01),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorderLight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.result.roast,
                    style: AppTheme.poppins(
                      size: 14,
                      color: isDark
                          ? AppColors.textDark.withOpacity(0.9)
                          : AppColors.textLight,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Red flags with animations
          if (widget.result.redFlags.isNotEmpty) ...[
            Text(
              "RED FLAGS DETECTED",
              style: AppTheme.bebas(
                size: 14,
                letterSpacing: 1,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.result.redFlags
                  .asMap()
                  .entries
                  .map((entry) => _AnimatedFlagChip(
                flag: entry.value,
                index: entry.key,
                isDark: isDark,
              ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// Animated Ring Gauge with gradient
class _AnimatedRingGauge extends StatelessWidget {
  const _AnimatedRingGauge({
    required this.value,
    required this.gradientColors,
    required this.pulseValue,
  });

  final int value;
  final List<Color> gradientColors;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0, 100);
    final size = 160.0;
    final strokeWidth = 12.0;

    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Container(
            width: size + (pulseValue * 20),
            height: size + (pulseValue * 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  gradientColors[0].withOpacity(0.3 * pulseValue),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Gradient ring
          CustomPaint(
            size: Size(size, size),
            painter: _GradientRingPainter(
              progress: safeValue / 100,
              colors: gradientColors,
              strokeWidth: strokeWidth,
            ),
          ),

          // Center value
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: gradientColors,
                ).createShader(bounds),
                child: Text(
                  "$safeValue",
                  style: AppTheme.bebas(
                    size: 56,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text(
                "SCORE",
                style: AppTheme.poppins(
                  size: 10,
                  color: gradientColors[0],
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for gradient ring
class _GradientRingPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final double strokeWidth;

  _GradientRingPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background circle
    final bgPaint = Paint()
      ..color = colors[0].withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Gradient progress arc
    final gradient = SweepGradient(
      colors: colors,
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + (2 * math.pi * progress),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Animated progress bar
class _AnimatedProgressBar extends StatelessWidget {
  const _AnimatedProgressBar({
    required this.value,
    required this.colors,
  });

  final double value;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 6,
      decoration: BoxDecoration(
        color: colors[0].withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(3),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Meta card with icon
class _MetaCard extends StatelessWidget {
  const _MetaCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.03),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.glassBorderDark.withOpacity(0.5)
              : AppColors.glassBorderLight.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: valueColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTheme.poppins(
                size: 13,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: valueColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              value,
              style: AppTheme.bebas(
                size: 14,
                color: valueColor,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated flag chip
class _AnimatedFlagChip extends StatefulWidget {
  const _AnimatedFlagChip({
    required this.flag,
    required this.index,
    required this.isDark,
  });

  final String flag;
  final int index;
  final bool isDark;

  @override
  State<_AnimatedFlagChip> createState() => _AnimatedFlagChipState();
}

class _AnimatedFlagChipState extends State<_AnimatedFlagChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        )),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..scale(_isHovered ? 1.05 : 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.vibrantPink.withOpacity(0.15),
                  AppColors.vibrantPurple.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? AppColors.vibrantPink.withOpacity(0.6)
                    : AppColors.vibrantPink.withOpacity(0.3),
                width: _isHovered ? 1.5 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: AppColors.vibrantPink.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🚩",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.flag,
                  style: AppTheme.poppins(
                    size: 12,
                    color: widget.isDark
                        ? AppColors.textDark.withOpacity(0.9)
                        : AppColors.textLight,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Premium glass card
class _PremiumGlassCard extends StatelessWidget {
  const _PremiumGlassCard({
    required this.child,
    required this.isDark,
    this.gradient,
  });

  final Widget child;
  final bool isDark;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient ??
            (isDark
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCard.withOpacity(0.6),
                AppColors.darkCard.withOpacity(0.4),
              ],
            )
                : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lightCard.withOpacity(0.8),
                Colors.white.withOpacity(0.6),
              ],
            )),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.glassBorderDark.withOpacity(0.5)
              : AppColors.glassBorderLight.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}