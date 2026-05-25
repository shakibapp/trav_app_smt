
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/modules/general_user_flow/auth/ui/4_reset_password.dart';
import 'package:hamishphipps/app/routes/app_routes.dart';

class VerifyOtpController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool isVerifyingOTP = false.obs;
  final RxBool isResendingOTP = false.obs;
  
  // Timer for resend OTP countdown
  final RxInt resendCountdown = 0.obs;
  final RxBool canResendOTP = true.obs;
  
  static const int resendTimeoutSeconds = 60;

  Future<void> onVerifyOtpPressed(String email, bool isForPasswordReset) async {
    // Validate OTP input
    if (otpController.text.isEmpty) {
      AppToast.showError('Please enter the OTP code');
      return;
    }

    if (otpController.text.length != 4) {
      AppToast.showError('OTP must be 4 digits');
      return;
    }

    if (!RegExp(r'^[0-9]{4}$').hasMatch(otpController.text)) {
      AppToast.showError('OTP must contain only numbers');
      return;
    }

    try {
      isVerifyingOTP.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.verifyOtp,
        {"email": email.trim(), "otp": int.parse(otpController.text.trim())},
      );
      
      if (response != null && response['success'] == true) {
        AppToast.showSuccess('OTP verified successfully');
        
        if (isForPasswordReset==true) {
          Get.to(()=>ResetPasswordScreen(email: email.trim()));
          log("user email to -----$email");
        } else {
         Get.offAllNamed(AppRoutes.LOGIN);
        }
      } else {
        AppToast.showError(response['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      AppToast.showError('Please try again.');
    } finally {
      isVerifyingOTP.value = false;
    }
  }

  Future<void> onResendOtpPressed(String email) async {
    if (!canResendOTP.value) {
      AppToast.showError('Please wait before requesting another OTP');
      return;
    }

    try {
      isResendingOTP.value = true;
      final response = await networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.resendOtp,
        {"email": email.trim()},
      );
      
      if (response != null && response['success'] == true) {
        AppToast.showSuccess(response['message'] ?? 'OTP resent successfully');
        _startResendCountdown();
      } else {
        AppToast.showError(response['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      AppToast.showError('An error occurred. Please try again.');
    } finally {
      isResendingOTP.value = false;
    }
  }

  void _startResendCountdown() {
    canResendOTP.value = false;
    resendCountdown.value = resendTimeoutSeconds;

    Future.delayed(Duration(seconds: 1), () {
      _decrementCountdown();
    });
  }

  void _decrementCountdown() {
    if (resendCountdown.value > 0) {
      resendCountdown.value--;
      Future.delayed(Duration(seconds: 1), () {
        _decrementCountdown();
      });
    } else {
      canResendOTP.value = true;
      resendCountdown.value = 0;
    }
  }

  
}