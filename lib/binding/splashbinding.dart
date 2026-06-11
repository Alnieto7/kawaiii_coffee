// lib/binding/SplashBinding.dart
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/SplashController.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}