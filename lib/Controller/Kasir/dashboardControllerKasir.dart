import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isActive = true.obs;
  var duration = '04:25:12'.obs;

  var stocks = [
    {'name': 'Biji Kopi', 'value': '12.5 kg', 'status': 'AMAN'},
    {'name': 'Susu UHT', 'value': '4.2 L', 'status': 'RENDAH'},
  ].obs;

  var transactions = [
    {
      'title': '2x Caramel Macchiato',
      'time': '14:20',
      'price': '48.000'
    },
    {
      'title': '1x Brown Sugar Latte',
      'time': '14:05',
      'price': '22.000'
    },
  ].obs;
}