import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/cart_menuController.dart';


class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(() {
      if (!cart.isOpen.value) {
        return const SizedBox();
      }

      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 320, // 🔥 FIX HEIGHT
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ],
          ),

          child: Column(
            children: [

              // 🔻 HANDLE
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // 🔻 HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        "Keranjang (${cart.items.length})",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                    onPressed: cart.clearCart,
                    child: const Text("Hapus Semua"),
                  )
                ],
              ),

              const SizedBox(height: 8),

              // 🔥 LIST ITEM (SCROLLABLE)
              Expanded(
                child: Obx(() {
                  if (cart.items.isEmpty) {
                    return const Center(
                      child: Text(
                        "Keranjang kosong",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, i) {
                      final item = cart.items[i];

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor:
                                  Color(0xFFFCECDD),
                              child: Icon(Icons.coffee,
                                  color: Color(0xFFD97706)),
                            ),

                            const SizedBox(width: 10),

                            // 🔻 INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold)),
                                  Text("Rp ${item.price}",
                                      style: const TextStyle(
                                          color: Colors.grey)),
                                ],
                              ),
                            ),

                            // 🔻 QTY
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      cart.decrease(i),
                                  icon: const Icon(
                                      Icons.remove),
                                ),
                                Text(item.qty.toString()),
                                IconButton(
                                  onPressed: () =>
                                      cart.increase(i),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 8),

              // 🔻 PAYMENT
              Row(
                children: [
                  _payButton("Cash", "cash"),
                  _payButton("QRIS", "qris"),
                  _payButton("E-Wallet", "ewallet"),
                ],
              ),

              const SizedBox(height: 10),

              // 🔻 TOTAL
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        "Rp ${cart.total}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                    onPressed: cart.checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD97706),
                    ),
                    child: const Text("Bayar"),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

// 🔻 PAYMENT BUTTON
Widget _payButton(String title, String value) {
  final cart = Get.find<CartController>();

  return Expanded(
    child: Obx(() => GestureDetector(
          onTap: () => cart.changePayment(value),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: cart.paymentMethod.value == value
                    ? const Color(0xFFD97706)
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(title)),
          ),
        )),
  );
}