import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

import 'package:kawaiii_coffee/Component/Cart/cart_item_card.dart';
import 'package:kawaiii_coffee/Component/Cart/payment_button.dart';
import 'package:kawaiii_coffee/Component/Cart/total_section.dart';
import 'package:kawaiii_coffee/Component/Cart/checkout_button.dart';

class CartPage extends StatelessWidget {

  CartPage({super.key});

  final cart =
      Get.find<CartController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF9FAFB),

      appBar: AppBar(
        title: const Text("Keranjang"),
      ),

      body: Column(

        children: [

          // LIST ITEM
          Expanded(

            child: Obx(() {

              if (cart.items.isEmpty) {

                return const Center(
                  child: Text(
                    "Keranjang kosong",
                  ),
                );
              }

              return ListView.builder(

                padding:
                    const EdgeInsets.all(16),

                itemCount:
                    cart.items.length,

                itemBuilder:
                    (context, index) {

                  final item =
                      cart.items[index];

                  return CartItemCard(

                    item: item,

                    onAdd: () {
                      cart.increase(index);
                    },

                    onRemove: () {
                      cart.decrease(index);
                    },
                  );
                },
              );
            }),
          ),

          // FOOTER
          Container(

            padding:
                const EdgeInsets.all(16),

            decoration:
                const BoxDecoration(
              color: Colors.white,
            ),

            child: Column(

              children: [

                // PAYMENT
                Obx(() => Row(

                      children: [

                        PaymentButton(

                          title: "Cash",

                          selected:
                              cart.paymentMethod.value ==
                                  "cash",

                          onTap: () {
                            cart.changePayment(
                              "cash",
                            );
                          },
                        ),

                        const SizedBox(width: 8),

                        PaymentButton(

                          title: "QRIS",

                          selected:
                              cart.paymentMethod.value ==
                                  "qris",

                          onTap: () {
                            cart.changePayment(
                              "qris",
                            );
                          },
                        ),
                      ],
                    )),

                const SizedBox(height: 20),

                // TOTAL
                Obx(() => TotalSection(
                      total: cart.total,
                    )),

                const SizedBox(height: 20),

                // CHECKOUT
                Obx(() => CheckoutButton(

      isLoading:
          cart.isLoading.value,

      onTap: () async {

        final confirm =
            await Get.dialog<bool>(

          AlertDialog(

            title: const Text(
              "Konfirmasi Pembayaran",
            ),

            content: Text(
              "Bayar pesanan sebesar Rp ${cart.total} ?",
            ),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16),
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Get.back(
                    result: false,
                  );

                },

                child: const Text(
                  "Batal",
                ),
              ),

              ElevatedButton(

                onPressed: () {

                  Get.back(
                    result: true,
                  );

                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFFD97706,
                  ),
                ),

                child: const Text(
                  "Bayar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {

          if (cart.paymentMethod.value ==
              "qris") {

            await cart
                .startQrisPayment();

          } else {

            await cart.checkout();
          }
        }
      },
    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}