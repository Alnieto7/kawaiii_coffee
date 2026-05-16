import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/dashboardkasir/AllStockCard.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/AllStockController.dart'; 

class AllStockPage extends StatelessWidget {
  const AllStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AllStockController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Semua Stok Bahan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (c.stocks.isEmpty) {
          return const Center(
            child: Text("Data stok tidak ditemukan", style: TextStyle(color: Colors.grey)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: c.stocks.length,
          itemBuilder: (context, index) {
            final item = c.stocks[index];
            
            // 👇 Menggunakan Reusable Component 👇
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