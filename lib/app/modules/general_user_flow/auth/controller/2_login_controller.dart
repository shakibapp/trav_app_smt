import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/local_data.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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

  void onLoginPressed() {
    FocusManager.instance.primaryFocus?.unfocus();

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Temporary local login (no API yet): persist a token so splash routes to NAVBAR.
    final email = emailController.text.trim();
    LocalService.localService.setEmail(email);
    LocalService.localService.setToken('logged_in');

    AppSnackBar.success('Login successful', title: 'Success');
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(AppRoutes.NAVBAR);
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
