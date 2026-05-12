import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/cart_menuController.dart';

class CartBinding extends Bindings {  

  @override
  void dependencies() {
    Get.lazyPut<CartController>(
      () => CartController(),
      fenix: true,
    );
  }
}