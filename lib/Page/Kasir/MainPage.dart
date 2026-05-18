import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
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
    Get.put(PosController(), permanent: true);
    Get.put(CartController(), permanent: true);

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
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textHint,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'POS'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
            ],
          ),
        ));
  }
}