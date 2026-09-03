import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class ReceiptTotalRow extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const ReceiptTotalRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}