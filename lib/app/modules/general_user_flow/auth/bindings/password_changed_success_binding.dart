import 'package:get/get.dart';

import '../controller/7_password_changed_success_controller.dart';

class PasswordChangedSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordChangedSuccessController>(
      () => PasswordChangedSuccessController(),
    );
  }
}
