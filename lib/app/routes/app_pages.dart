import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/auth/bindings/login_binding.dart';

import '../modules/auth/controller/signup_binding.dart';
import '../modules/auth/controller/forgot_password_binding.dart';
import '../modules/auth/controller/verify_otp_binding.dart';
import '../modules/auth/controller/reset_password_binding.dart';
import '../modules/auth/ui/2_login.dart';
import '../modules/auth/ui/signup.dart';
import '../modules/auth/ui/forgot_password.dart';
import '../modules/auth/ui/verify_otp.dart';
import '../modules/auth/ui/reset_password.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.VERIFICATION,
      page: () => const VerifyOtpScreen(),
      binding: VerifyOtpBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.SPLASH,
    //   page: () => SplashScreen(),
    //   binding: SplashBinding(),
    // ),
  ];
}
