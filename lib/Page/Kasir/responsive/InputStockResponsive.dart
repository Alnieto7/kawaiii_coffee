import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/Admin/Kasir/InputStockController.dart';
import 'package:kawaiii_coffee/Page/Kasir/InputStockPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/inputstockwide.dart';


class InputStokResponsive extends StatelessWidget {
  const InputStokResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InputStokController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          c.updateLayout(constraints);
          return Obx(() => c.isMobile.value
              ? const InputStokPage()
              : const InputStokWide());
        },
      ),
    );
  }
}