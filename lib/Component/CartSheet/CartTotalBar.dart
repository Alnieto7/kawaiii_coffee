import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CardDialogs.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CartFormatHelper.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartTotalBar extends StatelessWidget {
  final CartController cart;
  const CartTotalBar({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEmpty = cart.items.isEmpty;
      final isLoading = cart.isLoading.value;

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Total tagihan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Tagihan",
                    style: TextStyle(fontSize: 12, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Rp ${formatRupiah(cart.total)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Tombol bayar
            ElevatedButton(
              onPressed: isLoading || isEmpty ? null : () => CartDialogs.showPayConfirm(cart),
              // 🔥 LOGIKA PEMBAYARAN BARU DI SINI 🔥
              onPressed: isLoading || isEmpty
                  ? null
                  : () {
                      if (cart.paymentMethod.value == 'cash') {
                        // 1. Munculkan pop-up input uang cash
                        cart.tampilkanInputCash();
                      } else if (cart.paymentMethod.value == 'qris') {
                        // 2. Langsung proses QRIS
                        cart.startQrisPayment();
                      } else {
                        // 3. Langsung proses E-Wallet / Midtrans
                        cart.startMidtransPayment();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.textOnPrimary,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded, size: 16),
                        SizedBox(width: 4),
                        Text("Bayar", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
            ),
          ],
        ),
      );
    });
  }
}