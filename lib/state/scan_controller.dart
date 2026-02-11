import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'scan_state.dart';

final scanControllerProvider =
StateNotifierProvider<ScanController, AsyncValue<ScanResult?>>(
      (ref) => ScanController(),
);

class ScanController extends StateNotifier<AsyncValue<ScanResult?>> {
  // Ek hi Dio instance define karein options ke saath
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://dateshield-backend-production.up.railway.app",
      connectTimeout: const Duration(seconds: 120), // 2 minutes for Render cold start
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
      headers: {"Accept": "application/json"},
    ),
  );

  // SIRF EK CONSTRUCTOR: Isme super call aur warm-up dono honge
  ScanController() : super(const AsyncValue.data(null)) {
    _warmUpBackend();
  }

  // 💤 Render server ko 'spin up' karne ke liye logic
  Future<void> _warmUpBackend() async {
    try {
      // Root URL hit karke server ko jagaana
      await _dio.get('/');
      debugPrint("Backend is waking up...");
    } catch (e) {
      debugPrint("Warm-up ping sent (Server might be sleeping).");
    }
  }

  // Baki scan logic aur helper functions yahan aayenge...
  ScanResult _parseResponse(Map<String, dynamic> data) {
    return ScanResult(
      toxicity: (data["toxicity_score"] ?? 0) as int,
      risk: _parseRisk(data["scam_risk"]),
      verdict: data["verdict"] ?? "UNKNOWN",
      roast: data["roast"] ?? "",
      redFlags: List<String>.from(data["red_flags"] ?? []),
      replies: Map<String, String>.from(data["suggested_replies"] ?? {}),
      confidence: (data["confidence"] ?? 0.0).toDouble(),
      extractedText: data["extracted_text"] ?? "",
    );
  }
  /// Initial Image Scan (OCR + Analysis)
  Future<void> scan({
    required List<int> bytes,
    required String filename,
    String hint = "",
  }) async {
    state = const AsyncValue.loading();
    try {
      final formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes, filename: filename),
        "hint": hint,
      });

      final res = await _dio.post("/scan", data: formData);

      if (res.statusCode == 200) {
        state = AsyncValue.data(_parseResponse(res.data));
      } else {
        throw Exception("Server Error: ${res.statusCode}");
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Manual Refine Scan (JSON based Re-analysis)
  Future<void> scanText({
    required String youText,
    required String otherText,
  }) async {
    state = const AsyncValue.loading();
    try {
      final res = await _dio.post(
        "/scan_text", // New endpoint for manual split
        data: {
          "you_text": youText,
          "other_text": otherText,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      if (res.statusCode == 200) {
        state = AsyncValue.data(_parseResponse(res.data));
      } else {
        throw Exception("Server Error: ${res.statusCode}");
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  ScamRisk _parseRisk(String? risk) {
    switch (risk?.toUpperCase()) {
      case "HIGH":
        return ScamRisk.high;
      case "MEDIUM":
        return ScamRisk.medium;
      case "LOW":
      default:
        return ScamRisk.low;
    }
  }
}