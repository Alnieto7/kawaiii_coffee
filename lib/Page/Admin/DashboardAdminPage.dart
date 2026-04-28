import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/ActivityTile.dart';
import 'package:kawaiii_coffee/Component/mini_stat_card.dart';
import 'package:kawaiii_coffee/Component/revenue_card.dart'; // <-- Pastikan import ini ada
import 'package:kawaiii_coffee/Controller/DashboardAdminController.dart';

class DashboardAdminPage extends GetView<DashboardAdminController> {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text("Halo, ${controller.userName.value}!", 
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                      Obx(() => Text(controller.currentDate.value, 
                        style: const TextStyle(color: Colors.grey))),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFCECDD),
                    child: Icon(Icons.person, color: Color(0xFFD97217)),
                  )
                ],
              ),
              const SizedBox(height: 25),

              // Main Card
              Obx(() => RevenueCard(
                title: "PENDAPATAN",
                amount: controller.totalOmzet.value,
                growth: controller.omzetGrowth.value.toString(),
              )),
              const SizedBox(height: 16),

              // Mini Cards
              Row(
                children: [
                  Expanded(
                    child: Obx(() => MiniStatCard(
                      label: "Jumlah Transaksi",
                      value: "${controller.jumlahTransaksi.value}",
                      subValue: "Order",
                      icon: Icons.receipt_long,
                      iconColor: Colors.black,
                    )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => MiniStatCard(
                      label: "Status Stok",
                      value: "${controller.stokMenipis.value}",
                      subValue: "Menipis",
                      icon: Icons.inventory_2,
                      iconColor: Colors.red,
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Menu Manajemen Section
              _buildSectionHeader("Menu Manajemen", true),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMenuItem(Icons.bar_chart, "Laporan"),
                  _buildMenuItem(Icons.people, "Absensi"),
                  _buildMenuItem(Icons.inventory, "Stok"), 
                  _buildMenuItem(Icons.history, "Aktivitas"),
                ],
              ),
              const SizedBox(height: 30),

              // --- MULAI BAGIAN AKTIVITAS TERKINI (TRANSAKSI) ---
              _buildSectionHeader("Aktivitas Terkini", false),
              const SizedBox(height: 16),
              
              Obx(() {
                // 1. Tampilan saat API masih loading
                if (controller.isLoadingActivities.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Color(0xFFD97217)),
                    )
                  );
                }

                // 2. Tampilan saat API sukses tapi data kosong ("data": [])
                if (controller.recentTransactions.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200)
                    ),
                    child: const Text(
                      "Belum ada aktivitas transaksi hari ini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }

                // 3. Tampilan saat data transaksi tersedia
                return Column(
                  children: controller.recentTransactions.map((trx) => ActivityTile(
                    title: "Transaksi #${trx.invoiceNumber}",
                    subtitle: "Kasir: ${trx.cashierName} • ${controller.formatTime(trx.createdAt!)}",
                    value: controller.formatCurrency(trx.total ?? 0),
                    isWarning: false, 
                  )).toList(),
                );
              }),
              // --- SELESAI BAGIAN AKTIVITAS TERKINI ---

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool showLihatSemua) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (showLihatSemua)
          const Text("Lihat Semua", style: TextStyle(color: Color(0xFFD97217), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
          child: Icon(icon, color: const Color(0xFFD97217)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}