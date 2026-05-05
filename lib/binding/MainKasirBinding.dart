import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kawaiii_coffee/Controller/Admin/dashboardControllerKasir.dart';
import 'package:kawaiii_coffee/Controller/Admin/maincontroller.dart';
import 'package:kawaiii_coffee/Controller/Kasir/POScontroller.dart';


class MainKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<MainController>(() => MainController(), fenix: true); 
    Get.lazyPut<PosController>(() => PosController(), fenix: true);
  }
}