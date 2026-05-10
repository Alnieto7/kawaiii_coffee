import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:kawaiii_coffee/Controller/DashboardKasirController.dart';

class Dashboardkasirbinding extends Bindings {
  void dependencies() {
    Get.lazyPut<DashboardKasirController>(() => DashboardKasirController(),);
  }
}