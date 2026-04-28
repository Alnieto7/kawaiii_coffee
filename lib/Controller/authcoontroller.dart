import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/auth/serviceauth.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final box = GetStorage();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var role = ''.obs;
  var name = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  // 🔍 cek apakah user sudah login
  void checkLogin() {
    final token = box.read('token');

    if (token != null) {
      isLoggedIn.value = true;
      role.value = box.read('role') ?? '';
      name.value = box.read('name') ?? '';

      redirectByRole();
    } else {
      isLoggedIn.value = false;
    }
  }

  // 🔐 login
  Future<void> login(String nameInput, String password) async {
    try {
      isLoading.value = true;

      final result = await _authService.login(
        name: nameInput,
        password: password,
      );

      final token = result['token'];
      final user = result['user'];

      // simpan data
      box.write('token', token);
      box.write('role', user['role']);
      box.write('name', user['name']);

      isLoggedIn.value = true;
      role.value = user['role'];
      name.value = user['name'];

      redirectByRole();

    } catch (e) {
      Get.snackbar("Login Gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // 🔀 redirect sesuai role
  void redirectByRole() {
    if (role.value == 'admin') {
      Get.offAllNamed('/admin');
    } else if (role.value == 'kasir') {
      Get.offAllNamed('/kasir');
    } else {
      Get.offAllNamed('/login');
    }
  }

  // 🚪 logout
  void logout() {
    box.erase();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}