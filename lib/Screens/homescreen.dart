import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widgets/app_nav_bar.dart';
import '../Widgets/certificate_footer.dart';
import '../Widgets/header_section.dart';
import '../Widgets/info_panel.dart';
import '../Widgets/refine_text_panel.dart';
import '../Widgets/reply_god_section.dart';
import '../Widgets/result_grid.dart';
import '../Widgets/wallet_alert.dart';
import '../Widgets/siren_overlay.dart'; // Fixed SirenOverlay import
import '../state/scan_controller.dart';
import '../themes/app_gradients.dart';
import '../themes/app_spacing.dart';
import '../state/scan_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = AppSpacing.of(context);
    final scanAsync = ref.watch(scanControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // LAYER 1: Background (Ye hamesha sabse neeche hona chahiye)
          Positioned.fill(
            child: Container(decoration: const BoxDecoration(gradient: AppGradients.background)),
          ),

          // LAYER 2: Main Logic & Content
          scanAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
            error: (err, stack) => Center(
              child: Text("Error: $err", style: const TextStyle(color: Colors.white)),
            ),
            data: (scan) {
              final bool isHighRisk = scan != null && scan.risk == ScamRisk.high;

              return Stack(
                children: [
                  // Siren Overlay (Background layer for high risk)
                  if (isHighRisk) const Positioned.fill(child: SirenOverlay()),

                  // Main Scrollable Content
                  SafeArea(
                    child: SingleChildScrollView(
                      // Top padding di hai taaki NavBar ke liye jagah bache
                      padding: EdgeInsets.only(
                        left: spacing.pagePaddingX,
                        right: spacing.pagePaddingX,
                        bottom: spacing.pagePaddingY,
                        top: 80,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // HEADER section
                              if (spacing.isMobile) ...[
                                HeaderSection(spacing: spacing),
                                SizedBox(height: spacing.gap24),
                                InfoPanel(spacing: spacing),
                              ] else ...[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 7, child: HeaderSection(spacing: spacing)),
                                    SizedBox(width: spacing.gap20),
                                    Expanded(flex: 5, child: InfoPanel(spacing: spacing)),
                                  ],
                                ),
                              ],

                              SizedBox(height: spacing.gap24),

                              // WALLET ALERT
                              if (isHighRisk) ...[
                                const WalletAlertBanner(),
                                SizedBox(height: spacing.gap24),
                              ],

                              // RESULTS
                              if (scan != null) ...[
                                RefineTextPanel(spacing: spacing, result: scan),
                                SizedBox(height: spacing.gap24),
                                ResultGrid(spacing: spacing, result: scan),
                                SizedBox(height: spacing.gap24),
                                ReplyGodSection(spacing: spacing, result: scan),
                                SizedBox(height: spacing.gap24),
                                CertificateFooter(spacing: spacing, result: scan),
                              ],
                              const SizedBox(height: 40),
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

          // LAYER 3: AppNavBar (Ye sabse upar hona chahiye taaki clicks chalein)
          const Positioned(top: 0, left: 0, right: 0, child: AppNavBar()),
        ],
      ),
    );
  }
}