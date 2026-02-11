import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_theme.dart';
import '../themes/app_gradients.dart';
import '../state/scan_controller.dart';

class HeaderSection extends ConsumerStatefulWidget {
  const HeaderSection({super.key, required this.spacing});

  final AppSpacing spacing;

  @override
  ConsumerState<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late AnimationController _buttonController;
  late AnimationController _pillsController;

  @override
  void initState() {
    super.initState();

    // Glow pulse animation for background ambiance
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Staggered entrance animations
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _subtitleController.forward();
    });

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _buttonController.forward();
    });

    _pillsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _pillsController.forward();
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _buttonController.dispose();
    _pillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = widget.spacing;
    final scanState = ref.watch(scanControllerProvider);

    // Check if image is loaded - adjust state name based on your state class
    final hasImage = scanState.maybeWhen(
      data: (result) => true,
      orElse: () => false,
    );

    // Get filename - will show "Image loaded" when data exists
    final filename = scanState.maybeWhen(
      data: (result) => "Image loaded",
      orElse: () => "No file loaded",
    );

    return Stack(
      children: [
        // Animated glow background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.5,
                    colors: [
                      AppColors.vibrantPink
                          .withOpacity(0.08 + _glowController.value * 0.07),
                      AppColors.vibrantPurple
                          .withOpacity(0.05 + _glowController.value * 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Main content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated title with glitch effect
            _AnimatedTitle(
              controller: _titleController,
              spacing: spacing,
            ),

            const SizedBox(height: 6),

            // Animated subtitle
            _AnimatedSubtitle(
              controller: _subtitleController,
              spacing: spacing,
            ),

            SizedBox(height: spacing.gap16),

            // Upload section with animation
            _AnimatedUploadSection(
              controller: _buttonController,
              spacing: spacing,
              hasImage: hasImage,
              filename: filename,
            ),

            SizedBox(height: spacing.gap20),

            // Animated status pills
            _AnimatedStatusPills(
              controller: _pillsController,
              glowController: _glowController,
            ),
          ],
        ),
      ],
    );
  }
}

// === ANIMATED TITLE WITH GLITCH EFFECT ===
class _AnimatedTitle extends StatelessWidget {
  const _AnimatedTitle({
    required this.controller,
    required this.spacing,
  });

