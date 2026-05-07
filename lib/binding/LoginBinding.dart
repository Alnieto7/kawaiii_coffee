import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/LoginController.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(),);}}