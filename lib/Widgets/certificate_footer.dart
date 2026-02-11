import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../themes/app_theme.dart';
import '../state/scan_state.dart';
import '../utils/certificate_pdf.dart';

class CertificateFooter extends StatelessWidget {
  const CertificateFooter({
    super.key,
    required this.spacing,
    required this.result,
  });

  final AppSpacing spacing;
  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Gold button (responsive)
        Align(
          alignment: spacing.isMobile ? Alignment.center : Alignment.centerRight,
          child: SizedBox(
            width: spacing.isMobile ? double.infinity : null,
            child: ElevatedButton(
              onPressed: () => generateCertificate(result), // UI-only now
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "DOWNLOAD TOXICITY CERTIFICATE",
                style: AppTheme.bebas(
                  size: spacing.isMobile ? 18 : 20,
                  color: Colors.black,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: spacing.gap24),

        // Footer row (responsive)
        if (spacing.isMobile)
          Column(
            children: [
              Text(
                "Built for mockups. No uploads stored.",
                style: TextStyle(color: Colors.white.withOpacity(0.42), fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Red Flag Scanner • v0.1",
                style: TextStyle(color: Colors.white.withOpacity(0.32), fontSize: 12),
              ),
            ],
          )
        else
          Row(
            children: [
              Text(
                "Built for mockups. No uploads stored.",
                style: TextStyle(color: Colors.white.withOpacity(0.42), fontSize: 12),
              ),
              const Spacer(),
              Text(
                "Red Flag Scanner • v0.1",
                style: TextStyle(color: Colors.white.withOpacity(0.32), fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }
}
