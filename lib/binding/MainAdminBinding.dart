import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/MainAdminController.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAdminController>(() => MainAdminController());
  }
}