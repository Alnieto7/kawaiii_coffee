import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Controller/PrinterController.dart';

class PrinterSettingsWide extends StatelessWidget {
  PrinterSettingsWide({super.key});

  final controller = Get.find<PrinterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pengaturan Printer',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // KOLOM KIRI (Status & Tombol Scan)
            // ==========================================
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  Obx(() => ElevatedButton.icon(
                    onPressed: controller.isLoading.value ? null : controller.scanPrinter,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(controller.isLoading.value ? 'Memindai...' : 'Cari Printer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 52), // Sedikit lebih besar untuk tablet
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  )),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.textSecondary, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Kalau printer belum muncul, silakan pair (pasangkan) terlebih dahulu melalui menu Pengaturan Bluetooth di perangkat Anda, lalu kembali ke sini dan tekan tombol "Cari Printer".',
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 32),

            // ==========================================
            // KOLOM KANAN (Daftar Printer)
            // ==========================================
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Daftar Perangkat Bluetooth",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    Expanded(
                      child: Obx(() {
                        if (controller.printers.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bluetooth_disabled, size: 56, color: AppColors.textSecondary),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum ada perangkat terdeteksi.\nTekan "Cari Printer" untuk memindai.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: controller.printers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final printer = controller.printers[index];
                            final isThisConnected = controller.isConnected.value &&
                                controller.selectedPrinter.value?.macAdress == printer.macAdress;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isThisConnected ? AppColors.primary : AppColors.border,
                                  width: isThisConnected ? 1.5 : 1,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isThisConnected ? AppColors.primarySurface : AppColors.backgroundWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Icon(
                                    Icons.print,
                                    color: isThisConnected ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                ),
                                title: Text(
                                  printer.name.isEmpty ? 'Unknown Device' : printer.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                subtitle: Text(printer.macAdress, style: const TextStyle(fontSize: 13)),
                                trailing: controller.isConnecting.value
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                      )
                                    : isThisConnected
                                        ? const Icon(Icons.check_circle, color: AppColors.success, size: 28)
                                        : ElevatedButton(
                                            onPressed: () => controller.connectPrinter(printer),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.backgroundWhite,
                                              foregroundColor: AppColors.primary,
                                              side: const BorderSide(color: AppColors.primary),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                            child: const Text('Hubungkan'),
                                          ),
                                onTap: controller.isConnecting.value || isThisConnected
                                    ? null
                                    : () => controller.connectPrinter(printer),
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
    );
  }

  Widget _buildStatusCard() {
    return Obx(() {
      final connected = controller.isConnected.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: connected ? AppColors.successSurface : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: connected ? AppColors.success : AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: connected ? AppColors.success.withOpacity(0.2) : AppColors.backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                connected ? Icons.check_circle : Icons.error_outline,
                color: connected ? AppColors.success : AppColors.textSecondary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    connected ? 'Printer Terhubung' : 'Belum Ada Printer Terhubung',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  if (connected && controller.selectedPrinter.value != null)
                    Text(
                      controller.selectedPrinter.value!.name,
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),
            if (connected)
              OutlinedButton(
                onPressed: controller.disconnectPrinter,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Putuskan'),
              ),
          ],
        ),
      );
    });
  }
}