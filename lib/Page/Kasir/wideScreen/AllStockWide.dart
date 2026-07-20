import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/AllStockCard.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/AllStockController.dart';

class AllStockWide extends StatelessWidget {
  const AllStockWide({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AllStockController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Semua Stok Bahan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (c.stocks.isEmpty) {
          return const Center(
            child: Text(
              "Data stok tidak ditemukan",
              style: TextStyle(color: AppColors.textHint),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          // Menggunakan GridView untuk layar lebar
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom sejajar
            crossAxisSpacing: 16, // Jarak horizontal antar card
            mainAxisSpacing: 16, // Jarak vertikal antar card
            childAspectRatio: 4.0, // Mengatur rasio lebar vs tinggi agar card tidak terlalu tinggi
          ),
          itemCount: c.stocks.length,
          itemBuilder: (context, index) {
            final item = c.stocks[index];

            return AllStockCard(
              name: item.name,
              qty: '${item.stock} ${item.unit}',
              status: c.getStockStatus(item),
              statusBgColor: c.getStockBgColor(item),
              statusTextColor: c.getStockTextColor(item),
            );
          },
        );
      }),
    );
  }
}