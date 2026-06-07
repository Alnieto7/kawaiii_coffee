import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';

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
    SnackbarHelper.success(
      "Berhasil", 
      "Pengaturan sistem berhasil disimpan",
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