import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/AnalisisController.dart';


class AnalisisPage extends GetView<AnalisisController> {
  const AnalisisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      // --- FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: controller.downloadReport,
        backgroundColor: const Color(0xFFD97217),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.download_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Analisis Penjualan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                  CircleAvatar(
                    backgroundColor: const Color(0xFFFCECDD),
                    radius: 20,
                    child: const Icon(Icons.person, color: Color(0xFFD97217), size: 20),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // --- FILTER CHIPS ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip("7 Hari Terakhir", Icons.calendar_today, true),
                    const SizedBox(width: 12),
                    _buildFilterChip("Semua Produk", Icons.wine_bar, false),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.filter_list, size: 16, color: Color(0xFFD97217)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SUMMARY CARDS (GRID 2x2) ---
              Row(
                children: [
                  Expanded(child: Obx(() => _buildSummaryCard("TOTAL PENJUALAN", controller.totalPenjualan.value, controller.trendPenjualan.value, isGreen: controller.isPenjualanUp.value))),
                  const SizedBox(width: 16),
                  Expanded(child: Obx(() => _buildSummaryCard("TOTAL HPP", controller.totalHpp.value, controller.statusHpp.value, isGreen: false, isNeutral: true))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Obx(() => _buildSummaryCard("LABA KOTOR", controller.labaKotor.value, controller.trendLaba.value, isGreen: controller.isLabaUp.value))),
                  const SizedBox(width: 16),
                  Expanded(child: Obx(() => _buildSummaryCard("RATA-RATA MARGIN", controller.rataMargin.value, controller.targetMargin.value, isGreen: false, isNeutral: true))),
                ],
              ),
              const SizedBox(height: 32),

              // --- CHART TREN PENJUALAN ---
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tren Penjualan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Unit: Ribuan Rp", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(controller.chartBars.length, (index) {
                    bool isMax = index == 5; // Sabtu tertinggi (sesuai gambar)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 35,
                          height: controller.chartBars[index].toDouble(),
                          decoration: BoxDecoration(
                            color: isMax ? const Color(0xFFD97217) : const Color(0xFFFCECDD),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(controller.chartDays[index], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    );
                  }),
                )),
              ),
              const SizedBox(height: 32),

              // --- TOP 5 PRODUK TERLARIS ---
              const Text("Top 5 Produk Terlaris", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Obx(() => Column(
                children: controller.topProducts.map((prod) => _buildTopProductRow(
                  prod["name"] as String, 
                  "${prod["qty"]} Cup", 
                  prod["progress"] as double
                )).toList(),
              )),
              const SizedBox(height: 32),

              // --- METRIK PERFORMA PRODUK ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Metrik Performa Produk", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {}, 
                    child: const Text("Lihat Semua", style: TextStyle(color: Color(0xFFD97217), fontWeight: FontWeight.bold))
                  )
                ],
              ),
              const SizedBox(height: 8),
              
              // Header Table
              const Row(
                children: [
                  Expanded(flex: 2, child: Text("PRODUK", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text("TERJUAL", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text("PENDAPATAN", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                  Expanded(flex: 1, child: Text("LABA", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                ],
              ),
              const Divider(height: 24, color: Color(0xFFEEEEEE)),
              
              // Data Table
              Obx(() => Column(
                children: controller.metrics.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(item["name"] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                      Expanded(flex: 1, child: Text("${item["terjual"]}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 1, child: Text(item["pendapatan"] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
                      Expanded(flex: 1, child: Text(item["laba"] as String, textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: (item["labaColor"] as bool) ? Colors.green : Colors.grey))),
                    ],
                  ),
                )).toList(),
              )),
              
              const SizedBox(height: 60), // Spasi bawah untuk FAB
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS (Private Helpers) ---

  Widget _buildFilterChip(String label, IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD97217) : Colors.transparent,
        border: Border.all(color: isActive ? const Color(0xFFD97217) : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isActive ? Colors.white : const Color(0xFFD97217)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: isActive ? Colors.white : const Color(0xFFD97217), fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, String subValue, {bool isGreen = false, bool isNeutral = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          Row(
            children: [
              if (!isNeutral) Icon(isGreen ? Icons.trending_up : Icons.trending_down, size: 14, color: isGreen ? Colors.green : Colors.red),
              if (!isNeutral) const SizedBox(width: 4),
              Text(subValue, style: TextStyle(fontSize: 10, color: isNeutral ? Colors.grey : (isGreen ? Colors.green : Colors.red))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopProductRow(String name, String qty, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
              Text(qty, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          // Custom Progress Bar
          Stack(
            children: [
              Container(height: 6, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10))),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFD97217), borderRadius: BorderRadius.circular(10))),
              ),
            ],
          )
        ],
      ),
    );
  }
}