import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/PointOfSaleController.dart';
import 'package:kawaiii_coffee/Page/Kasir/CartSheetPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/CarSheetWide.dart';


class CartSheetResponsive extends StatelessWidget {
  const CartSheetResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final posController = Get.find<PosController>();

    return Obx(() {
      // Membaca status isMobile dari PosController
      return posController.isMobile.value 
          ? const CartSheetPage() 
          : const CartSheetWide();
    });
  }
}