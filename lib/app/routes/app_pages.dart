import 'package:get/get.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/add_activity_binding/add_activity_binding.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_activity/view/add_activity_screen.dart';
import 'package:hamishphipps/app/modules/general_user_flow/auth/bindings/login_binding.dart';

import '../modules/general_user_flow/auth/bindings/splash_binding.dart';
import '../modules/general_user_flow/auth/bindings/signup_binding.dart';
import '../modules/general_user_flow/auth/bindings/forgot_password_binding.dart';
import '../modules/general_user_flow/auth/bindings/reset_password_binding.dart';
import '../modules/general_user_flow/auth/bindings/password_changed_success_binding.dart';
import '../modules/general_user_flow/auth/ui/1_splash.dart';
import '../modules/general_user_flow/auth/ui/2_login.dart';
import '../modules/general_user_flow/auth/ui/5_signup.dart';
import '../modules/general_user_flow/auth/ui/3_forgot_password.dart';
import '../modules/general_user_flow/auth/ui/4_reset_password.dart';
import '../modules/general_user_flow/auth/ui/7_password_changed_success.dart';

import '../modules/general_user_flow/preferences/bindings/preferences_binding.dart';
import '../modules/general_user_flow/preferences/ui/1_search_place.dart';

import '../modules/general_user_flow/nav_bar/bindings/nav_bar_binding.dart';
import '../modules/general_user_flow/nav_bar/ui/nav_bar_screen.dart';
import '../modules/parent_flow/nav_bar/bindings/parent_nav_bar_binding.dart';
import '../modules/parent_flow/nav_bar/ui/nav_bar_screen.dart' as parent_nav;

import '../modules/general_user_flow/profile/subitems/account/bindings/account_binding.dart';
import '../modules/general_user_flow/profile/subitems/account/ui/account_screen.dart';
import '../modules/general_user_flow/profile/subitems/notification/bindings/notification_binding.dart';
import '../modules/general_user_flow/profile/subitems/notification/ui/notification_screen.dart';
import '../modules/general_user_flow/profile/subitems/parents/bindings/parents_binding.dart';
import '../modules/general_user_flow/profile/subitems/parents/ui/parents_screen.dart';

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
    // GetPage(
    //   name: AppRoutes.VERIFICATION,
    //   page: () => const VerifyOtpScreen(),
    //   binding: VerifyOtpBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.RESET_PASSWORD,
    //   page: () => const ResetPasswordScreen(),
    //   binding: ResetPasswordBinding(),
    // ),
    GetPage(
      name: AppRoutes.PASSWORD_CHANGED_SUCCESS,
      page: () => const PasswordChangedSuccessScreen(),
      binding: PasswordChangedSuccessBinding(),
    ),
    GetPage(
      name: AppRoutes.PREFERENCES,
      page: () =>  PreferencesSearchPlaceScreen(),
      binding: PreferencesBinding(),
    ),
    GetPage(
      name: AppRoutes.NAVBAR,
      page: () => const NavBarScreen(),
      binding: NavBarBinding(),
    ),
    GetPage(
      name: AppRoutes.PARENT_NAVBAR,
      page: () => const parent_nav.NavBarScreen(),
      binding: ParentNavBarBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE_ACCOUNT,
      page: () => AccountScreen(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE_NOTIFICATION,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE_PARENTS,
      page: () => const ParentsScreen(),
      binding: ParentsBinding(),
    ),

    GetPage(
      name: AppRoutes.addActivity,
      page: () => AddActivityView(),
      binding:AddActivityBinding() ,
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    // GetPage(
    //   name: AppRoutes.SPLASH,
    //   page: () => SplashScreen(),
    //   binding: SplashBinding(),
    // ),
  ];
}
