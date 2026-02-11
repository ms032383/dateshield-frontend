import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../Widgets/app_nav_bar.dart'; // AppBar integration
import 'red_flag_swipe_screen.dart'; // Swipe game import

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);

    return Scaffold(
      backgroundColor: AppColors.pitchBlack,
      // Layering: AppBar on top of content
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: spacing.pagePaddingX,
                right: spacing.pagePaddingX,
                top: 100, // Space for NavBar
                bottom: spacing.pagePaddingY,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "DATA SHIELD ARCADE",
                      style: AppTheme.bebas(size: 40, letterSpacing: 2)
                  ),
                  Text(
                      "Level up your relationship IQ.",
                      style: TextStyle(color: Colors.white.withOpacity(0.6))
                  ),
                  const SizedBox(height: 32),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: spacing.isMobile ? 1 : 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.5,
                      children: [
                        // 🚩 RED FLAG SWIPE GAME
                        _GameCard(
                          title: "RED FLAG SWIPE",
                          subtitle: "Quick reflexes to spot toxicity.",
                          icon: Icons.flag_rounded,
                          color: AppColors.neonRed,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RedFlagSwipeScreen()),
                            );
                          },
                        ),

                        // 🛡️ SCAM SURVIVOR QUIZ
                        _GameCard(
                          title: "SCAM SURVIVOR",
                          subtitle: "Can you spot the cafe scam?",
                          icon: Icons.shield_rounded,
                          color: AppColors.neonGreen,
                          onTap: () {
                            // TODO: Add ScamSurvivorQuizScreen navigation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Quiz mode loading... 🛡️")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Persistent NavBar
          const Positioned(top: 0, left: 0, right: 0, child: AppNavBar()),
        ],
      ),
    );
  }
}

// _GameCard class remains the same
class _GameCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 48),
            const SizedBox(height: 16),
            Text(title, style: AppTheme.bebas(size: 24, color: color)),
            Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)
            ),
          ],
        ),
      ),
    );
  }
}