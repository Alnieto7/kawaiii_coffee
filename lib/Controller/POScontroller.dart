import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/cart_menuController.dart';


class PosController extends GetxController {

  late CartController cart;

  // 🔍 search
  var searchQuery = ''.obs;

  // 🏷 kategori
  var selectedCategory = 'Semua'.obs;

  final List<String> categories = [
    "Semua",
    "Espresso Base",
    "Manual Brew",
    "Non Coffee",
  ];

  // 📦 DATA PRODUK (dummy)
  final List<Map<String, dynamic>> products = [
    {
      "name": "Espresso Double",
      "price": 18000,
      "category": "Espresso Base",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6H7LtT9HjVA3eoSFRGhFxt0ifngIlXRCmCw&s",
    },
    {
      "name": "Caffè Latte",
      "price": 25000,
      "category": "Espresso Base",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6H7LtT9HjVA3eoSFRGhFxt0ifngIlXRCmCw&s",
    },
    {
      "name": "Cold Brew Signature",
      "price": 28000,
      "category": "Manual Brew",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6H7LtT9HjVA3eoSFRGhFxt0ifngIlXRCmCw&s",
    },
    {
      "name": "Cappuccino",
      "price": 24000,
      "category": "Espresso Base",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6H7LtT9HjVA3eoSFRGhFxt0ifngIlXRCmCw&s",
    },
  ];

  // 🔥 LIST HASIL FILTER (REACTIVE)
  var filteredProducts = <Map<String, dynamic>>[].obs;

  // 🔄 INIT
  @override
  void onInit() {
    super.onInit();
    cart = Get.put(CartController());
    filterProducts();
      print("=== PosController onInit ===");
      print("CartController registered: ${Get.isRegistered<CartController>()}");
     
  }

  // 🔎 FILTER LOGIC
  void filterProducts() {
    final query = searchQuery.value.toLowerCase();

    final result = products.where((p) {
      final name = (p["name"] ?? "").toString().toLowerCase();
      final category = (p["category"] ?? "").toString();

      final matchSearch = name.contains(query);
      final matchCategory = selectedCategory.value == "Semua"
          ? true
          : category == selectedCategory.value;

      return matchSearch && matchCategory;
    }).toList();

    filteredProducts.assignAll(result);
  }

  // 🔍 UPDATE SEARCH
  void updateSearch(String value) {
    searchQuery.value = value;
    filterProducts();
  }

  // 🏷 GANTI CATEGORY
  void changeCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  // 🛒 ADD TO CART
  void addToCart(Map<String, dynamic> product) {
    cart.addItem(
      product["name"] ?? "",
      product["price"] ?? 0,
    );
  }
}