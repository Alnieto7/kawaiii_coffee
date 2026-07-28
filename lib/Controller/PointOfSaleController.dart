import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Model/ProductModel.dart';
import 'package:kawaiii_coffee/Model/productingredient.dart';
import 'package:kawaiii_coffee/Provider/ProductProvider.dart';
import 'package:kawaiii_coffee/Provider/ProductIngredientProvider.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';

class PosController extends GetxController {
  // =========================
  // State Layout Responsif
  // =========================
  var isMobile = true.obs;

  void updateLayout(BoxConstraints constraints) {
    isMobile.value = constraints.maxWidth < 800;
  }

  // =========================
  // State POS & Cart
  // =========================
  final CartController cart = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'Semua'.obs;

  final _box = GetStorage();

  var products = <ProductModel>[].obs;

  // 👇 Tambahan: peta resep tiap produk (productId -> daftar bahan baku)
  var productIngredientsMap = <int, List<ProductIngredientModel>>{}.obs;

  final categories = ["Semua", "Coffee", "Non Coffee"];

  String get cashierName => _box.read('name') ?? 'Kasir';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // 🔥 FETCH PRODUCTS + RESEP
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final List<ProductModel> result = await ProductProvider.fetchProducts();
      products.assignAll(result);

      // Ambil resep tiap produk setelah produk berhasil di-load
      await _fetchAllProductIngredients(result);
    } catch (e) {
      SnackbarHelper.error(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 👇 Tambahan: ambil resep semua produk secara paralel
  Future<void> _fetchAllProductIngredients(List<ProductModel> productList) async {
    final Map<int, List<ProductIngredientModel>> map = {};

    await Future.wait(productList.map((p) async {
      try {
        final recipe = await ProductIngredientProvider.fetchByProduct(p.id);
        map[p.id] = recipe;
      } catch (e) {
        map[p.id] = []; // gagal fetch = anggap tidak ada resep (default: tersedia)
      }
    }));

    productIngredientsMap.assignAll(map);
  }

  // 👇 Tambahan: cek ketersediaan produk berdasarkan stok bahan baku
  bool isProductAvailable(int productId) {
    final recipe = productIngredientsMap[productId];
    if (recipe == null || recipe.isEmpty) return true;

    for (var item in recipe) {
      if (item.ingredient.stock < item.quantity) {
        return false;
      }
    }
    return true;
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

  void addToCart(ProductModel product) {
    // 👇 Tambahan: guard stok habis
    if (!isProductAvailable(product.id)) {
      SnackbarHelper.error(
        "Stok Habis",
        "${product.name} tidak bisa ditambahkan, bahan baku habis.",
      );
      return;
    }

    cart.addItem(
      id: product.id,
      name: product.name,
      price: product.sellingPrice,
      image: product.image,
    );

    SnackbarHelper.success(
      "Berhasil!",
      "${product.name} dimasukkan ke keranjang.",
    );
  }
}