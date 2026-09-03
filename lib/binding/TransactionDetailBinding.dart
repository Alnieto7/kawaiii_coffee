import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/TransactionDetailController.dart';

class TransactionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailController>(() => TransactionDetailController());
  }
}