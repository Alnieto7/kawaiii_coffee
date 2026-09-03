import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class TransactionItem extends StatelessWidget {
  final Map data;

  const TransactionItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                data['time'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            'Rp ${data['price']}',
            style: const TextStyle(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}