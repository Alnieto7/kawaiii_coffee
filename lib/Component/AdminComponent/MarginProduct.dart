import 'package:flutter/material.dart';

class MarginProductItem extends StatelessWidget {
  final String name;
  final String sellPrice;
  final String hpp;
  final String marginPercent;
  final String marginValue;
  final bool isLoss;

  const MarginProductItem({
    super.key,
    required this.name,
    required this.sellPrice,
    required this.hpp,
    required this.marginPercent,
    required this.marginValue,
    required this.isLoss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLoss ? const Color(0xFFFFF5F5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          // Border kiri warna merah jika rugi
          left: BorderSide(color: isLoss ? Colors.red : Colors.transparent, width: 4),
          top: BorderSide(color: isLoss ? Colors.red.shade100 : Colors.grey.shade100),
          right: BorderSide(color: isLoss ? Colors.red.shade100 : Colors.grey.shade100),
          bottom: BorderSide(color: isLoss ? Colors.red.shade100 : Colors.grey.shade100),
        ),
        boxShadow: [
          if (!isLoss) BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kolom 1: Nama & Harga Jual
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isLoss ? Colors.red.shade800 : Colors.black87)),
                    if (isLoss) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 14),
                    ]
                  ],
                ),
                const SizedBox(height: 6),
                Text("Jual: $sellPrice", style: TextStyle(fontSize: 11, color: isLoss ? Colors.red.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          
          // Kolom 2: HPP
          Expanded(
            flex: 1,
            child: Text(hpp, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: isLoss ? Colors.red.shade600 : Colors.grey.shade700)),
          ),
          
          // Kolom 3: Margin
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(marginPercent, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isLoss ? Colors.red : Colors.green)),
                const SizedBox(height: 4),
                Text(marginValue, style: TextStyle(fontSize: 10, color: isLoss ? Colors.red.shade400 : Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}