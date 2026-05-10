import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Model/ProductModel.dart';
import 'package:kawaiii_coffee/Provider/ProductProvider.dart';


class PosController extends GetxController {
  // Logic tetap sama, pastikan CartController di-import dengan benar
  final CartController cart = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'Semua'.obs;

  // Menggunakan List<ProductModel> yang sudah ter-import
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
      // Pastikan class di ProductProvider bernama ProductProvider (bukan ProductService)
      final List<ProductModel> result = await ProductProvider.fetchProducts();

      // Menggunakan .assignAll untuk mengupdate RxList
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

  // 🔍 FILTERED PRODUCTS
  List<ProductModel> get filteredProducts {
    return products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );

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
