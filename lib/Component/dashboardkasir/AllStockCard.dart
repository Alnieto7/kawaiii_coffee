import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class AllStockCard extends StatelessWidget {
  final String name;
  final String qty;
  final String status;
  final Color statusBgColor;
  final Color statusTextColor;

  const AllStockCard({
    super.key,
    required this.name,
    required this.qty,
    required this.status,
    required this.statusBgColor,
    required this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    qty,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}