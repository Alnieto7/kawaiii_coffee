import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';

class CartMenubinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController());
  }
}