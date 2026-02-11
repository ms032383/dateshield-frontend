import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../themes/app_theme.dart';

class ReportRestaurantSheet extends StatefulWidget {
  const ReportRestaurantSheet({super.key});

  @override
  State<ReportRestaurantSheet> createState() => _ReportRestaurantSheetState();
}

class _ReportRestaurantSheetState extends State<ReportRestaurantSheet> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF120012), // Deep purple/black vibe
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("REPORT SCAM HUB", style: AppTheme.bebas(size: 32, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(
            "Help others by reporting restaurants that use commission-based dating scams.",
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
          ),
          const SizedBox(height: 20),

          _buildTextField("RESTAURANT NAME", _nameController, Icons.restaurant_rounded),
          const SizedBox(height: 16),
          _buildTextField("LOCATION / CITY", _locationController, Icons.location_on_rounded),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: POST to backend: /report-scam
                // Body: { "name": _nameController.text, "location": _locationController.text }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("RESTAURANT REPORTED. STAY SAFE! 🚩")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonRed),
              child: const Text("SUBMIT REPORT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.neonRed, fontSize: 12),
        prefixIcon: Icon(icon, color: AppColors.neonRed, size: 20),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.neonRed)),
      ),
    );
  }
}