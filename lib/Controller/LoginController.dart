import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Database/LoginReq.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthProvider _authProvider = AuthProvider();
  final box = GetStorage();

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> doLogin() async {
    final name = nameController.text.trim();
    final password = passwordController.text;
 
 
    if (name.isEmpty || password.isEmpty) {
      Get.snackbar('Peringatan', 'Nama dan password wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authProvider.login(name, password);

      if (result.token != null && result.token!.isNotEmpty) {
  box.write('auth_token', result.token);

  // amanin null
  box.write('role', result.user?.role ?? '');

  if (result.user?.role == 'admin') {
    Get.offAllNamed('/dashboardadmin');
  } else if (result.user?.role == 'kasir') {
    Get.offAllNamed('/kasir');
  } else {
    Get.snackbar('Error', 'Role tidak dikenali');
  }
} else {
        throw Exception('Token tidak ditemukan dari server.');
      }
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

