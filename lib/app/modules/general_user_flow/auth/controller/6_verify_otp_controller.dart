import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../../../routes/app_routes.dart';

class VerifyOtpController extends GetxController {
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final String flow;

  @override
  void onInit() {
    super.onInit();
    final args = (Get.arguments as Map?) ?? const {};
    flow = (args['flow'] as String?) ?? 'forgot';
  }

  String get fullOtp => otpController.text;

  void onVerifyPressed() {
    if (fullOtp.length == 4) {
      AppSnackBar.success('OTP verified successfully', title: 'Success');
      Future.delayed(const Duration(seconds: 1), () {
        if (flow == 'signup') {
          Get.offAllNamed(AppRoutes.PREFERENCES);
        } else {
          Get.offNamed(AppRoutes.RESET_PASSWORD);
        }
      });
    } else {
      AppSnackBar.error('Please enter all 4 digits', title: 'Invalid OTP');
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
