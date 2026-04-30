import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String code;
  final String price;
  final String time;
  final String items;
  final String cashier;
  final String status;

  const TransactionCard({
    super.key,
    required this.code,
    required this.price,
    required this.time,
    required this.items,
    required this.cashier,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status == "done";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          // ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFCECDD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.coffee, color: Color(0xFFD97706)),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(code,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDone ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDone ? Colors.green : Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text("$time • $items • Cashier: $cashier",
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}