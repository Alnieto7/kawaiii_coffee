import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Component/POS/category_chip.dart';
import 'package:kawaiii_coffee/Component/POS/productcard.dart';
import 'package:kawaiii_coffee/Page/Kasir/CartSheetPage.dart';

class PosWide extends StatelessWidget {
  PosWide({super.key});

  @override
  Widget build(BuildContext context) {
    final PosController posController = Get.find<PosController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.coffee, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kawaiii Coffee",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                        const Spacer(),
                        
                        // Search Bar
                        SizedBox(
                          width: 300,
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
                      ],
                    ),
                  ),

                  // Category chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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

                  const SizedBox(height: 24),

                  // Product grid (3 Kolom)
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
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, 
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
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
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade200, width: 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(-5, 0),
                    )
                  ]
                ),
                child: Column(
                  children: [
                    // Header Keranjang yang Elegan
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart_outlined, color: AppColors.primary, size: 28),
                          const SizedBox(width: 12),
                          const Text(
                            "Detail Pesanan",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    
                    // Render halaman CartSheet dengan Expanded agar tidak kolaps
                    const Expanded(
                      child: ClipRRect(
                        child: CartSheetPage(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}