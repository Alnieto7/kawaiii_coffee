import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:kawaiii_coffee/Controller/Admin/dashboardControllerKasir.dart';

class Dashboardkasirbinding extends Bindings {
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(),);
  }
}