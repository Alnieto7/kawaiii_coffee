// lib/Page/Kasir/CartSheetPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartItemList.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartPaymentSelector.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartSheetHandle.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartSheetHeader.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartTotalBar.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartSheetPage extends StatelessWidget {
  const CartSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(() {
      if (!cart.isOpen.value) return const SizedBox();

      return Stack(
        children: [
          // ── Backdrop: tap luar = tutup sheet ──────────────────────────
          GestureDetector(
            onTap: () => cart.isOpen.value = false,
            child: Container(
              color: Colors.black.withOpacity(0.4),
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // ── Sheet ──────────────────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            // 1. TAMBAHAN: Batasi maksimal tinggi sheet agar tidak bablas ke bawah layar
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CartSheetHandle(),
                    CartSheetHeader(cart: cart),
                    const Divider(height: 1, color: Color(0xFFEDE8DF)),

                    // 2. TAMBAHAN: Bungkus dengan Flexible agar list menyesuaikan sisa ruang
                    Flexible(child: CartItemList(cart: cart)),

                    CartPaymentSelector(cart: cart),
                    CartTotalBar(cart: cart),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
