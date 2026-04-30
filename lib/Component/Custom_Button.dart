import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isOutlined; // True untuk tombol bergaris (sekunder), False untuk oranye (utama)

  const CustomButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isOutlined = false, // Default-nya tombol oranye
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      // --- TOMBOL SEKUNDER (Garis Abu-abu) ---
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFF374151), size: 18),
        label: Text(label, style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    // --- TOMBOL UTAMA (Background Oranye) ---
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD97217),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}