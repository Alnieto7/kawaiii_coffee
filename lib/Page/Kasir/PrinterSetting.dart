import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Component/app_colors.dart';
import 'package:kawaiii_coffee/Controller/PrinterController.dart';

class PrinterSettingsPage extends StatelessWidget {
  PrinterSettingsPage({super.key});

  final controller = Get.put(PrinterController());

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
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildStatusCard(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton.icon(
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
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              )),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kalau printer belum muncul, pair dulu lewat Pengaturan '
                'Bluetooth HP, lalu tekan "Cari Printer" di sini.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              if (controller.printers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bluetooth_disabled, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      const Text(
                        'Belum ada device.\nTekan "Cari Printer" untuk memindai.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.printers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final printer = controller.printers[index];
                  final isThisConnected = controller.isConnected.value &&
                      controller.selectedPrinter.value?.macAdress == printer.macAdress;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isThisConnected ? AppColors.primary : AppColors.border,
                        width: isThisConnected ? 1.2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isThisConnected ? AppColors.primarySurface : AppColors.backgroundLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.print,
                          color: isThisConnected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      title: Text(
                        printer.name.isEmpty ? 'Unknown Device' : printer.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(printer.macAdress, style: const TextStyle(fontSize: 12)),
                      trailing: controller.isConnecting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                            )
                          : isThisConnected
                              ? const Icon(Icons.check_circle, color: AppColors.success)
                              : TextButton(
                                  onPressed: () => controller.connectPrinter(printer),
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Obx(() {
      final connected = controller.isConnected.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: connected ? AppColors.successSurface : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: connected ? AppColors.success : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              connected ? Icons.check_circle : Icons.error_outline,
              color: connected ? AppColors.success : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    connected ? 'Printer Terhubung' : 'Belum Ada Printer Terhubung',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  if (connected && controller.selectedPrinter.value != null)
                    Text(
                      controller.selectedPrinter.value.name,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                ],
              ),
            ),
            if (connected)
              TextButton(
                onPressed: controller.disconnectPrinter,
                child: const Text('Putuskan', style: TextStyle(color: AppColors.error)),
              ),
          ],
        ),
      );
    });
  }
}