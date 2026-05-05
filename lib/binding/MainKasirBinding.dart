import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kawaiii_coffee/Controller/dashboardControllerKasir.dart';
import 'package:kawaiii_coffee/Controller/maincontroller.dart';

class MainKasirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<MainController>(() => MainController(), fenix: true); 
  }
}