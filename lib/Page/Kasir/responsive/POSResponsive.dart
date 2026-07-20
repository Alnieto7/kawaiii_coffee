import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Page/Kasir/POS.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/PosWide.dart';
// Pastikan import PosMobile dan PosWide sesuai lokasi file-mu

class PosResponsive extends StatelessWidget {
  const PosResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PosController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          c.updateLayout(constraints);
          return Obx(() => c.isMobile.value
              ? PosPage()
              : PosWide());
        },
      ),
    );
  }
}