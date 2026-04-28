import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kawaiii_coffee/Page/Admin/DashboardAdminPage.dart';
import 'package:kawaiii_coffee/Page/Kasir/dashboardKasir.dart';
import 'package:kawaiii_coffee/Page/LoginPage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/binding/DashboardAdminBinding.dart';
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
      page: () => DashboardPage(),
      binding: Dashboardkasirbinding(),
    ),
  ];
}
