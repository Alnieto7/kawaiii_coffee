import 'package:flutter/material.dart';

class DashboardTransactionCard extends StatelessWidget {
  final String title;
  final String time;
  final String price;

  const DashboardTransactionCard({
    super.key,
    required this.title,
    required this.time,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          Text('Rp $price', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}