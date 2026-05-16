import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Model/ProductModel.dart';
import 'package:kawaiii_coffee/Provider/ProductProvider.dart';

class PosController extends GetxController {
  // Gunakan find jika CartController sudah di-inject di binding/main
  // atau put jika belum ada
  final CartController cart = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.find<CartController>();

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'Semua'.obs;
  var products = <ProductModel>[].obs;

  final categories = ["Semua", "Coffee", "Non Coffee"];

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // 🔥 FETCH API
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await ProductProvider.fetchProducts();
      products.assignAll(result);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🔍 FILTERED PRODUCTS (Gunakan .where untuk reaktivitas)
  List<ProductModel> get filteredProducts {
    return products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );

      // Normalisasi kategori agar case-insensitive jika perlu
      final matchCategory = selectedCategory.value == "Semua"
          ? true
          : p.categoryName.toLowerCase() ==
                selectedCategory.value.toLowerCase();

      return matchSearch && matchCategory;
    }).toList();
  }

  void updateSearch(String value) => searchQuery.value = value;

  void changeCategory(String category) => selectedCategory.value = category;

  // 🛒 ADD TO CART
  void addToCart(ProductModel product) {
    cart.addItem(
      id: product.id,
      name: product.name,
      price: product.sellingPrice,
      image: product.image,
    );
  }
}
