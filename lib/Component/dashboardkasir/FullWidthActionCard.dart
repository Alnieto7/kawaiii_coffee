import 'package:flutter/material.dart';

class ActionMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const ActionMenuCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD97706).withOpacity(0.15), // ✅ Oranye pudar untuk background icon
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFD97706), size: 28), // ✅ Oranye baru untuk icon
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}