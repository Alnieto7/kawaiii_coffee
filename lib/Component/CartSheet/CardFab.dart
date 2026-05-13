// lib/Component/Cart/cart_fab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartFormatHelper.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartFab extends StatelessWidget {
  const CartFab({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(() {
      final count = cart.items.length;
      final total = cart.total;
      final isOpen = cart.isOpen.value;

      // Jika cart kosong dan sheet tertutup, sembunyikan FAB
      if (count == 0 && !isOpen) return const SizedBox();

      return Positioned(
        bottom: 24,
        left: 20,
        right: 20,
        child: GestureDetector(
          onTap: () => cart.isOpen.value = !cart.isOpen.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 60,
            decoration: BoxDecoration(
              color: isOpen ? const Color(0xFF1A1008) : const Color(0xFFD97706),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color:
                      (isOpen
                              ? const Color(0xFF1A1008)
                              : const Color(0xFFD97706))
                          .withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // ── Icon keranjang + badge ──────────────────────────
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isOpen
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.shopping_basket_rounded,
                          key: ValueKey(isOpen),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      if (!isOpen && count > 0)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD97706),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              "$count",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFD97706),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  // ── Label ──────────────────────────────────────────
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isOpen
                          ? const Text(
                              "Tutup Keranjang",
                              key: ValueKey('close'),
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          : Text(
                              "$count item ditambahkan",
                              key: const ValueKey('open'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),

                  // ── Total ──────────────────────────────────────────
                  if (!isOpen)
                    Text(
                      "Rp ${formatRupiah(total)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),

                  if (isOpen)
                    const Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
