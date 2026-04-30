
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/actioncard.dart';
import 'package:kawaiii_coffee/Controller/Kasir/dashboardControllerKasir.dart';

class DashboardkasirPage extends StatelessWidget {
  const DashboardkasirPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(DashboardController());

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

                    // INFO CARD
                    Obx(() => Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(radius: 5, backgroundColor: Colors.green),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Status Shift', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      Text('AKTIF', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Durasi Kerja', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(c.duration.value, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        )),

                    const SizedBox(height: 16),

                    // MENU ORANGE
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE67E22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Transaksi Penjualan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Input pesanan baru sekarang', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white)
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // STOCK HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Stok Tersedia', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Lihat Semua', style: TextStyle(color: Colors.orange, fontSize: 12)),
                      ],
                    ),

                    const SizedBox(height: 8),

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
                                          color: status == 'AMAN' ? Colors.green[100] : Colors.red[100],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(status, style: TextStyle(fontSize: 10, color: status == 'AMAN' ? Colors.green : Colors.red)),
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

                    const SizedBox(height: 12),

                    // ACTION CARDS
                    Row(
                      children: [
                        Expanded(child: ActionCard(title: 'Input Stok Harian', icon: Icons.inventory)),
                        const SizedBox(width: 8),
                        Expanded(child: ActionCard(title: 'Riwayat Transaksi', icon: Icons.history)),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // TRANSAKSI
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Transaksi Terakhir', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Hari Ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 8),

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
                                      Text(title),
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

            // TOTAL FLOAT
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL HARI INI', style: TextStyle(color: Colors.white)),
                  Text('Rp 1.250k', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

