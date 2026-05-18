import 'package:flutter/material.dart';

class ShiftInfoCard extends StatelessWidget {
  final Color statusColor;
  final String statusText;    
  final String durationText;  // Akan menampung nama produk terlaris

  const ShiftInfoCard({
    super.key,
    required this.statusColor,
    required this.statusText,
    required this.durationText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD97706), // Tetap warna oranye yang kamu minta
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 5, backgroundColor: statusColor),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Transaksi', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  Text(statusText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 👇 UBAH LABEL TEKS DI SINI 👇
              const Text('Produk Terlaris', style: TextStyle(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 2),
              Text(
                durationText, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                overflow: TextOverflow.ellipsis, // Mencegah teks kepanjangan jika nama produk panjang
              ),
            ],
          )
        ],
      ),
    );
  }
}