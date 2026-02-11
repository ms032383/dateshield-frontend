import 'package:flutter/material.dart';

import '../themes/app_spacing.dart';
import '../themes/app_theme.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key, required this.spacing});
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("HOW IT WORKS",
                  style: AppTheme.bebas(size: 26, letterSpacing: 1.3)),
              const SizedBox(height: 10),

              _BulletRow(
                title: "Red Flags detected",
                sub: "We scan patterns like urgency, payment push, shady spots.",
              ),
              const SizedBox(height: 10),
              _BulletRow(
                title: "Scam Risk scored",
                sub: "LOW / MEDIUM / HIGH — wallet safety first.",
              ),
              const SizedBox(height: 10),
              _BulletRow(
                title: "Replies generated",
                sub: "Sigma / Classy / Ghost — tap to copy.",
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.gap16),
        _GlassCard(
          child: Text(
            "PROTOTYPE NOTE: This UI is a mock. No chat screenshots are stored.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              height: 1.35,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.title, required this.sub});
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  height: 1.3,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: child,
    );
  }
}
