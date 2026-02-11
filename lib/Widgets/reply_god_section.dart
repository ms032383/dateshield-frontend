import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../state/scan_state.dart';
import '../themes/app_spacing.dart';
import '../themes/app_theme.dart';
import '../themes/app_colors.dart';

class ReplyGodSection extends StatefulWidget {
  const ReplyGodSection({
    super.key,
    required this.spacing,
    required this.result,
  });

  final AppSpacing spacing;
  final ScanResult result;

  @override
  State<ReplyGodSection> createState() => _ReplyGodSectionState();
}

class _ReplyGodSectionState extends State<ReplyGodSection>
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

  void _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.vibrantCyan, AppColors.vibrantPurple],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Text(
              "Copied to clipboard! ✨",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard
            : AppColors.lightCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sigma = widget.result.replies["sigma"] ?? "Not interested. Bye.";
    final classy = widget.result.replies["classy"] ?? "I don't think we're a match. Take care.";
    final ghost = widget.result.replies["ghost"] ?? "...";

    return _PremiumGlassCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.vibrantPink.withOpacity(0.2),
                      AppColors.vibrantPurple.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.vibrantPink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.vibrantPink, AppColors.vibrantPurple],
                      ).createShader(bounds),
                      child: Text(
                        "REPLY GOD",
                        style: AppTheme.bebas(size: 28, letterSpacing: 1.5, color: Colors.white),
                      ),
                    ),
                    Text(
                      "Pick your vibe. Tap to copy.",
                      style: AppTheme.poppins(
                        size: 13,
                        color: isDark
                            ? AppColors.textMutedDark.withOpacity(0.7)
                            : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Reply tiles with animations
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _AnimatedReplyTile(
                title: "Sigma Mode",
                emoji: "🗿",
                body: sigma,
                gradient: LinearGradient(
                  colors: [
                    AppColors.vibrantPink.withOpacity(0.15),
                    AppColors.vibrantPurple.withOpacity(0.15),
                  ],
                ),
                borderColor: AppColors.vibrantPink,
                icon: Icons.whatshot_rounded,
                width: widget.spacing.isMobile ? double.infinity : 300,
                onTap: () => _copy(context, sigma),
                isDark: isDark,
              ),
              _AnimatedReplyTile(
                title: "Classy Mode",
                emoji: "🧘",
                body: classy,
                gradient: LinearGradient(
                  colors: [
                    AppColors.vibrantPurple.withOpacity(0.15),
                    AppColors.vibrantCyan.withOpacity(0.15),
                  ],
                ),
                borderColor: AppColors.vibrantPurple,
                icon: Icons.workspace_premium_rounded,
                width: widget.spacing.isMobile ? double.infinity : 300,
                onTap: () => _copy(context, classy),
                isDark: isDark,
              ),
              _AnimatedReplyTile(
                title: "Ghost Mode",
                emoji: "👻",
                body: ghost,
                gradient: LinearGradient(
                  colors: [
                    AppColors.vibrantCyan.withOpacity(0.15),
                    AppColors.vibrantGreen.withOpacity(0.15),
                  ],
                ),
                borderColor: AppColors.vibrantCyan,
                icon: Icons.visibility_off_rounded,
                width: widget.spacing.isMobile ? double.infinity : 300,
                onTap: () => _copy(context, ghost),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedReplyTile extends StatefulWidget {
  const _AnimatedReplyTile({
    required this.title,
    required this.emoji,
    required this.body,
    required this.gradient,
    required this.borderColor,
    required this.icon,
    required this.width,
    required this.onTap,
    required this.isDark,
  });

  final String title;
  final String emoji;
  final String body;
  final Gradient gradient;
  final Color borderColor;
  final IconData icon;
  final double width;
  final VoidCallback onTap;
  final bool isDark;

  @override
  State<_AnimatedReplyTile> createState() => _AnimatedReplyTileState();
}

class _AnimatedReplyTileState extends State<_AnimatedReplyTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: widget.width,
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? widget.borderColor
                    : widget.borderColor.withOpacity(0.3),
                width: _isHovered ? 2 : 1.5,
              ),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: widget.borderColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.borderColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: AppTheme.bebas(
                                size: 18,
                                letterSpacing: 1.2,
                                color: widget.isDark
                                    ? AppColors.textDark
                                    : AppColors.textLight,
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _isHovered
                                    ? 1.0 + (_pulseController.value * 0.1)
                                    : 1.0,
                                child: Icon(
                                  Icons.content_copy_rounded,
                                  size: 18,
                                  color: widget.borderColor,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.isDark
                              ? Colors.black.withOpacity(0.2)
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.body,
                          style: AppTheme.poppins(
                            size: 14,
                            color: widget.isDark
                                ? AppColors.textDark.withOpacity(0.9)
                                : AppColors.textLight,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumGlassCard extends StatelessWidget {
  const _PremiumGlassCard({
    required this.child,
    required this.isDark,
  });

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
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
        ),
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