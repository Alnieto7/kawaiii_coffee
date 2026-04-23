import 'package:get/get.dart';

class MainAdminController extends GetxController {
  // rxInt untuk menyimpan index halaman aktif (dimulai dari 0 yaitu Dashboard)
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}