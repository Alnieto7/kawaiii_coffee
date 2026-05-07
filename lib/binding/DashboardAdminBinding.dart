import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/DashboardAdminController.dart';


class Dashboardadminbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController(),);}}