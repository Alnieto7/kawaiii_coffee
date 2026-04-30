import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Controller untuk Text Fields
  final storeNameCtrl = TextEditingController(text: "Coffee Street Jakarta");
  final addressCtrl = TextEditingController(text: "JL Sudirman No. 123, SCBD, Jakarta Selatan, 12190");
  final merchantIdCtrl = TextEditingController(text: "MID-829310231");
  final apiKeyCtrl = TextEditingController(text: "sk_test_51MzS2VAnT9");

  // State untuk Switch Metode Pembayaran
  var isCashEnabled = true.obs;
  var isQrisEnabled = true.obs;
  var isTransferEnabled = false.obs;

  // State untuk hide/show API Key
  var isApiKeyVisible = false.obs;

  void toggleApiKeyVisibility() {
    isApiKeyVisible.value = !isApiKeyVisible.value;
  }

  void saveSettings() {
    // Simulasi proses simpan
    Get.snackbar(
      "Berhasil", 
      "Pengaturan sistem berhasil disimpan",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
    );
  }

  @override
  void onClose() {
    // Selalu dispose controller untuk menghindari memory leak
    storeNameCtrl.dispose();
    addressCtrl.dispose();
    merchantIdCtrl.dispose();
    apiKeyCtrl.dispose();
    super.onClose();
  }
}