import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../themes/app_theme.dart';
import '../themes/app_colors.dart';

class RedFlagSwipeScreen extends StatefulWidget {
  const RedFlagSwipeScreen({super.key});

  @override
  State<RedFlagSwipeScreen> createState() => _RedFlagSwipeScreenState();
}

class _RedFlagSwipeScreenState extends State<RedFlagSwipeScreen> {
  int score = 0;
  int currentIndex = 0;

  // Real scenarios based on your backend logic
  final List<Map<String, dynamic>> scenarios = [
    {"text": "Hey! Meet me at Cafe 69. Pay 500 entry fee now.", "isRed": true},
    {"text": "Let's meet at the Central Mall for coffee?", "isRed": false},
    {"text": "Send me your WhatsApp. I don't use this app much.", "isRed": true},
    {"text": "I'd love to know more about your hobbies first!", "isRed": false},
    {"text": "Emergency! I need 200 rs for petrol. Send on GPay.", "isRed": true},
  ];

  void _handleSwipe(bool userSwipedRed) {
    if (scenarios[currentIndex]['isRed'] == userSwipedRed) {
      setState(() => score += 10);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CORRECT! +10"), duration: Duration(milliseconds: 500)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WRONG! That was a trap."), backgroundColor: Colors.red),
      );
    }

    if (currentIndex < scenarios.length - 1) {
      setState(() => currentIndex++);
    } else {
      _showGameOver();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scenario = scenarios[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.pitchBlack,
      appBar: AppBar(
        title: Text("SCORE: $score", style: AppTheme.bebas(size: 24)),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // THE SWIPE CARD
            _SwipeCard(text: scenario['text']),

            const SizedBox(height: 50),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  label: "GREEN FLAG",
                  color: AppColors.neonGreen,
                  onTap: () => _handleSwipe(false),
                ),
                const SizedBox(width: 30),
                _ActionButton(
                  label: "RED FLAG",
                  color: AppColors.neonRed,
                  onTap: () => _handleSwipe(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("GAME OVER", style: AppTheme.bebas(size: 32, color: AppColors.neonRed)),
        content: Text("Your Final Score: $score", style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
            child: const Text("EXIT"),
          ),
        ],
      ),
    );
  }
}

class _SwipeCard extends StatelessWidget {
  final String text;
  const _SwipeCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ).animate(key: ValueKey(text)).fadeIn().scale();
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: AppTheme.bebas(size: 18, color: color)),
      ),
    );
  }
}