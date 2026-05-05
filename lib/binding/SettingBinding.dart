import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/SettingController.dart';


class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}