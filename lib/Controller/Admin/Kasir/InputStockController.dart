import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Sesuaikan path import model dan provider kamu jika berbeda
import 'package:kawaiii_coffee/Model/IngredientModel.dart';
import 'package:kawaiii_coffee/Provider/IngredientsProvider.dart';
import 'package:kawaiii_coffee/Provider/StockMovementProvider.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';
// 🔥 TAMBAHKAN IMPORT APP COLORS DI SINI
import 'package:kawaiii_coffee/Component/app_colors.dart'; 

class InputStokController extends GetxController {
  // --- STATE VARIABEL ---
  var isLoading = false.obs;
  var isSubmitting = false.obs; 
  var isMobile = true.obs;
  void updateLayout(BoxConstraints constraints) => isMobile.value = constraints.maxWidth < 600;

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

  // --- MENGAMBIL DATA BAHAN BAKU ---
  Future<void> fetchIngredients() async {
    isLoading.value = true;
    try {
      final data = await _ingredientProvider.getIngredients();
      ingredients.value = data;
    } catch (e) {
      SnackbarHelper.error('Error', 'Gagal memuat daftar bahan baku');
    } finally {
      isLoading.value = false;
    }
  }

  // --- FUNGSI MENGOSONGKAN FORM (INPUT ULANG) ---
  void resetForm() {
    selectedIngredient.value = null;
    selectedType.value = null;
    qtyController.clear();
    refController.clear();
    notesController.clear();
  }

  // --- MENGIRIM DATA STOK ---
  Future<void> submitData() async {
    if (isSubmitting.value) return; 

    // 1. Validasi Inputan
    if (selectedIngredient.value == null) {
      SnackbarHelper.warning('Peringatan', 'Pilih Bahan Baku terlebih dahulu!');
      return;
    }
    if (selectedType.value == null) {
      SnackbarHelper.warning('Peringatan', 'Pilih Jenis Pergerakan terlebih dahulu!');
      return;
    }
    if (qtyController.text.isEmpty || int.tryParse(qtyController.text) == null) {
      SnackbarHelper.warning('Peringatan', 'Jumlah harus diisi dengan angka yang valid!');
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
        // 🔥 MUNCULKAN POP-UP BERHASIL DI SINI 🔥
        Get.defaultDialog(
          title: 'Input Berhasil',
          titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
          titleStyle: const TextStyle(fontWeight: FontWeight.bold),
          middleText: 'Data stok telah berhasil disimpan ke sistem.',
          barrierDismissible: false, // Tidak bisa ditutup dengan sembarang klik
          radius: 16,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Menginput Ulang
                OutlinedButton(
                  onPressed: () {
                    Get.back(); // Tutup Pop-up
                    resetForm(); // Kosongkan form
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary, 
                    side: const BorderSide(color: AppColors.primary), 
                  ),
                  child: const Text('Input Stock Lagi'),
                ),
                
                // Tombol Kembali
                ElevatedButton(
                  onPressed: () {
                    Get.back(); 
                    Get.back(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, 
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembali'),
                ),
              ],
            )
          ]
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Gagal', 
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}