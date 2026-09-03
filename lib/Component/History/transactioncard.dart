import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final String code;
  final String price;
  final String time;
  final String items;
  final String cashier;
  final String status;

  const TransactionCard({
    super.key,
    required this.code,
    required this.price,
    required this.time,
    required this.items,
    required this.cashier,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = status == "done";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          // ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.coffee,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.successSurface
                            : AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDone
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "$time • $items • Cashier: $cashier",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          )
        ],
      ),
    );
  }
}