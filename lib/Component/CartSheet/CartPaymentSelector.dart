import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartPaymentSelector extends StatelessWidget {
  final CartController cart;
  const CartPaymentSelector({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Metode Pembayaran",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _PayChip(cart: cart, label: "Cash", value: "cash", icon: Icons.payments_rounded),
              const SizedBox(width: 8),
              _PayChip(cart: cart, label: "QRIS", value: "qris", icon: Icons.qr_code_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayChip extends StatelessWidget {
  final CartController cart;
  final String label;
  final String value;
  final IconData icon;

  const _PayChip({
    required this.cart,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final selected = cart.paymentMethod.value == value;
        return GestureDetector(
          onTap: () => cart.changePayment(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? AppColors.textOnPrimary : AppColors.secondary,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}