import 'package:datashield_frontend/Widgets/report_restaurant_sheet.dart';
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme.dart';

class WalletAlertBanner extends StatelessWidget {
  const WalletAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonRed.withOpacity(0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonRed.withOpacity(0.18),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.neonRed),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WALLET ALERT! CAFE SCAM DETECTED",
                  style: AppTheme.bebas(size: 20, color: AppColors.neonRed),
                ),
                Text(
                  "Is this a known scam spot?",
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ReportRestaurantSheet(),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.neonRed),
            child: const Text("REPORT 🚩", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}