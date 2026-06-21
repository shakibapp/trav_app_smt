import 'package:get/get.dart';
import '../../../../core/services/local_data.dart';
import '../../../../routes/app_routes.dart';
import '../../../parent_flow/nav_bar/ui/nav_bar_screen.dart';

class SplashController extends GetxController {
  final localService = LocalService.localService;

  @override
  @override
  void onInit() {
    super.onInit();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Simulate splash screen display for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if token exists in local data
    final token = localService.getToken();
    final role = localService.getRole();

    if (token != null && token.isNotEmpty) {
      // Token exists - navigate to home
      if (role == "PARENT") {
         Get.to(()=>NavBarScreen());
      } else if(role == "USER") {
        Get.offAllNamed(AppRoutes.NAVBAR);
      }

    } else {
      // No token - navigate to login
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
