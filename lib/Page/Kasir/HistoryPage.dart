import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/History/filter_chip.dart';
import 'package:kawaiii_coffee/Component/History/sectiontitle.dart';
import 'package:kawaiii_coffee/Component/History/summary_card.dart';
import 'package:kawaiii_coffee/Component/History/transactioncard.dart';
import 'package:kawaiii_coffee/Controller/HistoryController.dart';
import 'package:kawaiii_coffee/Binding/TransactionDetailBinding.dart';
import 'package:kawaiii_coffee/Page/Kasir/TransactionDetailPage.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 20),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Riwayat Transaksi",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
                    ),
                  ),
                  Icon(Icons.search, color: AppColors.primary),
                ],
              ),
            ),

            SizedBox(
              height: 40,
              child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  GestureDetector(
                    onTap: () => controller.changeFilter("Hari Ini"),
                    child: FilterChipItem(
                        label: "Hari Ini",
                        selected: controller.selectedFilter.value == "Hari Ini"),
                  ),
                  GestureDetector(
                    onTap: () => controller.changeFilter("Seminggu Terakhir"),
                    child: FilterChipItem(
                        label: "Seminggu Terakhir",
                        selected: controller.selectedFilter.value == "Seminggu Terakhir"),
                  ),
                  GestureDetector(
                    onTap: () => controller.changeFilter("Bulanan"),
                    child: FilterChipItem(
                        label: "Bulanan",
                        selected: controller.selectedFilter.value == "Bulanan"),
                  ),
                ],
              )),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => SummaryCard(
                totalPendapatan: controller.totalPendapatan.value,
                totalTransaksi: "${controller.totalTransaksi.value} TRANSAKSI",
                lastUpdated: controller.lastUpdated.value,
              )),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (controller.transactions.isEmpty) {
                  return const Center(
                    child: Text("Belum ada riwayat transaksi.", style: TextStyle(color: AppColors.textHint)),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SectionTitle("TERBARU"),
                    ...controller.transactions.map((trx) {
                      return GestureDetector(
                        onTap: () {
                          if (trx.id != null) {
                            Get.to(
                              () => const TransactionDetailPage(),
                              binding: TransactionDetailBinding(),
                              arguments: trx.id,
                            );
                          }
                        },
                        child: TransactionCard(
                          code: "#${trx.invoiceNumber}",
                          price: controller.formatRupiah(trx.total ?? 0),
                          time: controller.formatTime(trx.createdAt!),
                          items: "1 Item",
                          cashier: trx.cashierName ?? "Kasir",
                          status: "done",
                        ),
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