import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hamishphipps/app/core/constants/app_toast.dart';
import 'package:hamishphipps/app/core/data/network/endpoints.dart';
import 'package:hamishphipps/app/core/data/network/netconfig.dart';
import 'package:hamishphipps/app/core/services/local_data.dart';
import 'package:hamishphipps/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final networkConfig = NetworkConfigV1.instance;
  final localService = LocalService.localService;

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
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  //login
  final RxBool isLoginLoading = false.obs;
  Future<void> login() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoginLoading.value = true;
      final Map<String, dynamic> jsonBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };
      final response =
          await networkConfig.ApiRequestHandler(
            RequestMethod.POST,
            Urls.login,
            jsonEncode(jsonBody),
            is_auth: false,
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw TimeoutException('Request timed out. Please try again.'),
          );
      if (response != null && response["success"] == true) {
        final token = response["data"]["token"];
        final role = response["data"]["role"];
        bool isEmailVerify = response["data"]["emailVerified"] ?? false;
        bool isProfileComplete = response["data"]["isProfileComplete"] ?? false;

        if (role == "PARENT") {
          if (isEmailVerify == false) {
            AppToast.showError('Please verify your email before logging in.');
            return;
          } else {
            AppToast.showSuccess('Login successful');
            await localService.setToken(token);
            await localService.setRole(role);
           // Get.offAllNamed(AppRoutes.NAVBAR);
            log("Login successful. Token: $token, Role: $role");
          }
        } else if (role == "USER") {
          if (isEmailVerify == false) {
            AppToast.showError('Please verify your email before logging in.');
            return;
          }else if(isProfileComplete == false){
            AppToast.showSuccess('Login successful');
            await localService.setToken(token);
            await localService.setRole(role);
            log("Login successful profile incomplete. Token: $token, Role: $role");
            Get.offAllNamed(AppRoutes.PREFERENCES);
          } else {
            AppToast.showSuccess('Login successful');
            await localService.setToken(token);
            await localService.setRole(role);
            Get.offAllNamed(AppRoutes.NAVBAR);
            log("Login successful. Token: $token, Role: $role");
          }
        }
      } else {
        log(" Login failed: ${response["message"]}");
        // AppToast.showError(response["message"]);
      }
    } catch (w) {
      log(" Login error: $w");
    } finally {
      isLoginLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
