// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
// import 'package:kawaiii_coffee/Model/ProductModel.dart';
// import 'package:kawaiii_coffee/Model/productingredient.dart';
// import 'package:kawaiii_coffee/Provider/ProductProvider.dart';
// import 'package:kawaiii_coffee/Provider/ProductIngredientProvider.dart'; // 👈 tambahan
// import 'package:kawaiii_coffee/snackbarhelper.dart';

// class PosController extends GetxController {
//   final CartController cart = Get.isRegistered<CartController>()
//       ? Get.find<CartController>()
//       : Get.find<CartController>();

//   var isLoading = false.obs;
//   var searchQuery = ''.obs;
//   var selectedCategory = 'Semua'.obs;
//   var products = <ProductModel>[].obs;
//   var productIngredientsMap = <int, List<ProductIngredientModel>>{}.obs;

//   final categories = ["Semua", "Coffee", "Non Coffee"];

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   // 🔥 FETCH PRODUCTS + RESEP
//   Future<void> fetchProducts() async {
//     try {
//       isLoading.value = true;
//       final result = await ProductProvider.fetchProducts();
//       products.assignAll(result);

//       // Ambil resep tiap produk setelah produk berhasil di-load
//       await _fetchAllProductIngredients(result);
//     } catch (e) {
//       SnackbarHelper.error(
//         "Error",
//         e.toString().replaceAll('Exception: ', ''),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   //AMBIL RESEP SEMUA PRODUK SECARA PARALEL
//   Future<void> _fetchAllProductIngredients(List<ProductModel> productList) async {
//     final Map<int, List<ProductIngredientModel>> map = {};

//     await Future.wait(productList.map((p) async {
//       try {
//         final recipe = await ProductIngredientProvider.fetchByProduct(p.id);
//         map[p.id] = recipe;
//       } catch (e) {
//         // Kalau fetch resep gagal untuk 1 produk, anggap tidak ada resep (default: tersedia)
//         map[p.id] = [];
//       }
//     }));

//     productIngredientsMap.assignAll(map);
//   }

//   //CEK APAKAH PRODUK MASIH BISA DIJUAL (berdasarkan stok bahan baku)
//   bool isProductAvailable(int productId) {
//     final recipe = productIngredientsMap[productId];
//     if (recipe == null || recipe.isEmpty) return true; // tidak ada resep = anggap selalu tersedia

//     for (var item in recipe) {
//       if (item.ingredient.stock < item.quantity) {
//         return false; // salah satu bahan baku kurang → produk habis
//       }
//     }
//     return true;
//   }

//   //FILTERED PRODUCTS
//   List<ProductModel> get filteredProducts {
//     return products.where((p) {
//       final matchSearch = p.name.toLowerCase().contains(
//         searchQuery.value.toLowerCase(),
//       );

//       final matchCategory = selectedCategory.value == "Semua"
//           ? true
//           : p.categoryName.toLowerCase() ==
//                 selectedCategory.value.toLowerCase();

//       return matchSearch && matchCategory;
//     }).toList();
//   }

//   void updateSearch(String value) => searchQuery.value = value;

//   void changeCategory(String category) => selectedCategory.value = category;

//   //ADD TO CART (dengan guard stok habis)
//   void addToCart(ProductModel product) {
//     if (!isProductAvailable(product.id)) {
//       SnackbarHelper.error(
//         "Stok Habis",
//         "${product.name} tidak bisa ditambahkan, bahan baku habis.",
//       );
//       return;
//     }

//     cart.addItem(
//       id: product.id,
//       name: product.name,
//       price: product.sellingPrice,
//       image: product.image,
//     );
//     SnackbarHelper.success("Berhasil!", "${product.name} dimasukkan ke keranjang.");
//   }
// }