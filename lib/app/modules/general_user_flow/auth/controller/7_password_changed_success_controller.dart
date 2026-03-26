import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class PasswordChangedSuccessController extends GetxController {
  void onBackToLoginPressed() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
