import 'package:flutter/material.dart';

class TotalFloatCard extends StatelessWidget {
  final String totalValue;

  const TotalFloatCard({super.key, required this.totalValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD97706), // ✅ Oranye baru
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('TOTAL HARI INI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Text(totalValue, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}