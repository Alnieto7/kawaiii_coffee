import 'dart:io'; // Penting: Untuk HttpOverrides
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kawaiii_coffee/Routes/Pages.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';

// Class untuk mengizinkan sertifikat SSL (Bypass SSL)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Aktifkan SSL Bypass agar gambar dari server sandbox bisa dimuat
  HttpOverrides.global = MyHttpOverrides();

  await GetStorage.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginPage,
      getPages: AppPages.pages,
    );
  }
}
