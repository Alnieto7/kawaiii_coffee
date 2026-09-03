import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Provider/AuthProvider.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  
  // Variabel untuk layout responsif
  var isMobile = true.obs;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthProvider _authProvider = AuthProvider();
  final box = GetStorage();

  // Fungsi untuk update layout responsif
  void updateLayout(BoxConstraints constraints) => isMobile.value = constraints.maxWidth < 800;

  @override
  void onInit() {
    super.onInit();
    checkLogin(); 
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void checkLogin() {
    final token = box.read('auth_token');
    final role = box.read('role') ?? '';

    if (token != null && role.isNotEmpty) {
      redirectByRole(role);
    }
  }

  void redirectByRole(String role) {
    final r = role.trim().toLowerCase();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (r == 'admin') {
        Get.offAllNamed(AppRoutes.BNAdmin);
      } else if (r == 'cashier') {
        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        SnackbarHelper.error(
          'Error',
          'Role tidak dikenali: $r',
        );
      }
    });
  }

  Future<void> doLogin() async {
    final name = nameController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || password.isEmpty) {
      SnackbarHelper.warning('Peringatan', 'Nama dan password wajib diisi');
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
      SnackbarHelper.error(
        'Login Gagal',
        e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/login');
  }
}