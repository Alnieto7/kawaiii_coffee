import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

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
        children: const [
          Text("TOTAL PENDAPATAN (HARI INI)",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 8),
          Text(
            "Rp 2.450.000",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD97706),
            ),
          ),
          SizedBox(height: 8),
          Text("32 TRANSAKSI • Terakhir diperbarui 2 menit lalu",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}