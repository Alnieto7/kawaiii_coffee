import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/MainAdminController.dart';
import 'package:kawaiii_coffee/Page/Admin/AnalisisPage.dart';
import 'package:kawaiii_coffee/Page/Admin/DashboardAdminPage.dart';
import 'package:kawaiii_coffee/Page/Admin/HppMargin.dart';
import 'package:kawaiii_coffee/Page/Admin/SettingsPage.dart';


// Import halaman-halaman dummy (akan kita buat di langkah 4)


class MainView extends GetView<MainAdminController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditampilkan di dalam body
    final List<Widget> pages = [
      const DashboardAdminPage(),
      const Analisispage(),
      const HppMarginPage(),
      const Settingspage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // IndexedStack menumpuk semua halaman tapi hanya menampilkan index yang aktif
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changePage, // Panggil fungsi ganti halaman
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed, // Penting agar semua text muncul
            elevation: 0,
            
            // --- PENGATURAN WARNA ---
            selectedItemColor: const Color(0xFFD97217), // Warna orange saat aktif
            unselectedItemColor: const Color(0xFFAFAFAF), // Warna abu-abu saat tidak aktif
            
            // --- PENGATURAN TEXT ---
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            
            items: const [
              BottomNavigationBarItem(
                // Ikon yang mirip dengan kotak 4 (Dashboard)
                icon: Icon(Icons.space_dashboard_outlined), 
                activeIcon: Icon(Icons.space_dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                // Ikon bar chart (Analisis)
                icon: Icon(Icons.bar_chart_rounded),
                activeIcon: Icon(Icons.poll_rounded),
                label: 'Analisis',
              ),
              BottomNavigationBarItem(
                // Ikon uang / margin (HPP & Margin)
                icon: Icon(Icons.payments_outlined),
                activeIcon: Icon(Icons.payments_rounded),
                label: 'HPP & Margin',
              ),
              BottomNavigationBarItem(
                // Ikon gerigi (Setelan)
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'Setelan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}