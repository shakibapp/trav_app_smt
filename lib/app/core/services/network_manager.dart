import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/style/global_text_style.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();
  
  late StreamSubscription<InternetConnectionStatus> _subscription;
  bool isDialogOpen = false;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _subscription = InternetConnectionChecker.createInstance().onStatusChange.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(InternetConnectionStatus status) {
    if (status == InternetConnectionStatus.disconnected) {
      // Add a small delay (debounce) before showing the dialog.
      // This prevents the dialog from flashing during app startup or momentary network drops.
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 2), () {
        if (!isDialogOpen) {
          isDialogOpen = true;
          _showNoInternetDialog();
        }
      });
    } else {
      // If internet comes back, cancel the timer and close the dialog if it's open
      _debounceTimer?.cancel();
      if (isDialogOpen) {
        isDialogOpen = false;
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    }
  }

  void _showNoInternetDialog() async {
    while (Get.overlayContext == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (!isDialogOpen) return;

    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog.fullscreen(
          backgroundColor: AppColors.whiteColor,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.authOrange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 80,
                    color: AppColors.authOrange,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  "No Internet Connection",
                  style: globaltextInterTight(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "Please check your network settings. We're waiting for the connection to come back...",
                  style: globaltextInterTight(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryColor,
                    lineHeight: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),
                CircularProgressIndicator(
                  color: AppColors.authOrange,
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  "Waiting to reconnect...",
                  style: globaltextInterTight(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
