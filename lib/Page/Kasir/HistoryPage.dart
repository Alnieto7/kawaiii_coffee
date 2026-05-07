import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/History/filter_chip.dart';
import 'package:kawaiii_coffee/Component/History/sectiontitle.dart';
import 'package:kawaiii_coffee/Component/History/summary_card.dart';
import 'package:kawaiii_coffee/Component/History/transactioncard.dart';
import 'package:kawaiii_coffee/Controller/HistoryController.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Get.find untuk mengambil instance controller yang sudah ada
    final HistoryController controller = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // 🔙 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFD97217), size: 20),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Riwayat Transaksi",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1F2937)),
                    ),
                  ),
                  Icon(Icons.search, color: Color(0xFFD97217)),
                ],
              ),
            ),

            // 🔘 FILTER
            SizedBox(
              height: 40,
              child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  GestureDetector(
                    onTap: () => controller.changeFilter("Hari Ini"),
                    child: FilterChipItem(label: "Hari Ini", selected: controller.selectedFilter.value == "Hari Ini"),
                  ),
                  GestureDetector(
                    onTap: () => controller.changeFilter("Kemarin"),
                    child: FilterChipItem(label: "Kemarin", selected: controller.selectedFilter.value == "Kemarin"),
                  ),
                  GestureDetector(
                    onTap: () => controller.changeFilter("7 Hari Terakhir"),
                    child: FilterChipItem(label: "7 Hari Terakhir", selected: controller.selectedFilter.value == "7 Hari Terakhir"),
                  ),
                ],
              )),
            ),

            const SizedBox(height: 16),

            // 📊 SUMMARY CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => SummaryCard(
                totalPendapatan: controller.totalPendapatan.value,
                totalTransaksi: "${controller.totalTransaksi.value} TRANSAKSI",
                lastUpdated: controller.lastUpdated.value,
              )),
            ),

            const SizedBox(height: 16),

            // 📋 LIST TRANSAKSI
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFD97217)));
                }

                if (controller.transactions.isEmpty) {
                  return const Center(
                    child: Text("Belum ada riwayat transaksi.", style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SectionTitle("TERBARU"),
                    ...controller.transactions.map((trx) {
                      return TransactionCard(
                        code: "#${trx.invoiceNumber}",
                        price: controller.formatRupiah(trx.total ?? 0),
                        time: controller.formatTime(trx.createdAt!),
                        items: "1 Item", 
                        cashier: trx.cashierName ?? "Kasir",
                        status: "done", 
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}