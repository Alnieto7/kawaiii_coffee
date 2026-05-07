import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  // 1. Tambahkan deklarasi variabel di sini
  final String totalPendapatan;
  final String totalTransaksi;
  final String lastUpdated;

  // 2. Masukkan ke dalam constructor dengan 'required'
  const SummaryCard({
    super.key,
    required this.totalPendapatan,
    required this.totalTransaksi,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Tambahkan sedikit shadow agar mirip seperti di desain
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TOTAL PENDAPATAN (HARI INI)",
            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          Text(
            totalPendapatan, // 3. Panggil variabel totalPendapatan di sini
            style: const TextStyle(
              fontSize: 24, // Sedikit dibesarkan agar mirip desain
              fontWeight: FontWeight.bold,
              color: Color(0xFFD97706),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Badge Hijau untuk Total Transaksi (Sesuai desain di gambar)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  totalTransaksi, // 4. Panggil variabel totalTransaksi
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lastUpdated, // 5. Panggil variabel lastUpdated
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}