import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/HistoryController.dart';
import 'package:kawaiii_coffee/Page/Kasir/HistoryPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/HistoryWide.dart';
// Pastikan import HistoryMobile dan HistoryWide sesuai lokasi foldermu

class HistoryResponsive extends StatelessWidget {
  const HistoryResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          controller.updateLayout(constraints);
          return Obx(() => controller.isMobile.value
              ? const HistoryPage()
              : const HistoryWide());
        },
      ),
    );
  }
}