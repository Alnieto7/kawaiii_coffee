import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/maincontroller.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Controller/CartMenuController.dart';
import 'package:kawaiii_coffee/Page/Kasir/HistoryPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/POS.dart';
import 'package:kawaiii_coffee/Page/Kasir/DashboardKasirPage.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    // ✅ Inject controller POS di sini, sebelum pages dibuat
    Get.put(PosController(), permanent: true);
    Get.put(CartController(), permanent: true);

    // ✅ Pages dibuat di dalam build, bukan di field
    final pages = [
      const DashboardkasirPage(),
      PosPage(),
      const HistoryPage(),
      const Center(child: Text("Profil Page")),
    ];

    return Obx(() => Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeIndex,
            selectedItemColor: const Color(0xFFD97706),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag), label: 'POS'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'Riwayat'),
            ],
          ),
        ));
  }
}