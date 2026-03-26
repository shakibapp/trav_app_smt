import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  void onSendOtpPressed() {
    if (formKey.currentState!.validate()) {
      AppSnackBar.success('OTP sent to your email', title: 'Success');
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed(
          AppRoutes.VERIFICATION,
          arguments: {'flow': 'forgot', 'email': emailController.text.trim()},
        );
      });
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
