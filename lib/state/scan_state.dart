import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ScamRisk { low, medium, high }

class ScanResult {
  final int toxicity;
  final ScamRisk risk;
  final String verdict;
  final String roast;
  final List<String> redFlags;
  final Map<String, String> replies;
  final double confidence;
  final String extractedText; // <--- Add this

  const ScanResult({
    required this.toxicity,
    required this.risk,
    required this.verdict,
    required this.roast,
    required this.redFlags,
    required this.replies,
    required this.confidence,
    required this.extractedText, // <--- Add this
  });
}

// UI ke liye mock provider logic
final scanResultProvider = StateProvider<ScanResult?>((ref) => const ScanResult(
  toxicity: 85,
  risk: ScamRisk.high,
  verdict: "RUN BRO",
  roast: "She insists on 'Cafe 69' because she gets commission. Block her.",
  redFlags: ["Urgency to meet", "Unknown location", "Payment push"],
  replies: {
    "sigma": "Not interested. Bye.",
    "classy": "I don't think we are a match.",
    "ghost": "..."
  },
  confidence: 0.99,
  // Mock extracted text
  extractedText: "Hey! Let's meet at Cafe 69 today. Pay 500 for entry first.",
));