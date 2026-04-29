import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Kasir/maincontroller.dart';
import 'package:kawaiii_coffee/Page/Kasir/POS.dart';
import 'package:kawaiii_coffee/Page/Kasir/dashboardKasir.dart';

// import page lain nanti

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final controller = Get.put(MainController());

  final pages = [
    const DashboardkasirPage(),
    const PosPage(),
    const Center(child: Text("Riwayat Page")),
    const Center(child: Text("Profil Page")),
  ];

  @override
  Widget build(BuildContext context) {
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
            ],
          ),
        ));
  }
}