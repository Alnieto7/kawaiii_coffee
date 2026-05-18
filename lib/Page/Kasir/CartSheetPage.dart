import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
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
          // Backdrop
          GestureDetector(
            onTap: () => cart.isOpen.value = false,
            child: Container(
              color: AppColors.backgroundOverlay,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CartSheetHandle(),
                    CartSheetHeader(cart: cart),
                    const Divider(height: 1, color: AppColors.divider),
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