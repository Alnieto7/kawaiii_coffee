import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/Custom_Button.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/MarginProduct.dart';
import 'package:kawaiii_coffee/Component/AdminComponent/SummaryCard.dart';
import 'package:kawaiii_coffee/Controller/HppMarginController.dart';

class HppMarginPage extends GetView<HppMarginController> {
  const HppMarginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        // Seluruh halaman sekarang dibungkus SingleChildScrollView
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- KONTEN UTAMA ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Manajemen HPP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                        Row(
                          children: [
                            const Icon(Icons.notifications_none_rounded, color: Colors.grey),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              backgroundColor: const Color(0xFFFCECDD),
                              radius: 16,
                              child: Container(), 
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- HORIZONTAL SUMMARY CARDS ---
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          Obx(() => SummaryCard(
                            title: "EST. LABA HARIAN",
                            value: controller.estLabaHarian.value,
                            subValue: controller.trendLabaHarian.value,
                            isGreen: controller.isHarianUp.value,
                            trailingIcon: Icons.show_chart_rounded,
                            trailingIconColor: const Color(0xFFD97217),
                          )),
                          const SizedBox(width: 16),
                          Obx(() => SummaryCard(
                            title: "EST. LABA BULANAN",
                            value: controller.estLabaBulanan.value,
                            subValue: controller.targetLabaBulanan.value,
                            isNeutral: true,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- DAFTAR MARGIN PRODUK ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded( 
                          child: Row(
                            children: [
                              Icon(Icons.insert_chart, color: Color(0xFFD97217), size: 18),
                              SizedBox(width: 8),
                              Expanded( 
                                child: Text(
                                  "Daftar Margin per Produk", 
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF374151)), 
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis, 
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Lihat Laporan", style: TextStyle(color: Color(0xFFD97217), fontWeight: FontWeight.bold, fontSize: 12)),
                              Icon(Icons.chevron_right, color: Color(0xFFD97217), size: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Table Headers
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: Text("NAMA & HARGA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                          Expanded(flex: 1, child: Text("HPP", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                          Expanded(flex: 1, child: Text("MARGIN", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey))),
                        ],
                      ),
                    ),

                    // List Produk
                    Obx(() => Column(
                      children: controller.products.map((prod) {
                        int sellPrice = prod["sellPrice"] as int;
                        int hpp = prod["hpp"] as int;
                        bool isLoss = (sellPrice - hpp) < 0;

                        return MarginProductItem(
                          name: prod["name"] as String,
                          sellPrice: controller.formatRupiah(sellPrice),
                          hpp: controller.formatRupiah(hpp),
                          marginPercent: controller.getMarginPercent(sellPrice, hpp),
                          marginValue: controller.getMarginValue(sellPrice, hpp),
                          isLoss: isLoss,
                        );
                      }).toList(),
                    )),
                  ],
                ),
              ),

              // --- BOTTOM BUTTONS (SEKARANG IKUT DI-SCROLL) ---
              Container(
                // Tambahkan padding bawah 40 agar ada jarak bernapas dengan Bottom Navbar
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: "Unduh PDF",
                        icon: Icons.download_rounded,
                        isOutlined: true,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        label: "Produk Baru",
                        icon: Icons.add_circle_outline,
                        isOutlined: false,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}