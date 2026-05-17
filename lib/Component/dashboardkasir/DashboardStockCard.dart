import 'package:flutter/material.dart';

class DashboardStockCard extends StatelessWidget {
  final String name;
  final String value;
  final String status;
  final Color statusBgColor;
  final Color statusTextColor;

  const DashboardStockCard({
    super.key,
    required this.name,
    required this.value,
    required this.status,
    required this.statusBgColor,
    required this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(status, style: TextStyle(fontSize: 10, color: statusTextColor, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(color: Colors.grey, fontSize: 13)), // Warna abu-abu
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)), // Hitam tebal
        ],
      ),
    );
  }
}