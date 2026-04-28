import 'package:flutter/material.dart';

class StockCard extends StatelessWidget {
  final Map data;

  const StockCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['name']),
          const SizedBox(height: 8),
          Text(data['value'], style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(data['status'], style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}