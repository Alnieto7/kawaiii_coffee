import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transaksi Penjualan',
            style: TextStyle(color: AppColors.textOnPrimary),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textOnPrimary,
          ),
        ],
      ),
    );
  }
}