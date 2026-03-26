import 'package:get/get.dart';

import '../../../../core/services/local_data.dart';
import '../../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final fullName = ''.obs;
  final email = ''.obs;
  final imageUrl = ''.obs; // will come from API later

  @override
  void onInit() {
    super.onInit();
    loadLocalProfile();
  }

  void loadLocalProfile() {
    fullName.value = LocalService.localService.getName() ?? 'Hamish Phipps';
    email.value = LocalService.localService.getEmail() ?? '';
    // imageUrl.value = 'https://...'; // set from API later
  }

  // Actions (wire navigation later)
  void onAccountTap() {}

  void onNotificationsTap() {}

  void onParentsTap() {}

  void onPrivacyTap() {}

  void onTermsOfUseTap() {}

  Future<void> onLogoutTap() async {
    await LocalService.localService.clearUserData();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
