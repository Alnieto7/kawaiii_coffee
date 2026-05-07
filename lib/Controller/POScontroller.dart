import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/cart_menuController.dart';
import 'package:kawaiii_coffee/Model/product_model.dart';
import 'package:kawaiii_coffee/Services/product_service.dart';

class PosController extends GetxController {
  final CartController cart = Get.put(CartController());

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

      final result = await ProductService.fetchProducts();

      products.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🔍 FILTER
  List<ProductModel> get filteredProducts {
    final query = searchQuery.value.toLowerCase();

    return products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(query);

      final matchCategory = selectedCategory.value == "Semua"
          ? true
          : p.categoryName == selectedCategory.value;

      return matchSearch && matchCategory;
    }).toList();
  }

  // 🔍 SEARCH
  void updateSearch(String value) {
    searchQuery.value = value;
  }

  // 🏷 CATEGORY
  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // 🛒 CART
  void addToCart(ProductModel product) {
    cart.addItem(
      id: product.id,
      name: product.name,
      price: product.sellingPrice,
      image: product.image,
    );
  }
}
