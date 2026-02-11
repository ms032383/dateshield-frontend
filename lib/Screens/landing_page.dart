import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../themes/app_theme.dart';
import '../themes/app_colors.dart';
import '../themes/app_gradients.dart';
import '../themes/theme_provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage>
    with TickerProviderStateMixin {
  Offset _cursorPos = const Offset(500, 500);
  late AnimationController _heartBeatController;
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _heartBeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _heartBeatController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _cursorPos = event.localPosition;
          });
        },
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppGradients.backgroundDark
                      : AppGradients.backgroundLight,
                ),
              ),
            ),

            // Animated particles
            ..._buildFloatingParticles(isDark),

            // Cursor glow effect
            _buildCursorGlow(isDark),

            // Theme toggle button (top right)
            Positioned(
              top: 20,
              right: 20,
              child: _ThemeToggleButton(isDark: isDark),
            ),

            // Main content
            SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: [
                    _buildHeroSection(isDark, theme),
                    const SizedBox(height: 80),
                    _buildFeaturesSection(isDark, theme),
                    const SizedBox(height: 80),
                    _buildHowItWorksSection(isDark, theme),
                    const SizedBox(height: 80),
                    _buildStatsSection(isDark, theme),
                    const SizedBox(height: 80),
                    _buildCTASection(isDark, theme),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isDark, ThemeData theme) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated heart with shield
            _buildAnimatedHero(isDark),
            const SizedBox(height: 40),

            // Brand name
            ShaderMask(
              shaderCallback: (bounds) => AppGradients.vibrantGradient.createShader(bounds),
              child: Text(
                "RED FLAG SCANNER",
                style: AppTheme.bebas(
                  size: 64,
                  letterSpacing: 6,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // Tagline
            Text(
              "AI-Powered Toxic Chat Detector for Gen-Z",
              style: AppTheme.poppins(
                size: 18,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                weight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Upload screenshots, get instant vibes check. We scan for red flags, toxic patterns & scams. No cap.",
                style: AppTheme.poppins(
                  size: 16,
                  color: isDark
                      ? AppColors.textMutedDark.withOpacity(0.7)
                      : AppColors.textMutedLight,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),

            // CTA Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _ModernButton(
                  text: "START SCANNING",
                  icon: Icons.upload_rounded,
                  isPrimary: true,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                _ModernButton(
                  text: "WATCH DEMO",
                  icon: Icons.play_circle_outline_rounded,
                  isPrimary: false,
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Trust badge
            _buildTrustBadge(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedHero(bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _heartBeatController,
        _glowController,
        _rotateController,
      ]),
      builder: (context, child) {
        final scale = 1.0 + (_heartBeatController.value * 0.08);
        final glow = 0.4 + (_glowController.value * 0.3);

        return Container(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.vibrantPink.withOpacity(glow * 0.5),
                      AppColors.vibrantPurple.withOpacity(glow * 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Rotating gradient ring
              Transform.rotate(
                angle: _rotateController.value * 2 * math.pi,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        AppColors.vibrantPink,
                        AppColors.vibrantPurple,
                        AppColors.vibrantCyan,
                        AppColors.vibrantPink,
                      ],
                      stops: const [0.0, 0.33, 0.66, 1.0],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppColors.darkBg : AppColors.lightBg,
                    ),
                  ),
                ),
              ),

              // Heart icon
              Transform.scale(
                scale: scale,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.vibrantPink,
                        AppColors.vibrantPurple,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.vibrantPink.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),

              // Shield check
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.vibrantCyan,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.vibrantCyan.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrustBadge(bool isDark) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatController.value * 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.vibrantPink.withOpacity(0.1),
                  AppColors.vibrantPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark
                    ? AppColors.glassBorderDark
                    : AppColors.glassBorderLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: AppColors.vibrantCyan,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "15,000+ Chats Analyzed",
                  style: AppTheme.poppins(
                    size: 13,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesSection(bool isDark, ThemeData theme) {
    final features = [
      {
        'icon': Icons.psychology_rounded,
        'title': 'AI Toxicity Detection',
        'desc': 'Detects manipulation, gaslighting & sus behavior patterns instantly',
        'color': AppColors.vibrantPink,
      },
      {
        'icon': Icons.shield_rounded,
        'title': 'Scam Shield',
        'desc': 'Identifies catfishing, crypto scams & financial fraud in real-time',
        'color': AppColors.vibrantPurple,
      },
      {
        'icon': Icons.emoji_emotions_rounded,
        'title': 'Savage Roasts',
        'desc': 'Get brutally honest AI verdicts with Gen-Z humor & memes',
        'color': AppColors.vibrantYellow,
      },
      {
        'icon': Icons.chat_bubble_rounded,
        'title': 'Smart Replies',
        'desc': 'Pre-written responses: Sigma mode, Classy mode, or Ghost mode',
        'color': AppColors.vibrantCyan,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            "WHY WE'RE DIFFERENT",
            style: AppTheme.bebas(
              size: 42,
              letterSpacing: 4,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: features
                .map((f) => _FeatureCard(
              feature: f,
              isDark: isDark,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection(bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            "HOW IT WORKS",
            style: AppTheme.bebas(
              size: 42,
              letterSpacing: 4,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 50),
          _StepsTimeline(isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isDark, ThemeData theme) {
    final stats = [
      {'value': '99.8%', 'label': 'ACCURACY', 'icon': Icons.analytics_rounded},
      {'value': '<2s', 'label': 'SCAN TIME', 'icon': Icons.speed_rounded},
      {'value': '15K+', 'label': 'HEARTS SAVED', 'icon': Icons.favorite_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(50),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.vibrantPink.withOpacity(0.1),
            AppColors.vibrantPurple.withOpacity(0.1),
            AppColors.vibrantCyan.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 60,
        runSpacing: 40,
        alignment: WrapAlignment.center,
        children: stats
            .map((s) => Column(
          children: [
            Icon(
              s['icon'] as IconData,
              color: AppColors.vibrantPink,
              size: 32,
            ),
            const SizedBox(height: 12),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppGradients.vibrantGradient.createShader(bounds),
              child: Text(
                s['value'] as String,
                style: AppTheme.bebas(
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              s['label'] as String,
              style: AppTheme.poppins(
                size: 12,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ))
            .toList(),
      ),
    );
  }

  Widget _buildCTASection(bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppGradients.vibrantGradient.createShader(bounds),
            child: Text(
              "READY TO SCAN?",
              style: AppTheme.bebas(
                size: 48,
                letterSpacing: 6,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Join thousands protecting their peace",
            style: AppTheme.poppins(
              size: 16,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 30),
          _ModernButton(
            text: "GET STARTED FREE",
            icon: Icons.rocket_launch_rounded,
            isPrimary: true,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCursorGlow(bool isDark) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          left: _cursorPos.dx - 250,
          top: _cursorPos.dy - 250,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.vibrantPink.withOpacity(isDark ? 0.1 : 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          left: _cursorPos.dx - 150,
          top: _cursorPos.dy - 150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.vibrantCyan.withOpacity(isDark ? 0.1 : 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFloatingParticles(bool isDark) {
    return List.generate(20, (index) {
      final random = math.Random(index);
      final colors = [
        AppColors.vibrantPink,
        AppColors.vibrantPurple,
        AppColors.vibrantCyan,
        AppColors.vibrantYellow,
      ];

      return AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final offset = math.sin(
            (_floatController.value * 2 * math.pi) + (index * 0.3),
          ) *
              30;

          return Positioned(
            left: (index * 150) % 1500.0,
            top: ((index * 300) % 900.0) + offset,
            child: Transform.rotate(
              angle: random.nextDouble() * math.pi,
              child: Icon(
                index % 4 == 0
                    ? Icons.favorite
                    : index % 4 == 1
                    ? Icons.star
                    : index % 4 == 2
                    ? Icons.auto_awesome
                    : Icons.circle,
                size: 8 + (index % 12).toDouble(),
                color: colors[index % colors.length]
                    .withOpacity(isDark ? 0.05 : 0.03),
              ),
            ),
          );
        },
      );
    });
  }
}

// Theme Toggle Button Widget
class _ThemeToggleButton extends ConsumerWidget {
  final bool isDark;

  const _ThemeToggleButton({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.vibrantPink.withOpacity(0.2),
            AppColors.vibrantPurple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(themeModeProvider.notifier).state =
            isDark ? ThemeMode.light : ThemeMode.dark;
          },
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? AppColors.vibrantYellow : AppColors.vibrantPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isDark ? "LIGHT" : "DARK",
                  style: AppTheme.bebas(
                    size: 14,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                    letterSpacing: 1,
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

// Modern Button Widget
class _ModernButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _ModernButton({
    required this.text,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? AppGradients.primaryButton
                : null,
            borderRadius: BorderRadius.circular(12),
            border: !widget.isPrimary
                ? Border.all(
              color: AppColors.vibrantPink,
              width: 2,
            )
                : null,
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: AppColors.vibrantPink.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.isPrimary
                          ? Colors.white
                          : (isDark ? AppColors.textDark : AppColors.vibrantPink),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.text,
                      style: AppTheme.bebas(
                        size: 18,
                        color: widget.isPrimary
                            ? Colors.white
                            : (isDark ? AppColors.textDark : AppColors.vibrantPink),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Feature Card Widget
class _FeatureCard extends StatefulWidget {
  final Map<String, dynamic> feature;
  final bool isDark;

  const _FeatureCard({
    required this.feature,
    required this.isDark,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -8.0 : 0.0),
        width: 280,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: widget.isDark
              ? AppGradients.cardGradientDark
              : AppGradients.cardGradientLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? (widget.feature['color'] as Color).withOpacity(0.5)
                : (widget.isDark
                ? AppColors.glassBorderDark
                : AppColors.glassBorderLight),
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color:
              (widget.feature['color'] as Color).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (widget.feature['color'] as Color).withOpacity(0.2),
                    (widget.feature['color'] as Color).withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.feature['icon'],
                color: widget.feature['color'],
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.feature['title'],
              style: AppTheme.bebas(
                size: 20,
                letterSpacing: 1.5,
                color: widget.isDark ? AppColors.textDark : AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              widget.feature['desc'],
              style: AppTheme.poppins(
                size: 14,
                color: widget.isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Steps Timeline Widget
class _StepsTimeline extends StatelessWidget {
  final bool isDark;

  const _StepsTimeline({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'number': '1',
        'title': 'Upload Screenshot',
        'desc': 'Drop your sus chat screenshot',
        'icon': Icons.upload_file_rounded,
      },
      {
        'number': '2',
        'title': 'AI Analysis',
        'desc': 'AI scans for red flags & toxicity',
        'icon': Icons.psychology_rounded,
      },
      {
        'number': '3',
        'title': 'Get Verdict',
        'desc': 'Receive score + savage roast',
        'icon': Icons.analytics_rounded,
      },
      {
        'number': '4',
        'title': 'Choose Reply',
        'desc': 'Pick your response vibe',
        'icon': Icons.send_rounded,
      },
    ];

    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      children: steps
          .asMap()
          .entries
          .map((entry) => _StepCard(
        step: entry.value,
        index: entry.key,
        isDark: isDark,
      ))
          .toList(),
    );
  }
}

class _StepCard extends StatelessWidget {
  final Map<String, dynamic> step;
  final int index;
  final bool isDark;

  const _StepCard({
    required this.step,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.vibrantPink,
      AppColors.vibrantPurple,
      AppColors.vibrantCyan,
      AppColors.vibrantYellow,
    ];

    return Container(
      width: 240,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors[index].withOpacity(0.3),
                  colors[index].withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: colors[index],
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                step['icon'],
                color: colors[index],
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step['title'],
            style: AppTheme.bebas(
              size: 20,
              letterSpacing: 1.5,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            step['desc'],
            style: AppTheme.poppins(
              size: 13,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}