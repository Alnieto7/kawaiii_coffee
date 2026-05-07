import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 1. JANGAN LUPA IMPORT GETX DI SINI
import 'package:kawaiii_coffee/Routes/Pages.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

import 'package:get_storage/get_storage.dart'; // Pastikan di-import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.MAIN,
      getPages: AppPages.pages,
    );
  }
}
