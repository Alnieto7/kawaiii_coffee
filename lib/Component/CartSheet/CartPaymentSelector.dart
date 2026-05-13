// lib/Component/Cart/cart_payment_selector.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              color: Color(0xFF9C8A70),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _PayChip(
                cart: cart,
                label: "Cash",
                value: "cash",
                icon: Icons.payments_rounded,
              ),
              const SizedBox(width: 8),
              _PayChip(
                cart: cart,
                label: "QRIS",
                value: "qris",
                icon: Icons.qr_code_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Private: satu chip metode bayar ───────────────────────────────────────
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
              color: selected
                  ? const Color(0xFFD97706)
                  : const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? Colors.white : const Color(0xFFB08040),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF8C7560),
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
