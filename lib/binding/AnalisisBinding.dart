import 'package:get/get.dart';
import '../Controller/Admin/AnalisisController.dart';

class AnalisisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalisisController>(() => AnalisisController());
  }
}