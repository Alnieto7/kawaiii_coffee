import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kawaiii_coffee/Model/IngredientModel.dart';
import 'package:kawaiii_coffee/Provider/IngredientsProvider.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';

class AllStockController extends GetxController {
  var isLoading = true.obs;
  var stocks = <IngredientModel>[].obs;
  var isMobile = true.obs;
  void updateLayout(BoxConstraints constraints) => isMobile.value = constraints.maxWidth < 600;
  
  final IngredientProvider _ingredientProvider = IngredientProvider();

  @override
  void onInit() {
    super.onInit();
    fetchAllStocks();
  }

  void fetchAllStocks() async {
    isLoading.value = true;
    try {
      final data = await _ingredientProvider.getIngredients();
      stocks.value = data;
    } catch (e) {
      SnackbarHelper.error('Error', 'Gagal memuat data stok: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Logika warna status
  Color getStockBgColor(IngredientModel item) {
    return item.stock > item.minStock ? Colors.green[100]! : Colors.red[100]!;
  }

  Color getStockTextColor(IngredientModel item) {
    return item.stock > item.minStock ? Colors.green : Colors.red;
  }
  
  String getStockStatus(IngredientModel item) {
    return item.stock > item.minStock ? 'AMAN' : 'RENDAH';
  }
}