import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Model/IngredientModel.dart';
import 'package:kawaiii_coffee/Provider/IngredientsProvider.dart';
import 'package:kawaiii_coffee/Provider/StockMovementProvider.dart';

class InputStokController extends GetxController {
  // --- STATE VARIABEL ---
  var isLoading = false.obs;
  var isSubmitting = false.obs;

  // Nama User Otomatis
  final box = GetStorage();
  var userName = ''.obs;

var ingredients = <IngredientModel>[].obs;
var movementTypes = [
  {'label': 'Masuk (In)', 'value': 'IN'}, 
  {'label': 'Keluar (Out)', 'value': 'OUT'},
  {'label': 'Penyesuaian', 'value': 'ADJUSTMENT'}
];

  var selectedIngredient = Rxn<IngredientModel>();
  var selectedType = Rxn<String>();
  final qtyController = TextEditingController();
  final refController = TextEditingController();
  final notesController = TextEditingController();

  // Provider
  final IngredientProvider _ingredientProvider = IngredientProvider();
  final StockMovementProvider _movementProvider = StockMovementProvider();

  @override
  void onInit() {
    super.onInit();
    userName.value = box.read('name') ?? 'Kasir / Admin';
    fetchIngredients();
  }

  @override
  void onClose() {
    qtyController.dispose();
    refController.dispose();
    notesController.dispose();
    super.onClose();
  }

  
  Future<void> fetchIngredients() async {
    isLoading.value = true;
    try {
      final data = await _ingredientProvider.getIngredients();
      ingredients.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar bahan baku');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> submitData() async {
    // 1. Validasi
    if (selectedIngredient.value == null) {
      Get.snackbar('Peringatan', 'Pilih Bahan Baku terlebih dahulu!');
      return;
    }
    if (selectedType.value == null) {
      Get.snackbar('Peringatan', 'Pilih Jenis Pergerakan terlebih dahulu!');
      return;
    }
    if (qtyController.text.isEmpty || int.tryParse(qtyController.text) == null) {
      Get.snackbar('Peringatan', 'Jumlah harus diisi dengan angka yang valid!');
      return;
    }

    // 2. Kirim Data
    isSubmitting.value = true;
    try {
      bool success = await _movementProvider.createMovement(
        ingredientId: selectedIngredient.value!.id,
        type: selectedType.value!,
        quantity: int.parse(qtyController.text),
        reference: refController.text,
        notes: notesController.text,
      );

      if (success) {
        Get.snackbar(
          'Sukses', 
          'Pergerakan stok berhasil dicatat!', 
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
        Get.back(); 
      }
    } catch (e) {
      Get.snackbar(
        'Gagal', 
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}