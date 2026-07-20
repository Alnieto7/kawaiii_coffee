import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/History/TransactionSearchDelegate.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/History/filter_chip.dart';
import 'package:kawaiii_coffee/Component/History/sectiontitle.dart';
import 'package:kawaiii_coffee/Component/History/summary_card.dart';
import 'package:kawaiii_coffee/Component/History/transactioncard.dart';
import 'package:kawaiii_coffee/Controller/HistoryController.dart';
import 'package:kawaiii_coffee/Page/Kasir/TransactionDetailPage.dart';
import 'package:kawaiii_coffee/binding/TransactionDetailBinding.dart';

class HistoryWide extends StatelessWidget {
  const HistoryWide({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.find<HistoryController>();

    // Tambahkan variabel ini di HistoryController
  var isMobile = true.obs;

  void updateLayout(BoxConstraints constraints) {
    isMobile.value = constraints.maxWidth < 800;
  }

  // Pindahkan logika pindah halaman ke detail di sini
  void goToDetail(int? trxId) {
    if (trxId != null) {
      Get.to(
        () => const TransactionDetailPage(),
        binding: TransactionDetailBinding(), // Pastikan import bindingnya
        arguments: trxId,
      );
    }
  }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // KOLOM KIRI (Header, Filter, Summary)
              // ==========================================
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Riwayat Transaksi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28, // Font lebih besar untuk desktop
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: TransactionSearchDelegate(controller),
                            );
                          },
                          icon: const Icon(Icons.search, color: AppColors.primary, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // FILTERS (Menggunakan Wrap agar rapi turun ke bawah jika layar menyempit)
                    Obx(() => Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            GestureDetector(
                              onTap: () => controller.changeFilter("Hari Ini"),
                              child: FilterChipItem(
                                label: "Hari Ini",
                                selected: controller.selectedFilter.value == "Hari Ini",
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.changeFilter("Seminggu Terakhir"),
                              child: FilterChipItem(
                                label: "Seminggu Terakhir",
                                selected: controller.selectedFilter.value == "Seminggu Terakhir",
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.changeFilter("Bulanan"),
                              child: FilterChipItem(
                                label: "Bulanan",
                                selected: controller.selectedFilter.value == "Bulanan",
                              ),
                            ),
                          ],
                        )),
                    
                    const SizedBox(height: 32),

                    // SUMMARY CARD
                    Obx(() => SummaryCard(
                          totalPendapatan: controller.totalPendapatan.value,
                          totalTransaksi: "${controller.totalTransaksi.value} TRANSAKSI",
                          lastUpdated: controller.lastUpdated.value,
                        )),
                  ],
                ),
              ),
              
              const SizedBox(width: 32),

              // ==========================================
              // KOLOM KANAN (Daftar Transaksi)
              // ==========================================
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle("TERBARU"),
                      const SizedBox(height: 16),
                      
                      // LIST TRANSAKSI
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            );
                          }
                          if (controller.transactions.isEmpty) {
                            return const Center(
                              child: Text(
                                "Belum ada riwayat transaksi.",
                                style: TextStyle(color: AppColors.textHint, fontSize: 16),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: controller.transactions.length,
                            itemBuilder: (context, index) {
                              final trx = controller.transactions[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: GestureDetector(
                                  onTap: () => controller.goToDetail(trx.id),
                                  child: TransactionCard(
                                    code: "#${trx.invoiceNumber}",
                                    price: controller.formatRupiah(trx.total ?? 0),
                                    time: controller.formatTime(trx.createdAt!),
                                    items: "1 Item", 
                                    cashier: trx.cashierName ?? "Kasir",
                                    status: "done",
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}