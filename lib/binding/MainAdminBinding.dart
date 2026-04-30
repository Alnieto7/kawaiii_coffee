import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/AnalisisController.dart';
import 'package:kawaiii_coffee/Controller/DashboardAdminController.dart';
import 'package:kawaiii_coffee/Controller/HppMarginController.dart';
import 'package:kawaiii_coffee/Controller/MainAdminController.dart';
import 'package:kawaiii_coffee/Controller/SettingController.dart';

class MainAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAdminController>(() => MainAdminController());
    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController());
    Get.lazyPut<AnalisisController>(() => AnalisisController());
    Get.lazyPut<HppMarginController>(() => HppMarginController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
