import 'package:get/get.dart';
import 'package:kawaiii_coffee/snackbarhelper.dart';

class PaymentSuccessController extends GetxController {

  @override
  void onInit() {
    super.onInit();

    print('PAYMENT SUCCESS ARGUMENT = ${Get.arguments}');

    _autoNavigate();
  }

  void _autoNavigate() {

    Future.delayed(const Duration(seconds: 3), () {

      final args = Get.arguments;

      if (args == null ||
          args['transaction_id'] == null) {

       SnackbarHelper.error(
          'Error',
          'Transaction ID tidak ditemukan',
        );

        Get.offAllNamed('/main');

        return;
      }

      final int transactionId =
          args['transaction_id'];

      Get.offNamed(
        '/receipt',
        arguments: transactionId,
      );

    });
  }
}