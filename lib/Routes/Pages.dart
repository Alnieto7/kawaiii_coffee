import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:kawaiii_coffee/Page/LoginPage.dart';
import 'package:kawaiii_coffee/Routes/Routes.dart';
import 'package:kawaiii_coffee/binding/LoginBinding.dart';



class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.loginPage,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),

  ];
}
