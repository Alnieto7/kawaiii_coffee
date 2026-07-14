import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/DashboardKasirController.dart';
import 'package:kawaiii_coffee/Page/Kasir/DashboardKasirPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/DashboardWide.dart';


class DashboardkasirResponsive extends StatelessWidget {
  DashboardkasirResponsive({super.key});

  final c = Get.put(DashboardKasirController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          c.updateLayout(constraints);
          return Obx(() => c.isMobile.value
              ? DashboardkasirPage() // Memanggil UI Mobile kamu
              : DashboardkasirWide()); // Memanggil UI Wide/Tablet kamu
        },
      )
    );
  }
}