  final AnimationController controller;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: Stack(
          children: [
            // Glitch shadow effect
            Transform.translate(
              offset: const Offset(-2, -2),
              child: Text(
                "RED FLAG SCANNER",
                style: AppTheme.bebas(
                  size: spacing.isMobile ? 44 : 64,
                  letterSpacing: 2.4,
                  color: AppColors.vibrantCyan.withOpacity(0.3),
                ),
              ),
            ),
            // Main title with gradient
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.vibrantPink,
                  AppColors.vibrantPurple,
                  Colors.white,
                ],
              ).createShader(bounds),
              child: Text(
                "RED FLAG SCANNER",
                style: AppTheme.bebas(
                  size: spacing.isMobile ? 44 : 64,
                  letterSpacing: 2.4,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === ANIMATED SUBTITLE ===
class _AnimatedSubtitle extends StatelessWidget {
  const _AnimatedSubtitle({
    required this.controller,
    required this.spacing,
  });

  final AnimationController controller;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: Row(
          children: [
            // Blinking indicator
            _BlinkingIndicator(),
            const SizedBox(width: 8),
            Text(
              "Saves your Heart AND your Wallet.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: spacing.isMobile ? 13 : 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// === BLINKING INDICATOR ===
class _BlinkingIndicator extends StatefulWidget {
  @override
  State<_BlinkingIndicator> createState() => _BlinkingIndicatorState();
}

class _BlinkingIndicatorState extends State<_BlinkingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: AppColors.vibrantPink,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.vibrantPink.withOpacity(0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// === ANIMATED UPLOAD SECTION ===
class _AnimatedUploadSection extends StatelessWidget {
  const _AnimatedUploadSection({
    required this.controller,
    required this.spacing,
    required this.hasImage,
    required this.filename,
  });

  final AnimationController controller;
  final AppSpacing spacing;
  final bool hasImage;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PulsingUploadButton(isMobile: spacing.isMobile),
            if (hasImage) ...[
              const SizedBox(height: 12),
              _FileLoadedIndicator(filename: filename),
            ],
          ],
        ),
      ),
    );
  }
}

// === PULSING UPLOAD BUTTON ===
class _PulsingUploadButton extends ConsumerStatefulWidget {
  const _PulsingUploadButton({required this.isMobile});

  final bool isMobile;

  @override
  ConsumerState<_PulsingUploadButton> createState() =>
      _PulsingUploadButtonState();
}

class _PulsingUploadButtonState extends ConsumerState<_PulsingUploadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isHovering = false;

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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.vibrantPink
                      .withOpacity(0.3 + _pulseController.value * 0.3),
                  blurRadius: 20 + _pulseController.value * 15,
                  spreadRadius: _pulseController.value * 5,
                ),
              ],
            ),
            child: child,
          );
        },
        child: AnimatedScale(
          scale: _isHovering ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: ElevatedButton.icon(
            onPressed: () async {
              try {
                final picker = ImagePicker();
                final xfile =
                await picker.pickImage(source: ImageSource.gallery);
                if (xfile == null) return;

                final bytes = await xfile.readAsBytes();

                ref.read(scanControllerProvider.notifier).scan(
                  bytes: bytes,
                  filename: xfile.name,
                  hint: "",
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Upload failed: $e"),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.upload_rounded, size: 24),
            label: Text(
              "UPLOAD CHAT SCREENSHOT",
              style: AppTheme.bebas(
                size: widget.isMobile ? 18 : 20,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vibrantPink,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isMobile ? 20 : 32,
                vertical: widget.isMobile ? 16 : 20,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// === FILE LOADED INDICATOR ===
class _FileLoadedIndicator extends StatelessWidget {
  const _FileLoadedIndicator({required this.filename});

  final String filename;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.vibrantGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.vibrantGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.vibrantGreen,
            size: 18,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "Loaded: $filename",
              style: TextStyle(
                color: AppColors.vibrantGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// === ANIMATED STATUS PILLS ===
class _AnimatedStatusPills extends StatelessWidget {
  const _AnimatedStatusPills({
    required this.controller,
    required this.glowController,
  });

  final AnimationController controller;
  final AnimationController glowController;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatusPill(
              top: "SIGNAL",
              bottom: "BRUTAL",
              color: AppColors.vibrantPink,
              delay: 0,
              glowController: glowController,
            ),
            _StatusPill(
              top: "SCAM SHIELD",
              bottom: "ARMED",
              color: AppColors.vibrantPurple,
              delay: 100,
              glowController: glowController,
            ),
            _StatusPill(
              top: "OUTPUT",
              bottom: "VIRAL",
              color: AppColors.vibrantCyan,
              delay: 200,
              glowController: glowController,
            ),
          ],
        ),
      ),
    );
  }
}

// === STATUS PILL WITH GLOW ===
class _StatusPill extends StatefulWidget {
  const _StatusPill({
    required this.top,
    required this.bottom,
    required this.color,
    required this.delay,
    required this.glowController,
  });

  final String top;
  final String bottom;
  final Color color;
  final int delay;
  final AnimationController glowController;

  @override
  State<_StatusPill> createState() => _StatusPillState();
}

class _StatusPillState extends State<_StatusPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
      child: AnimatedBuilder(
        animation: widget.glowController,
        builder: (context, child) {
          return Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.color.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(
                    0.1 + widget.glowController.value * 0.15,
                  ),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.top,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      widget.color,
                      widget.color.withOpacity(0.8),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    widget.bottom,
                    style: AppTheme.bebas(
                      size: 22,
                      letterSpacing: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}