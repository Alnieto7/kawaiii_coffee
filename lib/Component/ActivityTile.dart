import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final bool isWarning;

  const ActivityTile({
    super.key, 
    required this.title, 
    required this.subtitle, 
    required this.value, 
    required this.isWarning
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Jika warning background-nya sedikit merah muda, jika tidak putih
        color: isWarning ? const Color(0xFFFFF5F5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isWarning ? Colors.red.shade100 : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // --- IKON LINGKARAN KIRI ---
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isWarning ? Colors.red.withOpacity(0.1) : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWarning ? Icons.priority_high_rounded : Icons.shopping_cart_outlined,
              color: isWarning ? Colors.red : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          
          // --- BAGIAN TENGAH (TEKS) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                    color: isWarning ? Colors.red.shade700 : const Color(0xFF1F2937)
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: const TextStyle(fontSize: 12, color: Colors.grey)
                ),
              ],
            ),
          ),
          
          // --- BAGIAN KANAN (HARGA / PANAH) ---
          if (value.isNotEmpty && !isWarning)
            Text(
              value, 
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Color(0xFFD97217), // Warna oranye Coffee Street
                fontSize: 14
              )
            ),
            
          // Tampilkan panah (chevron) jika ini adalah warning/stok menipis
          if (isWarning)
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}