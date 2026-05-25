

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/auth/ui/6_verify_otp.dart';


class SignupController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isTermsAgreed = false.obs;
  final isSignupLoading = false.obs;

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
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Full name can only contain letters and spaces';
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

  String? validatePhoneNumber(String? value) {
    // Phone number is optional, so empty is allowed
    if (value == null || value.isEmpty) {
      return null;
    }
    // If provided, validate format
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
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


  Future<void> onSignupPressed() async {
    try {
      isSignupLoading.value = true;

      // Validate form
      if (!formKey.currentState!.validate()) {
        isSignupLoading.value = false;
        return;
      }

      // Check terms agreement
      if (!isTermsAgreed.value) {
        AppToast.showError('You must agree to the terms and conditions');
        isSignupLoading.value = false;
        return;
      }

      // Build request body
      final Map<String, dynamic> jsonBody = {
        "fullName": fullNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      

      // Make API request
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.register,
        jsonEncode(jsonBody),
      );

      if (response != null && response['success'] == true) {
        AppToast.showSuccess(response['message'] ?? 'Signup successful');
        // Navigate to OTP verification screen
        Get.to(()=>VerifyOtpScreen(email: emailController.text.trim(),isForPasswordReset: false,));
      } else {
        AppToast.showError(response['message'] ?? 'Signup failed');
      }
    } catch (e) {
      AppToast.showError('An error occurred. Please try again.');
    } finally {
      isSignupLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}