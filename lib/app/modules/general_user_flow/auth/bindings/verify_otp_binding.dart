import 'package:get/get.dart';

import '../controller/6_verify_otp_controller.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<VerifyOtpController>(() => VerifyOtpController());
  }
}
