import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  final RxBool isResetLoading = false.obs;
  Future<void> onResetPassword(String email) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      isResetLoading.value = true;

      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.resetPassword,
        {
          "email": email.trim(),
          "password": confirmPasswordController.text.trim(),
        },
      );
      if (response != null && response['success'] == true) {
        email.isEmpty;
        confirmPasswordController.clear();

        AppToast.showSuccess(
            response['message'] ?? 'Password reset successfully');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRoutes.LOGIN);
        });
      } else {
        AppToast.showError(response['message'] ?? 'Failed to reset password');
        return;
      }
    } catch (e) {
      log("Reset Password error ${e.toString()}");
    } finally {
      isResetLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
