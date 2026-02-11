import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../state/scan_state.dart';

Future<void> generateCertificate(ScanResult result) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                "CERTIFICATE OF TOXICITY",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 24),

              pw.Text("Toxicity Score",
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text(
                "${result.toxicity}/100",
                style: pw.TextStyle(fontSize: 40),
              ),

              pw.SizedBox(height: 16),

              pw.Text(
                "Verdict: ${result.verdict}",
                style: pw.TextStyle(fontSize: 18),
              ),

              pw.SizedBox(height: 32),

              pw.Text(
                "Signed by AI Judge 🤖",
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (_) async => pdf.save(),
  );
}
