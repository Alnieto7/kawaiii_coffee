import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/AllStockCard.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/AllStockController.dart';

class AllStockPage extends StatelessWidget {
  const AllStockPage({super.key});

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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
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