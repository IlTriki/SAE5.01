import 'package:get/get.dart';
import 'package:ckoitgrol/pages/auth/starting_auth_page.dart';
import 'package:ckoitgrol/pages/main_layout_page.dart';
import 'package:ckoitgrol/pages/auth/login_page.dart';
import 'package:ckoitgrol/pages/auth/sign_up_page.dart';
import 'package:ckoitgrol/pages/auth/forgot_password_page.dart';
import 'package:ckoitgrol/controllers/auth_controller.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.STARTING_AUTH;

  static final routes = [
    GetPage(
      name: Routes.STARTING_AUTH,
      page: () => const StartingAuthPage(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainLayoutPage(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignUpPage(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgottenPasswordPage(),
    ),
  ];
}
