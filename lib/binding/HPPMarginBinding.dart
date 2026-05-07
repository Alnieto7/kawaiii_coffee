import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/HPPMarginController.dart';

class HppMarginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HppMarginController>(() => HppMarginController());
  }
}