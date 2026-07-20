import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/AllStockController.dart';
import 'package:kawaiii_coffee/Page/Kasir/AllStockPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/AllStockWide.dart';

class AllStockResponsive extends StatelessWidget {
  const AllStockResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AllStockController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          c.updateLayout(constraints);
          return Obx(() => c.isMobile.value
              ? const AllStockPage()
              : const AllStockWide());
        },
      ),
    );
  }
}