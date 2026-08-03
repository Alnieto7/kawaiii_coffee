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
  var isMobile = true.obs;

  void updateLayout(BoxConstraints constraints) {
    isMobile.value = constraints.maxWidth < 600;
  }

  bool isProductAvailable(int productId) {
    final recipe = productIngredientsMap[productId];
    if (recipe == null || recipe.isEmpty) return true;
    for (var item in recipe) {
      if (item.ingredient.stock < item.quantity) return false;
    }
    return true;
  }

  final CartController cart = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'Semua'.obs;

  final _box = GetStorage();
  var products = <ProductModel>[].obs;
  var productIngredientsMap = <int, List<ProductIngredientModel>>{}.obs;
  final categories = ["Semua", "Coffee", "Non Coffee"];

  String get cashierName => _box.read('name') ?? 'Kasir';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final List<ProductModel> result = await ProductProvider.fetchProducts();
      products.assignAll(result);
      await _fetchAllProductIngredients(result);
    } catch (e) {
      SnackbarHelper.error("Error", e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAllProductIngredients(
    List<ProductModel> productList,
  ) async {
    final Map<int, List<ProductIngredientModel>> map = {};
    await Future.wait(
      productList.map((p) async {
        try {
          final recipe = await ProductIngredientProvider.fetchByProduct(p.id);
          map[p.id] = recipe;
        } catch (e) {
          map[p.id] = [];
        }
      }),
    );
    productIngredientsMap.assignAll(map);
  }

  // 🔥 UPDATE LOGIKA: Sekarang menghitung SISA porsi (Database dikurangi isi Keranjang)
  // 🔥 UPDATE LOGIKA: Sekarang menghitung SISA porsi (Database dikurangi isi Keranjang)
  int calculateMaxPortions(int productId) {
    final recipe = productIngredientsMap[productId];
    if (recipe == null) return 0;
    if (recipe.isEmpty) return 999;

    // 1. Hitung total pemakaian bahan baku yang SAAT INI SUDAH ADA di keranjang
    Map<int, int> usedIngredients = {};
    for (var cartItem in cart.items) {
      final cartRecipe = productIngredientsMap[cartItem.id];
      if (cartRecipe != null) {
        for (var item in cartRecipe) {
          int usedQty = (item.quantity * cartItem.qty).toInt();
          int ingId = item.ingredient.id ?? 0;
          usedIngredients[ingId] = (usedIngredients[ingId] ?? 0) + usedQty;
        }
      }
    }

    // 2. Hitung sisa stok bahan baku yang masih bisa dipakai
    int maxPortions = 999999;
    for (var item in recipe) {
      if (item.quantity > 0) {
        int ingId = item.ingredient.id ?? 0;
        int usedQty = usedIngredients[ingId] ?? 0;

        // 🔥 FIX: Paksa stok dari database dan takaran menjadi integer (bulat)
        int stockDb = item.ingredient.stock.toInt();
        int takaran = item.quantity.toInt();

        int remainingStock = stockDb - usedQty;

        // Pembagian bulat yang sudah dipastikan sama-sama int
        int possiblePortions = remainingStock > 0
            ? (remainingStock ~/ takaran)
            : 0;

        if (possiblePortions < maxPortions) {
          maxPortions = possiblePortions;
        }
      }
    }

    return maxPortions == 999999 ? 0 : maxPortions;
  }

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
    // Karena logic-nya sudah menghitung sisa, maxStock sekarang berarti "Sisa Porsi"
    final maxStock = calculateMaxPortions(product.id);

    if (maxStock <= 0) {
      SnackbarHelper.error(
        "Stok Habis",
        "${product.name} tidak bisa ditambahkan lagi, bahan baku sudah mentok di keranjang.",
      );
      return;
    }

    bool isSuccess = cart.addItem(
      id: product.id,
      name: product.name,
      price: product.sellingPrice,
      image: product.image,
      stock: maxStock,
    );

    if (isSuccess) {
      SnackbarHelper.success(
        "Berhasil!",
        "${product.name} dimasukkan ke keranjang.",
      );
    }
  }
}
