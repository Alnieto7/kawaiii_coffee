import 'package:flutter/material.dart';

class MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;
  final IconData icon;
  final Color iconColor;

  const MiniStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.subValue,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding horizontal sedikit dikurangi dari 16 ke 12 agar teks punya ruang ekstra
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),

              // --- FIX OVERFLOW DI SINI ---
              // Expanded mencegah Row memakan tempat melebihi lebar layar
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ), // Font diperkecil sedikit ke 11
                  maxLines: 1, // Memaksa teks hanya 1 baris
                  overflow: TextOverflow
                      .ellipsis, // Jika mentok, akan menjadi "Jumlah Trans..."
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),

              // Dibungkus Expanded juga untuk berjaga-jaga jika angkanya nanti sangat besar
              Expanded(
                child: Text(
                  subValue,
                  style: TextStyle(
                    fontSize: 12,
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
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
