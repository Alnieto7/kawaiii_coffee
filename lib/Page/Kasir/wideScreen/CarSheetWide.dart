import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartItemList.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartPaymentSelector.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartTotalBar.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartSheetWide extends StatelessWidget {
  const CartSheetWide({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    // 🔥 KUNCI PERBAIKAN: Bungkus seluruh Column dengan Obx
    // Agar CartItemList dan CartTotalBar otomatis ter-refresh saat ada pesanan baru!
    return Obx(() => Column(
          children: [
            // Header keranjang khusus tampilan lebar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Daftar Item",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "${cart.items.length} Produk",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.divider),
            
            // List item belanjaan
            Flexible(child: CartItemList(cart: cart)),
            const Divider(height: 1, color: AppColors.divider),
            
            // Pilihan metode pembayaran
            CartPaymentSelector(cart: cart),
            
            // Total harga dan tombol bayar
            CartTotalBar(cart: cart),
          ],
        ));
  }
}