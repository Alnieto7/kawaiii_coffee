import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/DashboardAdminController.dart';
import 'package:kawaiii_coffee/Controller/LoginController.dart';
import 'package:kawaiii_coffee/Page/Admin/DashboardAdminPage.dart';

class Dashboardadminbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController(),);}}