import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final Map data;

  const TransactionItem({super.key, required this.data});

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
              Text(data['title']),
              Text(data['time'], style: const TextStyle(fontSize: 12)),
            ],
          ),
          Text('Rp ${data['price']}', style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }
}
