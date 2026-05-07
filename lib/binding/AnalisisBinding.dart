import 'package:get/get.dart';
import '../Controller/AnalisisController.dart';

class AnalisisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalisisController>(() => AnalisisController());
  }
}