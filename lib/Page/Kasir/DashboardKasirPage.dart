import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/FullWidthActionCard.dart';
import 'package:kawaiii_coffee/Controller/DashboardKasirController.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/ShiftInfoCard.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/DashboardStockCard.dart'; 
import 'package:kawaiii_coffee/Component/dashboardkasir/TotalFloatCard.dart';

class DashboardkasirPage extends StatelessWidget {
  const DashboardkasirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardKasirController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Dashboard Kasir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text('COFFEE STREET UMKM', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: const [
                      CircleAvatar(radius: 18, backgroundColor: AppColors.primary, child: Icon(Icons.notifications, size: 18, color: AppColors.textOnPrimary)),
                      SizedBox(width: 8),
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // INFO CARD PERFORM
                    // 🔥 DI SINI KITA MENGIRIM VARIABEL PRODUK TERLARIS KE UI 🔥
                    Obx(() => ShiftInfoCard (
                          statusColor: Colors.green, 
                          statusText: c.totalTransaksi.value, durationText: '', 
                         
                        )),

                    const SizedBox(height: 24),

                    // STOCK HEADER
                    const Text('Stok Tersedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),

                    // STOCK CARDS
                    Obx(() {
                      final items = c.stocks.toList();
                      return Row(
                        children: List.generate(items.length, (index) {
                          final e = items[index];
                          final status = e['status'] ?? '';
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12),
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

                    const SizedBox(height: 12),

                    // ACTION CARDS
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: c.goToInputStok,
                            child: const ActionMenuCard(title: 'Input Stok ', icon: Icons.inventory_2_outlined),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: c.goToAllStock,
                            child: const ActionMenuCard(title: 'Semua Stok', icon: Icons.kitchen_outlined),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TRANSAKSI LIST HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Transaksi Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                        Text('Hari Ini', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // TRANSAKSI LIST ITEMS
                    Obx(() => Column(
                          children: c.transactions.map((e) {
                            final title = e['title'] ?? '';
                            final time = e['time'] ?? '';
                            final price = e['price'] ?? '';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
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
                                      const SizedBox(height: 2),
                                      Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                                    ],
                                  ),
                                  Text('Rp $price', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            );
                          }).toList(),
                        )),

                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),

            // TOTAL FLOAT
            Obx(() => TotalFloatCard(totalValue: c.totalHariIni.value)),
          ],
        ),
      ),
    );
  }
}