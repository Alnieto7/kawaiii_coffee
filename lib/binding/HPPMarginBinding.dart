import 'package:get/get.dart';
import '../Controller/HppMarginController.dart';

class HppMarginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HppMarginController>(() => HppMarginController());
  }
}