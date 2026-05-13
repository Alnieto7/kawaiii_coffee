// lib/Page/Kasir/PosPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CardFab.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Component/POS/category_chip.dart';
import 'package:kawaiii_coffee/Component/POS/productcard.dart';
import 'package:kawaiii_coffee/Page/Kasir/CartSheetPage.dart';

class PosPage extends StatelessWidget {
  PosPage({super.key});

  final PosController posController = Get.find<PosController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Main content ─────────────────────────────────────────────
            Column(
              children: [
                // ── Header ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCECDD),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.coffee,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Coffee Street",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Kasir: Ahmad Fauzi",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Notifikasi saja — icon keranjang diganti FAB
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded),
                        tooltip: "Notifikasi",
                      ),
                    ],
                  ),
                ),

                // ── Search ─────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: posController.updateSearch,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        hintText: "Cari menu kopi...",
                        border: InputBorder.none,
                        suffixIcon: Obx(() {
                          if (posController.searchQuery.value.isNotEmpty) {
                            return IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => posController.updateSearch(''),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Category chips ─────────────────────────────────────────
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: posController.categories.length,
                    itemBuilder: (context, index) {
                      final cat = posController.categories[index];
                      return Obx(
                        () => CategoryChip(
                          label: cat,
                          selected: posController.selectedCategory.value == cat,
                          onTap: () => posController.changeCategory(cat),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ── Product grid ───────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (posController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = posController.filteredProducts;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          "Produk tidak ditemukan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      // Padding bawah biar produk tidak tertutup FAB
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          title: product.name,
                          price: "Rp ${product.sellingPrice}",
                          image: product.image,
                          onAddToCart: () => posController.addToCart(product),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),

            // ── Cart sheet overlay ────────────────────────────────────────
            const CartSheetPage(),

            // ── Floating cart button ──────────────────────────────────────
            const CartFab(),
          ],
        ),
      ),
    );
  }
}
