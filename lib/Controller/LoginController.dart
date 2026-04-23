import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Database/LoginReq.dart';


class LoginController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthProvider _authProvider = AuthProvider();
  final box = GetStorage();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> doLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Peringatan', 'Email dan password wajib diisi');
      return;
    }

    isLoading.value = true;

    try {
      // result sekarang bertipe LoginResponse
      final result = await _authProvider.login(email, password);

      // Panggil properti langsung dari Model (auto-complete jalan disini)
      if (result.token != null && result.token!.isNotEmpty) {
        box.write('auth_token', result.token);
        Get.offAllNamed('/dashboard');
        
        Get.snackbar('Sukses', result.message ?? 'Berhasil masuk',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        throw Exception('Token tidak ditemukan dari server.');
      }
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}