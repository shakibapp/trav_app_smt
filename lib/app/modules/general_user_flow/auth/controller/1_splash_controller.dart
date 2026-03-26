import 'package:get/get.dart';
import '../../../../core/services/local_data.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // Simulate splash screen display for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if token exists in local data
    final token = LocalService.localService.getToken();

    if (token != null && token.isNotEmpty) {
      // Token exists - navigate to home/navbar
      Get.offAllNamed(AppRoutes.NAVBAR);
    } else {
      // No token - navigate to login
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
