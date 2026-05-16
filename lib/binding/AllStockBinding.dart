import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/AllStockController.dart';


class AllStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllStockController>(() => AllStockController());
  }
}