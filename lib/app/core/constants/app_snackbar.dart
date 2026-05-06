import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: isSuccess ? Colors.white : Colors.black,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isSuccess ? Icons.check_circle : Icons.error,
        color: isSuccess ? Colors.white : Colors.black,
      ),
      shouldIconPulse: true,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  // Optional helper methods (clean usage)
  static void success(String message, {String title = "Success"}) {
    show(title: title, message: message, isSuccess: true);
  }

  static void failed(String message, {String title = "Failed"}) {
    show(title: title, message: message, isSuccess: false);
  }
}

