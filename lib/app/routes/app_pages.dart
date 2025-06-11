import 'package:get/get.dart';

import '../modules/Dashboard/dashboard_binding.dart';
import '../modules/Dashboard/dashboard_view.dart';
import '../modules/Detail_Product/detail_product_binding.dart';
import '../modules/Detail_Product/detail_product_view.dart';
import '../modules/Login/login_binding.dart';
import '../modules/Login/login_view.dart';
import '../modules/SignUp/sign_up_binding.dart';
import '../modules/SignUp/sign_up_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const transitionDuration = Duration(milliseconds: 1500);
  static const transitionCurve = Transition.cupertinoDialog;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
      transition: transitionCurve,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: _Paths.DETAIL_PRODUCT,
      page: () => const DetailProductView(),
      binding: DetailProductBinding(),
    ),
  ];
}
