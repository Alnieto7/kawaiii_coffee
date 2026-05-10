import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartSheetPage extends StatelessWidget {
  const CartSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Obx(() {
      // Jika panel tidak terbuka, sembunyikan widget
      if (!cart.isOpen.value) {
        return const SizedBox();
      }

      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 350, // Sedikit ditinggikan agar lebih lega
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              // 🔻 HANDLE (Visual indicator untuk sheet)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Keranjang (${cart.items.length})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: cart.clearCart,
                    child: const Text(
                      "Hapus Semua",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 🔥 LIST ITEM (SCROLLABLE)
              Expanded(
                child: cart.items.isEmpty
                    ? const Center(
                        child: Text(
                          "Keranjang kosong",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, i) {
                          final item = cart.items[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFFFCECDD),
                                  child: Icon(
                                    Icons.coffee,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // 🔻 INFO ITEM
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Rp ${item.price}",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 🔻 KONTROL QTY
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => cart.decrease(i),
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      item.qty.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => cart.increase(i),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        size: 20,
                                        color: Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const Divider(),

              // 🔻 PEMILIHAN METODE PEMBAYARAN
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Metode Bayar:",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _payButton("Cash", "cash"),
                  _payButton("QRIS", "qris"),
                  _payButton("E-Wallet", "ewallet"),
                ],
              ),

              const SizedBox(height: 16),

              // 🔻 TOTAL & CHECKOUT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Tagihan",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        "Rp ${cart.total}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),

                  // TOMBOL BAYAR DENGAN LOADING STATE
                  SizedBox(
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: cart.isLoading.value
                          ? null
                          : () {
                              // Cek metode bayar dan panggil fungsi yang sesuai
                              if (cart.paymentMethod.value == 'qris') {
                                cart.startQrisPayment();
                              } else if (cart.paymentMethod.value ==
                                  'ewallet') {
                                cart.startMidtransPayment();
                              } else {
                                cart.checkout();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: cart.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Bayar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // 🔻 WIDGET TOMBOL PEMBAYARAN (Internal helper)
  Widget _payButton(String title, String value) {
    final cart = Get.find<CartController>();

    return Expanded(
      child: Obx(() {
        final isSelected = cart.paymentMethod.value == value;
        return GestureDetector(
          onTap: () => cart.changePayment(value),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFD97706).withOpacity(0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFD97706)
                    : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFFD97706) : Colors.black54,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
