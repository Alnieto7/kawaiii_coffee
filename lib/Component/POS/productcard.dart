import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final VoidCallback? onAddToCart;
  final bool isOutOfStock; // 👈 param baru

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    this.onAddToCart,
    this.isOutOfStock = false, // 👈 default false biar card lama yang belum pakai param ini tetap aman
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isOutOfStock ? null : onAddToCart, // disable tap kalau habis
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0, // buram kalau habis
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.inputBorder,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Container(
                            color: AppColors.inputFill,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Badge "Stok Habis" — nutup seluruh area gambar
                    if (isOutOfStock)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Container(
                            color: Colors.black.withOpacity(0.45),
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "STOK HABIS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Icon tambah keranjang — sembunyikan kalau habis
                    if (!isOutOfStock)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.backgroundWhite,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // TEXT
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}