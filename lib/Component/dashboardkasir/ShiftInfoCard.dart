import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class ShiftInfoCard extends StatelessWidget {
  final Color statusColor;
  final String statusText;
  final String durationText;

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
                    'Status Shift',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Durasi Kerja',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textOnPrimary,
                ),
              ),
              Text(
                durationText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}