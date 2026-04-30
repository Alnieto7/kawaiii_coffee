import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kawaiii_coffee/Controller/Kasir/dashboardControllerKasir.dart';
import 'package:kawaiii_coffee/Controller/Kasir/maincontroller.dart';

class MainKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<MainController>(() => MainController(), fenix: true); 
  }
}