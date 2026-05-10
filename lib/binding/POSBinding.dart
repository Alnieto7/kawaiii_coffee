import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';


class Posbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<PosController>(() => PosController(), fenix: true);
  }
}