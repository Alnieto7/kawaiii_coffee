import 'package:flutter/material.dart';

class SettingSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const SettingSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD97217), size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child, // Isi dari masing-masing card akan masuk ke sini
        ],
      ),
    );
  }
}