import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/auth/bindings/login_binding.dart';

import '../modules/auth/bindings/splash_binding.dart';
import '../modules/auth/bindings/signup_binding.dart';
import '../modules/auth/bindings/forgot_password_binding.dart';
import '../modules/auth/bindings/verify_otp_binding.dart';
import '../modules/auth/bindings/reset_password_binding.dart';
import '../modules/auth/bindings/password_changed_success_binding.dart';
import '../modules/auth/ui/1_splash.dart';
import '../modules/auth/ui/2_login.dart';
import '../modules/auth/ui/5_signup.dart';
import '../modules/auth/ui/3_forgot_password.dart';
import '../modules/auth/ui/6_verify_otp.dart';
import '../modules/auth/ui/4_reset_password.dart';
import '../modules/auth/ui/7_password_changed_success.dart';

import '../modules/preferences/bindings/preferences_binding.dart';
import '../modules/preferences/ui/1_search_place.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
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
    GetPage(
      name: AppRoutes.PASSWORD_CHANGED_SUCCESS,
      page: () => const PasswordChangedSuccessScreen(),
      binding: PasswordChangedSuccessBinding(),
    ),
    GetPage(
      name: AppRoutes.PREFERENCES,
      page: () => const PreferencesSearchPlaceScreen(),
      binding: PreferencesBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.SPLASH,
    //   page: () => SplashScreen(),
    //   binding: SplashBinding(),
    // ),
  ];
}
