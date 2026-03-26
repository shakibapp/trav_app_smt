import 'package:get/get.dart';

import '../controller/2_login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<LoginController>(() => LoginController());
  }
}
