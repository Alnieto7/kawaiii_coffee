import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Model/ProductModel.dart';
import 'package:kawaiii_coffee/Provider/ProductProvider.dart';
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

  // Menggunakan List<ProductModel> yang sudah ter-import
  var products = <ProductModel>[].obs;

  final categories = ["Semua", "Coffee", "Non Coffee"];

  // Nama kasir yang sedang login, diambil dari GetStorage
  // (disimpan pas login lewat LoginController: box.write('name', ...))
  String get cashierName => _box.read('name') ?? 'Kasir';

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
      SnackbarHelper.error(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
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
  
  void addToCart(ProductModel product) {
    cart.addItem(
      id: product.id,
      name: product.name,
      price: product.sellingPrice,
      image: product.image,
    );
    
    // Tambahkan baris ini agar ada notifikasi sukses saat barang dipencet
    SnackbarHelper.success(
      "Berhasil!", 
      "${product.name} dimasukkan ke keranjang.",
    );
  }
}