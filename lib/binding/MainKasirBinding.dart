import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Controller/DashboardKasirController.dart';
import 'package:kawaiii_coffee/Controller/HistoryController.dart';
import 'package:kawaiii_coffee/Controller/PaymentSuccess.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Controller/QrisController.dart';
import 'package:kawaiii_coffee/Controller/maincontroller.dart';
import 'package:kawaiii_coffee/Controller/receipt_controller.dart';


class MainKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController(), permanent: true);
    
    // Cek dulu sebelum put, agar tidak buat instance baru
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(CartController(), permanent: true);
    }
    if (!Get.isRegistered<PosController>()) {
      Get.put<PosController>(PosController(), permanent: true);
    }
    
    Get.lazyPut<QrisController>(() => QrisController(), fenix: true);
    Get.lazyPut<PaymentSuccessController>(() => PaymentSuccessController(), fenix: true);
    Get.lazyPut<ReceiptController>(() => ReceiptController(), fenix: true);
    Get.lazyPut<DashboardKasirController>(() => DashboardKasirController(), fenix: true);
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}