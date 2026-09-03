// lib/Controller/SplashController.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

class SplashController extends GetxController {
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    print('SplashController onInit');
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 3));
    print('Navigating...');

    final token = _box.read('auth_token');
    final role  = (_box.read('role') ?? '').toString().trim().toLowerCase();

    if (token != null && role.isNotEmpty) {
      if (role == 'admin') {
        Get.offAllNamed(AppRoutes.BNAdmin);
      } else if (role == 'cashier') {
        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        Get.offAllNamed(AppRoutes.loginPage);
      }
    } else {
      Get.offAllNamed(AppRoutes.loginPage);
    }
  }
}