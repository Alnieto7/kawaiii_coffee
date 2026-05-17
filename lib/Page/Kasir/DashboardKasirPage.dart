import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    const Color brandOrange = Color(0xFFD97706); // ✅ Variabel oranye utama

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                      Text('Dashboard Kasir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('COFFEE STREET UMKM', style: TextStyle(color: brandOrange, fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: const [
                      CircleAvatar(radius: 18, backgroundColor: brandOrange, child: Icon(Icons.notifications, size: 18, color: Colors.white)),
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

                    // INFO CARD SHIFT
                    Obx(() => ShiftInfoCard(
                          statusColor: c.shiftStatusColor,
                          statusText: c.shiftStatusText,
                          durationText: c.duration.value,
                        )),

                    const SizedBox(height: 24), 

                    // STOCK HEADER
                    const Text('Stok Tersedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
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
                            child: const ActionMenuCard(title: 'Input Stok Harian', icon: Icons.inventory_2_outlined),
                          )
                        ),
                        const SizedBox(width: 12), 
                        Expanded(
                          child: GestureDetector(
                            onTap: c.goToAllStock, 
                            child: const ActionMenuCard(title: 'Semua Stok', icon: Icons.kitchen_outlined),
                          )
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TRANSAKSI LIST HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Transaksi Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                        Text('Hari Ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16), 
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                      const SizedBox(height: 2),
                                      Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                  Text('Rp $price', style: const TextStyle(color: brandOrange, fontWeight: FontWeight.bold)),
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