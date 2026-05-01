import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Database/LoginReq.dart';
import 'package:kawaiii_coffee/Page/Kasir/MainPage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthProvider _authProvider = AuthProvider();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkLogin(); // ✅ pindah dari AuthController
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ✅ pindah dari AuthController
  void checkLogin() {
    final token = box.read('auth_token');
    final role = box.read('role') ?? '';

    if (token != null && role.isNotEmpty) {
      redirectByRole(role);
    }
  }

  // ✅ pindah dari AuthController
  void redirectByRole(String role) {
    final r = role.trim().toLowerCase();

    if (r == 'admin') {
      Get.offAllNamed(AppRoutes.BNAdmin);
    } else if (r == 'cashier') {
      Get.offAll(() => MainPage());
    } else {
      Get.snackbar('Error', 'Role tidak dikenali: $r');
    }
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
        box.write('role', result.user?.role ?? '');
        box.write('name', result.user?.name ?? '');

        redirectByRole(result.user?.role ?? '');
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

  // ✅ pindah dari AuthController
  void logout() {
    box.erase();
    Get.offAllNamed('/login');
  }
}