import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/QrisController.dart';

class QrisDisplayPage extends StatelessWidget {
  const QrisDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QrisController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Scan QRIS', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kawaiii Coffee',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    'Total Bayar: Rp ${controller.formattedTotal}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF1a6b45),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Logo_QRIS.svg/1200px-Logo_QRIS.svg.png',
                        height: 30,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => controller.qrUrl.value.isEmpty
                            ? const Column(
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 80,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'QR URL tidak ditemukan',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Image.network(
                                controller.qrUrl.value,
                                width: 250,
                                height: 250,
                                headers: {
                                  'Authorization':
                                      'Basic ${base64Encode(utf8.encode('Mid-client-bzKn4crc5olHa9oR:'))}',
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const SizedBox(
                                        width: 250,
                                        height: 250,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                errorBuilder: (_, __, ___) => const Column(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 60,
                                    ),
                                    SizedBox(height: 8),
                                    Text('Gagal memuat QR Code'),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Menunggu pembayaran...',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const CircularProgressIndicator(color: Color(0xFF1a6b45)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.stopPolling();
                      Get.back();
                      Get.snackbar(
                        'Info',
                        'Pesanan sedang diproses, cek status di riwayat',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a6b45),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Selesai & Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
