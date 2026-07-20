import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/PrinterController.dart';
import 'package:kawaiii_coffee/Page/Kasir/PrinterSetting.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/printerSettingWide.dart';

class PrinterSettingsResponsive extends StatelessWidget {
  PrinterSettingsResponsive({super.key});

  // Inisialisasi controller di sini agar bisa digunakan oleh Mobile & Wide
  final controller = Get.put(PrinterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          controller.updateLayout(constraints);
          return Obx(() => controller.isMobile.value
              ? PrinterSettingsPage()
              : PrinterSettingsWide());
        },
      ),
    );
  }
}