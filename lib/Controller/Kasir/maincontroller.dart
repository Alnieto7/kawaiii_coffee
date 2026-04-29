import 'package:get/get.dart';

class MainController extends GetxController {
  var selectedIndex = 1.obs; // default ke POS

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}