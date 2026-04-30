import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kawaiii_coffee/Page/Admin/AnalisisPage.dart';
import 'package:kawaiii_coffee/Page/Admin/BottomNavAdmin.dart';
import 'package:kawaiii_coffee/Page/Admin/DashboardAdminPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/HistoryPage.dart';
import 'package:kawaiii_coffee/Page/Admin/HppMargin.dart';
import 'package:kawaiii_coffee/Page/Kasir/MainPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/POS.dart';
import 'package:kawaiii_coffee/Page/Kasir/dashboardKasir.dart';
import 'package:kawaiii_coffee/Page/LoginPage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/binding/AnalisisBinding.dart';
import 'package:kawaiii_coffee/binding/DashboardAdminBinding.dart';
import 'package:kawaiii_coffee/binding/HPPMarginBinding.dart';
import 'package:kawaiii_coffee/binding/LoginBinding.dart';
import 'package:kawaiii_coffee/binding/dashboardKasirBinding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.loginPage,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
     GetPage(
      name: AppRoutes.dashboardadmin,
      page: () => DashboardAdminPage(),
      binding: Dashboardadminbinding(),
    ),
    GetPage(
      name: AppRoutes.kasir, 
      page: () => DashboardkasirPage(),
      binding: Dashboardkasirbinding(),
    ),
     GetPage(
      name: AppRoutes.analisis, 
      page: () => AnalisisPage(),
      binding: AnalisisBinding(),
    ),
     GetPage(
      name: AppRoutes.BNAdmin, 
      page: () => MainView(),
    ),
      GetPage(
        name: AppRoutes.POS, 
        page: () => PosPage(),
      ),
        GetPage(
          name: AppRoutes.MAIN, 
          page: () => MainPage(),
        ),
        GetPage(
          name: AppRoutes.history, 
          page: () => const HistoryPage(),
          GetPage(
          name: AppRoutes.HPP, 
          page: () => HppMarginPage(),
            binding: HppMarginBinding(),
        ),
  ];
}
