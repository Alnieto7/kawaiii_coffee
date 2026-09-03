import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class CartSheetHandle extends StatelessWidget {
  const CartSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}