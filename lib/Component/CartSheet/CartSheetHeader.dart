// lib/Component/Cart/cart_sheet_header.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CardDialogs.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartSheetHeader extends StatelessWidget {
  final CartController cart;
  const CartSheetHeader({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Icon basket
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_basket_rounded,
              color: Color(0xFFD97706),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),

          // Judul + jumlah item
          Obx(
            () => Text(
              "Keranjang (${cart.items.length})",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: Color(0xFF1A1008),
              ),
            ),
          ),
          const Spacer(),

          // Tombol hapus semua
          Obx(
            () => TextButton.icon(
              onPressed: cart.items.isEmpty
                  ? null
                  : () => CartDialogs.showClearConfirm(cart),
              icon: const Icon(Icons.delete_sweep_rounded, size: 16),
              label: const Text("Hapus Semua"),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                textStyle: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
