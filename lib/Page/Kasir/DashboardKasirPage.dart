import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/actioncard.dart';
import 'package:kawaiii_coffee/Controller/DashboardKasirController.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/ShiftInfoCard.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/TotalFloatCard.dart';

class DashboardkasirPage extends StatelessWidget {
  const DashboardkasirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardKasirController>();

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
                      Text('Dashboard Kasir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('COFFEE STREET UMKM', style: TextStyle(color: Colors.orange, fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: const [
                      CircleAvatar(radius: 18, backgroundColor: Colors.orange, child: Icon(Icons.notifications, size: 18, color: Colors.white)),
                      SizedBox(width: 8),
                      CircleAvatar(radius: 18, backgroundColor: Colors.brown, child: Icon(Icons.person, size: 18, color: Colors.white)),
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

                    // INFO CARD SHIFT (Menggunakan Reusable Component)
                    Obx(() => ShiftInfoCard(
                          statusColor: c.shiftStatusColor,
                          statusText: c.shiftStatusText,
                          durationText: c.duration.value,
                        )),

                    const SizedBox(height: 24), 

                    // STOCK HEADER
                    const Text('Stok Tersedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),

                    // STOCK CARDS
                    Obx(() => Row(
                          children: c.stocks.map((e) {
                            final status = e['status'] ?? '';
                            final name = e['name'] ?? '';
                            final value = e['value'] ?? '';

                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: c.getStockBgColor(status),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(status, style: TextStyle(fontSize: 10, color: c.getStockTextColor(status))),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(name, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )),

                    const SizedBox(height: 16),

                    // ACTION CARDS
                    Row(
                      children: [
                        Expanded(child: GestureDetector(
                          onTap: c.goToInputStok,
                          child: const ActionCard(title: 'Input Stok Harian', icon: Icons.inventory),
                        )),
                        const SizedBox(width: 8),
                        Expanded(child: GestureDetector(
                          onTap: c.goToAllStock, 
                          child: const ActionCard(title: 'Semua Stok', icon: Icons.kitchen),
                        )),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TRANSAKSI LIST HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Transaksi Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2),
                                      Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                  Text('Rp $price', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
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

            // TOTAL FLOAT (Menggunakan Reusable Component)
            Obx(() => TotalFloatCard(totalValue: c.totalHariIni.value)),
          ],
        ),
      ),
    );
  }
}