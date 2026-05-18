import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

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
        color: isWarning ? const Color(0xFFFFF5F5) : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isWarning ? AppColors.warning : AppColors.border),
      ),
      child: Row(
        children: [
          // --- IKON LINGKARAN KIRI ---
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isWarning ? AppColors.warning.withOpacity(0.1) : AppColors.border  ,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWarning ? Icons.priority_high_rounded : Icons.shopping_cart_outlined,
              color: isWarning ? AppColors.warning : AppColors.textSecondary,
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
                    color: isWarning ? AppColors.error : const Color(0xFF1F2937)
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)
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
                color: AppColors.primary, // Warna oranye Coffee Street
                fontSize: 14
              )
            ),
            
          // Tampilkan panah (chevron) jika ini adalah warning/stok menipis
          if (isWarning)
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

