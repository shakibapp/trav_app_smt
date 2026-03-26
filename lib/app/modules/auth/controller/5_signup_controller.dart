import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isTermsAgreed = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleTermsAgreement() {
    isTermsAgreed.value = !isTermsAgreed.value;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Full name must be at least 3 characters';
    }
    return null;
  }

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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void onSignupPressed() {
    if (!isTermsAgreed.value) {
      AppSnackBar.error(
        'Please agree to Terms of Service and Privacy Policy',
        title: 'Error',
      );
      return;
    }
    if (formKey.currentState!.validate()) {
      AppSnackBar.success('OTP sent to your email', title: 'Success');
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed(
          AppRoutes.VERIFICATION,
          arguments: {'flow': 'signup', 'email': emailController.text.trim()},
        );
      });
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
