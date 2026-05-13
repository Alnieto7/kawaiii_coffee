import 'package:get/get.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

class PaymentSuccessController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _autoNavigate();
  }

  void _autoNavigate() {
    Future.delayed(const Duration(seconds: 3), () {
      //Get.offNamed(AppRoutes.StrukPage);//
    });
  }
}
