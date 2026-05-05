import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Kasir/POScontroller.dart';
import 'package:kawaiii_coffee/Controller/Kasir/cart_menuController.dart';

class Posbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<PosController>(() => PosController(), fenix: true);
  }
}