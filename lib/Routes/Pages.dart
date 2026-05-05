import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kawaiii_coffee/Page/Admin/AnalisisPage.dart';
import 'package:kawaiii_coffee/Page/Admin/BottomNavAdmin.dart';
import 'package:kawaiii_coffee/Page/Admin/DashboardAdminPage.dart';
import 'package:kawaiii_coffee/Page/Admin/HppMargin.dart';
import 'package:kawaiii_coffee/Page/Admin/SettingsPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/MainPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/POS.dart';
import 'package:kawaiii_coffee/Page/Kasir/cart_menu.dart';
import 'package:kawaiii_coffee/Page/Kasir/dashboardKasir.dart';
import 'package:kawaiii_coffee/Page/LoginPage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/binding/AnalisisBinding.dart';
import 'package:kawaiii_coffee/binding/DashboardAdminBinding.dart';
import 'package:kawaiii_coffee/binding/HPPMarginBinding.dart';
import 'package:kawaiii_coffee/binding/LoginBinding.dart';
import 'package:kawaiii_coffee/binding/MainAdminBinding.dart';
import 'package:kawaiii_coffee/binding/MainKasirBinding.dart';
import 'package:kawaiii_coffee/binding/POSBinding.dart';
import 'package:kawaiii_coffee/binding/SettingBinding.dart';
import 'package:kawaiii_coffee/binding/cart_menuBinding.dart';
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
      binding: MainAdminBinding(),
    ),
    GetPage(
      name: AppRoutes.POS, 
      page: () => PosPage(),
      binding: Posbinding(),
      ),
    GetPage(
      name: AppRoutes.MAIN, 
      page: () => MainPage(),
      binding: MainKasirBinding(),
      ),
    GetPage(
      name: AppRoutes.HPP,
      page: () => HppMarginPage(),
      binding: HppMarginBinding(),
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => SettingsPage(),
      binding: SettingsBinding(),   
    ),
    GetPage(
      name: AppRoutes.cartMenu,
      page: () => CartSheet(),
      binding: CartMenubinding(),
    ),
  ];
}
