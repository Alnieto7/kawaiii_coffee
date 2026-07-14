import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kawaiii_coffee/Controller/LoginController.dart';
import 'package:kawaiii_coffee/Page/Kasir/wideScreen/LoginWide.dart';
import 'package:kawaiii_coffee/Page/LoginPage.dart';
// Pastikan import LoginMobile dan LoginWide sesuai lokasi foldermu

class LoginResponsive extends StatelessWidget {
  const LoginResponsive({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          controller.updateLayout(constraints);
          return Obx(() => controller.isMobile.value
              ? const LoginPage()
              : const LoginWide());
        },
      ),
    );
  }
}