import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/TransactionDetailController.dart';
import 'package:kawaiii_coffee/Page/Kasir/TransactionDetailPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/TransactionDetailWide.dart';
// Pastikan import TransactionDetailMobile dan TransactionDetailWide sesuai lokasi foldermu

class TransactionDetailResponsive extends StatelessWidget {
  const TransactionDetailResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TransactionDetailController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          c.updateLayout(constraints);
          return Obx(() => c.isMobile.value
              ? const TransactionDetailPage()
              : const TransactionDetailWide());
        },
      ),
    );
  }
}