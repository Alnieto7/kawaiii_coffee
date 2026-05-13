import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/PaymentSuccess.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Controller/QrisController.dart';


class Posbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<PosController>(() => PosController(), fenix: true);
    Get.lazyPut<QrisController>(() => QrisController(), fenix: true);
    Get.lazyPut<PaymentSuccessController>(() => PaymentSuccessController(), fenix: true);
  }
}