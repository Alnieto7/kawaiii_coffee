import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kawaiii_coffee/Page/Admin/AnalisisPage.dart';
import 'package:kawaiii_coffee/Page/Admin/BottomNavAdmin.dart';
import 'package:kawaiii_coffee/Page/Admin/DashboardAdminPage.dart';
import 'package:kawaiii_coffee/Page/Admin/HppMargin.dart';
import 'package:kawaiii_coffee/Page/Admin/SettingsPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/AllStockPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/InputStockPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/MainPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/POS.dart';
import 'package:kawaiii_coffee/Page/Kasir/CartSheetPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/DashboardKasirPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/PaymentSuccess.dart';
import 'package:kawaiii_coffee/Page/Kasir/QrisDisplayPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/receiptPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/splashscreenPage.dart';
import 'package:kawaiii_coffee/Page/LoginPage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/binding/AllStockBinding.dart';
import 'package:kawaiii_coffee/binding/AnalisisBinding.dart';
import 'package:kawaiii_coffee/binding/DashboardAdminBinding.dart';
import 'package:kawaiii_coffee/binding/HPPMarginBinding.dart';
import 'package:kawaiii_coffee/binding/InputStockBinding.dart';
import 'package:kawaiii_coffee/binding/LoginBinding.dart';
import 'package:kawaiii_coffee/binding/MainAdminBinding.dart';
import 'package:kawaiii_coffee/binding/MainKasirBinding.dart';
import 'package:kawaiii_coffee/binding/POSBinding.dart';
import 'package:kawaiii_coffee/binding/SettingBinding.dart';
import 'package:kawaiii_coffee/binding/dashboardKasirBinding.dart';
import 'package:kawaiii_coffee/binding/SplashBinding.dart';
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.loginPage,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: SplashBinding(),
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
      page: () => CartSheetPage(),
      binding: Posbinding(),
    ),
    GetPage(
      name: AppRoutes.QrisDisplayPage,
      binding: Posbinding(),
      page: () => QrisDisplayPage(),
    ),
    GetPage(
      name: AppRoutes.PaymentSuccess,
      page: () => PaymentSuccessPage(),
      binding: Posbinding()
    ),
     GetPage(
      name: AppRoutes.InputStock,
      page: () => InputStokPage(),
      binding: InputStokBinding()
    ),
    GetPage(
        name: AppRoutes.receipt,
        page: () => ReceiptPage(),
        binding: Posbinding()
      ),
     GetPage(
      name: AppRoutes.AllStock,
      page: () => AllStockPage(),
      binding: AllStockBinding()
    ),
      
  ];
}
