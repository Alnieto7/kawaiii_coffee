import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/InputStockController.dart';


class InputStokBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut berarti controller hanya dipanggil ke memori saat UI benar-benar butuh
    Get.lazyPut<InputStokController>(() => InputStokController());
  }
}