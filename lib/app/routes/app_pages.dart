import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/auth/bindings/login_binding.dart';

import '../modules/general_user_flow/auth/bindings/splash_binding.dart';
import '../modules/general_user_flow/auth/bindings/signup_binding.dart';
import '../modules/general_user_flow/auth/bindings/forgot_password_binding.dart';
import '../modules/general_user_flow/auth/bindings/verify_otp_binding.dart';
import '../modules/general_user_flow/auth/bindings/reset_password_binding.dart';
import '../modules/general_user_flow/auth/bindings/password_changed_success_binding.dart';
import '../modules/general_user_flow/auth/ui/1_splash.dart';
import '../modules/general_user_flow/auth/ui/2_login.dart';
import '../modules/general_user_flow/auth/ui/5_signup.dart';
import '../modules/general_user_flow/auth/ui/3_forgot_password.dart';
import '../modules/general_user_flow/auth/ui/6_verify_otp.dart';
import '../modules/general_user_flow/auth/ui/4_reset_password.dart';
import '../modules/general_user_flow/auth/ui/7_password_changed_success.dart';

import '../modules/general_user_flow/preferences/bindings/preferences_binding.dart';
import '../modules/general_user_flow/preferences/ui/1_search_place.dart';

import '../modules/general_user_flow/nav_bar/bindings/nav_bar_binding.dart';
import '../modules/general_user_flow/nav_bar/ui/nav_bar_screen.dart';

import '../modules/general_user_flow/profile/subitems/account/bindings/account_binding.dart';
import '../modules/general_user_flow/profile/subitems/account/ui/account_screen.dart';

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
    GetPage(
      name: AppRoutes.NAVBAR,
      page: () => const NavBarScreen(),
      binding: NavBarBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE_ACCOUNT,
      page: () => AccountScreen(),
      binding: AccountBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.SPLASH,
    //   page: () => SplashScreen(),
    //   binding: SplashBinding(),
    // ),
  ];
}
