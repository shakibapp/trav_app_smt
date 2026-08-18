import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/auth/ui/6_verify_otp.dart';


class ForgotPasswordController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  
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

final RxBool isForgotLoading = false.obs;
  Future<void> onSendOtpPressed() async{
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      isForgotLoading.value = true;
      final Map<String, dynamic> jsonBody = {
        "email": emailController.text.trim(),
      };
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.forgotPassword,
        jsonEncode(jsonBody),
      );
      if (response != null && response['success'] == true) {
       AppToast.showSuccess(response['message'] ?? 'OTP sent successfully');
       Get.to(()=>VerifyOtpScreen(email: emailController.text.trim(), isForPasswordReset: true));
       log("Forgot Password Success: ${response.toString()}");
      
      } else {
       // response null হতে পারে (504 বা network error এর কারণে)
       final msg = response != null
           ? (response['message'] ?? 'Failed to send OTP')
           : 'Server error. Please try again later.';
       AppToast.showError(msg);
       log("Forgot Password Failed: ${response.toString()}");  
      }
    } catch (e) {
     AppToast.showError('An error occurred. Please try again.');
     log("Forgot Password Error: $e");
    }finally{
      isForgotLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
