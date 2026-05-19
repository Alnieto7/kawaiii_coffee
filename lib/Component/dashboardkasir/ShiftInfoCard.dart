import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

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
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor: statusColor,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Struk Hari Ini',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  Text(
                    statusText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}