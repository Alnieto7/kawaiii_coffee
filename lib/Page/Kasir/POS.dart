import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/CartSheet/CardFab.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Component/POS/category_chip.dart';
import 'package:kawaiii_coffee/Component/POS/productcard.dart';
import 'package:kawaiii_coffee/Page/Kasir/CartSheetPage.dart';

class PosPage extends StatelessWidget {
  PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PosController posController = Get.find<PosController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primarySurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.coffee, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kawaiii Coffee",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "Kasir: Ahmad Fauzi",
                            style: TextStyle(color: AppColors.textHint, fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded),
                        tooltip: "Notifikasi",
                      ),
                    ],
                  ),
                ),

                // Search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: posController.updateSearch,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search, color: AppColors.textHint),
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

                // Category chips
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

                // Product grid
                Expanded(
                  child: Obx(() {
                    if (posController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    }

                    final products = posController.filteredProducts;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text("Produk tidak ditemukan", style: TextStyle(color: AppColors.textHint)),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

            const CartSheetPage(),
            const CartFab(),
          ],
        ),
      ),
    );
  }
}