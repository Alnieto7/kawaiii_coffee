import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 1. JANGAN LUPA IMPORT GETX DI SINI
import 'package:kawaiii_coffee/Routes/Pages.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      initialRoute: AppRoutes.history,
      initialRoute: AppRoutes.HPP,
      getPages: AppPages.pages,
    );
  }
}
