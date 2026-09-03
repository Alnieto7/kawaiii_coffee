import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class InfoCard extends StatelessWidget {
  final bool isActive;
  final String duration;

  const InfoCard({
    super.key,
    required this.isActive,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 5,
                backgroundColor:
                    isActive ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 8),
              Text(
                isActive ? 'AKTIF' : 'NONAKTIF',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            duration,
            style: const TextStyle(
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}