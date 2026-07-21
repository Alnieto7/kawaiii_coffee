import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/FullWidthActionCard.dart'; // ActionMenuCard
import 'package:kawaiii_coffee/Controller/DashboardKasirController.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/ShiftInfoCard.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/DashboardStockCard.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/TotalFloatCard.dart';

class DashboardkasirWide extends StatelessWidget {
  const DashboardkasirWide({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardKasirController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dashboard Kasir',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Kawaiii Coffee',
                        style: TextStyle(color: AppColors.primary, fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // --- TOMBOL PRINTER BARU ---
                      GestureDetector(
                        onTap: () => Get.toNamed('/PrinterSetting'),
                        child: const CircleAvatar(
                          radius: 20, // Disesuaikan menjadi 20 agar sejajar dengan icon lain
                          backgroundColor: AppColors.backgroundCard,
                          child: Icon(Icons.print_outlined, size: 20, color: AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // --- TOMBOL NOTIFIKASI ---
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.notifications, size: 20, color: AppColors.textOnPrimary),
                      ),
                      const SizedBox(width: 12),
                      
                      // --- TOMBOL LOGOUT ---
                      GestureDetector(
                        onTap: c.confirmLogout,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.backgroundCard,
                          child: Icon(Icons.logout, size: 20, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // DUA KOLOM UNTUK WIDE SCREEN
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- KOLOM KIRI (Info Shift & Stok) ---
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => ShiftInfoCard(
                                  statusColor: Colors.green,
                                  statusText: c.totalTransaksi.value,
                                  durationText: c.itemTerjual.value,
                                )),
                            
                            const SizedBox(height: 32),
                            
                            const Text(
                              'Stok Tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            Obx(() {
                              final items = c.stocks.toList();
                              return Row(
                                children: List.generate(items.length, (index) {
                                  final e = items[index];
                                  final status = e['status'] ?? '';
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: index == items.length - 1 ? 0 : 16,
                                      ),
                                      child: DashboardStockCard(
                                        name: e['name'] ?? '',
                                        value: e['value'] ?? '',
                                        status: status,
                                        statusBgColor: c.getStockBgColor(status),
                                        statusTextColor: c.getStockTextColor(status),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: c.goToInputStok,
                                    child: const ActionMenuCard(
                                      title: 'Input Stok',
                                      icon: Icons.inventory_2_outlined,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: c.goToAllStock,
                                    child: const ActionMenuCard(
                                      title: 'Semua Stok',
                                      icon: Icons.kitchen_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 32),

                    // --- KOLOM KANAN (Transaksi & Total) ---
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Transaksi Terakhir',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Hari Ini',
                                style: TextStyle(fontSize: 14, color: AppColors.textHint),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          Expanded(
                            child: Obx(() => ListView(
                                  children: c.transactions.map((e) {
                                    final title = e['title'] ?? '';
                                    final time = e['time'] ?? '';
                                    final price = e['price'] ?? '';

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundCard,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                              const SizedBox(height: 4),
                                              Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                                            ],
                                          ),
                                          Text(
                                            'Rp $price',
                                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),

                          const SizedBox(height: 16),
                          Obx(() => TotalFloatCard(totalValue: c.totalHariIni.value)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}